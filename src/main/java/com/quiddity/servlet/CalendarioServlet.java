package com.quiddity.servlet;

import com.quiddity.dao.CalendarioOutfitDAO;
import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.model.CalendarioOutfit;
import com.quiddity.model.LookGenerado;
import com.quiddity.model.Usuario;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

/**
 * CalendarioServlet — calendario de outfits por día (Imagen 8)
 *
 * GET /calendario → calendario.jsp
 * GET /calendario/mes?mes=YYYY-MM → JSON looks del mes
 * GET /calendario/dia?fecha=YYYY-MM-DD → JSON looks del día
 * POST /calendario → asignar look a fecha
 * PUT /calendario/{id} → actualizar nota/momento/ocasión
 * DELETE /calendario/{id} → quitar look del día
 */
@WebServlet({ "/calendario", "/calendario/*" })
@javax.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024
        * 1024, maxRequestSize = 10 * 1024 * 1024)
public class CalendarioServlet extends HttpServlet {

    private final CalendarioOutfitDAO calendarioDAO = new CalendarioOutfitDAO();
    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final Gson gson = new com.google.gson.GsonBuilder()
            .setDateFormat("yyyy-MM-dd")
            .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        int idUsuario = getIdUsuario(req);

        // Página del calendario
        if (pathInfo == null || pathInfo.equals("/")) {
            req.setAttribute("seccionActiva", "calendario");
            req.getRequestDispatcher("/WEB-INF/usuario/calendario.jsp").forward(req, res);
            return;
        }

        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            if ("/mes".equals(pathInfo)) {
                // GET /calendario/mes?mes=2026-06
                String mes = req.getParameter("mes");
                if (mes == null || mes.isBlank()) {
                    // Si no se pasa mes, usar el mes actual
                    mes = java.time.YearMonth.now().toString();
                }
                List<CalendarioOutfit> lista = calendarioDAO.listarPorMes(idUsuario, mes);
                out.print(gson.toJson(lista));

            } else if ("/dia".equals(pathInfo)) {
                // GET /calendario/dia?fecha=2026-06-15
                String fechaStr = req.getParameter("fecha");
                if (fechaStr == null) {
                    res.setStatus(400);
                    out.print("{\"error\":\"Falta parámetro fecha\"}");
                    return;
                }
                List<CalendarioOutfit> lista = calendarioDAO.listarPorDia(
                        idUsuario, Date.valueOf(fechaStr));
                out.print(gson.toJson(lista));

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
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            String fechaStr = req.getParameter("fecha");
            String idLookStr = req.getParameter("idLook");

            if (fechaStr == null || idLookStr == null) {
                res.setStatus(400);
                out.print("{\"error\":\"Faltan parámetros fecha e idLook\"}");
                return;
            }

            int idLook = Integer.parseInt(idLookStr);

            // Verificar que el look pertenece al usuario
            LookGenerado look = lookDAO.obtenerPorIdYUsuario(idLook, idUsuario);
            if (look == null) {
                res.setStatus(403);
                out.print("{\"error\":\"Look no autorizado\"}");
                return;
            }

            CalendarioOutfit co = new CalendarioOutfit();
            co.setIdUsuario(idUsuario);
            co.setIdLook(idLook);
            co.setFecha(Date.valueOf(fechaStr));
            co.setMomentoDia(req.getParameter("momento"));
            co.setOcasion(req.getParameter("ocasion"));
            co.setNota(req.getParameter("nota"));

            boolean ok = calendarioDAO.crear(co);
            if (ok) {
                res.setStatus(201);
                out.print("{\"id\":" + co.getId() + ",\"mensaje\":\"Look asignado al calendario\"}");
            } else {
                res.setStatus(400);
                out.print("{\"error\":\"No se pudo asignar\"}");
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

        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                res.setStatus(400);
                out.print("{\"error\":\"ID requerido\"}");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));

            CalendarioOutfit co = new CalendarioOutfit();
            co.setId(id);
            co.setIdUsuario(idUsuario);
            co.setMomentoDia(req.getParameter("momento"));
            co.setOcasion(req.getParameter("ocasion"));
            co.setNota(req.getParameter("nota"));

            boolean ok = calendarioDAO.actualizar(co);
            res.setStatus(ok ? 200 : 404);
            out.print(ok ? "{\"mensaje\":\"Actualizado\"}"
                    : "{\"error\":\"No encontrado\"}");

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
            boolean ok = calendarioDAO.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 404);
            out.print(ok ? "{\"mensaje\":\"Look quitado del calendario\"}"
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