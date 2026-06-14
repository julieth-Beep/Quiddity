package com.quiddity.servlet;

import com.quiddity.dao.AvatarDAO;
import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.LookGenerado;
import com.quiddity.model.Usuario;
import com.quiddity.util.HuggingFaceUtil;
import com.quiddity.util.PromptBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * ChatServlet — chat con la IA para pedir ideas de outfits (Imagen 4)
 *
 * GET /chat → chatbot_outfit.jsp
 * POST /chat → recibe mensaje del usuario, genera imagen, devuelve JSON
 */
@WebServlet({ "/chat", "/chat/*" })
public class ChatServlet extends HttpServlet {

    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final AvatarDAO avatarDAO = new AvatarDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            req.setAttribute("seccionActiva", "chat");
            req.getRequestDispatcher("/WEB-INF/usuario/chatbot_outfit.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        int idUsuario = getIdUsuario(req);
        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        try {
            String mensaje = req.getParameter("mensaje");
            if (mensaje == null || mensaje.isBlank()) {
                res.setStatus(400);
                out.print("{\"error\":\"Escribe tu idea o plan\"}");
                return;
            }

            // Obtener características del avatar para personalizar la imagen
            Caracteristicas caract = avatarDAO.obtenerCaracteristicas(idUsuario);

            // Construir prompt enriquecido
            String prompt = PromptBuilder.buildChatOutfit(mensaje, caract);

            // Generar imagen — HuggingFace con fallback a Pollinations
            String rutaImagen = HuggingFaceUtil.generarLook(prompt, req);

            if (rutaImagen == null) {
                res.setStatus(500);
                out.print("{\"error\":\"No se pudo generar la imagen. Intenta de nuevo.\"}");
                return;
            }

            // Guardar en historial de looks (es_manual = false → generado por IA/chat)
            LookGenerado lg = new LookGenerado();
            lg.setIdUsuario(idUsuario);
            lg.setImagenGenerada(rutaImagen);
            lg.setPromptIA(prompt);
            lg.setEsManual(false);
            lg.setFavorito(false);
            lookDAO.crear(lg);

            // Respuesta al chat
            out.print("{\"tipo\":\"ia\""
                    + ",\"id\":" + lg.getId()
                    + ",\"imagen\":\"" + rutaImagen + "\""
                    + ",\"mensaje\":\"Aquí tienes tu idea de outfit\""
                    + ",\"prompt\":\"" + escaparJson(prompt) + "\"}");

        } catch (Exception e) {
            res.setStatus(500);
            out.print("{\"error\":\"" + escaparJson(e.getMessage()) + "\"}");
        }
    }

    private String escaparJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }

    private int getIdUsuario(HttpServletRequest req) {
        return ((Usuario) req.getSession(false).getAttribute("usuario")).getId();
    }
}