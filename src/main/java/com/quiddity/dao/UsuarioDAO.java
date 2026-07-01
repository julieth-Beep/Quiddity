package com.quiddity.dao;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.quiddity.model.Usuario;
import com.quiddity.util.ConexionDB;

public class UsuarioDAO {

    public static final int ROL_ADMIN = 1;
    public static final int ROL_USUARIO = 3;
    public static final int ROL_COMPRADOR = 2;

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNombre(rs.getString("nombre"));
        u.setApellido(rs.getString("apellido"));
        u.setEmail(rs.getString("email"));
        u.setContrasena(rs.getString("contrasena"));
        u.setDocumento(rs.getString("documento"));
        u.setUserName(rs.getString("username"));
        u.setFotoPerfil(rs.getString("fotoperfil"));
        u.setIdRol(rs.getInt("idrol"));
        return u;
    }

    // CREATE
    public boolean crear(Usuario usuario) {
        String sql = "INSERT INTO usuario (nombre, apellido, email, contrasena, documento, username, fotoperfil, idrol) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getContrasena());
            ps.setString(5, usuario.getDocumento());
            ps.setString(6, usuario.getUserName());
            ps.setString(7, usuario.getFotoPerfil());
            ps.setInt(8, usuario.getIdRol());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al crear usuario: " + e.getMessage());
            return false;
        }
    }

    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuario WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al obtener por ID: " + e.getMessage());
        }
        return null;
    }

    // READ — por email (para login)
    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT * FROM usuario WHERE email = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al obtener por email: " + e.getMessage());
        }
        return null;
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al listar usuarios: " + e.getMessage());
        }
        return lista;
    }

    // READ — listar por rol
    public List<Usuario> listarPorRol(int idRol) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario WHERE idrol = ? ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idRol);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al listar por rol: " + e.getMessage());
        }
        return lista;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // NUEVO: Búsqueda por nombre, apellido, username, email o documento
    // ═════════════════════════════════════════════════════════════════════════
    public List<Usuario> buscarPorNombreUserEmailDoc(String termino) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario WHERE "
                + "LOWER(nombre) LIKE ? OR "
                + "LOWER(apellido) LIKE ? OR "
                + "LOWER(username) LIKE ? OR "
                + "LOWER(email) LIKE ? OR "
                + "LOWER(documento) LIKE ? "
                + "ORDER BY nombre";

        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            String like = "%" + termino.toLowerCase() + "%";
            for (int i = 1; i <= 5; i++) {
                ps.setString(i, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al buscar usuarios: " + e.getMessage());
        }
        return lista;
    }

    // UPDATE — datos generales
    public boolean actualizar(Usuario usuario) {
        String sql = "UPDATE usuario SET nombre = ?, apellido = ?, email = ?, documento = ?, "
                + "username = ?, fotoperfil = ?, idrol = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getDocumento());
            ps.setString(5, usuario.getUserName());
            ps.setString(6, usuario.getFotoPerfil());
            ps.setInt(7, usuario.getIdRol());
            ps.setInt(8, usuario.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    // UPDATE — cambiar contraseña
    public boolean cambiarContrasena(int id, String nuevaContrasena) {
        String hashed = BCrypt.hashpw(nuevaContrasena, BCrypt.gensalt());

        String sql = "UPDATE usuario SET contrasena = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashed);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al cambiar contraseña: " + e.getMessage());
            return false;
        }
    }

    public boolean cambiarRol(int id, int nuevoRol) {
        String sql = "UPDATE usuario SET idrol = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoRol);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al cambiar rol: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sqlVerificarPedidos = "SELECT COUNT(*) FROM pedido WHERE usuarioid = ? AND estado <> ?";

        // Nivel más profundo (dependen de outfit/prenda/look_generado/viaje/pedido)
        String sqlViajeOutfit = "DELETE FROM viaje_outfit WHERE idviaje IN (SELECT id FROM viaje WHERE idusuario = ?)";
        String sqlCalendarioOutfit = "DELETE FROM calendario_outfit WHERE idusuario = ?";
        String sqlPrettify = "DELETE FROM prenda_prettify WHERE idprenda IN (SELECT id FROM prenda WHERE idusuario = ?)";
        String sqlOutfitPrenda = "DELETE FROM outfitprenda WHERE idoutfit IN (SELECT id FROM outfit WHERE idusuario = ?) OR idprenda IN (SELECT id FROM prenda WHERE idusuario = ?)";
        String sqlPedidoItems = "DELETE FROM pedido_item WHERE pedido_id IN (SELECT id FROM pedido WHERE usuarioid = ?)";

        // Nivel medio (dependen de usuario + referencian outfit)
        String sqlLookGenerado = "DELETE FROM look_generado WHERE idusuario = ?";
        String sqlGusto = "DELETE FROM gusto WHERE idusuario = ?";

        // Dependencias directas de usuario
        String sqlNotificaciones = "DELETE FROM notificaciones WHERE idusuario = ?";
        String sqlRutina = "DELETE FROM rutina WHERE idusuario = ?";
        String sqlOutfit = "DELETE FROM outfit WHERE idusuario = ?";
        String sqlPrenda = "DELETE FROM prenda WHERE idusuario = ?";
        String sqlAvatar = "DELETE FROM avatar WHERE idusuario = ?";
        String sqlViaje = "DELETE FROM viaje WHERE idusuario = ?";
        String sqlPedido = "DELETE FROM pedido WHERE usuarioid = ?";
        String sqlCarrito = "DELETE FROM carrito WHERE usuarioid = ?";
        String sqlDireccion = "DELETE FROM direccion WHERE usuarioid = ?";

        String sqlUsuario = "DELETE FROM usuario WHERE id = ?";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // 1. Bloquear si tiene pedidos que NO estén entregados
            try (PreparedStatement ps = con.prepareStatement(sqlVerificarPedidos)) {
                ps.setInt(1, id);
                ps.setString(2, com.quiddity.model.Pedido.Estado.ENTREGADO.name());
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    con.rollback();
                    System.err.println("[UsuarioDAO] No se puede eliminar: tiene pedidos sin entregar.");
                    return false;
                }
            }

            // 2. Eliminar en orden: lo más profundo primero
            ejecutarDelete(con, sqlViajeOutfit, id);
            ejecutarDelete(con, sqlCalendarioOutfit, id);
            ejecutarDelete(con, sqlPrettify, id);
            ejecutarDeleteDosParams(con, sqlOutfitPrenda, id, id);
            ejecutarDelete(con, sqlPedidoItems, id);

            ejecutarDelete(con, sqlLookGenerado, id);
            ejecutarDelete(con, sqlGusto, id);

            ejecutarDelete(con, sqlNotificaciones, id);
            ejecutarDelete(con, sqlRutina, id);
            ejecutarDelete(con, sqlOutfit, id);
            ejecutarDelete(con, sqlPrenda, id);
            ejecutarDelete(con, sqlAvatar, id);
            ejecutarDelete(con, sqlViaje, id);
            ejecutarDelete(con, sqlPedido, id);
            ejecutarDelete(con, sqlCarrito, id);
            ejecutarDelete(con, sqlDireccion, id);

            // 3. Eliminar usuario
            int filas;
            try (PreparedStatement ps = con.prepareStatement(sqlUsuario)) {
                ps.setInt(1, id);
                filas = ps.executeUpdate();
            }

            con.commit();
            return filas > 0;

        } catch (Exception e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                /* ignorar */ }
            System.err.println("[UsuarioDAO] Error al eliminar usuario: " + e.getMessage());
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException ex) {
                /* ignorar */ }
        }
    }

    private void ejecutarDelete(Connection con, String sql, int id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private void ejecutarDeleteDosParams(Connection con, String sql, int id1, int id2) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id1);
            ps.setInt(2, id2);
            ps.executeUpdate();
        }
    }

    private String hashSHA256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(texto.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return texto;
        }
    }

    public Usuario login(String identificador, String contrasena) {
        String sql = "SELECT * FROM usuario WHERE (email = ? OR username = ?) LIMIT 1";

        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, identificador);
            ps.setString(2, identificador);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = mapear(rs);
                String stored = u.getContrasena();

                boolean match;
                if (stored.startsWith("$2a$") || stored.startsWith("$2b$")) {
                    match = BCrypt.checkpw(contrasena, stored);
                } else {
                    match = stored.equals(contrasena);
                }

                if (match) {
                    return u;
                }
            }

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error en login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean actualizarFoto(int id, String nombreArchivo) {
        String sql = "UPDATE usuario SET fotoperfil = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreArchivo);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al actualizar foto: " + e.getMessage());
            return false;
        }
    }

    public boolean esAdmin(int id) {
        Usuario u = obtenerPorId(id);
        return u != null && u.getIdRol() == ROL_ADMIN;
    }

    public boolean emailExiste(String email) {
        String sql = "SELECT 1 FROM usuario WHERE email = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al verificar email: " + e.getMessage());
            return false;
        }
    }

    public boolean documentoExiste(String documento) {
        String sql = "SELECT 1 FROM usuario WHERE documento = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al verificar documento: " + e.getMessage());
            return false;
        }
    }
}
