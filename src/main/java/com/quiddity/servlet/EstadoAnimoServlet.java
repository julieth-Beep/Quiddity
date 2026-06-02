package com.quiddity.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.FraseDAO;
import com.quiddity.dao.NotificacionDAO;
import com.quiddity.model.Frase;
import com.quiddity.model.Notificacion;
import com.quiddity.model.Usuario;

@WebServlet("/estadoAnimo")
public class EstadoAnimoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final FraseDAO        fraseDAO        = new FraseDAO();
    private final NotificacionDAO notificacionDAO = new NotificacionDAO();

    // ── GET: mostrar pantalla de selección ────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Sin sesión → login
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Ya eligió hoy → home
        if (session.getAttribute("estadoAnimoSeleccionado") != null) {
            resp.sendRedirect(req.getContextPath() + "/inicio");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/usuario/estadoAnimo.jsp").forward(req, resp);
    }

    // ── POST: procesar selección ──────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String estado = req.getParameter("estado");
        if (estado == null || estado.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/estadoAnimo");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Buscar frase aleatoria según el estado de ánimo
        Frase frase = fraseDAO.buscarPorEstadoAnimo(estado);

        if (frase != null) {
            // Registrar notificación (qué frase se le mostró)
            Notificacion notif = new Notificacion(0, usuario.getId(), frase.getId());
            notificacionDAO.insertar(notif);

            // Guardar en sesión para no volver a preguntar
            session.setAttribute("estadoAnimoSeleccionado", estado);
            session.setAttribute("fraseActual", frase);
        } else {
            // No hay frases cargadas para ese estado → igual dejar pasar
            session.setAttribute("estadoAnimoSeleccionado", estado);
        }

        resp.sendRedirect(req.getContextPath() + "/inicio");
    }
}