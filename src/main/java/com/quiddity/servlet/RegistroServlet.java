package com.quiddity.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

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

@WebServlet("/registro")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
public class RegistroServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario u = (Usuario) session.getAttribute("usuario");
            resp.sendRedirect(destinoSegunRol(req, u));
            return;
        }
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nombre     = trim(req.getParameter("nombre"));
        String apellido   = trim(req.getParameter("apellido"));
        String email      = trim(req.getParameter("email"));
        String username   = trim(req.getParameter("userName"));
        String contrasena = req.getParameter("contrasena");
        String confirmar  = req.getParameter("confirmarContrasena");
        String documento  = trim(req.getParameter("documento"));
        String rolParam   = trim(req.getParameter("rol"));

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

        int idRol = "COMPRADOR".equalsIgnoreCase(rolParam)
                    ? UsuarioDAO.ROL_COMPRADOR
                    : UsuarioDAO.ROL_USUARIO;

        // Foto de perfil: solo leer si el form es multipart (el form actual no lo es)
        String rutaFoto = null;
        String contentType = req.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("multipart/form-data")) {
            Part fotoPart = req.getPart("fotoPerfil");
            if (fotoPart != null && fotoPart.getSize() > 0) {
                rutaFoto = guardarFoto(fotoPart, req);
                if (rutaFoto == null) {
                    reenviarConError(req, resp, "El archivo de foto no es válido. Solo se permiten imágenes JPG, PNG o WEBP.");
                    return;
                }
            }
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombre(nombre);
        nuevo.setApellido(apellido);
        nuevo.setEmail(email);
        nuevo.setUserName(username);
        nuevo.setContrasena(contrasena);
        nuevo.setDocumento(documento);
        nuevo.setFotoPerfil(rutaFoto);
        nuevo.setIdRol(idRol);

        boolean ok = usuarioDAO.crear(nuevo);

        if (!ok) {
            reenviarConError(req, resp, "No se pudo completar el registro. Inténtalo de nuevo.");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login?registro=ok");
    }

    private String guardarFoto(Part part, HttpServletRequest req) throws IOException {
        String nombreArchivo = obtenerNombreArchivo(part);
        if (nombreArchivo == null || nombreArchivo.isBlank()) return null;

        String extension = extension(nombreArchivo).toLowerCase();
        if (!extension.equals("jpg") && !extension.equals("jpeg") &&
            !extension.equals("png") && !extension.equals("webp")) {
            return null;
        }

        String uploadDir = req.getServletContext().getRealPath("/uploads/perfiles");
        Path dirPath = Paths.get(uploadDir);
        if (!Files.exists(dirPath)) Files.createDirectories(dirPath);

        String nombreUnico = System.currentTimeMillis() + "_" + nombreArchivo.replaceAll("\\s+", "_");
        Path destino = dirPath.resolve(nombreUnico);

        try (InputStream is = part.getInputStream()) {
            Files.copy(is, destino, StandardCopyOption.REPLACE_EXISTING);
        }

        return "uploads/perfiles/" + nombreUnico;
    }

    private String obtenerNombreArchivo(Part part) {
        String cd = part.getHeader("Content-Disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
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
        req.setAttribute("nombre",    req.getParameter("nombre"));
        req.setAttribute("apellido",  req.getParameter("apellido"));
        req.setAttribute("email",     req.getParameter("email"));
        req.setAttribute("userName",  req.getParameter("userName"));
        req.setAttribute("documento", req.getParameter("documento"));
        req.setAttribute("rol",       req.getParameter("rol"));
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    private String destinoSegunRol(HttpServletRequest req, Usuario u) {
        String base = req.getContextPath();
        return switch (u.getIdRol()) {
            case UsuarioDAO.ROL_ADMIN     -> base + "/admin/dashboard";
            case UsuarioDAO.ROL_COMPRADOR -> base + "/comprador/catalogo.jsp";
            default                       -> base + "/inicio";
        };
    }

    private String trim(String s)     { return s == null ? "" : s.trim(); }
    private boolean isBlank(String s) { return s == null || s.isBlank(); }
}