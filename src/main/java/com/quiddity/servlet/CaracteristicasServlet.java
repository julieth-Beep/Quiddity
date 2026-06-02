package com.quiddity.servlet;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/caracteristicas")
public class CaracteristicasServlet extends HttpServlet {

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

        req.getRequestDispatcher("/WEB-INF/usuario/caracteristicas.jsp").forward(req, resp);
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

        String tipoCuerpo  = req.getParameter("tipoCuerpo");
        String tipoCabello = req.getParameter("tipoCabello");
        String tipoPiel    = req.getParameter("tipoPiel");

        if (!esTipoCuerpoValido(tipoCuerpo) || !esTipoCabelloValido(tipoCabello) || !esTipoPielValido(tipoPiel)) {
            req.setAttribute("error", "Debes seleccionar todas las opciones.");
            req.getRequestDispatcher("/WEB-INF/usuario/caracteristicas.jsp").forward(req, resp);
            return;
        }

        // Cargar el registro existente del usuario (ya creado por facefull)
        Caracteristicas existente = caracteristicasDAO.obtenerPorUsuario(usuario.getId());

        if (existente != null) {
            existente.setTipoCuerpo(tipoCuerpo);
            existente.setTipoCabello(tipoCabello);
            existente.setTipoPiel(tipoPiel);
            boolean ok = caracteristicasDAO.actualizar(existente);

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/usuario");
            } else {
                req.setAttribute("error", "No se pudo guardar la informacion. Intentalo de nuevo.");
                req.getRequestDispatcher("/WEB-INF/usuario/caracteristicas.jsp").forward(req, resp);
            }
        } else {
            // Fallback: crear nuevo registro con los 3 campos
            Caracteristicas nueva = new Caracteristicas();
            nueva.setTipoCuerpo(tipoCuerpo);
            nueva.setTipoCabello(tipoCabello);
            nueva.setTipoPiel(tipoPiel);
            boolean ok = caracteristicasDAO.crearParaUsuario(usuario.getId(), nueva);

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/usuario");
            } else {
                req.setAttribute("error", "No se pudo guardar la informacion. Intentalo de nuevo.");
                req.getRequestDispatcher("/WEB-INF/usuario/caracteristicas.jsp").forward(req, resp);
            }
        }
    }

    private boolean esTipoCuerpoValido(String v) {
        if (v == null) return false;
        return switch (v.trim().toLowerCase()) {
            case "rectangulo", "pera", "manzana", "reloj_arena", "invertido" -> true;
            default -> false;
        };
    }

    private boolean esTipoCabelloValido(String v) {
        if (v == null) return false;
        return switch (v.trim().toLowerCase()) {
            case "liso", "ondulado", "rizado", "muy_rizado", "corto" -> true;
            default -> false;
        };
    }

    private boolean esTipoPielValido(String v) {
        if (v == null) return false;
        return switch (v.trim().toLowerCase()) {
            case "normal", "seca", "grasa", "mixta", "sensible" -> true;
            default -> false;
        };
    }
}