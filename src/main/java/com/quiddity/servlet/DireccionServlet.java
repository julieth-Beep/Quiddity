package com.quiddity.servlet;

import com.quiddity.dao.DireccionDAO;
import com.quiddity.model.Direccion;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * DireccionServlet
 *
 * GET  /direccion?accion=predeterminada&id={id}  → establecer predeterminada
 * POST /direccion?accion=guardarAjax             → guardar nueva dirección (responde JSON)
 * POST /direccion?accion=eliminar                → eliminar dirección
 * POST /direccion?accion=predeterminada          → establecer predeterminada (POST)
 */
@WebServlet("/direccion")
public class DireccionServlet extends HttpServlet {

    private final DireccionDAO direccionDAO = new DireccionDAO();

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        String accion = req.getParameter("accion");

        if ("predeterminada".equals(accion)) {
            int id = parseInt(req.getParameter("id"), 0);
            if (id > 0) direccionDAO.establecerPredeterminada(usuario.getId(), id);
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/checkout");
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        String accion = req.getParameter("accion");

        switch (accion != null ? accion : "") {
            case "guardarAjax"   -> accionGuardarAjax(req, resp, usuario);
            case "eliminar"      -> accionEliminar(req, resp, usuario);
            case "predeterminada"-> accionPredeterminada(req, resp, usuario);
            default              -> resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GUARDAR NUEVA DIRECCIÓN — responde JSON para el fetch del JSP
    // ─────────────────────────────────────────────────────────────────────────
    private void accionGuardarAjax(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String departamento = req.getParameter("departamento");
        String ciudad       = req.getParameter("ciudad");
        String direccion    = req.getParameter("direccion");

        // Validación mínima
        if (esVacio(departamento) || esVacio(ciudad) || esVacio(direccion)) {
            out.print("{\"success\":false,\"message\":\"Departamento, ciudad y dirección son obligatorios.\"}");
            return;
        }

        Direccion d = new Direccion();
        d.setUsuarioId(usuario.getId());
        d.setDepartamento(departamento.trim());
        d.setCiudad(ciudad.trim());
        d.setDireccion(direccion.trim());
        d.setBarrio(req.getParameter("barrio") != null ? req.getParameter("barrio").trim() : null);
        d.setEsRural("true".equals(req.getParameter("esRural")));
        d.setDescripcionRural(req.getParameter("descripcionRural") != null
                ? req.getParameter("descripcionRural").trim() : null);
        boolean predeterminada = "true".equals(req.getParameter("predeterminada"));
        d.setPredeterminada(predeterminada);

        // Si va a ser predeterminada, primero quitarle el flag a las demás
        if (predeterminada) {
            direccionDAO.establecerPredeterminada(usuario.getId(), -1); // quita todas
        }

        boolean ok = direccionDAO.crear(d);

        if (ok) {
            // Si era predeterminada, ahora sí actualizar la que acabamos de crear
            if (predeterminada) {
                // Obtener la que acabamos de insertar (la más reciente del usuario)
                List<com.quiddity.model.Direccion> lista = direccionDAO.listarPorUsuario(usuario.getId());
                if (!lista.isEmpty()) {
                    direccionDAO.establecerPredeterminada(usuario.getId(), lista.get(0).getId());
                }
            }
            out.print("{\"success\":true,\"message\":\"Dirección guardada correctamente.\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"No se pudo guardar la dirección. Intenta de nuevo.\"}");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ELIMINAR DIRECCIÓN
    // ─────────────────────────────────────────────────────────────────────────
    private void accionEliminar(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id > 0) direccionDAO.eliminar(id, usuario.getId());

        String redirect = req.getParameter("redirect");
        if ("checkout".equals(redirect)) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
        } else {
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ESTABLECER PREDETERMINADA (POST)
    // ─────────────────────────────────────────────────────────────────────────
    private void accionPredeterminada(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException {

        int id = parseInt(req.getParameter("id"), 0);
        if (id > 0) direccionDAO.establecerPredeterminada(usuario.getId(), id);

        String redirect = req.getParameter("redirect");
        if ("checkout".equals(redirect)) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
        } else {
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────────────────────────────────

    private Usuario usuarioAutenticado(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            // Si es una petición AJAX, responder con JSON en vez de redirigir
            if ("guardarAjax".equals(req.getParameter("accion"))) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"message\":\"Sesión expirada. Recarga la página.\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return null;
        }
        return (Usuario) session.getAttribute("usuario");
    }

    private boolean esVacio(String s) {
        return s == null || s.trim().isEmpty();
    }

    private int parseInt(String valor, int defecto) {
        try { return Integer.parseInt(valor); }
        catch (NumberFormatException | NullPointerException e) { return defecto; }
    }
}