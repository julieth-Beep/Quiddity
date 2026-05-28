package com.quiddity.dao;

import com.quiddity.model.ChatBot;
import com.quiddity.util.ConexionDB;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * ChatbotDAO
 *
 * Responsabilidades:
 * 1. Construir el system prompt según el rol del usuario
 * 2. Llamar a la API de Groq (modelo gratuito llama3-8b-8192)
 * 3. Persistir cada interacción en chatbot_interacciones
 * 4. Proveer estadísticas para el panel Admin
 *
 * Roles (igual que UsuarioDAO):
 * ROL_ADMIN = 1
 * ROL_USUARIO = 2
 * ROL_COMPRADOR = 3
 * INVITADO = 4 (sin sesión, no está en BD de usuarios)
 */
public class ChatbotDAO {

    // ── Constantes de rol (alineadas con UsuarioDAO) ─────────────────────────
    public static final int ROL_ADMIN = 1;
    public static final int ROL_USUARIO = 2;
    public static final int ROL_COMPRADOR = 3;
    public static final int ROL_INVITADO = 4;

    // ── Config API Groq ──────────────────────────────────────────────────────
    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL = "llama-3.1-8b-instant";
    private static final int MAX_TOKENS = 600;
    private static String API_KEY_CACHE = null;

    // Lee la API key en orden: 1) variable entorno, 2) property sistema, 3)
    // config.properties
    private static String getApiKey() {
        // 1. Variable de entorno (producción)
        String key = System.getenv("GROQ_API_KEY");
        if (key != null && !key.isBlank()) {
            return key;
        }

        // 2. Property del sistema (-Dgroq.api.key=...)
        key = System.getProperty("groq.api.key");
        if (key != null && !key.isBlank()) {
            return key;
        }

        // 3. Archivo config.properties (desarrollo local)
        if (API_KEY_CACHE != null && !API_KEY_CACHE.isBlank()) {
            return API_KEY_CACHE;
        }

        try (InputStream is = ChatbotDAO.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                key = props.getProperty("groq.api.key", "");
                if (!key.isBlank()) {
                    API_KEY_CACHE = key;
                    return key;
                }
            }
        } catch (IOException e) {
            System.err.println("[ChatbotDAO] Error leyendo config.properties: " + e.getMessage());
        }

