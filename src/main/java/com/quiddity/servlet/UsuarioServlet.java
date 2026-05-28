package com.quiddity.servlet;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class UsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Cualquier acceso a este servlet requiere sesión activa
        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        // Mostrar formulario para crear nuevo usuario (solo ADMIN)
        if ("nuevo".equals(action)) {
            if (!esAdmin(sesionUsuario)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/usuario/form.jsp").forward(req, resp);
            return;
        }

        // Ver perfil de un usuario por ID
        if (idParam != null && !idParam.isBlank()) {
            int id = Integer.parseInt(idParam);

            // Solo el propio usuario o un admin puede ver el perfil
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
            req.getRequestDispatcher("/WEB-INF/views/usuario/perfil.jsp").forward(req, resp);
            return;
        }

        // Listar todos los usuarios (solo ADMIN)
        if (!esAdmin(sesionUsuario)) {
            // Usuario normal y comprador solo pueden ver su propio perfil
            resp.sendRedirect(req.getContextPath() + "/usuarios?id=" + sesionUsuario.getId());
            return;
        }

        List<Usuario> lista = usuarioDAO.listarTodos();
        req.setAttribute("usuarios", lista);
        req.getRequestDispatcher("/WEB-INF/views/usuario/lista.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────
    // POST
    // ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "crear"      -> crearUsuario(req, resp, sesionUsuario);
            case "editar"     -> editarUsuario(req, resp, sesionUsuario);
            case "eliminar"   -> eliminarUsuario(req, resp, sesionUsuario);
            case "cambiarRol" -> cambiarRol(req, resp, sesionUsuario);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
        }
    }

    // ─────────────────────────────────────────────
    // ACCIONES PRIVADAS
    // ─────────────────────────────────────────────

    private void crearUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException, ServletException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        String email = req.getParameter("email");

        // Validación básica de duplicados
        if (usuarioDAO.emailExiste(email)) {
            req.setAttribute("error", "El correo ya está registrado.");
            req.getRequestDispatcher("/WEB-INF/views/usuario/form.jsp").forward(req, resp);
            return;
        }
        if (usuarioDAO.documentoExiste(req.getParameter("documento"))) {
            req.setAttribute("error", "El documento ya está registrado.");
            req.getRequestDispatcher("/WEB-INF/views/usuario/form.jsp").forward(req, resp);
            return;
        }

        int rolSolicitado = parseRol(req.getParameter("idrol"));

        Usuario nuevo = new Usuario();
        nuevo.setNombre(req.getParameter("nombre"));
        nuevo.setApellido(req.getParameter("apellido"));
        nuevo.setEmail(email);
        nuevo.setContrasena(req.getParameter("contrasena")); 
        nuevo.setDocumento(req.getParameter("documento"));
        nuevo.setUserName(req.getParameter("username"));
        nuevo.setFotoPerfil(req.getParameter("fotoperfil"));
        nuevo.setIdRol(rolSolicitado);

        boolean ok = usuarioDAO.crear(nuevo);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/usuarios");
        } else {
            req.setAttribute("error", "No se pudo crear el usuario. Inténtalo de nuevo.");
            req.getRequestDispatcher("/WEB-INF/views/usuario/form.jsp").forward(req, resp);
        }
    }

    /** Edita los datos de un usuario. El admin puede editar cualquiera; el usuario/comprador solo a sí mismo. */
    private void editarUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException, ServletException {

        int id = Integer.parseInt(req.getParameter("id"));

        if (!esAdmin(sesion) && sesion.getId() != id) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        Usuario u = usuarioDAO.obtenerPorId(id);
        if (u == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado");
            return;
        }

        u.setNombre(req.getParameter("nombre"));
        u.setApellido(req.getParameter("apellido"));
        u.setEmail(req.getParameter("email"));
        u.setDocumento(req.getParameter("documento"));
        u.setUserName(req.getParameter("username"));
        u.setFotoPerfil(req.getParameter("fotoperfil"));

        // Solo el admin puede cambiar el rol desde el formulario de edición
        if (esAdmin(sesion)) {
            u.setIdRol(parseRol(req.getParameter("idrol")));
        }

        boolean ok = usuarioDAO.actualizar(u);
        if (ok) {
            // Si el usuario editó su propio perfil, actualizar la sesión
            if (sesion.getId() == id) {
                req.getSession().setAttribute("usuario", u);
            }
            resp.sendRedirect(req.getContextPath() + "/usuarios?id=" + id);
        } else {
            req.setAttribute("error", "No se pudo actualizar el usuario.");
            req.setAttribute("usuario", u);
            req.getRequestDispatcher("/WEB-INF/views/usuario/perfil.jsp").forward(req, resp);
        }
    }

    /** Elimina un usuario. Solo ADMIN. */
    private void eliminarUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));

        // No permitir que el admin se elimine a sí mismo
        if (sesion.getId() == id) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=no_auto_eliminar");
            return;
        }

        usuarioDAO.eliminar(id);
        resp.sendRedirect(req.getContextPath() + "/usuarios");
    }

    /** Cambia el rol de un usuario. Solo ADMIN. */
    private void cambiarRol(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        if (!esAdmin(sesion)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        int id      = Integer.parseInt(req.getParameter("id"));
        int nuevoRol = parseRol(req.getParameter("idrol"));

        usuarioDAO.cambiarRol(id, nuevoRol);
        resp.sendRedirect(req.getContextPath() + "/usuarios");
    }

    // ─────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────
    private boolean esAdmin(Usuario u) {
        return u != null && u.getIdRol() == UsuarioDAO.ROL_ADMIN;
    }

    /**
     * Parsea el parámetro de rol validando que sea 1 (Admin), 2 (Usuario) o 3 (Comprador).
     * Si el valor es inválido, devuelve ROL_USUARIO como valor seguro por defecto.
     */
    private int parseRol(String rolParam) {
        if (rolParam == null) return UsuarioDAO.ROL_USUARIO;
        return switch (rolParam.trim()) {
            case "1" -> UsuarioDAO.ROL_ADMIN;
            case "3" -> UsuarioDAO.ROL_COMPRADOR;
            default  -> UsuarioDAO.ROL_USUARIO;
        };
    }
}