package com.quiddity.servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Usuario;

@WebServlet("/comprador/actualizar-perfil")
public class ActualizarPerfilCompradorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    private String getUploadDir() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) return env + File.separator + "perfiles";
        return getServletContext().getRealPath("/uploads/perfiles");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Usuario sesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesion == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Multipart = subida de foto
        if (ServletFileUpload.isMultipartContent(req)) {
            subirFoto(req, resp, sesion);
            return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "actualizarDatos"  -> actualizarDatos(req, resp, sesion);
            case "cambiarPassword"  -> cambiarPassword(req, resp, sesion);
            case "cambiarRol"       -> cambiarRol(req, resp, sesion);
            default -> resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
        }
    }

    // ── Actualizar datos personales ───────────────────────────────────────
    private void actualizarDatos(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        Usuario u = usuarioDAO.obtenerPorId(sesion.getId());
        if (u == null) {
            session(req).setAttribute("perfilError", "Usuario no encontrado.");
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
            return;
        }

        u.setNombre(req.getParameter("nombre"));
        u.setApellido(req.getParameter("apellido"));
        u.setEmail(req.getParameter("email"));
        // documento: solo admin puede cambiarlo, aquí no se toca

        boolean ok = usuarioDAO.actualizar(u);
        if (ok) {
            req.getSession().setAttribute("usuario", u);
            session(req).setAttribute("perfilExito", "Datos actualizados correctamente.");
        } else {
            session(req).setAttribute("perfilError", "No se pudo actualizar. Inténtalo de nuevo.");
        }
        resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
    }

    // ── Cambiar contraseña ────────────────────────────────────────────────
    private void cambiarPassword(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        String actual    = req.getParameter("contrasenaActual");
        String nueva     = req.getParameter("nuevaContrasena");
        String confirmar = req.getParameter("confirmarContrasena");

        Usuario verificado = usuarioDAO.login(sesion.getEmail(), actual);
        if (verificado == null) {
            session(req).setAttribute("perfilError", "La contraseña actual es incorrecta.");
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
            return;
        }
        if (nueva == null || nueva.length() < 8) {
            session(req).setAttribute("perfilError", "La nueva contraseña debe tener al menos 8 caracteres.");
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
            return;
        }
        if (!nueva.equals(confirmar)) {
            session(req).setAttribute("perfilError", "Las contraseñas no coinciden.");
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
            return;
        }

        boolean ok = usuarioDAO.cambiarContrasena(sesion.getId(), nueva);
        if (ok) {
            session(req).setAttribute("perfilExito", "Contraseña actualizada correctamente.");
        } else {
            session(req).setAttribute("perfilError", "No se pudo cambiar la contraseña.");
        }
        resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
    }

    // ── Cambiar rol (Comprador ↔ Usuario) ─────────────────────────────────
    private void cambiarRol(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        // Solo permitido entre rol 2 (Comprador) y rol 3 (Usuario)
        if (sesion.getIdRol() == UsuarioDAO.ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
            return;
        }

        String nuevoRolParam = req.getParameter("nuevoRol");
        int nuevoRol = "3".equals(nuevoRolParam) ? UsuarioDAO.ROL_USUARIO : UsuarioDAO.ROL_COMPRADOR;

        boolean ok = usuarioDAO.cambiarRol(sesion.getId(), nuevoRol);
        if (ok) {
            Usuario u = usuarioDAO.obtenerPorId(sesion.getId());
            req.getSession().setAttribute("usuario", u);
            session(req).setAttribute("perfilExito",
                nuevoRol == UsuarioDAO.ROL_USUARIO
                    ? "Ahora eres Usuario. Ya no tienes acceso al carrito de compras."
                    : "Ahora eres Comprador. Ya puedes agregar productos al carrito.");
        } else {
            session(req).setAttribute("perfilError", "No se pudo cambiar el rol.");
        }
        resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
    }

    // ── Subir foto de perfil ──────────────────────────────────────────────
    private void subirFoto(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        String uploadDir = getUploadDir();
        new File(uploadDir).mkdirs();

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 1024);
            factory.setRepository(File.createTempFile("tmp", null).getParentFile());

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(5 * 1024 * 1024L);
            upload.setSizeMax(6 * 1024 * 1024L);

            List<FileItem> items = upload.parseRequest(req);
            FileItem fotoItem = null;
            for (FileItem item : items) {
                if (!item.isFormField() && "foto".equals(item.getFieldName()) && item.getSize() > 0) {
                    fotoItem = item;
                }
            }

            if (fotoItem == null) {
                session(req).setAttribute("perfilError", "No se seleccionó ninguna imagen.");
                resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
                return;
            }

            String contentType = fotoItem.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                session(req).setAttribute("perfilError", "El archivo debe ser una imagen.");
                resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
                return;
            }

            // Borrar foto anterior
            Usuario actual = usuarioDAO.obtenerPorId(sesion.getId());
            if (actual != null && actual.getFotoPerfil() != null && !actual.getFotoPerfil().isBlank()) {
                new File(uploadDir, actual.getFotoPerfil()).delete();
            }

            // Guardar nueva foto
            String ext = "";
            String orig = fotoItem.getName();
            int dot = orig.lastIndexOf('.');
            if (dot >= 0) ext = orig.substring(dot).toLowerCase();

            String nombreArchivo = "perfil_" + sesion.getId() + "_"
                    + UUID.randomUUID().toString().substring(0, 8) + ext;
            fotoItem.write(new File(uploadDir, nombreArchivo));

            boolean ok = usuarioDAO.actualizarFoto(sesion.getId(), nombreArchivo);
            if (ok) {
                sesion.setFotoPerfil(nombreArchivo);
                req.getSession().setAttribute("usuario", sesion);
                session(req).setAttribute("perfilExito", "Foto de perfil actualizada.");
            } else {
                session(req).setAttribute("perfilError", "No se pudo guardar la foto.");
            }

        } catch (Exception e) {
            session(req).setAttribute("perfilError", "Error al procesar la imagen: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/comprador/perfil.jsp");
    }

    private HttpSession session(HttpServletRequest req) {
        return req.getSession();
    }
}