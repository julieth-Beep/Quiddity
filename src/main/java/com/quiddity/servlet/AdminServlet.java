package com.quiddity.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

/**
 * AdminServlet
 *
 * Rutas:
 *   GET  /admin/dashboard  → panel principal del admin
 *   GET  /admin/reportes   → vista de reportes
 *
 * NOTA: el control de acceso (solo ROL_ADMIN) ya lo aplica AuthFilter.
 */
@WebServlet(urlPatterns = {"/admin/usuarios", "/admin/reportes"})
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

        if (uri.endsWith("/admin/usuarios")) {
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
        req.getRequestDispatcher("/WEB-INF/admin/usuarios.jsp").forward(req, resp);
    }

    /** Vista de reportes — carga todos los usuarios para análisis. */
    private void mostrarReportes(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("usuarios",    usuarioDAO.listarTodos());
        req.setAttribute("usuarios2",   usuarioDAO.listarPorRol(UsuarioDAO.ROL_USUARIO));
        req.setAttribute("compradores", usuarioDAO.listarPorRol(UsuarioDAO.ROL_COMPRADOR));

        req.getRequestDispatcher("/WEB-INF/admin/reportes.jsp").forward(req, resp);
    }
}