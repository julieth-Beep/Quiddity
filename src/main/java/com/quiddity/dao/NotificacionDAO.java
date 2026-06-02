package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiddity.model.Notificacion;
import com.quiddity.util.ConexionDB;

public class NotificacionDAO {

    // ─── INSERT ────────────────────────────────────────────────────────────────
    // Registra qué frase se le mostró al usuario al ingresar.

    public boolean insertar(Notificacion notificacion) {
        // enviado_en tiene DEFAULT now() en BD, no se envía desde Java.
        String sql = "INSERT INTO notificaciones (idusuario, idfrase) VALUES (?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, notificacion.getIdUsuario());
            ps.setInt(2, notificacion.getIdFrase());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("NotificacionDAO.insertar: " + e.getMessage());
            return false;
        }
    }

    // ─── SELECT ALL ────────────────────────────────────────────────────────────

    public List<Notificacion> listarTodas() {
        List<Notificacion> lista = new ArrayList<>();
        String sql = "SELECT id, idusuario, idfrase FROM notificaciones ORDER BY id";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("NotificacionDAO.listarTodas: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT BY USUARIO ─────────────────────────────────────────────────────
    // Historial de frases recibidas por un usuario.

    public List<Notificacion> listarPorUsuario(int idUsuario) {
        List<Notificacion> lista = new ArrayList<>();
        String sql = "SELECT id, idusuario, idfrase FROM notificaciones WHERE idusuario = ? ORDER BY id DESC";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("NotificacionDAO.listarPorUsuario: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT BY ID ──────────────────────────────────────────────────────────

    public Notificacion buscarPorId(int id) {
        String sql = "SELECT id, idusuario, idfrase FROM notificaciones WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("NotificacionDAO.buscarPorId: " + e.getMessage());
        }
        return null;
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean eliminar(int id) {
        String sql = "DELETE FROM notificaciones WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("NotificacionDAO.eliminar: " + e.getMessage());
            return false;
        }
    }

    // ─── MAPPER ────────────────────────────────────────────────────────────────

    private Notificacion mapear(ResultSet rs) throws SQLException {
        return new Notificacion(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getInt("idfrase")
        );
    }
}