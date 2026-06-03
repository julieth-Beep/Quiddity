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

@WebServlet("/recuperar")
public class RecuperarContrasenaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Limpiar sesión de recuperación si viene de cero
        req.getSession().removeAttribute("emailRecuperacion");
        req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String paso = req.getParameter("paso");

        if ("2".equals(paso)) {
            cambiarContrasena(req, resp);
        } else {
            verificarEmail(req, resp);
        }
    }

    // ── Paso 1: verificar que el email exista ─────────────────────────────
    private void verificarEmail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Ingresa tu correo electrónico.");
            req.setAttribute("paso", "1");
            req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();
        Usuario u = usuarioDAO.obtenerPorEmail(email);

        if (u == null) {
            req.setAttribute("error", "No encontramos ninguna cuenta con ese correo.");
            req.setAttribute("paso", "1");
            req.setAttribute("emailPrevio", email);
            req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
            return;
        }

        // Email válido: guardar en sesión (no en campo oculto)
        HttpSession session = req.getSession();
        session.setAttribute("emailRecuperacion", email);

        req.setAttribute("paso", "2");
        req.setAttribute("emailVerificado", email);
        req.setAttribute("nombreUsuario", u.getNombre());
        req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
    }

    // ── Paso 2: guardar la nueva contraseña ───────────────────────────────
    private void cambiarContrasena(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Leer email desde sesión, no del formulario
        HttpSession session = req.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("emailRecuperacion") : null;

        // Si no hay sesión válida, redirigir al inicio
        if (email == null || email.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/recuperar");
            return;
        }

        String nueva = req.getParameter("nuevaContrasena");
        String confirmar = req.getParameter("confirmarContrasena");

        if (nueva == null || nueva.length() < 8) {
            req.setAttribute("error", "La contraseña debe tener al menos 8 caracteres.");
            req.setAttribute("paso", "2");
            req.setAttribute("emailVerificado", email);
            req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
            return;
        }

        if (!nueva.equals(confirmar)) {
            req.setAttribute("error", "Las contraseñas no coinciden.");
            req.setAttribute("paso", "2");
            req.setAttribute("emailVerificado", email);
            req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
            return;
        }

        Usuario u = usuarioDAO.obtenerPorEmail(email);
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/recuperar");
            return;
        }

        boolean ok = usuarioDAO.cambiarContrasena(u.getId(), nueva);
        if (ok) {
            // Limpiar sesión de recuperación
            session.removeAttribute("emailRecuperacion");
            resp.sendRedirect(req.getContextPath() + "/login?recuperacion=ok");
        } else {
            req.setAttribute("error", "No se pudo actualizar la contraseña. Inténtalo de nuevo.");
            req.setAttribute("paso", "2");
            req.setAttribute("emailVerificado", email);
            req.getRequestDispatcher("/recuperar.jsp").forward(req, resp);
        }
    }
}