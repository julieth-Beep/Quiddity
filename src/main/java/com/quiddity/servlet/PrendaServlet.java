package com.quiddity.servlet;

import com.quiddity.dao.PrendaDAO;
import com.quiddity.dao.PrendaPrettifyDAO;
import com.quiddity.model.Prenda;
import com.quiddity.model.PrendaPrettify;
import com.quiddity.model.Usuario;
import com.quiddity.util.ImagenUtil;
import com.quiddity.util.RemoveBgUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * PrendaServlet — CRUD completo del closet + Prettify integrado
 *
 * GET /closet/prenda → JSON lista de prendas del usuario
 * GET /closet/prenda?tipo=X → JSON prendas filtradas por tipo
 * GET /closet/prenda/{id} → JSON prenda específica
 * POST /closet/prenda → crear prenda (con imagen, aplica Prettify automático)
 * PUT /closet/prenda/{id} → actualizar prenda
 * DELETE /closet/prenda/{id} → eliminar prenda
 * POST /closet/prenda/{id}/prettify → re-aplicar Prettify manualmente
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
@WebServlet("/closet/prenda/*")
public class PrendaServlet extends HttpServlet {

    private final PrendaDAO prendaDAO = new PrendaDAO();
    private final PrendaPrettifyDAO prettifyDAO = new PrendaPrettifyDAO();
    private final Gson gson = new Gson();

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            String pathInfo = req.getPathInfo(); // null | "/{id}"

            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar — con filtro opcional por tipo
                String tipo = req.getParameter("tipo");
                List<Prenda> lista = (tipo != null && !tipo.isBlank())
                        ? prendaDAO.listarPorTipo(idUsuario, tipo)
                        : prendaDAO.listarPorUsuario(idUsuario);
                out.print(gson.toJson(lista));
            } else {
                // Prenda específica
                int id = parsearId(pathInfo);
                Prenda p = prendaDAO.obtenerPorIdYUsuario(id, idUsuario);
                if (p == null) {
                    res.setStatus(404);
                    out.print("{\"error\":\"Prenda no encontrada\"}");
                } else
                    out.print(gson.toJson(p));
            }
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            String pathInfo = req.getPathInfo();

            // POST /closet/prenda/{id}/prettify → re-aplicar Prettify
            if (pathInfo != null && pathInfo.endsWith("/prettify")) {
                int id = parsearId(pathInfo.replace("/prettify", ""));
                aplicarPrettify(id, idUsuario, req, res, out);
                return;
            }

            // POST /closet/prenda → crear prenda nueva
            Part filePart = req.getPart("imagen");
            if (!ImagenUtil.tieneArchivo(filePart)) {
                res.setStatus(400);
                out.print("{\"error\":\"La imagen es obligatoria\"}");
                return;
            }

            // 1. Guardar imagen original
            String rutaOriginal = ImagenUtil.guardarPrenda(filePart, req);

            // 2. Aplicar Prettify con RemoveBg (quitar fondo)
            String rutaFinal = aplicarRemoveBg(rutaOriginal, req);

            // 3. Crear prenda en BD
            Prenda p = new Prenda();
            p.setIdUsuario(idUsuario);
            p.setTipo(req.getParameter("tipo"));
            p.setColor(req.getParameter("color"));
            p.setEstilo(req.getParameter("estilo"));
            p.setTemporada(req.getParameter("temporada"));
            p.setTemporada(req.getParameter("temporada"));
            p.setSubcategoria(req.getParameter("subcategoria"));
            p.setImagen(rutaFinal); // ya procesada

            boolean ok = prendaDAO.crear(p);
            if (!ok) {
                res.setStatus(400);
                out.print("{\"error\":\"No se pudo crear la prenda\"}");
                return;
            }

            // 4. Guardar registro de prettify si se procesó
            if (!rutaFinal.equals(rutaOriginal)) {
                PrendaPrettify pp = new PrendaPrettify();
                pp.setIdPrenda(p.getId());
                pp.setImagenOriginal(rutaOriginal);
                pp.setImagenCorregida(rutaFinal);
                pp.setParametros("{\"proveedor\":\"remove.bg\",\"auto\":true}");
                prettifyDAO.crear(pp);
            }

            res.setStatus(201);
            out.print("{\"id\":" + p.getId()
                    + ",\"imagen\":\"" + rutaFinal + "\""
                    + ",\"mensaje\":\"Prenda agregada al closet\"}");

        } catch (IllegalArgumentException e) {
            res.setStatus(400);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // ── PUT ───────────────────────────────────────────────────────────────────
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            int id = parsearId(req.getPathInfo());
            Prenda existente = prendaDAO.obtenerPorIdYUsuario(id, idUsuario);
            if (existente == null) {
                res.setStatus(403);
                out.print("{\"error\":\"No autorizado o prenda no encontrada\"}");
                return;
            }

            // Actualizar campos de texto
            if (req.getParameter("tipo") != null)
                existente.setTipo(req.getParameter("tipo"));
            if (req.getParameter("color") != null)
                existente.setColor(req.getParameter("color"));
            if (req.getParameter("estilo") != null)
                existente.setEstilo(req.getParameter("estilo"));
            if (req.getParameter("temporada") != null)
                existente.setTemporada(req.getParameter("temporada"));
            if (req.getParameter("subcategoria") != null) // ← NUEVO BLOQUE
                existente.setSubcategoria(req.getParameter("subcategoria"));

            // Nueva imagen opcional
            Part filePart = req.getPart("imagen");
            if (ImagenUtil.tieneArchivo(filePart)) {
                ImagenUtil.eliminar(existente.getImagen(), req);
                String rutaOriginal = ImagenUtil.guardarPrenda(filePart, req);
                String rutaFinal = aplicarRemoveBg(rutaOriginal, req);
                existente.setImagen(rutaFinal);

                if (!rutaFinal.equals(rutaOriginal)) {
                    PrendaPrettify pp = new PrendaPrettify();
                    pp.setIdPrenda(id);
                    pp.setImagenOriginal(rutaOriginal);
                    pp.setImagenCorregida(rutaFinal);
                    pp.setParametros("{\"proveedor\":\"remove.bg\",\"auto\":true}");
                    prettifyDAO.crear(pp);
                }
            }

            boolean ok = prendaDAO.actualizar(existente);
            res.setStatus(ok ? 200 : 400);
            out.print(ok ? "{\"mensaje\":\"Prenda actualizada\"}"
                    : "{\"error\":\"No se pudo actualizar\"}");

        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // ── DELETE ────────────────────────────────────────────────────────────────
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            int id = parsearId(req.getPathInfo());
            Prenda p = prendaDAO.obtenerPorIdYUsuario(id, idUsuario);
            if (p == null) {
                res.setStatus(403);
                out.print("{\"error\":\"No autorizado\"}");
                return;
            }
            ImagenUtil.eliminar(p.getImagen(), req);
            boolean ok = prendaDAO.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 400);
            out.print(ok ? "{\"mensaje\":\"Prenda eliminada\"}"
                    : "{\"error\":\"No se pudo eliminar\"}");

        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // ── PRETTIFY ──────────────────────────────────────────────────────────────

    /**
     * Llama a RemoveBg, guarda el resultado y actualiza la imagen en BD.
     * Si RemoveBg falla, deja la imagen original sin error.
     */
    private String aplicarRemoveBg(String rutaOriginal, HttpServletRequest req) {
        try {
            // Leer bytes del archivo guardado
            String rutaAbsoluta = req.getServletContext().getRealPath("")
                    + java.io.File.separator
                    + rutaOriginal.replace("/", java.io.File.separator);

            byte[] bytesOriginales = java.nio.file.Files.readAllBytes(
                    java.nio.file.Paths.get(rutaAbsoluta));

            byte[] bytesProcesados = RemoveBgUtil.removerFondo(bytesOriginales);

            if (bytesProcesados == null || bytesProcesados.length == 0) {
                // RemoveBg falló — usar imagen original sin procesar
                System.out.println("[PrendaServlet] RemoveBg falló, usando imagen original.");
                return rutaOriginal;
            }

            // Guardar imagen procesada en subcarpeta prettify
            String rutaPrettify = ImagenUtil.guardarBytes(
                    bytesProcesados, "uploads/prettify/", ".png", req);

            return rutaPrettify;

        } catch (Exception e) {
            System.err.println("[PrendaServlet] Error en Prettify: " + e.getMessage());
            return rutaOriginal; // fallback seguro
        }
    }

    /** Handler para POST /closet/prenda/{id}/prettify */
    private void aplicarPrettify(int id, int idUsuario,
            HttpServletRequest req, HttpServletResponse res, PrintWriter out)
            throws Exception {

        Prenda p = prendaDAO.obtenerPorIdYUsuario(id, idUsuario);
        if (p == null) {
            res.setStatus(403);
            out.print("{\"error\":\"No autorizado\"}");
            return;
        }

        String rutaFinal = aplicarRemoveBg(p.getImagen(), req);
        if (rutaFinal.equals(p.getImagen())) {
            res.setStatus(500);
            out.print("{\"error\":\"No se pudo procesar la imagen\"}");
            return;
        }

        // Guardar imagen prettificada
        prendaDAO.guardarImagenPrettify(id, idUsuario, rutaFinal);

        PrendaPrettify pp = new PrendaPrettify();
        pp.setIdPrenda(id);
        pp.setImagenOriginal(p.getImagen());
        pp.setImagenCorregida(rutaFinal);
        pp.setParametros("{\"proveedor\":\"remove.bg\",\"manual\":true}");
        prettifyDAO.crear(pp);

        out.print("{\"mensaje\":\"Prettify aplicado\",\"imagen\":\"" + rutaFinal + "\"}");
    }

    // ── AUXILIARES ────────────────────────────────────────────────────────────

    private int getIdUsuario(HttpServletRequest req) {
        return ((Usuario) req.getSession(false).getAttribute("usuario")).getId();
    }

    private int parsearId(String pathInfo) {
        // pathInfo puede ser "/{id}" → quitar el /
        String limpio = pathInfo.replaceAll("[^0-9]", "");
        return Integer.parseInt(limpio);
    }
}