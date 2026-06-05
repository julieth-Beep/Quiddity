package com.quiddity.servlet;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.RutinaDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Rutina;
import com.quiddity.model.Usuario;
import com.quiddity.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/rutinas", "/rutinas/categoria"})
public class RutinaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final RutinaDAO rutinaDAO = new RutinaDAO();
    private final CaracteristicasDAO caracteristicasDAO = new CaracteristicasDAO();

    // ─────────────────────────────────────────────
    // GET
    // ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();
        String base = req.getContextPath();

        if (uri.endsWith("/rutinas/categoria")) {
            listarPorCategoria(req, resp, usuario);
        } else {
            listarRutinas(req, resp, usuario);
        }
    }

    // ─────────────────────────────────────────────
    // POST
    // ─────────────────────────────────────────────
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

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "guardar"  -> guardarRutina(req, resp, usuario);
            case "eliminar" -> eliminarRutina(req, resp, usuario);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
        }
    }

    // ─────────────────────────────────────────────
    // VISTAS
    // ─────────────────────────────────────────────

    /**
     * Lista todas las rutinas.
     * - Admin: ve todas sin filtro.
     * - Usuario: ve las filtradas por sus características.
     */
    private void listarRutinas(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws ServletException, IOException {

        try {
            List<Rutina> lista;

            if (esAdmin(usuario)) {
                lista = rutinaDAO.listarTodas();
            } else {
                Caracteristicas caract = caracteristicasDAO.obtenerPorUsuario(usuario.getId());
                if (caract == null) {
                    // Sin características → redirigir a completar perfil
                    resp.sendRedirect(req.getContextPath() + "/caracteristicas");
                    return;
                }
                lista = rutinaDAO.listarPorCaracteristicas(caract);
            }

            req.setAttribute("rutinas", lista);
            req.setAttribute("esAdmin", esAdmin(usuario));

            String jspPath = esAdmin(usuario)
                    ? "/WEB-INF/admin/rutinas.jsp"
                    : "/WEB-INF/usuario/rutinas.jsp";

            req.getRequestDispatcher(jspPath).forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error al listar rutinas", e);
        }
    }

    /**
     * Lista rutinas de una categoría específica.
     * ?categoria=Maquillaje
     */
    private void listarPorCategoria(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws ServletException, IOException {

        String categoria = req.getParameter("categoria");

        if (categoria == null || categoria.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/rutinas");
            return;
        }

        try {
            List<Rutina> lista;

            if (esAdmin(usuario)) {
                lista = rutinaDAO.listarTodas().stream()
                        .filter(r -> categoria.equalsIgnoreCase(r.getCategoria()))
                        .toList();
            } else {
                Caracteristicas caract = caracteristicasDAO.obtenerPorUsuario(usuario.getId());
                if (caract == null) {
                    resp.sendRedirect(req.getContextPath() + "/caracteristicas");
                    return;
                }
                lista = rutinaDAO.listarPorCategoriaYCaracteristicas(categoria, caract);
            }

            req.setAttribute("rutinas", lista);
            req.setAttribute("categoria", categoria);
            req.setAttribute("esAdmin", esAdmin(usuario));

            String jspPath = esAdmin(usuario)
                    ? "/WEB-INF/admin/rutinas.jsp"
                    : "/WEB-INF/usuario/rutinas.jsp";

            req.getRequestDispatcher(jspPath).forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error al listar rutinas por categoría", e);
        }
    }

    // ─────────────────────────────────────────────
    // ACCIONES
    // ─────────────────────────────────────────────

    /**
     * Guarda una rutina favorita del usuario.
     * Solo ROL_USUARIO — el admin no guarda favoritas.
     */
    private void guardarRutina(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException, ServletException {

        if (esAdmin(usuario)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "El admin no puede guardar favoritas");
            return;
        }

        String nombre      = req.getParameter("nombre");
        String objetivo    = req.getParameter("objetivo");
        String categoria   = req.getParameter("categoria");
        String subcategoria = req.getParameter("subcategoria");

        if (nombre == null || nombre.isBlank()) {
            req.setAttribute("error", "El nombre de la rutina es obligatorio.");
            listarRutinas(req, resp, usuario);
            return;
        }

        Rutina nueva = new Rutina();
        nueva.setIdUsuario(usuario.getId());
        nueva.setNombre(nombre);
        nueva.setObjetivo(objetivo);
        nueva.setCategoria(categoria);
        nueva.setSubcategoria(subcategoria);
        // url se dejó null — se agregará cuando esté implementado
        nueva.setFavoritos("true");

        try {
            rutinaDAO.guardar(nueva);
            resp.sendRedirect(req.getContextPath() + "/rutinas?success=Rutina guardada");
        } catch (SQLException e) {
            throw new ServletException("Error al guardar rutina", e);
        }
    }

    /**
     * Elimina una rutina.
     * - Admin: puede eliminar cualquiera.
     * - Usuario: solo las suyas.
     */
    private void eliminarRutina(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException, ServletException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/rutinas");
            return;
        }

        int id = Integer.parseInt(idParam);

        try {
            if (!esAdmin(usuario)) {
                // Verificar que la rutina pertenece al usuario
                Rutina rutina = rutinaDAO.obtenerPorId(id);
                if (rutina == null || rutina.getIdUsuario() != usuario.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "No puedes eliminar esta rutina");
                    return;
                }
            }

            rutinaDAO.eliminar(id);
            resp.sendRedirect(req.getContextPath() + "/rutinas?success=Rutina eliminada");

        } catch (SQLException e) {
            throw new ServletException("Error al eliminar rutina", e);
        }
    }

    // ─────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────
    private boolean esAdmin(Usuario u) {
        return u != null && u.getIdRol() == UsuarioDAO.ROL_ADMIN;
    }
}