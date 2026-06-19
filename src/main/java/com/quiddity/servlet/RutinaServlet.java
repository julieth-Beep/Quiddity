package com.quiddity.servlet;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.RutinaDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Rutina;
import com.quiddity.model.Usuario;

@WebServlet("/rutinas")
public class RutinaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final RutinaDAO rutinaDAO = new RutinaDAO();
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

        boolean esAdmin = usuario.getIdRol() == 1;
        String categoria = req.getParameter("categoria");
        List<Rutina> rutinas;

        if (esAdmin) {
            if (categoria != null && !categoria.isBlank()) {
                rutinas = rutinaDAO.obtenerTodas().stream()
                        .filter(r -> categoria.equalsIgnoreCase(r.getCategoria()))
                        .collect(Collectors.toList());
            } else {
                rutinas = rutinaDAO.obtenerTodas();
            }
            req.setAttribute("rutinas", rutinas);
            req.getRequestDispatcher("/WEB-INF/admin/rutinas.jsp").forward(req, resp);

        } else {
            Caracteristicas caract = caracteristicasDAO.obtenerPorUsuario(usuario.getId());
            if (categoria != null && !categoria.isBlank()) {
                rutinas = rutinaDAO.obtenerRecomendadasPorCategoria(caract, categoria);
            } else {
                rutinas = rutinaDAO.obtenerRecomendadasParaUsuario(caract);
            }
            req.setAttribute("caracteristicas", caract);
            req.setAttribute("perfilIncompleto", caract == null);
            req.setAttribute("rutinas", rutinas);
            req.getRequestDispatcher("/WEB-INF/usuario/rutinas.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Cualquier acción requiere estar logueado, pero NO todas requieren ser admin.
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean esAdmin = usuario.getIdRol() == 1;
        String action  = req.getParameter("action");
        String idParam = req.getParameter("id");

        try {
            if ("guardar".equals(action)) {
                // Solo el admin puede crear/editar rutinas.
                if (!esAdmin) {
                    resp.sendRedirect(req.getContextPath() + "/rutinas?error=No+tienes+permisos+para+esta+accion");
                    return;
                }

                Rutina r = new Rutina();

                if (idParam != null && !idParam.isBlank()) {
                    r.setId(Integer.parseInt(idParam.trim()));
                }

                r.setNombre(req.getParameter("nombre"));
                r.setObjetivo(req.getParameter("objetivo"));
                r.setCategoria(req.getParameter("categoria"));
                r.setSubcategoria(req.getParameter("subcategoria"));
                r.setUrl(req.getParameter("url"));
                r.setFavoritos(req.getParameter("favoritos") != null ? req.getParameter("favoritos") : "false");

                String tipoPiel    = req.getParameter("tipo_piel");
                String tipoCabello = req.getParameter("tipo_cabello");
                String tonoPiel    = req.getParameter("tono_piel");
                String formaCara   = req.getParameter("forma_cara");
                String tipoCuerpo  = req.getParameter("tipo_cuerpo");

                r.setTipoPiel   (tipoPiel    != null && !tipoPiel.isBlank()    ? tipoPiel    : null);
                r.setTipoCabello(tipoCabello != null && !tipoCabello.isBlank() ? tipoCabello : null);
                r.setTonoPiel   (tonoPiel    != null && !tonoPiel.isBlank()    ? tonoPiel    : null);
                r.setFormaCara  (formaCara   != null && !formaCara.isBlank()   ? formaCara   : null);
                r.setTipoCuerpo (tipoCuerpo  != null && !tipoCuerpo.isBlank()  ? tipoCuerpo  : null);
                r.setIdUsuario(usuario.getId());
                
                if (r.getId() > 0) {
                    rutinaDAO.actualizar(r);
                    resp.sendRedirect(req.getContextPath() + "/rutinas?success=Rutina+actualizada+correctamente");
                } else {
                    rutinaDAO.guardar(r);
                    resp.sendRedirect(req.getContextPath() + "/rutinas?success=Rutina+creada+correctamente");
                }

            } else if ("eliminar".equals(action)) {
                // Solo el admin puede eliminar rutinas.
                if (!esAdmin) {
                    resp.sendRedirect(req.getContextPath() + "/rutinas?error=No+tienes+permisos+para+esta+accion");
                    return;
                }

                rutinaDAO.eliminar(Integer.parseInt(idParam.trim()));
                resp.sendRedirect(req.getContextPath() + "/rutinas?success=Rutina+eliminada+correctamente");

            } else if ("favorito".equals(action)) {
                // Cualquier usuario logueado (admin, comprador o usuario) puede marcar favoritos.
                boolean fav = "true".equals(req.getParameter("favoritos"));
                rutinaDAO.marcarFavorito(Integer.parseInt(idParam.trim()), fav);
                resp.sendRedirect(req.getContextPath() + "/rutinas");

            } else {
                resp.sendRedirect(req.getContextPath() + "/rutinas");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/rutinas?error=Error+al+procesar+la+rutina");
        }
    }
}