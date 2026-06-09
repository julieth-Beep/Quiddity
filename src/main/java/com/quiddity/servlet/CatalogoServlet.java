package com.quiddity.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
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
import com.quiddity.dao.CatalogoEstadisticasDAO;
import com.quiddity.dao.PedidoDAO;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Pedido;
import com.quiddity.model.Usuario;

/**
 * CatalogoServlet
 *
 * GET /catalogo → catálogo para compradores/usuarios
 * GET /admin/catalogo → panel de productos (admin)
 * POST /admin/catalogo → acciones: agregar, actualizar, eliminar, stock,
 * toggleActivo
 * GET /admin/pedidos → panel de pedidos (admin)
 * POST /admin/pedidos → acción: avanzarEstado
 * GET /admin/pedidos/detalle → detalle de un pedido (admin)
 * GET /admin/estadisticas → panel de estadísticas (admin)
 */
@WebServlet(urlPatterns = {
        "/catalogo",
        "/admin/catalogo",
        "/admin/pedidos",
        "/admin/pedidos/detalle",
        "/admin/estadisticas",
        "/uploads/catalogo/*"
})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int ROL_ADMIN = 1;
    private static final int ROL_COMPRADOR = 2;
    private static final int ROL_USUARIO = 3;

    // Directorio raíz para imágenes de catálogo. Las imágenes se guardan en
    // uploads/catalogo/<categoria>/<uuid>_<filename>
    private static final String UPLOAD_ROOT = "uploads/catalogo";

    private final CatalogoDAO catalogoDAO = new CatalogoDAO();
    private final CatalogoEstadisticasDAO estadisticasDAO = new CatalogoEstadisticasDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();

    // ═════════════════════════════════════════════════════════════════════════
    // GET
    // ═════════════════════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.startsWith(req.getContextPath() + "/uploads/catalogo/")) {
            servirImagen(req, resp);
            return;
        }
        if (uri.endsWith("/admin/catalogo")) {
            adminCatalogoGet(req, resp);
        } else if (uri.endsWith("/admin/pedidos/detalle")) {
            adminPedidoDetalleGet(req, resp);
        } else if (uri.endsWith("/admin/pedidos")) {
            adminPedidosGet(req, resp);
        } else if (uri.endsWith("/admin/estadisticas")) {
            adminEstadisticasGet(req, resp);
        } else {
            // /catalogo — vista pública para compradores y usuarios
            catalogoUsuarioGet(req, resp);
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // POST
    // ═════════════════════════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/admin/catalogo")) {
            adminCatalogoPost(req, resp);
        } else if (uri.contains("/admin/pedidos")) {
            adminPedidosPost(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /catalogo — vista comprador/usuario
    // ─────────────────────────────────────────────────────────────────────────
    // ═════════════════════════════════════════════════════════════════════════
    // SERVIR IMÁGENES
    // ═════════════════════════════════════════════════════════════════════════
    private void servirImagen(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // Obtener la ruta relativa después de /uploads/catalogo/
        String relativePath = req.getPathInfo(); // ej: /belleza/uuid_file.jpg

        if (relativePath == null || relativePath.isEmpty()) {
            resp.sendError(404);
            return;
        }

        // Construir ruta física
        String basePath = getServletContext().getRealPath("") + File.separator + UPLOAD_ROOT;
        Path filePath = Paths.get(basePath, relativePath);

        // Verificar que el archivo existe y servirlo
        if (Files.exists(filePath) && Files.isRegularFile(filePath)) {
            String contentType = getServletContext().getMimeType(filePath.toString());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            resp.setContentType(contentType);
            resp.setContentLengthLong(Files.size(filePath));

            // Copiar archivo al response
            try (InputStream input = Files.newInputStream(filePath);
                    OutputStream output = resp.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int len;
                while ((len = input.read(buffer)) > 0) {
                    output.write(buffer, 0, len);
                }
                output.flush();
            }
        } else {
            // Imagen por defecto si no existe
            Path defaultImg = Paths.get(basePath, "default.jpg");
            if (Files.exists(defaultImg)) {
                resp.setContentType("image/jpeg");
                try (InputStream input = Files.newInputStream(defaultImg);
                        OutputStream output = resp.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int len;
                    while ((len = input.read(buffer)) > 0) {
                        output.write(buffer, 0, len);
                    }
                }
            } else {
                resp.sendError(404, "Image not found");
            }
        }
    }

    private void catalogoUsuarioGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario usuario = session != null ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (usuario.getIdRol() == ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
            return;
        }

        String categoria = req.getParameter("categoria");
        String marca = req.getParameter("marca");
        String buscar = req.getParameter("buscar");

        List<Catalogo> productos;
        if (buscar != null && !buscar.isBlank()) {
            productos = catalogoDAO.buscarPorNombre(buscar);
        } else if (categoria != null && !categoria.isBlank()) {
            productos = catalogoDAO.listarPorCategoria(categoria);
        } else if (marca != null && !marca.isBlank()) {
            productos = catalogoDAO.listarPorMarca(marca);
        } else {
            // Solo productos activos con stock
            productos = catalogoDAO.listarActivos();
        }

        req.setAttribute("productos", productos);
        req.setAttribute("categoriaActual", categoria);
        req.setAttribute("marcaActual", marca);
        req.getRequestDispatcher("/comprador/catalogo.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/catalogo — panel de administración de productos
    // ─────────────────────────────────────────────────────────────────────────
    private void adminCatalogoGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        // ── Filtros opcionales ──────────────────────────────────────────────
        String categoria = req.getParameter("categoria");
        String estado = req.getParameter("estado"); // activo|inactivo|bajo_stock|sin_stock
        String buscar = req.getParameter("buscar");

        List<Catalogo> productos;
        if ((categoria != null && !categoria.isBlank())
                || (estado != null && !estado.isBlank())
                || (buscar != null && !buscar.isBlank())) {
            productos = catalogoDAO.buscarConFiltros(categoria, estado, buscar);
        } else {
            // Vista por defecto: activos primero, luego inactivos
            productos = catalogoDAO.listarTodosAdmin();
        }

        // ── Contadores para tarjetas resumen ────────────────────────────────
        List<Catalogo> todos = catalogoDAO.listarTodos();
        List<Catalogo> activos = catalogoDAO.listarActivos();
        List<Catalogo> bajoStock = catalogoDAO.listarBajoStock(10);
        List<Catalogo> sinStock = catalogoDAO.listarSinStock();

        req.setAttribute("productos", productos);
        req.setAttribute("totalProductos", todos.size());
        req.setAttribute("productosActivos", activos.size());
        req.setAttribute("productosBajoStock", bajoStock.size());
        req.setAttribute("productosSinStock", sinStock.size());

        // ── Árbol de categorías con contadores ──────────────────────────────
        List<Map<String, Object>> arbolCategorias = catalogoDAO.getCategoriaConConteo();
        req.setAttribute("arbolCategorias", arbolCategorias);

        // ── Estadísticas rápidas para el panel ──────────────────────────────
        double ingresosTotales = estadisticasDAO.getIngresosTotales();
        List<Map<String, Object>> topVendidos = estadisticasDAO.getTopVendidos(10);
        List<Map<String, Object>> ventasPorCategoria = estadisticasDAO.getVentasPorCategoria();
        List<Catalogo> sinVentas = estadisticasDAO.getProductosSinVentas(30);

        req.setAttribute("ingresosTotales", ingresosTotales);
        req.setAttribute("topVendidos", topVendidos);
        req.setAttribute("ventasPorCategoria", ventasPorCategoria);
        req.setAttribute("sinVentas", sinVentas);

        // Pasar filtros activos de vuelta a la vista
        req.setAttribute("filtroCategoria", categoria);
        req.setAttribute("filtroEstado", estado);
        req.setAttribute("filtroBuscar", buscar);

        req.getRequestDispatcher("/WEB-INF/admin/catalogo.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST /admin/catalogo — acciones CRUD + stock
    // ─────────────────────────────────────────────────────────────────────────
    private void adminCatalogoPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        String accion = req.getParameter("accion");
        if (accion == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
            return;
        }

        switch (accion) {
            case "agregar" -> accionAgregar(req, resp);
            case "actualizar" -> accionActualizar(req, resp);
            case "eliminar" -> accionEliminar(req, resp);
            case "stock" -> accionStock(req, resp);
            case "toggleActivo" -> accionToggleActivo(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/admin/catalogo");
        }
    }

    // ── Agregar producto ────────────────────────────────────────────────────
    private void accionAgregar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String nombre = getParam(req, "nombre");
        String descripcion = getParam(req, "descripcion");
        String componentes = getParam(req, "componentes");
        String categoria = getParam(req, "categoria");
        String marca = getParam(req, "marca");
        double precio = parseDouble(req.getParameter("precio"), 0);
        int stock = parseInt(req.getParameter("stock"), 0);

        if (nombre == null || nombre.isBlank() || precio <= 0) {
            redirigir(req, resp, "/admin/catalogo", "error", "Nombre y precio son obligatorios.");
            return;
        }

        String imagenNombre = null;
        Part filePart = req.getPart("imagen");
        if (filePart != null && filePart.getSize() > 0) {
            imagenNombre = guardarImagen(filePart, categoria);
            if (imagenNombre == null) {
                redirigir(req, resp, "/admin/catalogo", "error",
                        "Imagen inválida. Use JPG, PNG o GIF (máx. 10 MB).");
                return;
            }
        }

        Catalogo c = new Catalogo();
        c.setNombre(nombre);
        c.setDescripcion(nvl(descripcion));
        c.setComponentes(nvl(componentes));
        c.setPrecio(precio);
        c.setStock(stock);
        c.setImagen(imagenNombre);
        c.setCategoria(nvl(categoria));
        c.setMarca(nvl(marca));
        c.setActivo(true);

        boolean ok = catalogoDAO.crear(c);
        redirigir(req, resp, "/admin/catalogo",
                ok ? "exito" : "error",
                ok ? "Producto agregado correctamente." : "No se pudo agregar el producto.");
    }

    // ── Actualizar producto ─────────────────────────────────────────────────
    private void accionActualizar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            redirigir(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        Catalogo actual = catalogoDAO.obtenerPorId(id);
        if (actual == null) {
            redirigir(req, resp, "/admin/catalogo", "error", "Producto no encontrado.");
            return;
        }

        String nombre = getParam(req, "nombre");
        String descripcion = getParam(req, "descripcion");
        String componentes = getParam(req, "componentes");
        String categoria = getParam(req, "categoria");
        String marca = getParam(req, "marca");
        double precio = parseDouble(req.getParameter("precio"), 0);
        int stock = parseInt(req.getParameter("stock"), 0);

        // Nueva imagen opcional
        String imagenNombre = actual.getImagen();
        Part filePart = req.getPart("imagen");
        if (filePart != null && filePart.getSize() > 0) {
            // Borrar imagen anterior del disco
            if (imagenNombre != null && !imagenNombre.isBlank()) {
                borrarImagenDisco(imagenNombre, actual.getCategoria());
            }
            imagenNombre = guardarImagen(filePart, categoria);
        }

        actual.setNombre(nvl(nombre));
        actual.setDescripcion(nvl(descripcion));
        actual.setComponentes(nvl(componentes));
        actual.setPrecio(precio);
        actual.setStock(stock);
        actual.setImagen(imagenNombre);
        actual.setCategoria(nvl(categoria));
        actual.setMarca(nvl(marca));

        boolean ok = catalogoDAO.actualizar(actual);
        redirigir(req, resp, "/admin/catalogo",
                ok ? "exito" : "error",
                ok ? "Producto actualizado." : "No se pudo actualizar el producto.");
    }

    // ── Eliminar producto (soft o hard) ─────────────────────────────────────
    private void accionEliminar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            redirigir(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        Catalogo producto = catalogoDAO.obtenerPorId(id);
        if (producto == null) {
            redirigir(req, resp, "/admin/catalogo", "error", "Producto no encontrado.");
            return;
        }

        String deleteType = req.getParameter("deleteType"); // "soft" | "hard"
        boolean esSoft = "soft".equalsIgnoreCase(deleteType);

        boolean ok;
        if (esSoft) {
            // Soft delete: marcar inactivo, conservar imagen
            ok = catalogoDAO.desactivar(id);
            redirigir(req, resp, "/admin/catalogo",
                    ok ? "exito" : "error",
                    ok ? "Producto marcado como inactivo." : "No se pudo desactivar el producto.");
        } else {
            // Hard delete: eliminar imagen del disco y registro de BD
            if (producto.getImagen() != null && !producto.getImagen().isBlank()) {
                borrarImagenDisco(producto.getImagen(), producto.getCategoria());
            }
            ok = catalogoDAO.eliminar(id);
            redirigir(req, resp, "/admin/catalogo",
                    ok ? "exito" : "error",
                    ok ? "Producto eliminado definitivamente." : "No se pudo eliminar el producto.");
        }
    }

    // ── Actualizar stock inline ──────────────────────────────────────────────
    private void accionStock(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        String operacion = req.getParameter("operacion"); // "set" | "aumentar" | "disminuir"
        int cantidad = parseInt(req.getParameter("cantidad"), 1);
        int nuevoStock = parseInt(req.getParameter("stock"), -1);

        if (id <= 0) {
            redirigir(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        boolean ok;
        if ("set".equalsIgnoreCase(operacion) && nuevoStock >= 0) {
            ok = catalogoDAO.actualizarStock(id, nuevoStock);
        } else if ("aumentar".equalsIgnoreCase(operacion)) {
            ok = catalogoDAO.aumentarStock(id, cantidad);
        } else if ("disminuir".equalsIgnoreCase(operacion)) {
            ok = catalogoDAO.disminuirStock(id, cantidad);
        } else {
            // Por defecto: tratar "stock" como valor directo (compatibilidad con
            // formularios simples)
            ok = catalogoDAO.actualizarStock(id, Math.max(0, nuevoStock >= 0 ? nuevoStock : cantidad));
        }

        redirigir(req, resp, "/admin/catalogo",
                ok ? "exito" : "error",
                ok ? "Stock actualizado." : "No se pudo actualizar el stock.");
    }

    // ── Activar / desactivar toggle ─────────────────────────────────────────
    private void accionToggleActivo(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) {
            redirigir(req, resp, "/admin/catalogo", "error", "ID inválido.");
            return;
        }

        Catalogo producto = catalogoDAO.obtenerPorId(id);
        if (producto == null) {
            redirigir(req, resp, "/admin/catalogo", "error", "Producto no encontrado.");
            return;
        }

        boolean ok;
        String mensaje;
        if (producto.isActivo()) {
            ok = catalogoDAO.desactivar(id);
            mensaje = ok ? "Producto desactivado." : "No se pudo desactivar.";
        } else {
            ok = catalogoDAO.activar(id);
            mensaje = ok ? "Producto activado." : "No se pudo activar.";
        }

        redirigir(req, resp, "/admin/catalogo", ok ? "exito" : "error", mensaje);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/pedidos — listado de pedidos con filtros
    // ─────────────────────────────────────────────────────────────────────────
    private void adminPedidosGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        String estadoParam = req.getParameter("estado");
        String desdeParam = req.getParameter("desde");
        String hastaParam = req.getParameter("hasta");
        String usuarioParam = req.getParameter("usuario"); // nombre/email para búsqueda libre
        String idUsuParam = req.getParameter("usuarioId");

        LocalDate desde = parseFecha(desdeParam);
        LocalDate hasta = parseFecha(hastaParam);

        List<Pedido> pedidos;

        // Si se busca por nombre/email de usuario, usar ese método
        if (usuarioParam != null && !usuarioParam.isBlank()) {
            pedidos = pedidoDAO.buscarPorNombreUsuario(usuarioParam);
        } else {
            Integer usuarioId = null;
            if (idUsuParam != null && !idUsuParam.isBlank()) {
                try {
                    usuarioId = Integer.parseInt(idUsuParam);
                } catch (NumberFormatException ignored) {
                }
            }
            pedidos = pedidoDAO.buscarConFiltros(
                    (estadoParam != null && !estadoParam.isBlank()) ? estadoParam : null,
                    desde, hasta, usuarioId);
        }

        // Contadores por estado para tarjetas resumen
        Map<String, Integer> conteoPorEstado = pedidoDAO.getConteoPorEstado();

        req.setAttribute("pedidos", pedidos);
        req.setAttribute("conteoPorEstado", conteoPorEstado);
        req.setAttribute("filtroEstado", estadoParam);
        req.setAttribute("filtroDesde", desdeParam);
        req.setAttribute("filtroHasta", hastaParam);
        req.setAttribute("filtroUsuario", usuarioParam);

        req.getRequestDispatcher("/WEB-INF/admin/pedidos.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/pedidos/detalle?id=N — detalle de un pedido
    // ─────────────────────────────────────────────────────────────────────────
    private void adminPedidoDetalleGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        int pedidoId = parseInt(req.getParameter("id"), 0);
        if (pedidoId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/pedidos");
            return;
        }

        Pedido pedido = pedidoDAO.getDetallePedidoAdmin(pedidoId);
        if (pedido == null) {
            redirigir(req, resp, "/admin/pedidos", "error", "Pedido no encontrado.");
            return;
        }

        req.setAttribute("pedido", pedido);
        req.getRequestDispatcher("/WEB-INF/admin/detallePedido.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST /admin/pedidos — avanzar estado
    // ─────────────────────────────────────────────────────────────────────────
    private void adminPedidosPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        String accion = req.getParameter("accion");
        int pedidoId = parseInt(req.getParameter("id"), 0);

        if (pedidoId <= 0) {
            redirigir(req, resp, "/admin/pedidos", "error", "ID de pedido inválido.");
            return;
        }

        if ("avanzarEstado".equalsIgnoreCase(accion)) {
            boolean ok = pedidoDAO.avanzarEstado(pedidoId);
            redirigir(req, resp, "/admin/pedidos/detalle?id=" + pedidoId,
                    ok ? "exito" : "error",
                    ok ? "Estado actualizado correctamente."
                            : "No se pudo avanzar el estado (verifique que el pedido permita transición).");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/pedidos");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/estadisticas — panel de estadísticas con rango de fechas
    // ─────────────────────────────────────────────────────────────────────────
    private void adminEstadisticasGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (verificarAdmin(req, resp) == null)
            return;

        // Rango de fechas — por defecto el mes actual
        String desdeParam = req.getParameter("desde");
        String hastaParam = req.getParameter("hasta");

        LocalDate desde = parseFecha(desdeParam);
        LocalDate hasta = parseFecha(hastaParam);

        if (desde == null)
            desde = LocalDate.now().withDayOfMonth(1);
        if (hasta == null)
            hasta = LocalDate.now();

        // Top 10 más vendidos en el período
        List<Map<String, Object>> topVendidos = estadisticasDAO.getTopVendidosPorPeriodo(10, desde, hasta);

        // Ventas por categoría en el período
        List<Map<String, Object>> ventasPorCategoria = estadisticasDAO.getVentasPorCategoriaPeriodo(desde, hasta);

        // Resumen (ingresos totales, pedidos, clientes) en el período
        Map<String, Object> resumen = estadisticasDAO.getResumenPeriodo(desde, hasta);

        // Productos sin ventas en los últimos 30 días (siempre fijo)
        List<Catalogo> sinVentas = estadisticasDAO.getProductosSinVentas(30);

        req.setAttribute("topVendidos", topVendidos);
        req.setAttribute("ventasPorCategoria", ventasPorCategoria);
        req.setAttribute("resumen", resumen);
        req.setAttribute("sinVentas", sinVentas);
        req.setAttribute("filtroDesde", desde.toString());
        req.setAttribute("filtroHasta", hasta.toString());

        req.getRequestDispatcher("/WEB-INF/admin/estadisticas.jsp").forward(req, resp);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // MANEJO DE IMÁGENES
    // ═════════════════════════════════════════════════════════════════════════

    /**
     * Guarda la imagen en uploads/catalogo/<categoria>/<uuid>_<filename>.
     * Devuelve la ruta relativa guardada en BD (categoria/<uuid>_<filename>)
     * o null si hay error.
     */
    private String guardarImagen(Part filePart, String categoria) throws IOException {
        // Validar tipo MIME
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/"))
            return null;

        // Validar extensión
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = getExtension(fileName).toLowerCase();
        if (!extension.equals("jpg") && !extension.equals("jpeg")
                && !extension.equals("png") && !extension.equals("gif")) {
            return null;
        }

        // Carpeta según categoría (sanitizar para que sea nombre de directorio válido)
        String carpetaCategoria = sanitizarNombreDir(categoria != null ? categoria : "general");
        String uniqueName = UUID.randomUUID() + "_" + fileName;

        // Ruta física en el servidor
        String basePath = getServletContext().getRealPath("") + File.separator + UPLOAD_ROOT;
        String catPath = basePath + File.separator + carpetaCategoria;
        File uploadDir = new File(catPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        // Guardar archivo
        String filePath = catPath + File.separator + uniqueName;
        try (InputStream input = filePart.getInputStream();
                FileOutputStream output = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = input.read(buffer)) > 0)
                output.write(buffer, 0, len);
        }

        // Valor guardado en BD: "categoria/uuid_filename" para construir la URL en el
        // JSP
        return carpetaCategoria + "/" + uniqueName;
    }

    /**
     * Borra la imagen del disco.
     * imagenRelativa tiene el formato "categoria/uuid_filename" tal como se guardó
     * en BD.
     */
    private void borrarImagenDisco(String imagenRelativa, String categoriaActual) {
        if (imagenRelativa == null || imagenRelativa.isBlank())
            return;
        String basePath = getServletContext().getRealPath("") + File.separator + UPLOAD_ROOT;
        Path filePath = Paths.get(basePath, imagenRelativa);
        try {
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            System.err.println("[CatalogoServlet] No se pudo borrar imagen: " + filePath + " → " + e.getMessage());
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // HELPERS
    // ═════════════════════════════════════════════════════════════════════════

    private Usuario verificarAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        Usuario u = session != null ? (Usuario) session.getAttribute("usuario") : null;
        if (u == null || u.getIdRol() != ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return u;
    }

    private String getParam(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v != null ? v.trim() : null;
    }

    private String nvl(String s) {
        return s != null ? s : "";
    }

    private int parseInt(String val, int def) {
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException | NullPointerException e) {
            return def;
        }
    }

    private double parseDouble(String val, double def) {
        try {
            return Double.parseDouble(val);
        } catch (NumberFormatException | NullPointerException e) {
            return def;
        }
    }

    private LocalDate parseFecha(String val) {
        if (val == null || val.isBlank())
            return null;
        try {
            return LocalDate.parse(val);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot == -1 ? "" : fileName.substring(dot + 1);
    }

    /** Convierte "Cuidado Facial" → "cuidado_facial" para nombre de carpeta. */
    private String sanitizarNombreDir(String nombre) {
        return nombre.trim()
                .toLowerCase()
                .replaceAll("[^a-z0-9áéíóúüñ]", "_")
                .replaceAll("_+", "_");
    }

    private void redirigir(HttpServletRequest req, HttpServletResponse resp,
            String destino, String tipo, String mensaje)
            throws IOException {
        String encoded = java.net.URLEncoder.encode(mensaje, "UTF-8");
        // Si el destino ya tiene parámetros (ej: /admin/pedidos/detalle?id=5)
        String sep = destino.contains("?") ? "&" : "?";
        resp.sendRedirect(req.getContextPath() + destino + sep + tipo + "=" + encoded);
    }
}