package com.quiddity.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * RemoveBgUtil — elimina el fondo de fotos de prendas usando remove.bg
 *
 * API gratuita: 50 imágenes/mes
 * Docs: https://www.remove.bg/api
 *
 * CONFIGURACIÓN: pon tu API key en la constante API_KEY.
 */
public class RemoveBgUtil {

    private static final String API_KEY = System.getenv("API_KEY") != null ? System.getenv("API_KEY") : "";
    private static final String ENDPOINT = "https://api.remove.bg/v1.0/removebg";

    /**
     * Elimina el fondo de una imagen.
     *
     * @param imagenOriginalBytes bytes de la imagen original (jpg/png/webp)
     * @return bytes de la imagen resultante con fondo transparente (PNG)
     *         o null si falla la API
     */
    public static byte[] removerFondo(byte[] imagenOriginalBytes) {
        try {
            // Construir multipart/form-data manualmente (sin librerías)
            String boundary = "----Boundary" + System.currentTimeMillis();
            byte[] cuerpo = construirMultipart(imagenOriginalBytes, boundary);

            URL url = new URL(ENDPOINT);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(30_000);
            conn.setReadTimeout(60_000);
            conn.setRequestProperty("X-Api-Key", API_KEY);
            conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
            conn.setRequestProperty("Content-Length", String.valueOf(cuerpo.length));

            // Enviar request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(cuerpo);
            }

            int codigo = conn.getResponseCode();

            if (codigo == 200) {
                // Leer bytes de la imagen resultante
                return leerBytes(conn.getInputStream());
            } else {
                // Leer mensaje de error para debug
                String error = new String(leerBytes(conn.getErrorStream()), StandardCharsets.UTF_8);
                System.err.println("[RemoveBgUtil] Error " + codigo + ": " + error);
                return null;
            }

        } catch (Exception e) {
            System.err.println("[RemoveBgUtil] Excepción: " + e.getMessage());
            return null;
        }
    }

    /**
     * Construye el body multipart/form-data.
     * Enviamos: image_file (bytes) + size=auto + format=png
     */
    private static byte[] construirMultipart(byte[] imagen, String boundary) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        String CRLF = "\r\n";
        String sep = "--" + boundary;

        // Campo: size
        escribirTexto(out, sep + CRLF
                + "Content-Disposition: form-data; name=\"size\"" + CRLF + CRLF
                + "auto" + CRLF);

        // Campo: format (queremos PNG para tener transparencia)
        escribirTexto(out, sep + CRLF
                + "Content-Disposition: form-data; name=\"format\"" + CRLF + CRLF
                + "png" + CRLF);

        // Campo: image_file (binario)
        escribirTexto(out, sep + CRLF
                + "Content-Disposition: form-data; name=\"image_file\"; filename=\"prenda.png\"" + CRLF
                + "Content-Type: image/png" + CRLF + CRLF);
        out.write(imagen);
        escribirTexto(out, CRLF);

        // Cierre del multipart
        escribirTexto(out, sep + "--" + CRLF);

        return out.toByteArray();
    }

    private static void escribirTexto(ByteArrayOutputStream out, String texto) throws IOException {
        out.write(texto.getBytes(StandardCharsets.UTF_8));
    }

    private static byte[] leerBytes(InputStream is) throws IOException {
        if (is == null)
            return new byte[0];
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] chunk = new byte[8192];
        int leidos;
        while ((leidos = is.read(chunk)) != -1) {
            buffer.write(chunk, 0, leidos);
        }
        return buffer.toByteArray();
    }
}