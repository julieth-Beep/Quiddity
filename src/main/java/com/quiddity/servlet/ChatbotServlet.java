package com.quiddity.servlet;

import com.quiddity.dao.ChatbotDAO;
import com.quiddity.model.ChatBot;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import org.json.JSONObject;

/**
 * ChatbotServlet
 *
 * GET /chatbot → devuelve mensaje de bienvenida y nombre del rol
 * POST /chatbot → recibe { "pregunta": "..." } y devuelve { "respuesta": "..."
 * }
 *
 * La ruta /chatbot es pública en el AuthFilter (se agrega abajo),
 * el servlet internamente detecta si hay sesión para determinar el rol.
 */
@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    private ChatbotDAO chatbotDAO;

    // NUEVO: Mapa para historial de registro por sesión (en memoria)
    private static final java.util.Map<String, java.util.List<String>> registroHistorial = new java.util.concurrent.ConcurrentHashMap<>();

    @Override
    public void init() throws ServletException {
        chatbotDAO = new ChatbotDAO();
    }

    // ── GET: bienvenida inicial ───────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        int rolId = getRolId(req);
        System.out.println("[ChatbotServlet] GET /chatbot — rolId=" + rolId
                + " | sessionId=" + (req.getSession(false) != null
                        ? req.getSession(false).getId()
                        : "sin-sesión"));
        String nombreRol = getNombreRol(rolId);
        String bienvenida = getBienvenida(rolId);

        JSONObject json = new JSONObject();
        json.put("rol", rolId);
        json.put("nombreRol", nombreRol);
        json.put("bienvenida", bienvenida);
        out.print(json.toString());
    }

    // ── POST: procesar pregunta ───────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        // DEBUG encoding
        System.out.println("[DEBUG] Request encoding: " + req.getCharacterEncoding());
        System.out.println("[DEBUG] Response encoding: " + resp.getCharacterEncoding());

        // Leer body JSON
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(req.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
        }

        JSONObject body;
        try {
            body = new JSONObject(sb.toString());
        } catch (Exception e) {
            resp.setStatus(400);
            out.print(new JSONObject().put("error", "JSON inválido").toString());
            return;
        }

        String pregunta = body.optString("pregunta", "").trim();
        String modo = body.optString("modo", "chat"); // NUEVO: "chat" o "registro"
        System.out.println("[DEBUG] Pregunta recibida: " + pregunta + " | modo: " + modo);

        if (pregunta.isEmpty()) {
            resp.setStatus(400);
            out.print(new JSONObject().put("error", "La pregunta no puede estar vacía").toString());
            return;
        }

        int rolId = getRolId(req);
        String sessionId = req.getSession(true).getId();

        try {
            ChatBot chat;

            // NUEVO: Modo registro - solo para invitados en página de registro
            if ("registro".equals(modo) && rolId == ChatbotDAO.ROL_INVITADO) {
                chat = procesarModoRegistro(pregunta, sessionId);
            } else {
                // Modo chat normal (existente)
                chat = chatbotDAO.procesarMensaje(pregunta, rolId);
            }

            System.out.println("[DEBUG] Respuesta DAO: " + chat.getRespuesta());
            if (chat.getRolRecomendado() != null) {
                System.out.println("[DEBUG] Rol recomendado: " + chat.getRolRecomendado());
            }

            JSONObject result = new JSONObject();
            result.put("respuesta", chat.getRespuesta());

            // NUEVO: Agregar rol recomendado si existe
            if (chat.getRolRecomendado() != null) {
                result.put("rolRecomendado", Integer.parseInt(chat.getRolRecomendado()));
                result.put("finFlujo", true);
            }

            System.out.println("[DEBUG] JSON enviado: " + result.toString());
            out.print(result.toString());

        } catch (IllegalStateException e) {
            // API key no configurada
            resp.setStatus(503);
            out.print(new JSONObject()
                    .put("error", "El asistente no está disponible en este momento. " + e.getMessage())
                    .toString());
        } catch (Exception e) {
            resp.setStatus(500);
            out.print(new JSONObject()
                    .put("error", "Error procesando tu solicitud. Por favor intenta de nuevo.")
                    .toString());
            System.err.println("[ChatbotServlet] Error: " + e.getMessage());
        }
    }

    // ════════════════════════════════════════════════════════════════════════
    // NUEVO: MÉTODOS PARA FLUJO DE REGISTRO
    // ════════════════════════════════════════════════════════════════════════

    /**
     * Procesa mensaje en modo REGISTRO para invitados.
     * Mantiene historial en memoria y detecta recomendación de rol.
     */
    private ChatBot procesarModoRegistro(String pregunta, String sessionId) throws Exception {
        java.util.List<String> historial = registroHistorial.computeIfAbsent(sessionId,
                k -> new java.util.ArrayList<>());

        // Crear prompt especial para registro según progreso
        String systemPrompt = getRegistroPrompt(historial);

        // Llamar a Groq con prompt de registro (sin persistir en BD)
        String respuesta = chatbotDAO.llamarGroqAPIRegistro(pregunta, systemPrompt);

        historial.add(pregunta);

        // Detectar si hay recomendación de rol en la respuesta
        String rolRecomendado = extraerRolRecomendado(respuesta);

        ChatBot chat = new ChatBot(pregunta, respuesta, ChatbotDAO.ROL_INVITADO);
        chat.setRolRecomendado(rolRecomendado);

        // Si ya hay recomendación, limpiar historial para permitir reintentar
        if (rolRecomendado != null) {
            registroHistorial.remove(sessionId);
        }

        return chat;
    }

    /**
     * Genera el system prompt para el flujo de registro según el progreso.
     */
    private String getRegistroPrompt(java.util.List<String> historial) {
        String base = "Eres QuiddityBot, asistente de Quiddity (plataforma de belleza y moda). " +
                "Responde en español, amable y breve. ";

        if (historial == null || historial.isEmpty()) {
            // Primera pregunta
            return base + "Estás en el PROCESO DE REGISTRO de un nuevo usuario. " +
                    "Tu objetivo es conocer sus intereses para recomendarle el rol más adecuado. " +
                    "Haz UNA pregunta breve y amigable. " +
                    "\n\nPREGUNTA 1: ¿Qué te interesa más de nuestra plataforma? " +
                    "Dime cuál opción te llama más: " +
                    "(a) Comprar productos de belleza y moda, " +
                    "(b) Crear outfits, guardar mi ropa y recibir sugerencias de estilo, " +
                    "o (c) Ambas cosas y más funciones personalizadas. " +
                    "\n\nDespués de la última pregunta, DEBES recomendar un rol específico " +
                    "usando exactamente este formato al final: [ROL_RECOMENDADO: X] " +
                    "donde X es 2 (Usuario) o 3 (Comprador). " +
                    "Usuario (rol 2) = acceso completo: closet, outfits, avatar, rutinas, catálogo y compras. " +
                    "Comprador (rol 3) = solo catálogo, carrito y perfil. " +
                    "Recomienda Usuario (2) si quiere funciones completas, Comprador (3) si solo quiere comprar.";
        }

        if (historial.size() == 1) {
            // Segunda pregunta
            return base + "Continúas el PROCESO DE REGISTRO. Ya sabes el interés general del usuario. " +
                    "Haz una pregunta de confirmación breve. " +
                    "\n\nPREGUNTA 2: ¿Cuál es tu motivo principal para usar Quiddity? " +
                    "¿Buscas principalmente (a) comprar productos, " +
                    "(b) organizar tu estilo y recibir tips personalizados, o (c) ambas? " +
                    "\n\nDespués de esta respuesta, DEBES dar tu RECOMENDACIÓN FINAL usando exactamente: [ROL_RECOMENDADO: X] "
                    +
                    "donde X es 2 para Usuario (acceso completo) o 3 para Comprador (solo compras). " +
                    "Explica brevemente por qué ese rol le conviene.";
        }

        // Tercera interacción o más: forzar recomendación
        return base + "Finaliza el PROCESO DE REGISTRO. Basado en las respuestas del usuario, " +
                "da tu RECOMENDACIÓN FINAL de rol. " +
                "DEBES usar exactamente: [ROL_RECOMENDADO: X] donde X es 2 (Usuario - acceso completo) " +
                "o 3 (Comprador - solo catálogo). " +
                "Explica por qué le conviene ese rol y menciona que puede cambiarlo después si lo desea.";
    }

    /**
     * Extrae el rol recomendado del texto de respuesta.
     */
    private String extraerRolRecomendado(String respuesta) {
        if (respuesta == null)
            return null;
        if (respuesta.contains("[ROL_RECOMENDADO: 2]"))
            return "2";
        if (respuesta.contains("[ROL_RECOMENDADO: 3]"))
            return "3";
        return null;
    }

    // ── Helpers existentes ────────────────────────────────────────────────────

    /** Obtiene el rol del usuario desde la sesión. Sin sesión = INVITADO */
    private int getRolId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null)
            return ChatbotDAO.ROL_INVITADO;
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null)
            return ChatbotDAO.ROL_INVITADO;
        return usuario.getIdRol();
    }

    private String getNombreRol(int rolId) {
        switch (rolId) {
            case ChatbotDAO.ROL_ADMIN:
                return "Administrador";
            case ChatbotDAO.ROL_USUARIO:
                return "Usuario";
            case ChatbotDAO.ROL_COMPRADOR:
                return "Comprador";
            default:
                return "Invitado";
        }
    }

    private String getBienvenida(int rolId) {
        switch (rolId) {
            case ChatbotDAO.ROL_ADMIN:
                return "¡Hola, Admin! 🛠️ Puedo mostrarte estadísticas, reportes y ayudarte con cualquier consulta del sistema.";
            case ChatbotDAO.ROL_USUARIO:
                return "¡Hola! ✨ Soy QuiddityBot. Pregúntame sobre belleza, tu closet, rutinas, outfits o cualquier cosa de la plataforma.";
            case ChatbotDAO.ROL_COMPRADOR:
                return "¡Hola! 💳 Soy QuiddityBot. ¿Tienes dudas sobre tu compra, el carrito o los métodos de pago?";
            default:
                return "¡Bienvenida a Quiddity! 🌸 Soy QuiddityBot. Pregúntame sobre belleza, moda o cómo funciona la plataforma.";
        }
    }
}