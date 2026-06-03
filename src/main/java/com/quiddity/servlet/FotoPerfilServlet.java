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
            return env + File.separator + "perfiles";
        }
        return getServletContext().getRealPath("/uploads/perfiles");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo(); // ej. /perfil_3_abc123.jpg
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Evitar path traversal
        String nombreArchivo = new File(pathInfo.substring(1)).getName();
        File archivo = new File(getUploadDir(), nombreArchivo);

        if (!archivo.exists() || !archivo.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Detectar content type
        String contentType = Files.probeContentType(archivo.toPath());
        if (contentType == null) contentType = "application/octet-stream";

        resp.setContentType(contentType);
        resp.setContentLengthLong(archivo.length());
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
    }
}
