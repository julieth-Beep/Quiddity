package com.quiddity.dao;

import com.quiddity.model.Avatar;
import com.quiddity.model.Caracteristicas;
import com.quiddity.util.ConexionDB;

import java.sql.*;

/**
 * Maneja tanto la tabla caracteristicas como avatar juntas,
 * ya que siempre se usan juntas (crear avatar = crear caracteristicas +
 * avatar).
 */
public class AvatarDAO {

    /**
     * Crear características y avatar del usuario en una sola operación.
     * Si el usuario ya tiene avatar, lo actualiza.
     */
    public boolean crearOActualizar(int idUsuario, Caracteristicas caract) throws SQLException {
        // ¿Ya tiene avatar?
        Avatar existente = obtenerPorUsuario(idUsuario);
        if (existente != null) {
            return actualizarCaracteristicas(existente.getIdCaracteristicas(), caract);
        }
        // Crear nuevo
        return crear(idUsuario, caract);
    }

    /** Crear características nuevas y vincularlas al usuario */
    private boolean crear(int idUsuario, Caracteristicas caract) throws SQLException {
        String sqlCaract = "INSERT INTO caracteristicas (tonopiel, formacara, tipocuerpo, tipocabello, tipopiel) "
                + "VALUES (?, ?, ?, ?, ?)";
        String sqlAvatar = "INSERT INTO avatar (idusuario, idcaracteristicas) VALUES (?, ?)";

        try (Connection con = ConexionDB.getConnection()) {
            con.setAutoCommit(false);
            try {
                int idCaract;
                // 1. Insertar características
                try (PreparedStatement ps = con.prepareStatement(sqlCaract, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, caract.getTonoPiel());
                    ps.setString(2, caract.getFormaCara());
                    ps.setString(3, caract.getTipoCuerpo());
                    ps.setString(4, caract.getTipoCabello());
                    ps.setString(5, caract.getTipoPiel());
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    if (!rs.next())
                        throw new SQLException("No se generó ID de características");
                    idCaract = rs.getInt(1);
                    caract.setId(idCaract);
                }
                // 2. Insertar avatar
                try (PreparedStatement ps = con.prepareStatement(sqlAvatar)) {
                    ps.setInt(1, idUsuario);
                    ps.setInt(2, idCaract);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    /** Actualizar características existentes */
    private boolean actualizarCaracteristicas(int idCaract, Caracteristicas caract) throws SQLException {
        String sql = "UPDATE caracteristicas SET tonopiel=?, formacara=?, tipocuerpo=?, tipocabello=?, tipopiel=? "
                + "WHERE id=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, caract.getTonoPiel());
            ps.setString(2, caract.getFormaCara());
            ps.setString(3, caract.getTipoCuerpo());
            ps.setString(4, caract.getTipoCabello());
            ps.setString(5, caract.getTipoPiel());
            ps.setInt(6, idCaract);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Obtener avatar con sus características por usuario.
     * Devuelve null si el usuario aún no configuró su avatar.
     */
    public Avatar obtenerPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT a.*, c.tonopiel, c.formacara, c.tipocuerpo, c.tipocabello, c.tipopiel "
                + "FROM avatar a "
                + "JOIN caracteristicas c ON a.idcaracteristicas = c.id "
                + "WHERE a.idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Caracteristicas c = new Caracteristicas(
                        rs.getInt("idcaracteristicas"),
                        rs.getString("tonopiel"),
                        rs.getString("formacara"),
                        rs.getString("tipocuerpo"),
                        rs.getString("tipocabello"),
                        rs.getString("tipopiel"));
                Avatar a = new Avatar(rs.getInt("idavatar"), idUsuario, c.getId());
                a.setCaracteristicas(c);
                return a;
            }
        }
        return null;
    }

    /** Solo las características, sin el objeto avatar */
    public Caracteristicas obtenerCaracteristicas(int idUsuario) throws SQLException {
        Avatar av = obtenerPorUsuario(idUsuario);
        return av != null ? av.getCaracteristicas() : null;
    }
}