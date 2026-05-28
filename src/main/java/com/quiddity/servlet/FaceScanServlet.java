package com.quiddity.servlet;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/facefull")
public class FaceScanServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CaracteristicasDAO caracteristicasDAO = new CaracteristicasDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (usuario.getIdRol() != UsuarioDAO.ROL_USUARIO) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/usuario/facescan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String formaCara = req.getParameter("formaCara");
        String tonoPiel  = req.getParameter("tonoPiel");

        if (!esFormaValida(formaCara)) {
            req.setAttribute("error", "Selecciona una forma de cara válida.");
            req.getRequestDispatcher("/WEB-INF/usuario/facescan.jsp").forward(req, resp);
            return;
        }

        // Guardar forma de cara
        boolean ok = caracteristicasDAO.actualizarFormaCara(usuario.getId(), formaCara);

        // Guardar tono de piel si fue seleccionado
        if (ok && tonoPiel != null && !tonoPiel.isBlank()) {
            caracteristicasDAO.actualizarTonoPiel(usuario.getId(), tonoPiel);
        }

        if (ok) {
            // Redirigir al formulario de características restantes
            resp.sendRedirect(req.getContextPath() + "/caracteristicas");
        } else {
            req.setAttribute("error", "No se pudo guardar la información. Inténtalo de nuevo.");
            req.getRequestDispatcher("/WEB-INF/usuario/facescan.jsp").forward(req, resp);
        }
    }

    private boolean esFormaValida(String forma) {
        if (forma == null) return false;
        return switch (forma.trim().toLowerCase()) {
            case "ovalada","redonda","cuadrada","corazon","diamante","rectangular","triangular" -> true;
            default -> false;
        };
    }
}