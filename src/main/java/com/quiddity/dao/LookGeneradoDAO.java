package com.quiddity.dao;

import com.quiddity.model.LookGenerado;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LookGeneradoDAO {

    /** Guardar look recién generado */
    public boolean crear(LookGenerado lg) throws SQLException {
        String sql = "INSERT INTO look_generado (idusuario, idoutfit, imagen_generada, prompt_ia, es_manual, favorito) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, lg.getIdUsuario());
            if (lg.getIdOutfit() != null)
                ps.setInt(2, lg.getIdOutfit());
            else
                ps.setNull(2, Types.INTEGER);
            ps.setString(3, lg.getImagenGenerada());
            ps.setString(4, lg.getPromptIA());
            ps.setBoolean(5, lg.isEsManual());
            ps.setBoolean(6, lg.isFavorito());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    lg.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Historial completo del usuario — para la pantalla de grid (Imagen 7) */
    public List<LookGenerado> listarPorUsuario(int idUsuario) throws SQLException {
        List<LookGenerado> lista = new ArrayList<>();
        String sql = "SELECT * FROM look_generado WHERE idusuario = ? ORDER BY creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Solo favoritos */
    public List<LookGenerado> listarFavoritos(int idUsuario) throws SQLException {
        List<LookGenerado> lista = new ArrayList<>();
        String sql = "SELECT * FROM look_generado WHERE idusuario = ? AND favorito = true ORDER BY creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Obtener look validando propietario */
    public LookGenerado obtenerPorIdYUsuario(int id, int idUsuario) throws SQLException {
        String sql = "SELECT * FROM look_generado WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        }
        return null;
    }

    /** Toggle favorito — devuelve el nuevo estado */
    public boolean toggleFavorito(int id, int idUsuario) throws SQLException {
        String sql = "UPDATE look_generado SET favorito = NOT favorito WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    /** Eliminar look */
    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = "DELETE FROM look_generado WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Verificar si un look puede asignarse al calendario.
     * Solo verifica que existe y pertenece al usuario.
     */
    public boolean existeYPertenece(int idLook, int idUsuario) throws SQLException {
        String sql = "SELECT 1 FROM look_generado WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idLook);
            ps.setInt(2, idUsuario);
            return ps.executeQuery().next();
        }
    }

    private LookGenerado mapear(ResultSet rs) throws SQLException {
        return new LookGenerado(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getObject("idoutfit") != null ? rs.getInt("idoutfit") : null,
                rs.getString("imagen_generada"),
                rs.getString("prompt_ia"),
                rs.getBoolean("es_manual"),
                rs.getBoolean("favorito"),
                rs.getTimestamp("creado_en"));
    }
}