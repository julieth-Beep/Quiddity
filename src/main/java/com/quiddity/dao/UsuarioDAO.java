package com.quiddity.dao;

import com.quiddity.model.Usuario;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class UsuarioDAO {

    public static final int ROL_ADMIN = 1;
    public static final int ROL_USUARIO = 2;
    public static final int ROL_COMPRADOR = 3;

    // ─────────────────────────────────────────────
    // CONEXIÓN
    // ─────────────────────────────────────────────
    private Connection getConnection() throws Exception {
        Properties props = new Properties();
        InputStream is = getClass().getClassLoader().getResourceAsStream("db.properties");
        if (is == null)
            throw new Exception("No se encontró db.properties en resources");
        props.load(is);

        Class.forName(props.getProperty("db.driver"));
        return DriverManager.getConnection(
                props.getProperty("db.url"),
                props.getProperty("db.username"),
                props.getProperty("db.password"));
    }

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
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

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
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al obtener por ID: " + e.getMessage());
        }
        return null;
    }

    // READ — por email (para login)
    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT * FROM usuario WHERE email = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al obtener por email: " + e.getMessage());
        }
        return null;
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nombre";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al listar usuarios: " + e.getMessage());
        }
        return lista;
    }

    // READ — listar por rol

    public List<Usuario> listarPorRol(int idRol) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario WHERE idrol = ? ORDER BY nombre";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idRol);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al listar por rol: " + e.getMessage());
        }
        return lista;
    }

    // UPDATE — datos generales
    public boolean actualizar(Usuario usuario) {
        String sql = "UPDATE usuario SET nombre = ?, apellido = ?, email = ?, documento = ?, "
                + "username = ?, fotoperfil = ?, idrol = ? WHERE id = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

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
        String sql = "UPDATE usuario SET contrasena = ? WHERE id = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevaContrasena);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al cambiar contraseña: " + e.getMessage());
            return false;
        }
    }

    public boolean cambiarRol(int id, int nuevoRol) {
        String sql = "UPDATE usuario SET idrol = ? WHERE id = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoRol);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al cambiar rol: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuario WHERE id = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }

    public Usuario login(String identificador, String contrasena) {
        // Busca por email O username, y compara contraseña en texto plano
        String sql = "SELECT * FROM usuario WHERE (email = ? OR username = ?) AND contrasena = ? LIMIT 1";

        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            // Pasamos el identificador DOS veces: una para email y otra para username
            ps.setString(1, identificador);
            ps.setString(2, identificador);
            ps.setString(3, contrasena);

            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error en login: " + e.getMessage());
            e.printStackTrace(); // Para ver el error completo en consola
        }
        return null;
    }

    public boolean esAdmin(int id) {
        Usuario u = obtenerPorId(id);
        return u != null && u.getIdRol() == ROL_ADMIN;
    }

    public boolean emailExiste(String email) {
        String sql = "SELECT 1 FROM usuario WHERE email = ?";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

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
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            System.err.println("[UsuarioDAO] Error al verificar documento: " + e.getMessage());
            return false;
        }
    }
}