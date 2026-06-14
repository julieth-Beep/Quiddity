package com.quiddity.servlet;

import com.quiddity.dao.AvatarDAO;
import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.dao.ViajeDAO;
import com.quiddity.model.*;
import com.quiddity.util.HuggingFaceUtil;
import com.quiddity.util.OpenWeatherUtil;
import com.quiddity.util.PromptBuilder;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

/**
 * ViajeServlet — gestión de viajes y outfits recomendados (Imágenes 9 y 10)
 *
 * GET /viajes → viajes.jsp
 * GET /viajes/api → JSON lista de viajes
 * GET /viajes/{id}/outfits → JSON outfits asignados al viaje
 * GET /viajes/{id}/recomendar → JSON prendas recomendadas según clima
 * POST /viajes → crear viaje (detecta clima automático)
 * POST /viajes/{id}/outfit → asignar look a día del viaje
 * POST /viajes/{id}/generar → generar look IA para un día del viaje
 * DELETE /viajes/{id} → eliminar viaje
 * DELETE /viajes/outfit/{id} → quitar outfit de un día
 */
@WebServlet({ "/viajes", "/viajes/*" })
@javax.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024
        * 1024, maxRequestSize = 10 * 1024 * 1024)
public class ViajeServlet extends HttpServlet {

    private final ViajeDAO viajeDAO = new ViajeDAO();
    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final AvatarDAO avatarDAO = new AvatarDAO();
    private final Gson gson = new com.google.gson.GsonBuilder().setDateFormat("yyyy-MM-dd").create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        int idUsuario = getIdUsuario(req);

