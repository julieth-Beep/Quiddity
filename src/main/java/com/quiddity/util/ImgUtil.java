package com.quiddity.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

/**
 * ImagenUtil — gestión de imágenes usando Supabase Storage.
 *
 * En vez de guardar en disco (que Railway borra en cada redeploy),
 * sube los archivos a Supabase Storage y devuelve la URL pública.
 *
 * Variables de entorno requeridas en Railway:
 *   SUPABASE_URL  → https://kgyruuohejtgclexpgnc.supabase.co
 *   SUPABASE_KEY  → service_role key (Project Settings → API)
 *
 * Buckets usados (créalos en Supabase → Storage → New bucket, marcar PUBLIC):
 *   - prendas      (closet del usuario)
 *   - prettify     (imágenes procesadas por RemoveBg)
 *   - looks        (outfits generados por IA)
 *   - catalogo     (productos del catálogo admin)
 *   - perfiles     (fotos de perfil)
 */
public class ImgUtil {

    // ── Buckets ──────────────────────────────────────────────────────────────
    public static final String CARPETA_PRENDAS  = "prendas";
    public static final String CARPETA_PRETTIFY = "prettify";
    public static final String CARPETA_LOOKS    = "looks";
    public static final String CARPETA_CATALOGO = "catalogo";
    public static final String CARPETA_PERFILES = "perfiles";

    // ── Config desde variables de entorno ────────────────────────────────────
    private static final String SUPABASE_URL = System.getenv("SUPABASE_URL");
    private static final String SUPABASE_KEY = System.getenv("SUPABASE_KEY");

    // ─────────────────────────────────────────────────────────────────────────
    // API PÚBLICA
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Guarda la imagen de una prenda del closet.
     * Llamado desde PrendaServlet en POST /closet/prenda.
     *
     * @return URL pública en Supabase Storage, ej:
     *         https://xxx.supabase.co/storage/v1/object/public/prendas/abc123.jpg
     */
    public static String guardarPrenda(Part filePart, HttpServletRequest req) throws IOException {
        String extension = obtenerExtension(filePart);
        String nombreArchivo = UUID.randomUUID().toString() + "." + extension;
        byte[] bytes = leerBytes(filePart.getInputStream());
        String contentType = filePart.getContentType() != null ? filePart.getContentType() : "image/jpeg";
        return subirASupabase(CARPETA_PRENDAS, nombreArchivo, bytes, contentType);
    }

    /**
     * Guarda bytes de imagen en el bucket indicado.
     * Usado por HuggingFaceUtil, RemoveBgUtil y PrendaServlet.
     *
     * @param carpeta    Nombre del bucket (usa las constantes CARPETA_*)
     * @param extension  Extensión con punto, ej: ".png"
     * @param bytes      Contenido del archivo
     * @param req        HttpServletRequest (ya no se usa, se mantiene por compatibilidad)
     * @return URL pública en Supabase Storage
     */
    public static String guardarBytes(byte[] bytes, String carpeta, String extension,
                                      HttpServletRequest req) throws IOException {
        // Normalizar nombre del bucket: "uploads/prettify/" → "prettify"
        String bucket = normalizarBucket(carpeta);
        String contentType = extension.contains("png") ? "image/png" : "image/jpeg";
        String nombreArchivo = UUID.randomUUID().toString() + extension;
        return subirASupabase(bucket, nombreArchivo, bytes, contentType);
    }

    /**
     * Elimina una imagen de Supabase Storage.
     * La URL tiene formato: https://xxx.supabase.co/storage/v1/object/public/bucket/archivo
     */
    public static void eliminar(String urlImagen, HttpServletRequest req) {
        if (urlImagen == null || urlImagen.isBlank()) return;
        if (!urlImagen.contains("/storage/v1/object/public/")) return;

        try {
            // Extraer bucket y path del archivo desde la URL pública
            // URL: https://xxx.supabase.co/storage/v1/object/public/prendas/abc.jpg
            String parte = urlImagen.substring(urlImagen.indexOf("/storage/v1/object/public/")
                    + "/storage/v1/object/public/".length());
            // parte = "prendas/abc.jpg"
            int slash = parte.indexOf('/');
            if (slash < 0) return;
            String bucket = parte.substring(0, slash);
            String archivo = parte.substring(slash + 1);

            eliminarDeSupabase(bucket, archivo);
        } catch (Exception e) {
            System.err.println("[ImagenUtil] Error eliminando imagen: " + e.getMessage());
        }
    }

