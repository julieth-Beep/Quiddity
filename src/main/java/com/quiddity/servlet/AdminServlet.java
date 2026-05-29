package com.quiddity.servlet;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AdminServlet
 *
 * Rutas:
 *   GET  /admin/dashboard  → panel principal del admin
 *   GET  /admin/usuarios   → listado de todos los usuarios (por rol opcional)
 *   GET  /admin/reportes   → vista de reportes
 *
 * NOTA: el control de acceso (solo ROL_ADMIN) ya lo aplica AuthFilter.
 *       Este servlet añade una segunda verificación como defensa en profundidad.
 */
@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/usuarios", "/admin/reportes"})
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Defensa en profundidad: verificar sesión y rol
        HttpSession session = req.getSession(false);
        Usuario admin = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (admin == null || admin.getIdRol() != UsuarioDAO.ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri  = req.getRequestURI();
        String base = req.getContextPath();

        if (uri.endsWith("/admin/dashboard")) {
            mostrarDashboard(req, resp);
        } else if (uri.endsWith("/admin/usuarios")) {
            listarUsuarios(req, resp);
        } else if (uri.endsWith("/admin/reportes")) {
            mostrarReportes(req, resp);
        } else {
            resp.sendRedirect(base + "/admin/dashboard");
        }
    }

    // ─────────────────────────────────────────────
    // VISTAS
    // ─────────────────────────────────────────────

    /** Dashboard principal: resumen de usuarios por rol. */
    private void mostrarDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Usuario> todosUsuarios  = usuarioDAO.listarTodos();
        List<Usuario> usuarios       = usuarioDAO.listarPorRol(UsuarioDAO.ROL_USUARIO);
        List<Usuario> compradores    = usuarioDAO.listarPorRol(UsuarioDAO.ROL_COMPRADOR);

        req.setAttribute("totalUsuarios",   todosUsuarios.size());
        req.setAttribute("totalClientes",   usuarios.size());
        req.setAttribute("totalCompradores",compradores.size());
        req.setAttribute("ultimosUsuarios", todosUsuarios.subList(0, Math.min(5, todosUsuarios.size())));

<<<<<<< HEAD
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
=======
        req.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(req, resp);
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    }

    /** Listado de usuarios — puede filtrar por ?rol=1|2|3. */
    private void listarUsuarios(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String rolParam = req.getParameter("rol");
        List<Usuario> lista;

        if (rolParam != null && !rolParam.isBlank()) {
            try {
                int rol = Integer.parseInt(rolParam.trim());
                lista = usuarioDAO.listarPorRol(rol);
                req.setAttribute("rolFiltro", rol);
            } catch (NumberFormatException e) {
                lista = usuarioDAO.listarTodos();
            }
        } else {
            lista = usuarioDAO.listarTodos();
        }

        req.setAttribute("usuarios", lista);
<<<<<<< HEAD
        req.getRequestDispatcher("/admin/usuarios.jsp").forward(req, resp);
=======
        req.getRequestDispatcher("/WEB-INF/admin/usuarios.jsp").forward(req, resp);
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    }

    /** Vista de reportes — carga todos los usuarios para análisis. */
    private void mostrarReportes(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("usuarios",    usuarioDAO.listarTodos());
        req.setAttribute("usuarios2",   usuarioDAO.listarPorRol(UsuarioDAO.ROL_USUARIO));
        req.setAttribute("compradores", usuarioDAO.listarPorRol(UsuarioDAO.ROL_COMPRADOR));

<<<<<<< HEAD
        req.getRequestDispatcher("/admin/reportes.jsp").forward(req, resp);
=======
        req.getRequestDispatcher("/WEB-INF/admin/reportes.jsp").forward(req, resp);
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    }
}