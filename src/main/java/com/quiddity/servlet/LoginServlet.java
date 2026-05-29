package com.quiddity.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        // Logout: invalidar sesión y redirigir al login
        if (uri.endsWith("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Si ya hay sesión activa, redirigir directamente según rol
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario u = (Usuario) session.getAttribute("usuario");
            resp.sendRedirect(destino(req, u));
            return;
        }

        // Mostrar la página de login
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String contrasena = req.getParameter("contrasena");

        // Validación mínima de parámetros
        if (email == null || email.isBlank() || contrasena == null || contrasena.isBlank()) {
            req.setAttribute("error", "Por favor ingresa tu correo y contraseña.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Login: buscar por email O username
        Usuario u = usuarioDAO.login(email.trim(), contrasena.trim());

        if (u == null) {
            req.setAttribute("error", "Correo o contraseña incorrectos.");
            req.setAttribute("emailPrevio", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Crear sesión y guardar el usuario autenticado
        HttpSession session = req.getSession(true);
        session.setAttribute("usuario", u);
        session.setAttribute("rolId", u.getIdRol());
        session.setAttribute("esAdmin", u.getIdRol() == UsuarioDAO.ROL_ADMIN);
        session.setAttribute("esComprador", u.getIdRol() == UsuarioDAO.ROL_COMPRADOR);

        // Redirigir al destino según el rol
        resp.sendRedirect(destino(req, u));
    }

    private String destino(HttpServletRequest req, Usuario u) {
        String base = req.getContextPath();
        return switch (u.getIdRol()) {
            case UsuarioDAO.ROL_ADMIN     -> base + "/admin/dashboard";
            case UsuarioDAO.ROL_COMPRADOR -> base + "/catalogo";
            default                       -> base + "/facefull";
        };
    }
}