        // Página principal de viajes
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Viaje> viajes = new java.util.ArrayList<>();
            try {
                viajes = viajeDAO.listarPorUsuario(idUsuario);
            } catch (Exception ignored) {
            }
            req.setAttribute("viajes", viajes);
            req.setAttribute("seccionActiva", "viajes");
            req.getRequestDispatcher("/WEB-INF/usuario/viajes.jsp").forward(req, res);
            return;
        }

        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            if ("/api".equals(pathInfo)) {
                // Lista JSON de viajes
                out.print(gson.toJson(viajeDAO.listarPorUsuario(idUsuario)));
                return;
            }

            // Rutas con ID: /viajes/{id}/outfits | /viajes/{id}/recomendar
            String[] partes = pathInfo.split("/");
            // partes[0]="" partes[1]=id partes[2]=accion
            if (partes.length >= 3) {
                int idViaje = Integer.parseInt(partes[1]);

                if ("outfits".equals(partes[2])) {
                    // Outfits asignados al viaje (Imagen 10)
                    out.print(gson.toJson(viajeDAO.listarOutfitsDelViaje(idViaje, idUsuario)));

                } else if ("recomendar".equals(partes[2])) {
                    // Prendas del closet recomendadas según clima del viaje
                    Viaje v = viajeDAO.obtenerPorIdYUsuario(idViaje, idUsuario);
                    if (v == null) {
                        res.setStatus(404);
                        out.print("{\"error\":\"Viaje no encontrado\"}");
                        return;
                    }
                    List<Prenda> recomendadas = viajeDAO.recomendarPrendas(idUsuario, v.getClimaEsperado());
                    out.print(gson.toJson(recomendadas));

                } else {
                    res.setStatus(404);
                    out.print("{\"error\":\"Ruta no encontrada\"}");
                }
                return;
            }

            res.setStatus(404);
            out.print("{\"error\":\"Ruta no encontrada\"}");

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
        String pathInfo = req.getPathInfo();

        try {
            // ── Crear viaje nuevo (Imagen 9) ─────────────────────────────────
            if (pathInfo == null || pathInfo.equals("/")) {
                String destino = req.getParameter("destino");
                String fechaIni = req.getParameter("fechaInicio");
                String fechaFin = req.getParameter("fechaFin");
                String notas = req.getParameter("notas");

                if (destino == null || fechaIni == null || fechaFin == null) {
                    res.setStatus(400);
                    out.print("{\"error\":\"Faltan campos obligatorios\"}");
                    return;
                }

                // Detectar clima automáticamente con OpenWeatherMap
                String clima = OpenWeatherUtil.obtenerClima(destino, Date.valueOf(fechaIni));

                Viaje v = new Viaje();
                v.setIdUsuario(idUsuario);
                v.setDestino(destino.trim());
                v.setFechaInicio(Date.valueOf(fechaIni));
                v.setFechaFin(Date.valueOf(fechaFin));
                v.setClimaEsperado(clima);
                v.setNotas(notas);

                boolean ok = viajeDAO.crear(v);
                if (ok) {
                    res.setStatus(201);
                    out.print("{\"id\":" + v.getId()
                            + ",\"destino\":\"" + escapar(destino) + "\""
                            + ",\"climaEsperado\":\"" + escapar(clima) + "\""
                            + ",\"duracionDias\":" + v.getDuracionDias()
                            + ",\"mensaje\":\"Viaje creado\"}");
                } else {
                    res.setStatus(400);
                    out.print("{\"error\":\"No se pudo crear el viaje\"}");
                }
                return;
            }

            String[] partes = pathInfo.split("/");
            if (partes.length >= 3) {
                int idViaje = Integer.parseInt(partes[1]);

                // ── Asignar look existente a día del viaje ────────────────────
                if ("outfit".equals(partes[2])) {
                    String diaStr = req.getParameter("dia");
                    String idLookStr = req.getParameter("idLook");
                    String motivo = req.getParameter("motivo");

                    if (diaStr == null || idLookStr == null) {
                        res.setStatus(400);
                        out.print("{\"error\":\"Faltan parámetros\"}");
                        return;
                    }

                    int idLook = Integer.parseInt(idLookStr);
                    LookGenerado lg = lookDAO.obtenerPorIdYUsuario(idLook, idUsuario);
                    if (lg == null) {
                        res.setStatus(403);
                        out.print("{\"error\":\"Look no autorizado\"}");
                        return;
                    }

                    ViajeOutfit vo = new ViajeOutfit();
                    vo.setIdViaje(idViaje);
                    vo.setIdLookGenerado(idLook);
                    vo.setDia(Date.valueOf(diaStr));
                    vo.setMotivo(motivo);
                    vo.setTipo("look");

                    boolean ok = viajeDAO.asignarLook(vo);
                    res.setStatus(ok ? 201 : 400);
                    out.print(ok ? "{\"id\":" + vo.getId() + ",\"mensaje\":\"Look asignado al viaje\"}"
                            : "{\"error\":\"No se pudo asignar\"}");
                    return;
                }

                // ── Generar look IA específico para el viaje ──────────────────
                if ("generar".equals(partes[2])) {
                    Viaje v = viajeDAO.obtenerPorIdYUsuario(idViaje, idUsuario);
                    if (v == null) {
                        res.setStatus(404);
                        out.print("{\"error\":\"Viaje no encontrado\"}");
                        return;
                    }

                    String diaStr = req.getParameter("dia");
                    String motivo = req.getParameter("motivo");
                    if (diaStr == null) {
                        res.setStatus(400);
                        out.print("{\"error\":\"Falta el parámetro dia\"}");
                        return;
                    }

                    // Prendas recomendadas + avatar para el prompt
                    List<Prenda> prendas = viajeDAO.recomendarPrendas(idUsuario, v.getClimaEsperado());
                    Caracteristicas caract = avatarDAO.obtenerCaracteristicas(idUsuario);
                    String prompt = PromptBuilder.buildViaje(prendas, v.getDestino(), v.getClimaEsperado(), caract);

                    String rutaImagen = HuggingFaceUtil.generarLook(prompt, req);
                    if (rutaImagen == null) {
                        res.setStatus(500);
                        out.print("{\"error\":\"No se pudo generar la imagen\"}");
                        return;
                    }

                    // Guardar look generado
                    LookGenerado lg = new LookGenerado();
                    lg.setIdUsuario(idUsuario);
                    lg.setImagenGenerada(rutaImagen);
                    lg.setPromptIA(prompt);
                    lg.setEsManual(false);
                    lg.setFavorito(false);
                    lookDAO.crear(lg);

                    // Asignar al día del viaje
                    ViajeOutfit vo = new ViajeOutfit();
                    vo.setIdViaje(idViaje);
                    vo.setIdLookGenerado(lg.getId());
                    vo.setDia(Date.valueOf(diaStr));
                    vo.setMotivo(motivo != null ? motivo : "Outfit para " + v.getDestino());
                    vo.setTipo("look");
                    viajeDAO.asignarLook(vo);

                    res.setStatus(201);
                    out.print("{\"idLook\":" + lg.getId()
                            + ",\"imagen\":\"" + rutaImagen + "\""
                            + ",\"mensaje\":\"Look generado para el viaje\"}");
                    return;
                }
            }

            res.setStatus(404);
            out.print("{\"error\":\"Ruta no encontrada\"}");

        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + escapar(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        String pathInfo = req.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                res.setStatus(400);
                out.print("{\"error\":\"ID requerido\"}");
                return;
            }

            String[] partes = pathInfo.split("/");

            // DELETE /viajes/outfit/{id} → quitar outfit de un día
            if (partes.length == 3 && "outfit".equals(partes[1])) {
                int id = Integer.parseInt(partes[2]);
                boolean ok = viajeDAO.eliminarOutfit(id, idUsuario);
                res.setStatus(ok ? 200 : 404);
                out.print(ok ? "{\"mensaje\":\"Outfit quitado del viaje\"}"
                        : "{\"error\":\"No encontrado\"}");
                return;
            }

            // DELETE /viajes/{id} → eliminar viaje completo
            int id = Integer.parseInt(partes[1]);
            boolean ok = viajeDAO.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 404);
            out.print(ok ? "{\"mensaje\":\"Viaje eliminado\"}"
                    : "{\"error\":\"No encontrado\"}");

        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + escapar(e.getMessage()) + "\"}");
        }
    }

    private String escapar(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private int getIdUsuario(HttpServletRequest req) {
        return ((Usuario) req.getSession(false).getAttribute("usuario")).getId();
    }
}