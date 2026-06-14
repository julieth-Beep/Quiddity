package com.quiddity.dao;

import com.quiddity.model.Prenda;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrendaDAO {

    /** Crear prenda nueva en el closet */
    public boolean crear(Prenda p) throws SQLException {
        String sql = "INSERT INTO prenda (idusuario, tipo, color, estilo, imagen, temporada,subcategoria) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getIdUsuario());
            ps.setString(2, p.getTipo());
            ps.setString(3, p.getColor());
            ps.setString(4, p.getEstilo());
            ps.setString(5, p.getImagen());
            ps.setString(6, p.getTemporada());
            ps.setString(7, p.getSubcategoria());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    p.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Todas las prendas del closet del usuario */
    public List<Prenda> listarPorUsuario(int idUsuario) throws SQLException {
        List<Prenda> lista = new ArrayList<>();
        String sql = "SELECT * FROM prenda WHERE idusuario = ? ORDER BY id DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Prendas filtradas por tipo (para los tabs: tops, bottoms, etc.) */
    public List<Prenda> listarPorTipo(int idUsuario, String tipo) throws SQLException {
        List<Prenda> lista = new ArrayList<>();
        String sql = "SELECT * FROM prenda WHERE idusuario = ? AND tipo = ? ORDER BY id DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, tipo);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Prendas filtradas por temporada — útil para recomendaciones de viaje */
    public List<Prenda> listarPorTemporada(int idUsuario, String temporada) throws SQLException {
        List<Prenda> lista = new ArrayList<>();
        String sql = "SELECT * FROM prenda WHERE idusuario = ? AND (temporada = ? OR temporada = 'todas') ORDER BY id DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, temporada);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Obtener una prenda validando que pertenece al usuario */
    public Prenda obtenerPorIdYUsuario(int id, int idUsuario) throws SQLException {
        String sql = "SELECT * FROM prenda WHERE id = ? AND idusuario = ?";
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

    /** Actualizar datos de la prenda */
    public boolean actualizar(Prenda p) throws SQLException {
        String sql = "UPDATE prenda SET tipo=?, color=?, estilo=?, imagen=?, temporada=?, subcategoria=? "
                + "WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getTipo());
            ps.setString(2, p.getColor());
            ps.setString(3, p.getEstilo());
            ps.setString(4, p.getImagen());
            ps.setString(5, p.getTemporada());
            ps.setString(6, p.getSubcategoria());
            ps.setInt(7, p.getId());
            ps.setInt(8, p.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Guardar la imagen prettificada en la prenda.
     * Se llama después de que RemoveBg procese la imagen.
     */
    public boolean guardarImagenPrettify(int idPrenda, int idUsuario, String rutaPrettify) throws SQLException {
        // La tabla prenda no tiene columna imagen_prettify directamente,
        // guardamos la ruta corregida sobreescribiendo la imagen principal
        // (la original queda en prenda_prettify como respaldo)
        String sql = "UPDATE prenda SET imagen = ? WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rutaPrettify);
            ps.setInt(2, idPrenda);
            ps.setInt(3, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    /** Eliminar prenda */
    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = "DELETE FROM prenda WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    /** Contar prendas del closet */
    public int contarPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT COUNT(*) FROM prenda WHERE idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    private Prenda mapear(ResultSet rs) throws SQLException {
        Prenda p = new Prenda(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getString("tipo"),
                rs.getString("color"),
                rs.getString("estilo"),
                rs.getString("imagen"),
                rs.getString("temporada"));
        p.setSubcategoria(rs.getString("subcategoria"));
        return p;
    }
}