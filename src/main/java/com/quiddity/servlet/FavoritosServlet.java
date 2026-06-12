package com.quiddity.servlet;

import com.quiddity.dao.CatalogoDAO;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * GET /favoritos → muestra los productos favoritos del usuario
 */
@WebServlet("/favoritos")
public class FavoritosServlet extends HttpServlet {

    private static final int ROL_COMPRADOR = 2;
    private static final int ROL_USUARIO = 3;

    private final CatalogoDAO catalogoDAO = new CatalogoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int rol = usuario.getIdRol();

        // Solo compradores y usuarios normales ven favoritos
        if (rol != ROL_COMPRADOR && rol != ROL_USUARIO) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Obtener IDs de favoritos del usuario desde la BD
        // Si no tienes tabla de favoritos en BD, usa localStorage vía parámetro
        List<Integer> favIds = obtenerFavoritos(usuario.getId(), req);

        List<Catalogo> productos = new ArrayList<>();
        if (favIds != null && !favIds.isEmpty()) {
            productos = catalogoDAO.obtenerPorIds(favIds);
        }

        req.setAttribute("productos", productos);
        req.getRequestDispatcher("/comprador/favoritos.jsp").forward(req, resp);
    }

    /**
     * Obtiene los IDs de favoritos.
     * Primero intenta desde parámetro (enviado desde localStorage del cliente),
     * si no, intenta desde la base de datos.
     */
    private List<Integer> obtenerFavoritos(int usuarioId, HttpServletRequest req) {
        // Opción 1: Desde parámetro POST/GET (localStorage del cliente)
        String favsParam = req.getParameter("favs");
        if (favsParam != null && !favsParam.isBlank()) {
            List<Integer> ids = new ArrayList<>();
            for (String s : favsParam.split(",")) {
                try {
                    ids.add(Integer.parseInt(s.trim()));
                } catch (NumberFormatException ignored) {}
            }
            return ids;
        }

        // Opción 2: Desde base de datos (si tienes tabla favoritos)
        // Descomenta cuando tengas la tabla:
        // return catalogoDAO.getFavoritosPorUsuario(usuarioId);

        return new ArrayList<>();
    }
}