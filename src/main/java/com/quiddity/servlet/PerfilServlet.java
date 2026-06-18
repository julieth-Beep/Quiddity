package com.quiddity.servlet;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // Directorio base de uploads de fotos de perfil.
    // En Render: configura la variable de entorno UPLOAD_DIR apuntando
    // a tu Persistent Disk, p. ej. /var/data/uploads
    // En local: si no esta definida, usa webapp/uploads/perfiles
    private String getUploadDir() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) {
            return env + File.separator + "perfiles";
        }
        // fallback local: directorio relativo al contexto
        return getServletContext().getRealPath("/uploads/perfiles");
    }

    // -------------------------------------------------------------------------
    // GET — mostrar perfil del usuario en sesion
    // -------------------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Recargar datos frescos de la BD
        Usuario u = usuarioDAO.obtenerPorId(sesionUsuario.getId());
        if (u != null) {
            session.setAttribute("usuario", u);
        }

        // === FIX: Redirigir segun el rol a la JSP correspondiente ===
        String destino;
        if (sesionUsuario.getIdRol() == UsuarioDAO.ROL_ADMIN) {
            destino = "/WEB-INF/admin/perfil.jsp";
        } else if (sesionUsuario.getIdRol() == UsuarioDAO.ROL_COMPRADOR) {
            destino = "/comprador/perfil.jsp";
        } else {
            destino = "/WEB-INF/usuario/perfil.jsp";
        }
        req.getRequestDispatcher(destino).forward(req, resp);
    }

    // -------------------------------------------------------------------------
    // POST — despachar por accion
    // -------------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Usuario sesionUsuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (sesionUsuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Si es multipart (subida de foto) lo manejamos aparte
        if (ServletFileUpload.isMultipartContent(req)) {
            subirFoto(req, resp, sesionUsuario);
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        if (accion == null) {
            accion = "";
        }

        switch (accion) {
            case "actualizarInfo" ->
                actualizarInfo(req, resp, sesionUsuario);
            case "cambiarPassword" ->
                cambiarPassword(req, resp, sesionUsuario);
            case "cambiarRol" ->
                cambiarRol(req, resp, sesionUsuario);
            default ->
                resp.sendRedirect(req.getContextPath() + "/perfil");
        }
    }

    // -------------------------------------------------------------------------
    // ACCION: actualizar datos personales
    // -------------------------------------------------------------------------
    private void actualizarInfo(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        Usuario u = usuarioDAO.obtenerPorId(sesion.getId());
        if (u == null) {
            req.getSession().setAttribute("mensajeError", "Usuario no encontrado.");
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        u.setNombre(req.getParameter("nombre"));
        u.setApellido(req.getParameter("apellido"));
        u.setEmail(req.getParameter("email"));

        if (sesion.getIdRol() == UsuarioDAO.ROL_ADMIN) {
            u.setDocumento(req.getParameter("documento"));
        }

        u.setUserName(req.getParameter("userName"));

        // Cambio de rol: solo permitido entre Usuario(3) y Comprador(2), nunca a
        // Admin(1)
        String idRolParam = req.getParameter("idRol");
        if (idRolParam != null && sesion.getIdRol() != UsuarioDAO.ROL_ADMIN) {
            int nuevoRol = "2".equals(idRolParam) ? UsuarioDAO.ROL_COMPRADOR : UsuarioDAO.ROL_USUARIO;
            u.setIdRol(nuevoRol);
        }

        boolean ok = usuarioDAO.actualizar(u);
        if (ok) {
            req.getSession().setAttribute("usuario", u);
            req.getSession().setAttribute("mensajeExito", "Datos actualizados correctamente.");
        } else {
            req.getSession().setAttribute("mensajeError", "No se pudo actualizar. Intentalo de nuevo.");
        }
        resp.sendRedirect(req.getContextPath() + "/perfil");
    }

    // -------------------------------------------------------------------------
    // ACCION: cambiar contrasena
    // -------------------------------------------------------------------------
    private void cambiarPassword(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException, ServletException {

        String actual = req.getParameter("passwordActual");
        String nueva = req.getParameter("passwordNueva");
        String confirmar = req.getParameter("passwordConfirmar");

        // Verificar contrasena actual
        Usuario verificado = usuarioDAO.login(sesion.getEmail(), actual);
        if (verificado == null) {
            req.getSession().setAttribute("mensajeError", "La contrasena actual es incorrecta.");
            req.getSession().setAttribute("tabActiva", "seguridad");
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        if (!nueva.equals(confirmar)) {
            req.getSession().setAttribute("mensajeError", "Las contrasenas nuevas no coinciden.");
            req.getSession().setAttribute("tabActiva", "seguridad");
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        if (nueva.length() < 8) {
            req.getSession().setAttribute("mensajeError", "La contrasena debe tener al menos 8 caracteres.");
            req.getSession().setAttribute("tabActiva", "seguridad");
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        boolean ok = usuarioDAO.cambiarContrasena(sesion.getId(), nueva);
        if (ok) {
            req.getSession().setAttribute("mensajeExito", "Contrasena actualizada correctamente.");
        } else {
            req.getSession().setAttribute("mensajeError", "No se pudo cambiar la contrasena.");
        }
        req.getSession().setAttribute("tabActiva", "seguridad");
        resp.sendRedirect(req.getContextPath() + "/perfil");
    }

    // -------------------------------------------------------------------------
    // ACCION: subir foto de perfil (multipart)
    // -------------------------------------------------------------------------
    private void subirFoto(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        String uploadDir = getUploadDir();
        File dirFile = new File(uploadDir);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 1024); // 1 MB en memoria
            factory.setRepository(File.createTempFile("tmp", null).getParentFile());

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(5 * 1024 * 1024L); // 5 MB max por archivo
            upload.setSizeMax(6 * 1024 * 1024L); // 6 MB total

            List<FileItem> items = upload.parseRequest(req);
            Map<String, String> campos = new HashMap<>();
            FileItem fotoItem = null;

            for (FileItem item : items) {
                if (item.isFormField()) {
                    campos.put(item.getFieldName(), item.getString("UTF-8"));
                } else if ("foto".equals(item.getFieldName()) && item.getSize() > 0) {
                    fotoItem = item;
                }
            }

            if (fotoItem == null) {
                req.getSession().setAttribute("mensajeError", "No se selecciono ninguna imagen.");
                resp.sendRedirect(req.getContextPath() + "/perfil");
                return;
            }

            // Validar tipo de archivo
            String contentType = fotoItem.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                req.getSession().setAttribute("mensajeError", "El archivo debe ser una imagen (JPG, PNG, etc.).");
                resp.sendRedirect(req.getContextPath() + "/perfil");
                return;
            }

            // Generar nombre unico
            String originalName = fotoItem.getName();
            String extension = "";
            int dotIdx = originalName.lastIndexOf('.');
            if (dotIdx >= 0) {
                extension = originalName.substring(dotIdx).toLowerCase();
            }
            String nombreArchivo = "perfil_" + sesion.getId() + "_" + UUID.randomUUID().toString().substring(0, 8)
                    + extension;

            // Borrar foto anterior si existe
            Usuario usuarioActual = usuarioDAO.obtenerPorId(sesion.getId());
            if (usuarioActual != null && usuarioActual.getFotoPerfil() != null
                    && !usuarioActual.getFotoPerfil().isBlank()) {
                File fotoAnterior = new File(uploadDir, usuarioActual.getFotoPerfil());
                if (fotoAnterior.exists()) {
                    fotoAnterior.delete();
                }
            }

            // Guardar nuevo archivo
            File destino = new File(uploadDir, nombreArchivo);
            fotoItem.write(destino);

            // Actualizar BD con el nombre del archivo (solo nombre, sin ruta)
            boolean ok = usuarioDAO.actualizarFoto(sesion.getId(), nombreArchivo);
            if (ok) {
                sesion.setFotoPerfil(nombreArchivo);
                req.getSession().setAttribute("usuario", sesion);
                req.getSession().setAttribute("mensajeExito", "Foto de perfil actualizada.");
            } else {
                req.getSession().setAttribute("mensajeError", "No se pudo guardar la foto en la base de datos.");
            }

        } catch (Exception e) {
            System.err.println("[PerfilServlet] Error al subir foto: " + e.getMessage());
            req.getSession().setAttribute("mensajeError", "Error al procesar la imagen: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/perfil");
    }

    private void cambiarRol(HttpServletRequest req, HttpServletResponse resp, Usuario sesion)
            throws IOException {

        if (sesion.getIdRol() == UsuarioDAO.ROL_ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }

        String nuevoRolParam = req.getParameter("nuevoRol");
        int nuevoRol = "3".equals(nuevoRolParam) ? UsuarioDAO.ROL_USUARIO : UsuarioDAO.ROL_COMPRADOR;

        boolean ok = usuarioDAO.cambiarRol(sesion.getId(), nuevoRol);
        if (ok) {
            Usuario u = usuarioDAO.obtenerPorId(sesion.getId());
            req.getSession().setAttribute("usuario", u);
            req.getSession().setAttribute("mensajeExito",
                    nuevoRol == UsuarioDAO.ROL_USUARIO
                            ? "Ahora eres Usuario. Ya no tienes acceso al carrito."
                            : "Ahora eres Comprador. Ya puedes agregar al carrito.");
        } else {
            req.getSession().setAttribute("mensajeError", "No se pudo cambiar el rol.");
        }
        resp.sendRedirect(req.getContextPath() + "/perfil");
    }
}