    /**
     * Verifica si un Part tiene un archivo adjunto con contenido.
     */
    public static boolean tieneArchivo(Part part) {
        if (part == null || part.getSize() == 0) return false;
        String nombre = getFileName(part);
        return nombre != null && !nombre.isBlank();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SUPABASE STORAGE REST API
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Sube bytes a Supabase Storage y devuelve la URL pública.
     * Usa la REST API de Supabase: POST /storage/v1/object/{bucket}/{path}
     */
    private static String subirASupabase(String bucket, String nombreArchivo,
                                          byte[] bytes, String contentType) throws IOException {
        validarConfig();

        String endpoint = SUPABASE_URL + "/storage/v1/object/" + bucket + "/" + nombreArchivo;

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(30_000);
        conn.setRequestProperty("Authorization", "Bearer " + SUPABASE_KEY);
        conn.setRequestProperty("Content-Type", contentType);
        conn.setRequestProperty("Content-Length", String.valueOf(bytes.length));
        // x-upsert: true → si el archivo ya existe, lo sobreescribe
        conn.setRequestProperty("x-upsert", "true");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(bytes);
        }

        int status = conn.getResponseCode();

        if (status == 200 || status == 201) {
            // URL pública del archivo
            return SUPABASE_URL + "/storage/v1/object/public/" + bucket + "/" + nombreArchivo;
        } else {
            // Leer error para log
            String error = "";
            try {
                InputStream es = conn.getErrorStream();
                if (es != null) error = new String(leerBytes(es), StandardCharsets.UTF_8);
            } catch (Exception ignored) {}
            throw new IOException("[ImagenUtil] Supabase Storage error " + status + ": " + error);
        }
    }

    /**
     * Elimina un archivo de Supabase Storage.
     * DELETE /storage/v1/object/{bucket}/{archivo}
     */
    private static void eliminarDeSupabase(String bucket, String archivo) throws IOException {
        validarConfig();

        String endpoint = SUPABASE_URL + "/storage/v1/object/" + bucket + "/" + archivo;
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("DELETE");
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(10_000);
        conn.setRequestProperty("Authorization", "Bearer " + SUPABASE_KEY);

        int status = conn.getResponseCode();
        if (status != 200 && status != 204) {
            System.err.println("[ImagenUtil] No se pudo eliminar de Supabase: HTTP " + status
                    + " → " + bucket + "/" + archivo);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // AUXILIARES
    // ─────────────────────────────────────────────────────────────────────────

    private static void validarConfig() {
        if (SUPABASE_URL == null || SUPABASE_URL.isBlank()) {
            throw new IllegalStateException("Variable de entorno SUPABASE_URL no configurada");
        }
        if (SUPABASE_KEY == null || SUPABASE_KEY.isBlank()) {
            throw new IllegalStateException("Variable de entorno SUPABASE_KEY no configurada");
        }
    }

    private static String obtenerExtension(Part part) {
        String nombre = getFileName(part);
        if (nombre != null && nombre.contains(".")) {
            return nombre.substring(nombre.lastIndexOf('.') + 1).toLowerCase();
        }
        // Inferir desde Content-Type
        String ct = part.getContentType();
        if (ct != null) {
            if (ct.contains("png"))  return "png";
            if (ct.contains("gif"))  return "gif";
            if (ct.contains("webp")) return "webp";
        }
        return "jpg";
    }

    private static String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.toLowerCase().startsWith("filename")) {
                int idx = token.indexOf('=');
                if (idx > 0) {
                    String name = token.substring(idx + 1).trim()
                            .replace("\"", "");
                    // Quitar path si el navegador lo incluyó
                    int s = name.lastIndexOf('\\');
                    if (s >= 0) name = name.substring(s + 1);
                    s = name.lastIndexOf('/');
                    if (s >= 0) name = name.substring(s + 1);
                    return name;
                }
            }
        }
        return null;
    }

    /**
     * Normaliza el parámetro "carpeta" que puede venir como:
     * "uploads/prettify/" → "prettify"
     * "looks"             → "looks"
     * "uploads/looks"     → "looks"
     */
    private static String normalizarBucket(String carpeta) {
        if (carpeta == null) return CARPETA_PRENDAS;
        String b = carpeta.replace("uploads/", "").replace("/", "").trim();
        return b.isEmpty() ? CARPETA_PRENDAS : b;
    }

    private static byte[] leerBytes(InputStream is) throws IOException {
        if (is == null) return new byte[0];
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        byte[] chunk = new byte[8192];
        int n;
        while ((n = is.read(chunk)) != -1) buf.write(chunk, 0, n);
        return buf.toByteArray();
    }
}