package com.quiddity.dao;

import com.quiddity.model.PrendaPrettify;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrendaPrettifyDAO {

    /** Guardar registro de una corrección Prettify */
    public boolean crear(PrendaPrettify pp) throws SQLException {
        String sql = "INSERT INTO prenda_prettify (idprenda, imagen_original, imagen_corregida, parametros) "
                + "VALUES (?, ?, ?, ?::jsonb)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pp.getIdPrenda());
            ps.setString(2, pp.getImagenOriginal());
            ps.setString(3, pp.getImagenCorregida());
            ps.setString(4, pp.getParametros());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    pp.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Historial de correcciones de una prenda */
    public List<PrendaPrettify> listarPorPrenda(int idPrenda) throws SQLException {
        List<PrendaPrettify> lista = new ArrayList<>();
        String sql = "SELECT * FROM prenda_prettify WHERE idprenda = ? ORDER BY creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPrenda);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Última corrección de una prenda */
    public PrendaPrettify obtenerUltima(int idPrenda) throws SQLException {
        String sql = "SELECT * FROM prenda_prettify WHERE idprenda = ? ORDER BY creado_en DESC LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPrenda);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        }
        return null;
    }

    private PrendaPrettify mapear(ResultSet rs) throws SQLException {
        return new PrendaPrettify(
                rs.getInt("id"),
                rs.getInt("idprenda"),
                rs.getString("imagen_original"),
                rs.getString("imagen_corregida"),
                rs.getString("parametros"),
                rs.getTimestamp("creado_en"));
    }
}