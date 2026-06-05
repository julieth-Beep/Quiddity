package com.quiddity.dao;

import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Rutina;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RutinaDAO {

    // Todas las rutinas (admin / sin filtro)
    public List<Rutina> listarTodas() throws SQLException {
        List<Rutina> lista = new ArrayList<>();
        String sql = "SELECT * FROM rutina ORDER BY categoria, subcategoria";

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    // Rutinas filtradas por las características del usuario
    // Las columnas de características en rutina son nullable:
    // NULL significa "aplica para cualquier valor de esa característica"
    public List<Rutina> listarPorCaracteristicas(Caracteristicas c) throws SQLException {
        List<Rutina> lista = new ArrayList<>();
        String sql = """
                SELECT * FROM rutina
                WHERE (tipo_piel    IS NULL OR tipo_piel    = ?)
                  AND (tipo_cabello IS NULL OR tipo_cabello = ?)
                  AND (tono_piel    IS NULL OR tono_piel    = ?)
                  AND (forma_cara   IS NULL OR forma_cara   = ?)
                  AND (tipo_cuerpo  IS NULL OR tipo_cuerpo  = ?)
                ORDER BY categoria, subcategoria
                """;

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getTipoPiel());
            ps.setString(2, c.getTipoCabello());
            ps.setString(3, c.getTonoPiel());
            ps.setString(4, c.getFormaCara());
            ps.setString(5, c.getTipoCuerpo());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    // Rutinas de una categoría específica, filtradas por características
    public List<Rutina> listarPorCategoriaYCaracteristicas(String categoria, Caracteristicas c) throws SQLException {
        List<Rutina> lista = new ArrayList<>();
        String sql = """
                SELECT * FROM rutina
                WHERE categoria = ?
                  AND (tipo_piel    IS NULL OR tipo_piel    = ?)
                  AND (tipo_cabello IS NULL OR tipo_cabello = ?)
                  AND (tono_piel    IS NULL OR tono_piel    = ?)
                  AND (forma_cara   IS NULL OR forma_cara   = ?)
                  AND (tipo_cuerpo  IS NULL OR tipo_cuerpo  = ?)
                ORDER BY subcategoria
                """;

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);
            ps.setString(2, c.getTipoPiel());
            ps.setString(3, c.getTipoCabello());
            ps.setString(4, c.getTonoPiel());
            ps.setString(5, c.getFormaCara());
            ps.setString(6, c.getTipoCuerpo());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    // Guardar rutina favorita de un usuario (idUsuario en la fila)
    public void guardar(Rutina r) throws SQLException {
        String sql = """
                INSERT INTO rutina (idusuario, nombre, objetivo, url, favoritos,
                                    categoria, subcategoria, tipo_piel, tipo_cabello,
                                    tono_piel, forma_cara, tipo_cuerpo)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getIdUsuario());
            ps.setString(2, r.getNombre());
            ps.setString(3, r.getObjetivo());
            ps.setString(4, r.getUrl());
            ps.setString(5, r.getFavoritos());
            ps.setString(6, r.getCategoria());
            ps.setString(7, r.getSubcategoria());
            ps.setString(8, r.getTipoPiel());
            ps.setString(9, r.getTipoCabello());
            ps.setString(10, r.getTonoPiel());
            ps.setString(11, r.getFormaCara());
            ps.setString(12, r.getTipoCuerpo());

            ps.executeUpdate();
        }
    }

    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM rutina WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Rutina obtenerPorId(int id) throws SQLException {
        String sql = "SELECT * FROM rutina WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    private Rutina mapear(ResultSet rs) throws SQLException {
        return new Rutina(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getString("nombre"),
                rs.getString("objetivo"),
                rs.getString("url"),
                rs.getString("favoritos"),
                rs.getString("categoria"),
                rs.getString("subcategoria"),
                rs.getString("tipo_piel"),
                rs.getString("tipo_cabello"),
                rs.getString("tono_piel"),
                rs.getString("forma_cara"),
                rs.getString("tipo_cuerpo"));
    }
}