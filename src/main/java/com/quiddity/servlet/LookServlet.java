package com.quiddity.servlet;

import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.model.LookGenerado;
import com.quiddity.model.Usuario;
import com.quiddity.util.ImagenUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * LookServlet — historial de looks generados (Imagen 7)
 *
 * GET /look → historial_looks.jsp
 * GET /look/api → JSON todos los looks del usuario
 * GET /look/api/favoritos → JSON solo favoritos
 * PUT /look/{id}/fav → toggle favorito
 * DELETE /look/{id} → eliminar look + imagen del disco
 */
@WebServlet({ "/look", "/look/*" })
@javax.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024
        * 1024, maxRequestSize = 10 * 1024 * 1024)
public class LookServlet extends HttpServlet {

    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final Gson gson = new com.google.gson.GsonBuilder().setDateFormat("yyyy-MM-dd").create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        int idUsuario = getIdUsuario(req);

        // Página del historial visual
        if (pathInfo == null || pathInfo.equals("/")) {
            List<LookGenerado> looks = new java.util.ArrayList<>();
            try {
                looks = lookDAO.listarPorUsuario(idUsuario);
            } catch (Exception ignored) {
            }
            req.setAttribute("looks", looks);
            req.setAttribute("seccionActiva", "historial");
            req.getRequestDispatcher("/WEB-INF/usuario/historial_looks.jsp").forward(req, res);
            return;
        }

        // API JSON
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            if ("/api".equals(pathInfo)) {
                out.print(gson.toJson(lookDAO.listarPorUsuario(idUsuario)));
            } else if ("/api/favoritos".equals(pathInfo)) {
                out.print(gson.toJson(lookDAO.listarFavoritos(idUsuario)));
            } else {
                res.setStatus(404);
                out.print("{\"error\":\"Ruta no encontrada\"}");
            }
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        String pathInfo = req.getPathInfo();

        try {
            // PUT /look/{id}/fav → toggle favorito
            if (pathInfo != null && pathInfo.endsWith("/fav")) {
                int id = Integer.parseInt(pathInfo.replace("/fav", "").substring(1));
                boolean ok = lookDAO.toggleFavorito(id, idUsuario);
                res.setStatus(ok ? 200 : 404);
                out.print(ok ? "{\"mensaje\":\"Favorito actualizado\"}"
                        : "{\"error\":\"Look no encontrado\"}");
            } else {
                res.setStatus(400);
                out.print("{\"error\":\"Ruta no válida\"}");
            }
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                res.setStatus(400);
                out.print("{\"error\":\"ID requerido\"}");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));

            // Eliminar archivo del disco antes de borrar de BD
            LookGenerado lg = lookDAO.obtenerPorIdYUsuario(id, idUsuario);
            if (lg != null)
                ImagenUtil.eliminar(lg.getImagenGenerada(), req);

            boolean ok = lookDAO.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 404);
            out.print(ok ? "{\"mensaje\":\"Look eliminado\"}"
                    : "{\"error\":\"No encontrado\"}");
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private int getIdUsuario(HttpServletRequest req) {
        return ((Usuario) req.getSession(false).getAttribute("usuario")).getId();
    }
}