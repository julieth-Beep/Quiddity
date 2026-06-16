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
 * GET  /favoritos?favs=1,2,3  → muestra los productos favoritos del usuario
 * POST /favoritos              → igual, acepta favs en el body
 */
@WebServlet("/favoritos")
public class FavoritosServlet extends HttpServlet {

    private static final int ROL_COMPRADOR = 2;
    private static final int ROL_USUARIO   = 3;

    private final CatalogoDAO catalogoDAO = new CatalogoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        procesarFavoritos(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        procesarFavoritos(req, resp);
    }

    private void procesarFavoritos(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int rol = usuario.getIdRol();

        if (rol != ROL_COMPRADOR && rol != ROL_USUARIO) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Integer> favIds = parsearFavsParam(req.getParameter("favs"));

        List<Catalogo> productos = new ArrayList<>();
        if (!favIds.isEmpty()) {
            productos = catalogoDAO.obtenerPorIds(favIds);
        }

        req.setAttribute("productos", productos);
        req.getRequestDispatcher("/comprador/favoritos.jsp").forward(req, resp);
    }

    /**
     * Parsea el parámetro "favs" (ej: "1,2,3") a lista de enteros.
     * Retorna lista vacía si el parámetro es nulo o inválido.
     */
    private List<Integer> parsearFavsParam(String favsParam) {
        List<Integer> ids = new ArrayList<>();
        if (favsParam == null || favsParam.isBlank()) return ids;
        for (String s : favsParam.split(",")) {
            try {
                int id = Integer.parseInt(s.trim());
                if (id > 0) ids.add(id);
            } catch (NumberFormatException ignored) {}
        }
        return ids;
    }
}