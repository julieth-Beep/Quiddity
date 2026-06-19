package com.quiddity.servlet;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = { "/usuarios", "/usuario/dashboard" })
public class UsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ── Mismo helper que PerfilServlet para coherencia de rutas ──────────────
    private String getUploadDir() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) {
            return env + File.separator + "perfiles";
        }
        return getServletContext().getRealPath("/uploads/perfiles");
    }

    // ─────────────────────────────────────────────
    // GET
    // ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        if (uri.equals(contextPath + "/usuario/dashboard")) {
            req.getRequestDispatcher("/panel").forward(req, resp);
            return;
        }

        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String editarParam = req.getParameter("editar");

        // Mostrar formulario para crear nuevo usuario (solo ADMIN)
        if ("nuevo".equals(action)) {
            if (!esAdmin(sesionUsuario)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
            return;
        }

        // Ver/editar perfil por ID
        if (idParam != null && !idParam.isBlank()) {
            int id = Integer.parseInt(idParam);

            if (!esAdmin(sesionUsuario) && sesionUsuario.getId() != id) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }

            Usuario u = usuarioDAO.obtenerPorId(id);
            if (u == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado");
                return;
            }

            req.setAttribute("usuario", u);

            if ("true".equals(editarParam)) {
                if (!esAdmin(sesionUsuario) && sesionUsuario.getId() != id) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
                return;
            }

            req.getRequestDispatcher("/WEB-INF/usuario/perfil.jsp").forward(req, resp);
            return;
        }

        // Listar todos (solo ADMIN) o redirigir al propio perfil
        if (!esAdmin(sesionUsuario)) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?id=" + sesionUsuario.getId());
            return;
        }

        List<Usuario> lista = usuarioDAO.listarTodos();
        req.setAttribute("usuarios", lista);
        req.getRequestDispatcher("/WEB-INF/usuario/lista.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────
    // POST — detecta multipart antes de parsear
    // ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Los formularios de crear/editar envían multipart (por la foto).
        // En ese caso extraemos todos los campos con FileUpload antes de despachar.
        if (ServletFileUpload.isMultipartContent(req)) {
            manejarMultipart(req, resp, sesionUsuario);
            return;
        }

        // Formularios sin archivo (eliminar, cambiarRol, dashboard)
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {
            case "eliminar" -> eliminarUsuario(req, resp, sesionUsuario);
            case "cambiarRol" -> cambiarRol(req, resp, sesionUsuario);
            case "dashboard" -> mostrarDashboard(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
        }
    }

    // ─────────────────────────────────────────────
    // MULTIPART: extrae campos + archivo y despacha
    // ─────────────────────────────────────────────
    private void manejarMultipart(HttpServletRequest req, HttpServletResponse resp, Usuario sesionUsuario)
            throws IOException, ServletException {

        Map<String, String> campos = new HashMap<>();
        FileItem fotoItem = null;

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 1024); // 1 MB en memoria

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(5 * 1024 * 1024L); // 5 MB por archivo
            upload.setSizeMax(6 * 1024 * 1024L); // 6 MB total

            List<FileItem> items = upload.parseRequest(req);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    campos.put(item.getFieldName(), item.getString("UTF-8"));
                } else if ("foto".equals(item.getFieldName()) && item.getSize() > 0) {
                    fotoItem = item;
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("mensajeError", "Error al procesar la imagen: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        String action = campos.getOrDefault("action", "");
        switch (action) {
            case "crear" -> crearUsuario(req, resp, sesionUsuario, campos, fotoItem);
            case "editar" -> editarUsuario(req, resp, sesionUsuario, campos, fotoItem);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
        }
    }

    // ─────────────────────────────────────────────
    // Guarda foto en disco y devuelve el nombre del archivo.
    // Devuelve null si no hay foto válida.
    // Si idUsuario > 0 borra la foto anterior del usuario.
    // ─────────────────────────────────────────────
    private String guardarFoto(FileItem fotoItem, int idUsuario) throws Exception {
        if (fotoItem == null || fotoItem.getSize() == 0)
            return null;

        String contentType = fotoItem.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("El archivo debe ser una imagen (JPG, PNG, etc.).");
        }

        String uploadDir = getUploadDir();
        File dirFile = new File(uploadDir);
        if (!dirFile.exists())
            dirFile.mkdirs();

        // Borrar foto anterior si el usuario ya tiene una
        if (idUsuario > 0) {
            Usuario actual = usuarioDAO.obtenerPorId(idUsuario);
            if (actual != null && actual.getFotoPerfil() != null && !actual.getFotoPerfil().isBlank()) {
                new File(uploadDir, actual.getFotoPerfil()).delete();
            }
        }

        // Determinar extensión
        String originalName = fotoItem.getName();
        String extension = "";
        int dotIdx = originalName.lastIndexOf('.');
        if (dotIdx >= 0)
            extension = originalName.substring(dotIdx).toLowerCase();

        String nombreArchivo = "perfil_" + idUsuario + "_" + UUID.randomUUID().toString().substring(0, 8) + extension;
        fotoItem.write(new File(uploadDir, nombreArchivo));
        return nombreArchivo;
    }

    // ─────────────────────────────────────────────
    // CREAR usuario (multipart)
    // ─────────────────────────────────────────────
    private void crearUsuario(HttpServletRequest req, HttpServletResponse resp,
            Usuario sesion, Map<String, String> campos, FileItem fotoItem)
            throws IOException, ServletException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        String email = campos.get("email");

        if (usuarioDAO.emailExiste(email)) {
            req.setAttribute("error", "El correo ya está registrado.");
            req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
            return;
        }
        if (usuarioDAO.documentoExiste(campos.get("documento"))) {
            req.setAttribute("error", "El documento ya está registrado.");
            req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
            return;
        }

        // Primero crear el usuario sin foto para obtener el ID generado
        Usuario nuevo = new Usuario();
        nuevo.setNombre(campos.get("nombre"));
        nuevo.setApellido(campos.get("apellido"));
        nuevo.setEmail(email);
        nuevo.setContrasena(campos.get("contrasena"));
        nuevo.setDocumento(campos.get("documento"));
        nuevo.setUserName(campos.get("username"));
        nuevo.setIdRol(parseRol(campos.get("idrol")));

        boolean ok = usuarioDAO.crear(nuevo);
        if (!ok) {
            req.setAttribute("error", "No se pudo crear el usuario. Inténtalo de nuevo.");
            req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
            return;
        }

        // Obtener el usuario recién creado para conseguir su ID
        Usuario creado = usuarioDAO.obtenerPorEmail(email);
        if (creado != null && fotoItem != null && fotoItem.getSize() > 0) {
            try {
                String nombreFoto = guardarFoto(fotoItem, creado.getId());
                if (nombreFoto != null) {
                    usuarioDAO.actualizarFoto(creado.getId(), nombreFoto);
                }
            } catch (Exception e) {
                // La foto falló pero el usuario ya fue creado; no bloqueamos
                System.err.println("[UsuarioServlet] Error al guardar foto al crear: " + e.getMessage());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/usuarios?success=Usuario+creado+correctamente");
    }

    // ─────────────────────────────────────────────
    // EDITAR usuario (multipart)
    // ─────────────────────────────────────────────
    private void editarUsuario(HttpServletRequest req, HttpServletResponse resp,
            Usuario sesion, Map<String, String> campos, FileItem fotoItem)
            throws IOException, ServletException {

        int id;
        try {
            id = Integer.parseInt(campos.get("id"));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de usuario inválido");
            return;
        }

        if (!esAdmin(sesion) && sesion.getId() != id) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        Usuario u = usuarioDAO.obtenerPorId(id);
        if (u == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado");
            return;
        }

        u.setNombre(campos.get("nombre"));
        u.setApellido(campos.get("apellido"));
        u.setEmail(campos.get("email"));
        u.setDocumento(campos.get("documento"));
        u.setUserName(campos.get("username"));

        if (esAdmin(sesion)) {
            u.setIdRol(parseRol(campos.get("idrol")));
        }

        // Procesar foto si se subió una nueva
        if (fotoItem != null && fotoItem.getSize() > 0) {
            try {
                String nombreFoto = guardarFoto(fotoItem, id);
                if (nombreFoto != null) {
                    u.setFotoPerfil(nombreFoto);
                }
            } catch (IllegalArgumentException ex) {
                req.setAttribute("error", ex.getMessage());
                req.setAttribute("usuario", u);
                req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
                return;
            } catch (Exception ex) {
                System.err.println("[UsuarioServlet] Error al guardar foto al editar: " + ex.getMessage());
            }
        }

        boolean ok = usuarioDAO.actualizar(u);
        if (ok) {
            // Si el usuario editó su propio perfil, actualizar sesión
            if (sesion.getId() == id) {
                req.getSession().setAttribute("usuario", u);
            }
            resp.sendRedirect(req.getContextPath() + "/usuarios?id=" + id + "&success=Perfil+actualizado");
        } else {
            req.setAttribute("error", "No se pudo actualizar el usuario.");
            req.setAttribute("usuario", u);
            req.getRequestDispatcher("/WEB-INF/usuario/form.jsp").forward(req, resp);
        }
    }

    // ─────────────────────────────────────────────
    // DASHBOARD
    // ─────────────────────────────────────────────
    private void mostrarDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Usuario> todosUsuarios = usuarioDAO.listarTodos();
        List<Usuario> usuarios = usuarioDAO.listarPorRol(UsuarioDAO.ROL_USUARIO);
        List<Usuario> compradores = usuarioDAO.listarPorRol(UsuarioDAO.ROL_COMPRADOR);

        req.setAttribute("totalUsuarios", todosUsuarios.size());
        req.setAttribute("totalClientes", usuarios.size());
        req.setAttribute("totalCompradores", compradores.size());
        req.setAttribute("ultimosUsuarios", todosUsuarios.subList(0, Math.min(5, todosUsuarios.size())));

        req.getRequestDispatcher("/WEB-INF/usuario/dashboard.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────
    // ELIMINAR (solo ADMIN)
    // ─────────────────────────────────────────────
    private void eliminarUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));

        if (sesion.getId() == id) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=no_auto_eliminar");
            return;
        }

        usuarioDAO.eliminar(id);
        resp.sendRedirect(req.getContextPath() + "/usuarios?success=Usuario+eliminado");
    }

    // ─────────────────────────────────────────────
    // CAMBIAR ROL (solo ADMIN)
    // ─────────────────────────────────────────────
    private void cambiarRol(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        int nuevoRol = parseRol(req.getParameter("idrol"));

        usuarioDAO.cambiarRol(id, nuevoRol);
        resp.sendRedirect(req.getContextPath() + "/usuarios?success=Rol+actualizado");
    }

    // ─────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────
    private boolean esAdmin(Usuario u) {
        return u != null && u.getIdRol() == UsuarioDAO.ROL_ADMIN;
    }

    private int parseRol(String rolParam) {
        if (rolParam == null)
            return UsuarioDAO.ROL_USUARIO;
        return switch (rolParam.trim()) {
            case "1" -> UsuarioDAO.ROL_ADMIN;
            case "2" -> UsuarioDAO.ROL_COMPRADOR;
            default -> UsuarioDAO.ROL_USUARIO;
        };
    }
}