        return "";
    }

    // ════════════════════════════════════════════════════════════════════════
    // MÉTODO PRINCIPAL: procesar pregunta y retornar respuesta
    // ════════════════════════════════════════════════════════════════════════

    /**
     * Recibe la pregunta del usuario y su rol, llama a Groq y
     * persiste la interacción. Retorna el objeto ChatBot con la respuesta.
     *
     * @param pregunta texto del usuario
     * @param rolId    rol del usuario (usar constantes de esta clase)
     */
    public ChatBot procesarMensaje(String pregunta, int rolId) throws Exception {
        String systemPrompt = getSystemPrompt(rolId);
        String respuesta = llamarGroqAPI(pregunta, systemPrompt);

        ChatBot chat = new ChatBot(pregunta, respuesta, rolId);
        guardarInteraccion(chat);
        return chat;
    }

    // ════════════════════════════════════════════════════════════════════════
    // SYSTEM PROMPTS POR ROL
    // ════════════════════════════════════════════════════════════════════════

    private String getSystemPrompt(int rolId) {
        String base = "Eres QuiddityBot, el asistente virtual de Quiddity, una plataforma de belleza, " +
                "moda y bienestar para mujeres. Responde siempre en español, de forma amable, " +
                "breve y profesional. Si no sabes algo, dilo con honestidad. " +
                "No uses listas largas; prefiere respuestas conversacionales y cálidas. ";

        switch (rolId) {

            case ROL_INVITADO:
                return base +
                        "El usuario es un VISITANTE que no ha iniciado sesión. " +
                        "SOLO puedes responder sobre: " +
                        "(1) Qué es Quiddity y cómo funciona la plataforma en general. " +
                        "(2) Tipos de usuarios y qué puede hacer cada rol. " +
                        "(3) Contenido general: productos, ropa, maquillaje, skincare, tendencias de belleza. " +
                        "(4) Recomendaciones y sugerencias de estilo y belleza en general. " +
                        "(5) Cómo registrarse o iniciar sesión. " +
                        "NUNCA inventes datos concretos como precios, nombres de productos, stocks ni estadísticas. " +
                        "Si preguntan sobre carrito, compras, perfil o funciones privadas, " +
                        "invítalos amablemente a registrarse.";

            case ROL_COMPRADOR:
                return base +
                        "El usuario es un COMPRADOR con sesión activa. Tiene acceso al catálogo, carrito y su perfil. "
                        +
                        "Responde sobre: " +
                        "(1) Proceso de compra paso a paso. " +
                        "(2) Métodos de pago: tarjeta, PSE, contra entrega, etc. " +
                        "(3) Cómo usar el carrito: agregar, eliminar, actualizar cantidades. " +
                        "(4) Seguridad al comprar: datos seguros, política de privacidad. " +
                        "(5) Cómo editar datos del perfil. " +
                        "(6) Preguntas generales sobre categorías de productos del catálogo. " +
                        "NUNCA inventes precios exactos, nombres de productos específicos, stocks ni datos de pedidos reales. "
                        +
                        "No ofrezcas funciones de rutinas, closet, avatar ni administración.";

            case ROL_USUARIO:
                return base +
                        "El usuario tiene ACCESO COMPLETO a la plataforma. " +
                        "Puedes responder sobre: " +
                        "(1) Belleza, skincare, maquillaje, cuidado del cabello, tendencias de moda. " +
                        "(2) Avatar: cómo configurar tono de piel, tipo de cabello, forma de cara, tipo de cuerpo. " +
                        "(3) Closet: cómo registrar prendas, crear outfits por clima y ocasión. " +
                        "(4) Rutinas de belleza y cuidado personal. " +
                        "(5) Catálogo, marcas, productos y compras en términos generales. " +
                        "(6) Frases motivacionales y bienestar. " +
                        "(7) Cualquier duda técnica sobre el uso de la plataforma. " +
                        "NUNCA inventes precios, stocks, nombres de productos del catálogo real ni datos de usuario. " +
                        "Sé detallada y personalizada.";

            case ROL_ADMIN:
                return base +
                        "El usuario es ADMINISTRADOR del sistema con acceso total. " +
                        "Puedes orientarlo sobre: " +
                        "(1) Cómo navegar y usar cada sección del panel de administración. " +
                        "(2) Qué significan las métricas o reportes que él mismo está viendo en pantalla. " +
                        "(3) Gestión de usuarios, productos, catálogo y pedidos a nivel de flujo/proceso. " +
                        "(4) Gestión de reportes, quejas y reclamos: pasos a seguir. " +
                        "(5) Configuración y mantenimiento general de la plataforma. " +
                        "REGLA CRÍTICA: NUNCA inventes cifras, estadísticas, conteos de usuarios, " +
                        "nombres de pedidos, montos ni ningún dato concreto del sistema. " +
                        "Si el admin pregunta por datos reales (ej: '¿cuántos usuarios hay?', " +
                        "'¿cuál fue la venta de ayer?'), responde: " +
                        "'Esa información la encuentras directamente en el panel de administración, " +
                        "en la sección correspondiente.' " +
                        "Solo responde con datos que el propio admin te proporcione en la conversación.";
            default:
                return base;
        }
    }

    // ════════════════════════════════════════════════════════════════════════
    // LLAMADA A LA API DE GROQ (formato OpenAI compatible)
    // ════════════════════════════════════════════════════════════════════════

    private String llamarGroqAPI(String pregunta, String systemPrompt) throws Exception {
        String apiKey = getApiKey();
        if (apiKey.isBlank()) {
            throw new IllegalStateException(
                    "Configura la variable de entorno GROQ_API_KEY, la property groq.api.key, " +
                            "o crea src/config.properties con groq.api.key=tu_key. " +
                            "Obtén una key gratis en: https://console.groq.com");
        }

        // Body JSON (formato OpenAI)
        JSONObject body = new JSONObject();
        body.put("model", MODEL);
        body.put("max_tokens", MAX_TOKENS);

        JSONArray messages = new JSONArray();

        // System message
        JSONObject systemMsg = new JSONObject();
        systemMsg.put("role", "system");
        systemMsg.put("content", systemPrompt);
        messages.put(systemMsg);

        // User message
        JSONObject userMsg = new JSONObject();
        userMsg.put("role", "user");
        userMsg.put("content", pregunta);
        messages.put(userMsg);

        body.put("messages", messages);

        // Conexión HTTP
        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + apiKey);
        conn.setDoOutput(true);
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(30_000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        InputStream is = (status == 200) ? conn.getInputStream() : conn.getErrorStream();

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
        }

        if (status != 200) {
            throw new RuntimeException("Error API Groq [" + status + "]: " + sb);
        }

        // Parsear respuesta OpenAI/Groq
        return new JSONObject(sb.toString())
                .getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");
    }

    // ════════════════════════════════════════════════════════════════════════
    // NUEVO: LLAMADA PARA MODO REGISTRO (sin persistir en BD)
    // ════════════════════════════════════════════════════════════════════════

    /**
     * Llama a Groq con un system prompt personalizado para flujo de registro.
     * NO persiste en BD. El servlet maneja el historial y la recomendación.
     */
    public String llamarGroqAPIRegistro(String pregunta, String systemPrompt) throws Exception {
        String apiKey = getApiKey();
        if (apiKey.isBlank()) {
            throw new IllegalStateException(
                    "Configura la variable de entorno GROQ_API_KEY, la property groq.api.key, " +
                            "o crea src/config.properties con groq.api.key=tu_key. " +
                            "Obtén una key gratis en: https://console.groq.com");
        }

        JSONObject body = new JSONObject();
        body.put("model", MODEL);
        body.put("max_tokens", MAX_TOKENS);

        JSONArray messages = new JSONArray();

        JSONObject systemMsg = new JSONObject();
        systemMsg.put("role", "system");
        systemMsg.put("content", systemPrompt);
        messages.put(systemMsg);

        JSONObject userMsg = new JSONObject();
        userMsg.put("role", "user");
        userMsg.put("content", pregunta);
        messages.put(userMsg);

        body.put("messages", messages);

        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + apiKey);
        conn.setDoOutput(true);
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(30_000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        InputStream is = (status == 200) ? conn.getInputStream() : conn.getErrorStream();

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
        }

        if (status != 200) {
            throw new RuntimeException("Error API Groq [" + status + "]: " + sb);
        }

        return new JSONObject(sb.toString())
                .getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");
    }

    // ════════════════════════════════════════════════════════════════════════
    // PERSISTENCIA EN BASE DE DATOS
    // ════════════════════════════════════════════════════════════════════════

    /** Guarda una interacción en chatbot_interacciones */
    public void guardarInteraccion(ChatBot chat) {
        String sql = "INSERT INTO chatbot_interacciones (pregunta, respuesta, id_rol) VALUES (?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, chat.getPregunta());
            ps.setString(2, chat.getRespuesta());

            // Invitado se guarda con NULL, sin violar la FK
            if (chat.getIdRol() == ROL_INVITADO) {
                ps.setNull(3, java.sql.Types.INTEGER);
            } else {
                ps.setInt(3, chat.getIdRol());
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[ChatbotDAO] Error guardando interacción: " + e.getMessage());
        }
    }

    /** Top N preguntas más frecuentes (últimos 30 días) — para Admin */
    public List<ChatBot> getPreguntasFrecuentes(int limite) {
        List<ChatBot> lista = new ArrayList<>();
        String sql = "SELECT pregunta, COUNT(*) AS total " +
                "FROM chatbot_interacciones " +
                "WHERE fecha >= NOW() - INTERVAL '30 days' " +
                "GROUP BY pregunta ORDER BY total DESC LIMIT ?";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChatBot c = new ChatBot();
                c.setPregunta(rs.getString("pregunta"));
                c.setRespuesta(String.valueOf(rs.getInt("total")));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("[ChatbotDAO] Error obteniendo frecuentes: " + e.getMessage());
        }
        return lista;
    }

    /** Cantidad de interacciones agrupadas por rol — para Admin */
    public List<ChatBot> getEstadisticasPorRol() {
        List<ChatBot> lista = new ArrayList<>();
        String sql = "SELECT r.nombrerol, COUNT(ci.id) AS total " +
                "FROM chatbot_interacciones ci " +
                "JOIN rol r ON r.id = ci.id_rol " +
                "GROUP BY r.nombrerol ORDER BY total DESC";
        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChatBot c = new ChatBot();
                c.setPregunta(rs.getString("nombrerol"));
                c.setRespuesta(String.valueOf(rs.getInt("total")));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("[ChatbotDAO] Error obteniendo estadísticas: " + e.getMessage());
        }
        return lista;
    }
}