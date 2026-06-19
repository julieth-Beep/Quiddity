package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiddity.model.Direccion;
import com.quiddity.util.ConexionDB;

public class DireccionDAO {

    // ─── MAPPER ────────────────────────────────────────────────────────────────

    private Direccion mapear(ResultSet rs) throws SQLException {
        Direccion d = new Direccion();
        d.setId(rs.getInt("id"));
        d.setUsuarioId(rs.getInt("usuarioid"));
        d.setDepartamento(rs.getString("departamento"));
        d.setCiudad(rs.getString("ciudad"));
        d.setBarrio(rs.getString("barrio"));
        d.setDireccion(rs.getString("direccion"));
        d.setEsRural(rs.getBoolean("es_rural"));
        d.setDescripcionRural(rs.getString("descripcion_rural"));
        d.setPredeterminada(rs.getBoolean("predeterminada"));
        return d;
    }

    // ─── INSERT ────────────────────────────────────────────────────────────────

    public boolean crear(Direccion direccion) {
        String sql = "INSERT INTO direccion (usuarioid, departamento, ciudad, barrio, " +
                     "direccion, es_rural, descripcion_rural, predeterminada) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, direccion.getUsuarioId());
            ps.setString(2, direccion.getDepartamento());
            ps.setString(3, direccion.getCiudad());
            ps.setString(4, direccion.getBarrio());
            ps.setString(5, direccion.getDireccion());
            ps.setBoolean(6, direccion.isEsRural());
            ps.setString(7, direccion.getDescripcionRural());
            ps.setBoolean(8, direccion.isPredeterminada());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al crear dirección: " + e.getMessage());
            return false;
        }
    }

    // ─── SELECT — todas las del usuario ───────────────────────────────────────

    public List<Direccion> listarPorUsuario(int usuarioId) {
        List<Direccion> lista = new ArrayList<>();
        String sql = "SELECT * FROM direccion " +
                     "WHERE usuarioid = ? " +
                     "ORDER BY predeterminada DESC, id DESC";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al listar direcciones: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT — por id ───────────────────────────────────────────────────────

    public Direccion obtenerPorId(int id) {
        String sql = "SELECT * FROM direccion WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al obtener dirección: " + e.getMessage());
        }
        return null;
    }

    // ─── SELECT — dirección predeterminada del usuario ─────────────────────────

    public Direccion obtenerPredeterminada(int usuarioId) {
        String sql = "SELECT * FROM direccion WHERE usuarioid = ? AND predeterminada = true LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al obtener predeterminada: " + e.getMessage());
        }
        return null;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean actualizar(Direccion direccion) {
        String sql = "UPDATE direccion SET departamento = ?, ciudad = ?, barrio = ?, " +
                     "direccion = ?, es_rural = ?, descripcion_rural = ? " +
                     "WHERE id = ? AND usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, direccion.getDepartamento());
            ps.setString(2, direccion.getCiudad());
            ps.setString(3, direccion.getBarrio());
            ps.setString(4, direccion.getDireccion());
            ps.setBoolean(5, direccion.isEsRural());
            ps.setString(6, direccion.getDescripcionRural());
            ps.setInt(7, direccion.getId());
            ps.setInt(8, direccion.getUsuarioId()); // seguridad: el usuario solo edita las suyas

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al actualizar dirección: " + e.getMessage());
            return false;
        }
    }

    // ─── UPDATE — cambiar dirección predeterminada ─────────────────────────────
    // Primero quita la flag a todas, luego la pone a la elegida.
    // Se hace en una sola conexión/transacción para evitar inconsistencias.

    public boolean establecerPredeterminada(int usuarioId, int direccionId) {
        String sqlQuitar = "UPDATE direccion SET predeterminada = false WHERE usuarioid = ?";
        String sqlPoner  = "UPDATE direccion SET predeterminada = true  WHERE id = ? AND usuarioid = ?";
        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sqlQuitar)) {
                ps1.setInt(1, usuarioId);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = con.prepareStatement(sqlPoner)) {
                ps2.setInt(1, direccionId);
                ps2.setInt(2, usuarioId);
                ps2.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al cambiar predeterminada: " + e.getMessage());
            try { if (con != null) con.rollback(); } catch (SQLException ex) { /* ignorar */ }
            return false;
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException ex) { /* ignorar */ }
        }
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean eliminar(int id, int usuarioId) {
        String sql = "DELETE FROM direccion WHERE id = ? AND usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, usuarioId); // seguridad: solo borra las suyas
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DireccionDAO] Error al eliminar dirección: " + e.getMessage());
            return false;
        }
    }
}