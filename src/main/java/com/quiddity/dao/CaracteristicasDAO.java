package com.quiddity.dao;

import com.quiddity.model.Caracteristicas;
import com.quiddity.util.ConexionDB;

import java.sql.*;

public class CaracteristicasDAO {

    // ─────────────────────────────────────────────
    // Obtener caracteristicas por usuario (via avatar)
    // ─────────────────────────────────────────────
    public Caracteristicas obtenerPorUsuario(int idUsuario) {
        String sql = "SELECT c.* FROM caracteristicas c " +
                     "INNER JOIN avatar a ON a.idcaracteristicas = c.id " +
                     "WHERE a.idusuario = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error obtenerPorUsuario: " + e.getMessage());
        }
        return null;
    }

    // ─────────────────────────────────────────────
    // Crear caracteristicas + vincular en avatar
    // ─────────────────────────────────────────────
    public boolean crearParaUsuario(int idUsuario, Caracteristicas c) {
        String sqlCaract = "INSERT INTO caracteristicas (tonopiel, formacara, tipocuerpo, tipocabello, tipopiel) " +
                           "VALUES (?, ?, ?, ?, ?)";
        String sqlAvatar = "INSERT INTO avatar (idusuario, idcaracteristicas) VALUES (?, ?)";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            int idCaract;
            try (PreparedStatement ps = con.prepareStatement(sqlCaract, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, c.getTonoPiel());
                ps.setString(2, c.getFormaCara());
                ps.setString(3, c.getTipoCuerpo());
                ps.setString(4, c.getTipoCabello());
                ps.setString(5, c.getTipoPiel());
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) { con.rollback(); return false; }
                idCaract = keys.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement(sqlAvatar)) {
                ps.setInt(1, idUsuario);
                ps.setInt(2, idCaract);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error crearParaUsuario: " + e.getMessage());
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            ConexionDB.close(con);
        }
    }

    // ─────────────────────────────────────────────
    // Actualizar solo formacara (usado por el escaneo facial)
    // ─────────────────────────────────────────────
    public boolean actualizarFormaCara(int idUsuario, String formaCara) {
        Caracteristicas existente = obtenerPorUsuario(idUsuario);

        if (existente != null) {
            String sql = "UPDATE caracteristicas SET formacara = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, formaCara);
                ps.setInt(2, existente.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                System.err.println("[CaracteristicasDAO] Error actualizarFormaCara: " + e.getMessage());
                return false;
            }
        } else {
            Caracteristicas nueva = new Caracteristicas();
            nueva.setFormaCara(formaCara);
            return crearParaUsuario(idUsuario, nueva);
        }
    }

    // ─────────────────────────────────────────────
    // Actualizar todas las características
    // ─────────────────────────────────────────────
    public boolean actualizar(Caracteristicas c) {
        String sql = "UPDATE caracteristicas SET tonopiel = ?, formacara = ?, tipocuerpo = ?, " +
                     "tipocabello = ?, tipopiel = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getTonoPiel());
            ps.setString(2, c.getFormaCara());
            ps.setString(3, c.getTipoCuerpo());
            ps.setString(4, c.getTipoCabello());
            ps.setString(5, c.getTipoPiel());
            ps.setInt(6, c.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error actualizar: " + e.getMessage());
            return false;
        }
    }

    // ─────────────────────────────────────────────
    // MAPPER
    // ─────────────────────────────────────────────
    private Caracteristicas mapear(ResultSet rs) throws SQLException {
        Caracteristicas c = new Caracteristicas();
        c.setId(rs.getInt("id"));
        c.setTonoPiel(rs.getString("tonopiel"));
        c.setFormaCara(rs.getString("formacara"));
        c.setTipoCuerpo(rs.getString("tipocuerpo"));
        c.setTipoCabello(rs.getString("tipocabello"));
        c.setTipoPiel(rs.getString("tipopiel"));
        return c;
    }

    public void actualizarTonoPiel(int id, String tonoPiel) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'actualizarTonoPiel'");
    }
}