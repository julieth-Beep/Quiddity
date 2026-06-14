package com.quiddity.servlet;

import com.google.gson.Gson;
import com.quiddity.dao.OutfitPrendaDAO;
import com.quiddity.model.OutfitPrenda;
import com.quiddity.model.Usuario;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/outfitprenda/*")
public class OutfitPrendaServlet extends HttpServlet {

    private final OutfitPrendaDAO dao = new OutfitPrendaDAO();
    private final Gson gson = new Gson();

    /**
     * GET /outfitprenda?idOutfit=X → lista de OutfitPrenda (con prenda incluida)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getUsuarioSesion(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            String param = req.getParameter("idOutfit");
            if (param == null) {
                res.setStatus(400);
                out.print("{\"error\":\"Falta parámetro idOutfit\"}");
                return;
            }
            int idOutfit = Integer.parseInt(param);
            List<OutfitPrenda> lista = dao.listarPorOutfit(idOutfit, idUsuario);
            out.print(gson.toJson(lista));
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    /** POST /outfitprenda → agregar prenda al outfit */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getUsuarioSesion(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            OutfitPrenda op = gson.fromJson(req.getReader(), OutfitPrenda.class);
            boolean ok = dao.agregar(op, idUsuario);
            res.setStatus(ok ? 201 : 403);
            out.print(ok ? "{\"mensaje\":\"Prenda agregada al outfit\"}"
                    : "{\"error\":\"No autorizado o prenda/outfit no encontrado\"}");
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    /** DELETE /outfitprenda/{id} → quitar prenda del outfit */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getUsuarioSesion(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                res.setStatus(400);
                out.print("{\"error\":\"Falta ID de la relación\"}");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));
            boolean ok = dao.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 403);
            out.print(ok ? "{\"mensaje\":\"Prenda eliminada del outfit\"}"
                    : "{\"error\":\"No autorizado o no encontrado\"}");
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private int getUsuarioSesion(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        Usuario u = (Usuario) session.getAttribute("usuario");
        return u.getId();
    }
}