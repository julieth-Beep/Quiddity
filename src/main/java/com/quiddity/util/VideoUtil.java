package com.quiddity.util;

import javax.servlet.ServletContext;
import java.io.File;
import java.util.*;

public class VideoUtil {

    /**
     * Dado un nombre de categoría (o "mixed"), devuelve la ruta
     * relativa al webapp de un video aleatorio de esa carpeta.
     * Ejemplo devuelto: "videos/ropa/ropa_02.mp4"
     */
    public static String getRandomVideo(ServletContext ctx, String categoria) {
        // Normaliza: minúsculas, sin tildes para coincidir con nombres de carpeta
        String folder = normalizarCategoria(categoria);

        String dirPath = ctx.getRealPath("/uploads/videos/" + folder);
        File dir = new File(dirPath);

        if (!dir.exists() || !dir.isDirectory()) {
            // Fallback a mixed si la carpeta no existe
            dirPath = ctx.getRealPath("/uploads/videos/mixed");
            dir = new File(dirPath);
            folder = "mixed";
        }

        File[] videos = dir.listFiles(f ->
            f.getName().endsWith(".mp4") || f.getName().endsWith(".webm")
        );

        if (videos == null || videos.length == 0) return null;

        File elegido = videos[new Random().nextInt(videos.length)];
        return "videos/" + folder + "/" + elegido.getName();
    }

    private static String normalizarCategoria(String cat) {
        if (cat == null) return "mixed";
        return cat.toLowerCase()
                  .replaceAll("[áà]", "a")
                  .replaceAll("[éè]", "e")
                  .replaceAll("[íì]", "i")
                  .replaceAll("[óò]", "o")
                  .replaceAll("[úù]", "u")
                  .replaceAll("ñ", "n")
                  .replaceAll("\\s+", "_");
    }
}