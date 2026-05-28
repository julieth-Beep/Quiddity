package com.quiddity.servlet;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * FaceScanServlet
 *
 * GET  /facefull  → muestra la página de escaneo facial
 * POST /facefull  → guarda la forma de cara elegida en caracteristicas
 *                   y redirige a la siguiente pantalla de características
 *
 * Valores válidos para formacara:
 *   ovalada | redonda | cuadrada | corazon | diamante | rectangular | triangular
 */
@WebServlet("/facefull")
public class FaceScanServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CaracteristicasDAO caracteristicasDAO = new CaracteristicasDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Requiere sesión activa
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Solo ROL_USUARIO (2) tiene acceso a Face Full
        if (usuario.getIdRol() != 2) {
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

        // Validar que sea un valor permitido
        if (!esFormaValida(formaCara)) {
            req.setAttribute("error", "Selecciona una forma de cara válida.");
            req.getRequestDispatcher("/WEB-INF/usuario/facescan.jsp").forward(req, resp);
            return;
        }

        boolean ok = caracteristicasDAO.actualizarFormaCara(usuario.getId(), formaCara);

        if (ok) {
            // Redirigir a la siguiente etapa de configuración del perfil
            resp.sendRedirect(req.getContextPath() + "/inicio?facescan=ok"); 
            
        } else {
            req.setAttribute("error", "No se pudo guardar la información. Inténtalo de nuevo.");
            req.getRequestDispatcher("/WEB-INF/usuario/facescan.jsp").forward(req, resp);
        }
    }

    private boolean esFormaValida(String forma) {
        if (forma == null) return false;
        return switch (forma.trim().toLowerCase()) {
            case "ovalada", "redonda", "cuadrada", "corazon", "diamante", "rectangular", "triangular" -> true;
            default -> false;
        };
    }
}