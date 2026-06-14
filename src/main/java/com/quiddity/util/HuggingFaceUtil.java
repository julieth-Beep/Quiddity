package com.quiddity.util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * HuggingFaceUtil — genera imágenes de outfits usando FLUX.1-schnell
 *
 * Modelo: black-forest-labs/FLUX.1-schnell (gratuito con token HuggingFace)
 * Docs: https://huggingface.co/black-forest-labs/FLUX.1-schnell
 *
 * CONFIGURACIÓN: pon tu token en HF_TOKEN.
 *
 * El modelo devuelve la imagen directamente como bytes (image/jpeg o
 * image/png).
 * La guardamos en disco y devolvemos la ruta relativa.
 */
public class HuggingFaceUtil {

    private static final String HF_TOKEN = "";
    private static final String ENDPOINT = " https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell";

    /**
     * Tamaño fijo del canvas de OutfitComposerUtil — todas las imágenes deben
     * coincidir
     */
    private static final int IMG_W = 800;
    private static final int IMG_H = 960;

    /**
     * Genera una imagen a partir de un prompt de texto.
     *
     * @param prompt descripción del outfit (construido por PromptBuilder)
     * @return bytes PNG/JPEG de la imagen generada, o null si falla
     */
    public static byte[] generarImagen(String prompt) {
        System.out.println("ENDPOINT USADO: " + ENDPOINT);
        try {
            // Body JSON
            String json = "{\"inputs\": " + jsonString(prompt) + ", "
                    + "\"parameters\": {\"num_inference_steps\": 4, "
                    + "\"guidance_scale\": 0.0}}";

            byte[] bodyBytes = json.getBytes(StandardCharsets.UTF_8);

            URL url = new URL(ENDPOINT);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(30_000);
            conn.setReadTimeout(120_000); // FLUX puede tardar hasta 2 min en cold start
            conn.setRequestProperty("Authorization", "Bearer " + HF_TOKEN);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Content-Length", String.valueOf(bodyBytes.length));

            try (OutputStream os = conn.getOutputStream()) {
                os.write(bodyBytes);
            }

            int codigo = conn.getResponseCode();

            System.out.println("[HuggingFace] HTTP " + codigo);

            if (codigo == 200) {
                return leerBytes(conn.getInputStream());

            } else if (codigo == 503) {

                System.out.println("[HuggingFaceUtil] Modelo cargando, reintentando en 20s...");
                Thread.sleep(20_000);
                return generarImagen(prompt);

            } else {

                String error = new String(
                        leerBytes(conn.getErrorStream()),
                        StandardCharsets.UTF_8);

                System.err.println("[HuggingFace] HTTP " + codigo);
                System.err.println("[HuggingFace] Respuesta: " + error);

                return null;
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Genera imagen del outfit y la guarda en disco redimensionada a IMG_W x IMG_H.
     *
     * @param prompt descripción completa del outfit
     * @param req    para obtener la ruta real del servidor
     * @return ruta relativa guardada (ej: "uploads/looks/look_abc123.png")
     *         o null si falla
     */
    public static String generarYGuardar(String prompt, javax.servlet.http.HttpServletRequest req) {
        try {
            byte[] bytes = generarImagen(prompt);
            if (bytes == null || bytes.length == 0)
                return null;

            bytes = redimensionar(bytes);
            if (bytes == null)
                return null;

            return ImagenUtil.guardarBytes(bytes, ImagenUtil.CARPETA_LOOKS, ".png", req);

        } catch (Exception e) {
            System.err.println("[HuggingFaceUtil] Error al guardar: " + e.getMessage());
            return null;
        }
    }

    // ── FALLBACK: Pollinations (sin API key, completamente gratis) ────────────

    /**
     * Si HuggingFace falla o el modelo está saturado,
     * Pollinations sirve como respaldo inmediato (sin key, sin límite).
     */
    public static String generarConPollinations(String prompt,
            javax.servlet.http.HttpServletRequest req) {
        try {
            String encoded = java.net.URLEncoder.encode(prompt, "UTF-8");
            // Pedimos exactamente IMG_W x IMG_H para evitar redimensionados innecesarios
            String urlStr = "https://image.pollinations.ai/prompt/" + encoded
                    + "?width=" + IMG_W + "&height=" + IMG_H + "&nologo=true&seed="
                    + System.currentTimeMillis();

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(30_000);
            conn.setReadTimeout(90_000);
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");

            if (conn.getResponseCode() == 200) {
                byte[] bytes = leerBytes(conn.getInputStream());
                conn.disconnect();

                // Redimensionar igualmente por si Pollinations devuelve otro tamaño
                bytes = redimensionar(bytes);
                if (bytes == null)
                    return null;

                return ImagenUtil.guardarBytes(bytes, ImagenUtil.CARPETA_LOOKS, ".png", req);
            }
            conn.disconnect();
            return null;

        } catch (Exception e) {
            System.err.println("[HuggingFaceUtil/Pollinations] Error: " + e.getMessage());
            return null;
        }
    }

    /**
     * Intenta HuggingFace primero, cae a Pollinations si falla.
     * Este es el método que deben llamar los servlets.
     */
    public static String generarLook(String prompt,
            javax.servlet.http.HttpServletRequest req) {
        // Intentar con HuggingFace
        String ruta = generarYGuardar(prompt, req);
        if (ruta != null)
            return ruta;

        // Fallback a Pollinations
        System.out.println("[HuggingFaceUtil] Usando Pollinations como fallback...");
        return generarConPollinations(prompt, req);
    }

    // ── REDIMENSIONADO ────────────────────────────────────────────────────────

    /**
     * Redimensiona los bytes de imagen a IMG_W x IMG_H manteniendo proporción
     * y rellenando con fondo blanco (igual que el canvas de OutfitComposerUtil).
     *
     * @return bytes PNG redimensionados, o null si la imagen no se puede leer
     */
    private static byte[] redimensionar(byte[] original) {
        try {
            BufferedImage src = ImageIO.read(new ByteArrayInputStream(original));
            if (src == null) {
                System.err.println("[HuggingFaceUtil] No se pudo decodificar la imagen para redimensionar");
                return null;
            }

            // Escalar manteniendo proporción (fit, no crop)
            double scale = Math.min((double) IMG_W / src.getWidth(), (double) IMG_H / src.getHeight());
            int sw = (int) (src.getWidth() * scale);
            int sh = (int) (src.getHeight() * scale);

            BufferedImage canvas = new BufferedImage(IMG_W, IMG_H, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = canvas.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, IMG_W, IMG_H);
            g.drawImage(src, (IMG_W - sw) / 2, (IMG_H - sh) / 2, sw, sh, null);
            g.dispose();

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(canvas, "png", baos);
            return baos.toByteArray();

        } catch (IOException e) {
            System.err.println("[HuggingFaceUtil] Error al redimensionar: " + e.getMessage());
            return null;
        }
    }

    // ── AUXILIARES ────────────────────────────────────────────────────────────

    private static byte[] leerBytes(InputStream is) throws IOException {
        if (is == null)
            return new byte[0];
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        byte[] chunk = new byte[8192];
        int n;
        while ((n = is.read(chunk)) != -1)
            buf.write(chunk, 0, n);
        return buf.toByteArray();
    }

    /** Escapa un string para incluirlo en JSON */
    private static String jsonString(String s) {
        return "\"" + s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r") + "\"";
    }
}