package com.quiddity.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;

/**
 * Sirve las fotos de perfil desde el directorio externo (UPLOAD_DIR).
 * URL: /foto-perfil/{nombreArchivo}
 */
@WebServlet("/foto-perfil/*")
public class FotoPerfilServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String getUploadDir() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) {
            String dir = env + File.separator + "perfiles";
            System.out.println("[FotoPerfilServlet] Usando UPLOAD_DIR: " + dir);
            return dir;
        }
        String dir = getServletContext().getRealPath("/uploads/perfiles");
        System.out.println("[FotoPerfilServlet] Usando ruta local: " + dir);
        return dir;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String pathInfo = req.getPathInfo(); // ej. /perfil_3_abc123.jpg
            System.out.println("[FotoPerfilServlet] pathInfo: " + pathInfo);

            if (pathInfo == null || pathInfo.equals("/")) {
                System.out.println("[FotoPerfilServlet] pathInfo vacio, devolviendo 404");
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Evitar path traversal
            String nombreArchivo = new File(pathInfo.substring(1)).getName();
            System.out.println("[FotoPerfilServlet] nombreArchivo: " + nombreArchivo);

            String uploadDir = getUploadDir();
            File archivo = new File(uploadDir, nombreArchivo);
            System.out.println("[FotoPerfilServlet] Buscando archivo: " + archivo.getAbsolutePath());
            System.out.println("[FotoPerfilServlet] Existe: " + archivo.exists() + ", Es archivo: " + archivo.isFile());

            if (!archivo.exists() || !archivo.isFile()) {
                // Intentar buscar en directorio alternativo (compatibilidad)
                File altDir = new File(getServletContext().getRealPath("/uploads/perfiles"));
                File altArchivo = new File(altDir, nombreArchivo);
                System.out.println("[FotoPerfilServlet] Buscando en alternativo: " + altArchivo.getAbsolutePath());

                if (altArchivo.exists() && altArchivo.isFile()) {
                    archivo = altArchivo;
                    System.out.println("[FotoPerfilServlet] Encontrado en directorio alternativo");
                } else {
                    System.out.println("[FotoPerfilServlet] Archivo no encontrado, devolviendo 404");
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }

            // Detectar content type
            String contentType = Files.probeContentType(archivo.toPath());
            if (contentType == null)
                contentType = "application/octet-stream";

            resp.setContentType(contentType);
            resp.setContentLength((int) archivo.length());
            // Cache 1 hora
            resp.setHeader("Cache-Control", "public, max-age=3600");

            try (InputStream in = new FileInputStream(archivo);
                    OutputStream out = resp.getOutputStream()) {
                byte[] buf = new byte[8192];
                int n;
                while ((n = in.read(buf)) != -1) {
                    out.write(buf, 0, n);
                }
            }
            System.out.println("[FotoPerfilServlet] Archivo servido correctamente: " + nombreArchivo);

        } catch (Exception e) {
            System.err.println("[FotoPerfilServlet] ERROR: " + e.getMessage());
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al servir imagen: " + e.getMessage());
        }
    }
}