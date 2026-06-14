package com.quiddity.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 * ImagenUtil — guarda, valida y elimina imágenes del servidor.
 * Todas las rutas que devuelve son RELATIVAS (ej: uploads/prendas/xxx.png)
 * para guardar en BD y construir URLs desde el JSP.
 */
public class ImagenUtil {

    private static final long MAX_BYTES = 5 * 1024 * 1024; // 5 MB
    private static final String[] FORMATOS = { ".jpg", ".jpeg", ".png", ".webp" };

    // Subcarpetas dentro del webroot
    public static final String CARPETA_PRENDAS = "uploads/prendas/";
    public static final String CARPETA_LOOKS = "uploads/looks/";
    public static final String CARPETA_PERFILES = "uploads/perfiles/";

    // ── GUARDAR ───────────────────────────────────────────────────────────────

    /** Guarda imagen de prenda y devuelve ruta relativa */
    public static String guardarPrenda(Part parte, HttpServletRequest req) throws IOException {
        return guardar(parte, req, CARPETA_PRENDAS);
    }

    /** Guarda imagen de perfil y devuelve ruta relativa */
    public static String guardarPerfil(Part parte, HttpServletRequest req) throws IOException {
        return guardar(parte, req, CARPETA_PERFILES);
    }

    /**
     * Guarda cualquier imagen en la subcarpeta indicada.
     * Lanza IllegalArgumentException si el archivo no es válido.
     */
    public static String guardar(Part parte, HttpServletRequest req, String subcarpeta)
            throws IOException {
        validar(parte);

        String ext = obtenerExtension(parte);
        String nombre = UUID.randomUUID() + ext;
        String dirAbs = req.getServletContext().getRealPath("") + File.separator
                + subcarpeta.replace("/", File.separator);

        new File(dirAbs).mkdirs();
        parte.write(dirAbs + nombre);

        return subcarpeta + nombre; // ruta relativa para BD
    }

    /**
     * Guarda bytes crudos (usados cuando la imagen viene de una API externa,
     * ej: HuggingFace o RemoveBg devuelven bytes, no un Part).
     */
    public static String guardarBytes(byte[] bytes, String subcarpeta,
            String extension, HttpServletRequest req)
            throws IOException {
        String nombre = UUID.randomUUID() + extension;
        String dirAbs = req.getServletContext().getRealPath("") + File.separator
                + subcarpeta.replace("/", File.separator);

        new File(dirAbs).mkdirs();
        java.nio.file.Files.write(
                java.nio.file.Paths.get(dirAbs + nombre), bytes);

        return subcarpeta + nombre;
    }

    // ── ELIMINAR ──────────────────────────────────────────────────────────────

    /** Elimina un archivo del disco dado su ruta relativa */
    public static void eliminar(String rutaRelativa, HttpServletRequest req) {
        if (rutaRelativa == null || rutaRelativa.isBlank())
            return;
        String ruta = req.getServletContext().getRealPath("") + File.separator
                + rutaRelativa.replace("/", File.separator);
        File f = new File(ruta);
        if (f.exists())
            f.delete();
    }

    // ── VALIDACIÓN ────────────────────────────────────────────────────────────

    /** true si el Part contiene un archivo real */
    public static boolean tieneArchivo(Part parte) {
        if (parte == null || parte.getSize() <= 0)
            return false;
        String nombre = getNombreOriginal(parte);
        return nombre != null && !nombre.isBlank();
    }

    private static void validar(Part parte) {
        if (!tieneArchivo(parte))
            throw new IllegalArgumentException("No se recibió ningún archivo.");
        if (parte.getSize() > MAX_BYTES)
            throw new IllegalArgumentException("La imagen supera el límite de 5 MB.");
        String ext = obtenerExtension(parte);
        for (String f : FORMATOS) {
            if (f.equals(ext))
                return;
        }
        throw new IllegalArgumentException("Formato no permitido. Usa jpg, jpeg, png o webp.");
    }

    // ── AUXILIARES ────────────────────────────────────────────────────────────

    public static String obtenerExtension(Part parte) {
        String nombre = getNombreOriginal(parte);
        if (nombre == null || !nombre.contains("."))
            return ".jpg";
        return nombre.substring(nombre.lastIndexOf('.')).toLowerCase();
    }

    private static String getNombreOriginal(Part parte) {
        String cd = parte.getHeader("content-disposition");
        if (cd == null)
            return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename=")) {
                String n = token.substring(9).replace("\"", "").trim();
                if (n.contains("\\"))
                    n = n.substring(n.lastIndexOf('\\') + 1);
                return n;
            }
        }
        return null;
    }

    /** Construye la URL completa para usar en src de <img> en JSP */
    public static String toUrl(String rutaRelativa, HttpServletRequest req) {
        if (rutaRelativa == null)
            return "";
        return req.getContextPath() + "/" + rutaRelativa;
    }
}