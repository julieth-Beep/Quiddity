package com.quiddity.servlet;

import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.dao.OutfitDAO;
import com.quiddity.dao.PrendaDAO;
import com.quiddity.model.*;
import com.quiddity.util.OutfitComposerUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet({ "/outfit", "/outfit/*" })
@javax.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024
        * 1024, maxRequestSize = 10 * 1024 * 1024)
public class OutfitServlet extends HttpServlet {

    private final OutfitDAO outfitDAO = new OutfitDAO();
    private final PrendaDAO prendaDAO = new PrendaDAO();
    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final Gson gson = new com.google.gson.GsonBuilder()
            .setDateFormat("yyyy-MM-dd").create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        int idUsuario = getIdUsuario(req);

        if (pathInfo == null || pathInfo.equals("/")) {
            List<Prenda> prendas = new ArrayList<>();
            try {
                prendas = prendaDAO.listarPorUsuario(idUsuario);
            } catch (Exception ignored) {
            }
            req.setAttribute("prendas", prendas);
            req.setAttribute("seccionActiva", "outfit");
            req.getRequestDispatcher("/WEB-INF/usuario/outfit_composer.jsp").forward(req, res);
            return;
        }

        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        try {
            if ("/lista".equals(pathInfo)) {
                out.print(gson.toJson(outfitDAO.listarPorUsuario(idUsuario)));
            } else if (pathInfo.matches("/\\d+/prendas")) {
                int idOutfit = Integer.parseInt(pathInfo.split("/")[1]);
                out.print(gson.toJson(outfitDAO.listarPrendasDeOutfit(idOutfit, idUsuario)));
            } else {
                res.setStatus(404);
                out.print("{\"error\":\"Ruta no encontrada\"}");
            }
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + esc(e.getMessage()) + "\"}");
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
            if ("/crear".equals(pathInfo)) {
                Outfit o = new Outfit();
                o.setIdUsuario(idUsuario);
                o.setClima(req.getParameter("clima"));
                o.setOcasion(req.getParameter("ocasion"));
                boolean ok = outfitDAO.crear(o);
                res.setStatus(ok ? 201 : 400);
                out.print(ok ? "{\"id\":" + o.getId() + "}" : "{\"error\":\"No se pudo crear\"}");
                return;
            }

            if ("/prenda".equals(pathInfo)) {
                int idOutfit = Integer.parseInt(req.getParameter("idOutfit"));
                int idPrenda = Integer.parseInt(req.getParameter("idPrenda"));
                OutfitPrenda op = new OutfitPrenda(0, idOutfit, idPrenda);
                boolean ok = outfitDAO.agregarPrenda(op, idUsuario);
                res.setStatus(ok ? 201 : 403);
                out.print(ok ? "{\"mensaje\":\"Prenda agregada\"}" : "{\"error\":\"No autorizado\"}");
                return;
            }

            if ("/generar".equals(pathInfo)) {
                String[] idsPrendas = req.getParameterValues("prendas");
                if (idsPrendas == null || idsPrendas.length == 0) {
                    res.setStatus(400);
                    out.print("{\"error\":\"Selecciona al menos una prenda\"}");
                    return;
                }

                // Resolver ruta absoluta de forma robusta para Windows y Linux
                String webRoot = req.getServletContext().getRealPath("");
                // Quitar separador final si existe
                if (webRoot.endsWith(File.separator) || webRoot.endsWith("/")) {
                    webRoot = webRoot.substring(0, webRoot.length() - 1);
                }

                List<OutfitComposerUtil.PrendaConRuta> prendas = new ArrayList<>();
                for (String idStr : idsPrendas) {
                    Prenda p = prendaDAO.obtenerPorIdYUsuario(
                            Integer.parseInt(idStr.trim()), idUsuario);
                    if (p == null) {
                        res.setStatus(403);
                        out.print("{\"error\":\"Prenda no autorizada: " + idStr + "\"}");
                        return;
                    }
                    // Construir ruta absoluta normalizando separadores
                    String imgRelativa = p.getImagen()
                            .replace("/", File.separator)
                            .replace("\\", File.separator);
                    String rutaAbs = webRoot + File.separator + imgRelativa;

                    System.out.println("[OutfitServlet] Prenda " + p.getId()
                            + " tipo=" + p.getTipo()
                            + " ruta=" + rutaAbs
                            + " existe=" + new File(rutaAbs).exists());

                    prendas.add(new OutfitComposerUtil.PrendaConRuta(p, rutaAbs));
                }

                // Generar flatlay
                String carpeta = webRoot + File.separator + "uploads" + File.separator + "looks";
                String nombre = "look_" + System.currentTimeMillis() + ".png";
                String rutaSalida = carpeta + File.separator + nombre;
                String rutaRelativa = "uploads/looks/" + nombre;

                System.out.println("[OutfitServlet] Guardando en: " + rutaSalida);

                boolean ok = OutfitComposerUtil.componer(prendas, rutaSalida);
                if (!ok) {
                    res.setStatus(500);
                    out.print("{\"error\":\"No se pudo generar el flatlay. Revisa los logs.\"}");
                    return;
                }

                // Guardar en BD
                LookGenerado lg = new LookGenerado();
                lg.setIdUsuario(idUsuario);
                lg.setImagenGenerada(rutaRelativa);
                lg.setPromptIA("flatlay:" + java.util.Arrays.toString(idsPrendas));
                lg.setEsManual(true);
                lg.setFavorito(false);
                lookDAO.crear(lg);

                // Construir JSON de prendas para la UI
                StringBuilder prendasJson = new StringBuilder("[");
                for (int i = 0; i < prendas.size(); i++) {
                    OutfitComposerUtil.PrendaConRuta p = prendas.get(i);
                    if (i > 0)
                        prendasJson.append(",");
                    prendasJson.append("{")
                            .append("\"id\":").append(p.id).append(",")
                            .append("\"tipo\":\"").append(esc(p.tipo)).append("\",")
                            .append("\"color\":\"").append(esc(p.color)).append("\",")
                            .append("\"estilo\":\"").append(esc(p.estilo)).append("\",")
                            .append("\"imagen\":\"").append(esc(p.imagen)).append("\"")
                            .append("}");
                }
                prendasJson.append("]");

                res.setStatus(201);
                out.print("{\"id\":" + lg.getId()
                        + ",\"imagen\":\"" + esc(rutaRelativa) + "\""
                        + ",\"prendas\":" + prendasJson + "}");
                return;
            }

            res.setStatus(404);
            out.print("{\"error\":\"Ruta no encontrada\"}");

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(500);
            out.print("{\"error\":\"" + esc(e.getMessage()) + "\"}");
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
            if (pathInfo == null) {
                res.setStatus(400);
                out.print("{\"error\":\"ID requerido\"}");
                return;
            }
            if (pathInfo.startsWith("/prenda/")) {
                int id = Integer.parseInt(pathInfo.substring(8));
                boolean ok = outfitDAO.eliminarPrenda(id, idUsuario);
                res.setStatus(ok ? 200 : 404);
                out.print(ok ? "{\"mensaje\":\"OK\"}" : "{\"error\":\"No encontrado\"}");
                return;
            }
            int id = Integer.parseInt(pathInfo.substring(1));
            boolean ok = outfitDAO.eliminar(id, idUsuario);
            res.setStatus(ok ? 200 : 404);
            out.print(ok ? "{\"mensaje\":\"Outfit eliminado\"}" : "{\"error\":\"No encontrado\"}");
        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private String esc(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private int getIdUsuario(HttpServletRequest req) {
        return ((Usuario) req.getSession(false).getAttribute("usuario")).getId();
    }
}