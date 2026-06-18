package com.quiddity.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

@WebServlet(urlPatterns = { "/admin/usuarios", "/admin/reportes" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
        maxFileSize = 1024 * 1024 * 5, // 5 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // Directorio raíz para imágenes de perfil
    private static final String UPLOAD_PERFILES = "uploads/perfiles";

    // Método consistente con FotoPerfilServlet
    private String getUploadDir() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) {
            return env + File.separator + "perfiles";
        }
        return getServletContext().getRealPath("/" + UPLOAD_PERFILES);
    }

    // ─────────────────────────────────────────────
    // GET
    // ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!esAdmin(req, resp)) {
            return;
        }

        String uri = req.getRequestURI();
        String base = req.getContextPath();
        String action = req.getParameter("action"); // "nuevo"
        String idStr = req.getParameter("id");
        String editar = req.getParameter("editar"); // "true"
        String accion = req.getParameter("accion"); // "editar" | "ver" (desde la lista)

        if (uri.endsWith("/admin/reportes")) {
            mostrarReportes(req, resp);
            return;
        }

        // ═══════════════════════════════════════════════════════════════════
        // FIX #1: /admin/usuarios?action=nuevo → formulario VACÍO
        // ═══════════════════════════════════════════════════════════════════
        if ("nuevo".equals(action)) {
            req.removeAttribute("usuario"); // ← LIMPIAR para que no quede datos viejos
            req.removeAttribute("accion");
            req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
            return;
        }

        // /admin/usuarios?accion=editar&id=X → formulario relleno
        if ("editar".equals(accion) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Usuario u = usuarioDAO.obtenerPorId(id);
                if (u == null) {
                    resp.sendRedirect(base + "/admin/usuarios");
                    return;
                }
                req.setAttribute("usuario", u);
                req.setAttribute("accion", "editar");
                req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(base + "/admin/usuarios");
            }
            return;
        }

        // /admin/usuarios?accion=ver&id=X → modo solo lectura
        if ("ver".equals(accion) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Usuario u = usuarioDAO.obtenerPorId(id);
                if (u == null) {
                    resp.sendRedirect(base + "/admin/usuarios");
                    return;
                }
                req.setAttribute("usuario", u);
                req.setAttribute("accion", "ver");
                req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(base + "/admin/usuarios");
            }
            return;
        }

        // /admin/usuarios?id=X&editar=true → compatibilidad
        if (idStr != null && "true".equals(editar)) {
            try {
                int id = Integer.parseInt(idStr);
                Usuario u = usuarioDAO.obtenerPorId(id);
                if (u == null) {
                    resp.sendRedirect(base + "/admin/usuarios");
                    return;
                }
                req.setAttribute("usuario", u);
                req.setAttribute("accion", "editar");
                req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(base + "/admin/usuarios");
            }
            return;
        }

        // /admin/usuarios?id=X → detalle/modo ver
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Usuario u = usuarioDAO.obtenerPorId(id);
                req.setAttribute("usuario", u);
                req.setAttribute("accion", "ver");
                req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(base + "/admin/usuarios");
            }
            return;
        }

        // /admin/usuarios → listado (con filtros opcionales)
        listarUsuarios(req, resp);
    }

    // ─────────────────────────────────────────────
    // POST (crear / editar / eliminar / cambiarRol)
    // ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!esAdmin(req, resp)) {
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String base = req.getContextPath();

        switch (action == null ? "" : action) {

            case "crear":
                crearUsuario(req, resp);
                break;

            case "editar":
                editarUsuario(req, resp);
                break;

            case "eliminar":
                eliminarUsuario(req, resp);
                break;

            case "cambiarRol":
                cambiarRol(req, resp);
                break;

            default:
                resp.sendRedirect(base + "/admin/usuarios");
        }
    }

    // ─────────────────────────────────────────────
    // ACCIONES
    // ─────────────────────────────────────────────
    private void listarUsuarios(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String rolParam = req.getParameter("rol");
        String buscarParam = req.getParameter("buscar");
        List<Usuario> lista;

        // ═══════════════════════════════════════════════════════════════════
        // FIX #2: Búsqueda por nombre, username, email o documento
        // ═══════════════════════════════════════════════════════════════════
        if (buscarParam != null && !buscarParam.isBlank()) {
            lista = usuarioDAO.buscarPorNombreUserEmailDoc(buscarParam.trim());
        } else if (rolParam != null && !rolParam.isBlank()) {
            try {
                lista = usuarioDAO.listarPorRol(Integer.parseInt(rolParam.trim()));
            } catch (NumberFormatException e) {
                lista = usuarioDAO.listarTodos();
            }
        } else {
            lista = usuarioDAO.listarTodos();
        }

        req.setAttribute("usuarios", lista);
        req.getRequestDispatcher("/WEB-INF/admin/usuarios.jsp").forward(req, resp);
    }

    private void mostrarReportes(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("usuarios", usuarioDAO.listarTodos());
        req.setAttribute("usuarios2", usuarioDAO.listarPorRol(UsuarioDAO.ROL_USUARIO));
        req.setAttribute("compradores", usuarioDAO.listarPorRol(UsuarioDAO.ROL_COMPRADOR));
        req.getRequestDispatcher("/WEB-INF/admin/reportes.jsp").forward(req, resp);
    }

    private void crearUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String base = req.getContextPath();
        try {
            Usuario u = new Usuario();
            u.setNombre(req.getParameter("nombre"));
            u.setApellido(req.getParameter("apellido"));
            u.setEmail(req.getParameter("email"));
            u.setDocumento(req.getParameter("documento"));
            u.setUserName(req.getParameter("username"));
            u.setContrasena(req.getParameter("contrasena"));
            u.setIdRol(Integer.parseInt(req.getParameter("idrol")));

            // === MANEJO DE IMAGEN DE PERFIL ===
            Part filePart = req.getPart("avatar");
            String fotoPerfil = null;
            if (filePart != null && filePart.getSize() > 0) {
                fotoPerfil = guardarImagenPerfil(filePart, u.getNombre(), u.getApellido());
            }
            if (fotoPerfil == null) {
                String fotoTexto = req.getParameter("fotoperfil_url");
                if (fotoTexto != null && !fotoTexto.isBlank()) {
                    fotoPerfil = fotoTexto.trim();
                }
            }
            u.setFotoPerfil(fotoPerfil);

            usuarioDAO.crear(u);
            resp.sendRedirect(base + "/admin/usuarios?exito="
                    + java.net.URLEncoder.encode("Usuario creado correctamente.", "UTF-8"));

        } catch (Exception e) {
            req.setAttribute("error", "Error al crear el usuario: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
        }
    }

    private void editarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String base = req.getContextPath();
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Usuario u = usuarioDAO.obtenerPorId(id);
            if (u == null) {
                resp.sendRedirect(base + "/admin/usuarios");
                return;
            }

            u.setNombre(req.getParameter("nombre"));
            u.setApellido(req.getParameter("apellido"));
            u.setEmail(req.getParameter("email"));
            u.setDocumento(req.getParameter("documento"));
            u.setUserName(req.getParameter("username"));

            String nuevaContrasena = req.getParameter("contrasena");
            if (nuevaContrasena != null && !nuevaContrasena.isBlank()) {
                u.setContrasena(nuevaContrasena);
            }

            HttpSession session = req.getSession(false);
            Usuario admin = (Usuario) session.getAttribute("usuario");
            if (admin.getIdRol() == UsuarioDAO.ROL_ADMIN) {
                u.setIdRol(Integer.parseInt(req.getParameter("idrol")));
            }

            // ═══════════════════════════════════════════════════════════════════
            // FIX #3: MANEJO ROBUSTO DE IMAGEN DE PERFIL (EDITAR)
            // Ahora usa el ID del usuario para evitar colisiones de nombres
            // y fuerza la actualización en BD incluso si el nombre cambió
            // ═══════════════════════════════════════════════════════════════════
            Part filePart = req.getPart("avatar");
            String fotoPerfil = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Borrar foto anterior si existe y no es URL externa
                if (u.getFotoPerfil() != null && !u.getFotoPerfil().isBlank()
                        && !u.getFotoPerfil().startsWith("http")) {
                    borrarImagenPerfil(u.getFotoPerfil());
                }
                // Guardar nueva foto con ID + UUID para evitar colisiones
                fotoPerfil = guardarImagenPerfil(filePart, u.getNombre(), u.getApellido(), id);
            }

            if (fotoPerfil == null) {
                String fotoTexto = req.getParameter("fotoperfil_url");
                if (fotoTexto != null && !fotoTexto.isBlank()) {
                    fotoPerfil = fotoTexto.trim();
                } else {
                    fotoPerfil = u.getFotoPerfil(); // Conservar foto anterior
                }
            }
            u.setFotoPerfil(fotoPerfil);

            // Si el admin edita su propio perfil, actualizar la sesión
            if (admin.getId() == id) {
                req.getSession().setAttribute("usuario", u);
            }

            // ═══════════════════════════════════════════════════════════════════
            // FIX #4: Forzar actualización de foto en BD con método dedicado
            // para asegurar que el campo foto_perfil se actualice
            // ═══════════════════════════════════════════════════════════════════
            boolean ok = usuarioDAO.actualizar(u);
            if (ok && fotoPerfil != null) {
                // Doble verificación: actualizar explícitamente la foto
                usuarioDAO.actualizarFoto(id, fotoPerfil);
            }

            resp.sendRedirect(base + "/admin/usuarios?exito="
                    + java.net.URLEncoder.encode("Usuario actualizado correctamente.", "UTF-8"));

        } catch (Exception e) {
            req.setAttribute("error", "Error al editar el usuario: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/admin/form.jsp").forward(req, resp);
        }
    }

    private void eliminarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String base = req.getContextPath();
        try {
            int id = Integer.parseInt(req.getParameter("id"));

            HttpSession session = req.getSession(false);
            Usuario admin = (Usuario) session.getAttribute("usuario");
            if (admin.getId() == id) {
                resp.sendRedirect(base + "/admin/usuarios?error="
                        + java.net.URLEncoder.encode("No puedes eliminar tu propia cuenta.", "UTF-8"));
                return;
            }

            Usuario u = usuarioDAO.obtenerPorId(id);
            if (u != null && u.getFotoPerfil() != null && !u.getFotoPerfil().isBlank()
                    && !u.getFotoPerfil().startsWith("http")) {
                borrarImagenPerfil(u.getFotoPerfil());
            }

            usuarioDAO.eliminar(id);
            resp.sendRedirect(base + "/admin/usuarios?exito="
                    + java.net.URLEncoder.encode("Usuario eliminado correctamente.", "UTF-8"));

        } catch (Exception e) {
            resp.sendRedirect(base + "/admin/usuarios?error="
                    + java.net.URLEncoder.encode("Error al eliminar: " + e.getMessage(), "UTF-8"));
        }
    }

    private void cambiarRol(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String base = req.getContextPath();
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int nuevoRol = Integer.parseInt(req.getParameter("idrol"));

            HttpSession session = req.getSession(false);
            Usuario admin = (Usuario) session.getAttribute("usuario");
            if (admin.getId() == id) {
                resp.sendRedirect(base + "/admin/usuarios?error="
                        + java.net.URLEncoder.encode("No puedes cambiar tu propio rol.", "UTF-8"));
                return;
            }

            usuarioDAO.cambiarRol(id, nuevoRol);
            resp.sendRedirect(base + "/admin/usuarios?exito="
                    + java.net.URLEncoder.encode("Rol cambiado correctamente.", "UTF-8"));

        } catch (Exception e) {
            resp.sendRedirect(base + "/admin/usuarios?error="
                    + java.net.URLEncoder.encode("Error al cambiar rol: " + e.getMessage(), "UTF-8"));
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // MANEJO DE IMÁGENES DE PERFIL
    // ═════════════════════════════════════════════════════════════════════════

    /**
     * Guarda imagen de perfil con nombre único basado en ID + UUID.
     * Esto evita colisiones cuando dos usuarios tienen el mismo nombre.
     */
    private String guardarImagenPerfil(Part filePart, String nombre, String apellido, int userId)
            throws IOException {

        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return null;
        }

        String fileName = getFileNameFromPart(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        String extension = getExtension(fileName).toLowerCase();
        if (!extension.equals("jpg") && !extension.equals("jpeg")
                && !extension.equals("png") && !extension.equals("gif") && !extension.equals("webp")) {
            return null;
        }

        // ═══════════════════════════════════════════════════════════════════
        // FIX #5: Usar ID + UUID para nombre único, evita colisiones
        // ═══════════════════════════════════════════════════════════════════
        String nombreBase = sanitizarNombreArchivo(nombre + "_" + apellido);
        if (nombreBase.isEmpty()) {
            nombreBase = "perfil";
        }
        // Nombre final: perfil_{id}_{nombre}_{uuid}.{ext}
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        String finalName = "perfil_" + userId + "_" + nombreBase + "_" + uuid + "." + extension;

        String basePath = getUploadDir();
        File uploadDir = new File(basePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String filePath = basePath + File.separator + finalName;

        try (InputStream input = filePart.getInputStream(); FileOutputStream output = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = input.read(buffer)) > 0) {
                output.write(buffer, 0, len);
            }
        }

        System.out.println("[AdminServlet] Foto guardada: " + finalName + " en " + filePath);
        return finalName;
    }

    /**
     * Sobrecarga para compatibilidad con crearUsuario (sin ID aún).
     * Genera nombre con UUID aleatorio.
     */
    private String guardarImagenPerfil(Part filePart, String nombre, String apellido)
            throws IOException {
        String nombreBase = sanitizarNombreArchivo(nombre + "_" + apellido);
        if (nombreBase.isEmpty())
            nombreBase = "perfil";
        String uuid = UUID.randomUUID().toString().substring(0, 8);

        String fileName = getFileNameFromPart(filePart);
        String extension = getExtension(fileName).toLowerCase();
        String finalName = nombreBase + "_" + uuid + "." + extension;

        String basePath = getUploadDir();
        File uploadDir = new File(basePath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        // Verificar que no exista
        String filePath = basePath + File.separator + finalName;
        File destFile = new File(filePath);
        int counter = 1;
        while (destFile.exists()) {
            finalName = nombreBase + "_" + uuid + "_" + counter + "." + extension;
            filePath = basePath + File.separator + finalName;
            destFile = new File(filePath);
            counter++;
        }

        try (InputStream input = filePart.getInputStream(); FileOutputStream output = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = input.read(buffer)) > 0) {
                output.write(buffer, 0, len);
            }
        }

        System.out.println("[AdminServlet] Foto guardada (nuevo usuario): " + finalName);
        return finalName;
    }

    private void borrarImagenPerfil(String nombreArchivo) {
        if (nombreArchivo == null || nombreArchivo.isBlank()) {
            return;
        }
        if (nombreArchivo.startsWith("http://") || nombreArchivo.startsWith("https://")) {
            return;
        }

        String basePath = getUploadDir();
        Path filePath = Paths.get(basePath, nombreArchivo);

        try {
            boolean deleted = Files.deleteIfExists(filePath);
            System.out.println("[AdminServlet] Foto anterior borrada: " + deleted + " - " + filePath);
        } catch (IOException e) {
            System.err.println("[AdminServlet] No se pudo borrar imagen: " + filePath);
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // HELPERS
    // ═════════════════════════════════════════════════════════════════════════
    private String getFileNameFromPart(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return null;
        }
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            token = token.trim();
            if (token.toLowerCase().startsWith("filename")) {
                int idx = token.indexOf('=');
                if (idx > 0) {
                    String fileName = token.substring(idx + 1).trim();
                    if (fileName.startsWith("\"") && fileName.endsWith("\"")) {
                        fileName = fileName.substring(1, fileName.length() - 1);
                    }
                    int lastSlash = fileName.lastIndexOf('\\');
                    if (lastSlash >= 0) {
                        fileName = fileName.substring(lastSlash + 1);
                    }
                    lastSlash = fileName.lastIndexOf('/');
                    if (lastSlash >= 0) {
                        fileName = fileName.substring(lastSlash + 1);
                    }
                    return fileName;
                }
            }
        }
        return null;
    }

    private String sanitizarNombreArchivo(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            return "perfil";
        }
        return nombre.trim().toLowerCase()
                .replaceAll("[áäâà]", "a")
                .replaceAll("[éëêè]", "e")
                .replaceAll("[íïîì]", "i")
                .replaceAll("[óöôò]", "o")
                .replaceAll("[úüûù]", "u")
                .replaceAll("[ñ]", "n")
                .replaceAll("[ç]", "c")
                .replaceAll("[^a-z0-9]", "_")
                .replaceAll("_+", "_")
                .replaceAll("^_+|_+$", "");
    }

    private String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot == -1 ? "" : fileName.substring(dot + 1);
    }

    private boolean esAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        Usuario u = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (u == null || u.getIdRol() != UsuarioDAO.ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}