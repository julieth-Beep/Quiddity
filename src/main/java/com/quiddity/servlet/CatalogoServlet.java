package com.quiddity.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.quiddity.dao.CatalogoDAO;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Usuario;

/**
 * CatalogoServlet - GET /catalogo → muestra el catálogo (ROL_USUARIO=3 y
 * ROL_COMPRADOR=2) - GET /admin/catalogo → panel de administración
 * (ROL_ADMIN=1) - POST /admin/catalogo → acciones: agregar, actualizar,
 * eliminar (solo admin)
 */
@WebServlet(urlPatterns = {"/catalogo", "/admin/catalogo"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int ROL_ADMIN = 1;
    private static final int ROL_COMPRADOR = 2;
    private static final int ROL_USUARIO = 3;

    private final CatalogoDAO catalogoDAO = new CatalogoDAO();

    // Directorio donde se guardarán las imágenes
    private static final String UPLOAD_DIR = "uploads/catalogo";

    // ── GET ──────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // ── GET /admin/catalogo ───────────────────────────────────────
        if (uri.endsWith("/admin/catalogo")) {
            Usuario admin = verificarAdmin(req, resp);
            if (admin == null) {
                return;
            }

            // Listar todos los productos para el panel admin
            List<Catalogo> productos = catalogoDAO.listarTodos();
            req.setAttribute("productos", productos);
            req.getRequestDispatcher("/admin/catalogo-admin.jsp").forward(req, resp);
            return;
        }

        // ── GET /catalogo (para compradores/usuarios) ───────────────
        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) {
            return;
        }

        // Obtener parámetros de filtrado
        String categoria = req.getParameter("categoria");
        String marca = req.getParameter("marca");
        String buscar = req.getParameter("buscar");

        List<Catalogo> productos;

        if (buscar != null && !buscar.trim().isEmpty()) {
            productos = catalogoDAO.buscarPorNombre(buscar);
        } else if (categoria != null && !categoria.trim().isEmpty()) {
            productos = catalogoDAO.listarPorCategoria(categoria);
        } else if (marca != null && !marca.trim().isEmpty()) {
            productos = catalogoDAO.listarPorMarca(marca);
        } else {
            productos = catalogoDAO.listarConStock(); // Solo productos disponibles
        }

        System.out.println(">>> [DEBUG] productos cargados: " + productos.size());
        if (productos.isEmpty()) {
            try (java.sql.Connection con = com.quiddity.util.ConexionDB.getConnection()) {
                System.out.println(">>> [DEBUG] conexión OK: " + con.getMetaData().getURL());
            } catch (Exception ex) {
                System.out.println(">>> [DEBUG] ERROR conexión: " + ex.getMessage());
            }
        }
        
        req.setAttribute("productos", productos);
        req.setAttribute("categoriaActual", categoria);
        req.setAttribute("marcaActual", marca);
        req.getRequestDispatcher("/comprador/catalogo.jsp").forward(req, resp);
    }

    // ── POST: acciones de administración ────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Verificar que sea admin
        Usuario admin = verificarAdmin(req, resp);
        if (admin == null) {
            return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
            return;
        }

        switch (accion) {
            case "agregar" ->
                accionAgregar(req, resp);
            case "actualizar" ->
                accionActualizar(req, resp);
            case "eliminar" ->
                accionEliminar(req, resp);
            default ->
                resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // AGREGAR PRODUCTO (con subida de imagen)
    // ────────────────────────────────────────────────────────────────────
    private void accionAgregar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        // Obtener datos del formulario
        String nombre = getParameter(req, "nombre");
        String descripcion = getParameter(req, "descripcion");
        String componentes = getParameter(req, "componentes");
        String categoria = getParameter(req, "categoria");
        String marca = getParameter(req, "marca");
        double precio = parseDouble(req.getParameter("precio"), 0);
        int stock = parseInt(req.getParameter("stock"), 0);

        // Validar datos básicos
        if (nombre == null || nombre.trim().isEmpty() || precio <= 0) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                    "Nombre y precio son obligatorios.");
            return;
        }

        // Procesar imagen si se subió
        String imagenNombre = null;
        Part filePart = req.getPart("imagen");

        if (filePart != null && filePart.getSize() > 0) {
            imagenNombre = procesarImagen(filePart);
            if (imagenNombre == null) {
                redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                        "Error al subir la imagen. Verifique el formato y tamaño.");
                return;
            }
        }

        // Crear objeto Catalogo
        Catalogo catalogo = new Catalogo();
        catalogo.setNombre(nombre.trim());
        catalogo.setDescripcion(descripcion != null ? descripcion.trim() : "");
        catalogo.setComponentes(componentes != null ? componentes.trim() : "");
        catalogo.setPrecio(precio);
        catalogo.setStock(stock);
        catalogo.setImagen(imagenNombre);
        catalogo.setCategoria(categoria != null ? categoria.trim() : "");
        catalogo.setMarca(marca != null ? marca.trim() : "");

        // Guardar en BD
        boolean ok = catalogoDAO.crear(catalogo);

        if (ok) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "exito",
                    "Producto agregado correctamente.");
        } else {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                    "No se pudo agregar el producto.");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // ACTUALIZAR PRODUCTO (con opción de cambiar imagen)
    // ────────────────────────────────────────────────────────────────────
    private void accionActualizar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        // Obtener datos
        String nombre = getParameter(req, "nombre");
        String descripcion = getParameter(req, "descripcion");
        String componentes = getParameter(req, "componentes");
        String categoria = getParameter(req, "categoria");
        String marca = getParameter(req, "marca");
        double precio = parseDouble(req.getParameter("precio"), 0);
        int stock = parseInt(req.getParameter("stock"), 0);

        // Obtener producto actual para conservar imagen si no se sube nueva
        Catalogo productoActual = catalogoDAO.obtenerPorId(id);
        if (productoActual == null) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                    "Producto no encontrado.");
            return;
        }

        String imagenNombre = productoActual.getImagen();

        // Procesar nueva imagen si se subió
        Part filePart = req.getPart("imagen");
        if (filePart != null && filePart.getSize() > 0) {
            // Eliminar imagen anterior si existe
            if (imagenNombre != null && !imagenNombre.isEmpty()) {
                eliminarImagen(imagenNombre);
            }
            imagenNombre = procesarImagen(filePart);
        }

        // Actualizar objeto
        productoActual.setNombre(nombre.trim());
        productoActual.setDescripcion(descripcion != null ? descripcion.trim() : "");
        productoActual.setComponentes(componentes != null ? componentes.trim() : "");
        productoActual.setPrecio(precio);
        productoActual.setStock(stock);
        productoActual.setImagen(imagenNombre);
        productoActual.setCategoria(categoria != null ? categoria.trim() : "");
        productoActual.setMarca(marca != null ? marca.trim() : "");

        boolean ok = catalogoDAO.actualizar(productoActual);

        if (ok) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "exito",
                    "Producto actualizado correctamente.");
        } else {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                    "No se pudo actualizar el producto.");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // ELIMINAR PRODUCTO
    // ────────────────────────────────────────────────────────────────────
    private void accionEliminar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        // Obtener producto para eliminar su imagen
        Catalogo producto = catalogoDAO.obtenerPorId(id);
        if (producto != null) {
            if (producto.getImagen() != null && !producto.getImagen().isEmpty()) {
                eliminarImagen(producto.getImagen());
            }
            catalogoDAO.eliminar(id);
            redirigirConMensaje(req, resp, "/admin/catalogo", "exito",
                    "Producto eliminado correctamente.");
        } else {
            redirigirConMensaje(req, resp, "/admin/catalogo", "error",
                    "Producto no encontrado.");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // PROCESAR IMAGEN (guardar en servidor)
    // ────────────────────────────────────────────────────────────────────
    private String procesarImagen(Part filePart) throws IOException, ServletException {

        // Validar tipo de archivo
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return null;
        }

        // Obtener nombre del archivo
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Validar extensión
        String extension = getFileExtension(fileName).toLowerCase();
        if (!extension.equals("jpg") && !extension.equals("jpeg")
                && !extension.equals("png") && !extension.equals("gif")) {
            return null;
        }

        // Generar nombre único para evitar colisiones
        String uniqueName = UUID.randomUUID().toString() + "_" + fileName;

        // Crear directorio si no existe
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Guardar archivo
        String filePath = uploadPath + File.separator + uniqueName;
        try (InputStream input = filePart.getInputStream(); FileOutputStream output = new FileOutputStream(filePath)) {

            byte[] buffer = new byte[1024];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        }

        return uniqueName;
    }

    // ────────────────────────────────────────────────────────────────────
    // ELIMINAR IMAGEN DEL DISCO
    // ────────────────────────────────────────────────────────────────────
    private void eliminarImagen(String imageName) {
        if (imageName == null || imageName.isEmpty()) {
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        Path filePath = Paths.get(uploadPath, imageName);

        try {
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            System.err.println("[CatalogoServlet] Error al eliminar imagen: " + e.getMessage());
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // HELPERS
    // ────────────────────────────────────────────────────────────────────
    private Usuario verificarAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getIdRol() != ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        return u;
    }

    private Usuario usuarioAutenticado(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getIdRol() != ROL_USUARIO && u.getIdRol() != ROL_COMPRADOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        return u;
    }

    private String getParameter(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value != null ? value.trim() : null;
    }

    private int parseInt(String valor, int defecto) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException | NullPointerException e) {
            return defecto;
        }
    }

    private double parseDouble(String valor, double defecto) {
        try {
            return Double.parseDouble(valor);
        } catch (NumberFormatException | NullPointerException e) {
            return defecto;
        }
    }

    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        return (lastDot == -1) ? "" : fileName.substring(lastDot + 1);
    }

    private void redirigirConMensaje(HttpServletRequest req, HttpServletResponse resp,
            String destino, String tipo, String mensaje)
            throws IOException {

        String encoded = java.net.URLEncoder.encode(mensaje, "UTF-8");
        resp.sendRedirect(req.getContextPath() + destino + "?" + tipo + "=" + encoded);
    }
}
