package com.quiddity.servlet;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;

/**
 * RegistroServlet
 *
 * GET  /registro → muestra el formulario de registro
 * POST /registro → procesa el registro: nombre, apellido, email, username,
 *                  contraseña, documento, foto de perfil y rol (usuario=2 | comprador=3)
 *
 * La foto de perfil se guarda en <contexto>/uploads/perfiles/
 * y se almacena en BD como ruta relativa (uploads/perfiles/<filename>).
 */
@WebServlet("/registro")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB — empieza a escribir en disco
    maxFileSize       = 5 * 1024 * 1024,  // 5 MB por archivo
    maxRequestSize    = 10 * 1024 * 1024  // 10 MB por petición
)
public class RegistroServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ─────────────────────────────────────────────
    // GET — mostrar formulario
    // ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Si ya hay sesión activa, redirigir al destino correspondiente
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario u = (Usuario) session.getAttribute("usuario");
            resp.sendRedirect(destinoSegunRol(req, u));
            return;
        }

        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    // ─────────────────────────────────────────────
    // POST — procesar registro
    // ─────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ── Leer campos de texto ──────────────────
        String nombre     = trim(req.getParameter("nombre"));
        String apellido   = trim(req.getParameter("apellido"));
        String email      = trim(req.getParameter("email"));
        String username   = trim(req.getParameter("username"));
        String contrasena = req.getParameter("contrasena");
        String confirmar  = req.getParameter("confirmarContrasena");
        String documento  = trim(req.getParameter("documento"));
        String rolParam   = trim(req.getParameter("rol")); // "2" = usuario, "3" = comprador

        // ── Validaciones básicas ──────────────────
        if (isBlank(nombre) || isBlank(apellido) || isBlank(email) ||
            isBlank(username) || isBlank(contrasena) || isBlank(documento)) {
            reenviarConError(req, resp, "Todos los campos obligatorios deben estar completos.");
            return;
        }

        if (!contrasena.equals(confirmar)) {
            reenviarConError(req, resp, "Las contraseñas no coinciden.");
            return;
        }

        if (contrasena.length() < 6) {
            reenviarConError(req, resp, "La contraseña debe tener al menos 6 caracteres.");
            return;
        }

        if (usuarioDAO.emailExiste(email)) {
            reenviarConError(req, resp, "El correo electrónico ya está registrado.");
            return;
        }

        if (usuarioDAO.documentoExiste(documento)) {
            reenviarConError(req, resp, "El documento ya está registrado.");
            return;
        }

        // ── Determinar rol (solo usuario=2 o comprador=3) ──
        int idRol = "3".equals(rolParam) ? UsuarioDAO.ROL_COMPRADOR : UsuarioDAO.ROL_USUARIO;

        // ── Procesar foto de perfil (opcional) ───
        String rutaFoto = null;
        Part fotoPart = req.getPart("fotoPerfil");
        if (fotoPart != null && fotoPart.getSize() > 0) {
            rutaFoto = guardarFoto(fotoPart, req);
            if (rutaFoto == null) {
                reenviarConError(req, resp, "El archivo de foto no es válido. Solo se permiten imágenes JPG, PNG o WEBP.");
                return;
            }
        }

        // ── Crear usuario ─────────────────────────
        Usuario nuevo = new Usuario();
        nuevo.setNombre(nombre);
        nuevo.setApellido(apellido);
        nuevo.setEmail(email);
        nuevo.setUserName(username);
        nuevo.setContrasena(contrasena); // TODO: hashear con BCrypt antes de guardar
        nuevo.setDocumento(documento);
        nuevo.setFotoPerfil(rutaFoto);
        nuevo.setIdRol(idRol);

        boolean ok = usuarioDAO.crear(nuevo);

        if (!ok) {
            reenviarConError(req, resp, "No se pudo completar el registro. Inténtalo de nuevo.");
            return;
        }

        // ── Registro exitoso → redirigir al login con mensaje ──
        resp.sendRedirect(req.getContextPath() + "/login?registro=ok");
    }

    // ─────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────

    /**
     * Guarda la foto de perfil en disco y devuelve la ruta relativa,
     * o null si el tipo de archivo no es permitido.
     */
    private String guardarFoto(Part part, HttpServletRequest req) throws IOException {
        String nombreArchivo = obtenerNombreArchivo(part);
        if (nombreArchivo == null || nombreArchivo.isBlank()) return null;

        String extension = extension(nombreArchivo).toLowerCase();
        if (!extension.equals("jpg") && !extension.equals("jpeg") &&
            !extension.equals("png") && !extension.equals("webp")) {
            return null;
        }

        // Directorio de destino dentro del contexto desplegado
        String uploadDir = req.getServletContext().getRealPath("/uploads/perfiles");
        Path dirPath = Paths.get(uploadDir);
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
        }

        // Nombre único para evitar colisiones
        String nombreUnico = System.currentTimeMillis() + "_" + nombreArchivo.replaceAll("\\s+", "_");
        Path destino = dirPath.resolve(nombreUnico);

        try (InputStream is = part.getInputStream()) {
            Files.copy(is, destino, StandardCopyOption.REPLACE_EXISTING);
        }

        return "uploads/perfiles/" + nombreUnico;
    }

    /** Extrae el nombre original del archivo del header Content-Disposition. */
    private String obtenerNombreArchivo(Part part) {
        String contentDisposition = part.getHeader("Content-Disposition");
        if (contentDisposition == null) return null;
        for (String token : contentDisposition.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1)
                            .trim()
                            .replace("\"", "");
            }
        }
        return null;
    }

    private String extension(String nombre) {
        int dot = nombre.lastIndexOf('.');
        return dot >= 0 ? nombre.substring(dot + 1) : "";
    }

    private void reenviarConError(HttpServletRequest req, HttpServletResponse resp, String mensaje)
            throws ServletException, IOException {
        req.setAttribute("error", mensaje);
        // Conservar campos completados para no forzar al usuario a rellenar de nuevo
        req.setAttribute("nombre",   req.getParameter("nombre"));
        req.setAttribute("apellido", req.getParameter("apellido"));
        req.setAttribute("email",    req.getParameter("email"));
        req.setAttribute("username", req.getParameter("username"));
        req.setAttribute("documento",req.getParameter("documento"));
        req.setAttribute("rol",      req.getParameter("rol"));
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    private String destinoSegunRol(HttpServletRequest req, Usuario u) {
        String base = req.getContextPath();
        return switch (u.getIdRol()) {
            case UsuarioDAO.ROL_ADMIN     -> base + "/admin/dashboard";
            case UsuarioDAO.ROL_COMPRADOR -> base + "/comprador/home";
            default                       -> base + "/inicio";
        };
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
    private boolean isBlank(String s) { return s == null || s.isBlank(); }
}