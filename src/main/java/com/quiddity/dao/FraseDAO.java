package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiddity.model.Frase;
import com.quiddity.util.ConexionDB;

public class FraseDAO {

    // ─── INSERT ────────────────────────────────────────────────────────────────

    public boolean insertar(Frase frase) {
        String sql = "INSERT INTO frase (imagen, autor, categoria, estadoanimo) VALUES (?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, frase.getImagen());
            ps.setString(2, frase.getAutor());
            ps.setString(3, frase.getCategoria());
            ps.setString(4, frase.getEstadoAnimo());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("FraseDAO.insertar: " + e.getMessage());
            return false;
        }
    }

    // ─── SELECT ALL ────────────────────────────────────────────────────────────

    public List<Frase> listarTodas() {
        List<Frase> lista = new ArrayList<>();
        String sql = "SELECT id, imagen, autor, categoria, estadoanimo FROM frase ORDER BY id";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("FraseDAO.listarTodas: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT BY ID ──────────────────────────────────────────────────────────

    public Frase buscarPorId(int id) {
        String sql = "SELECT id, imagen, autor, categoria, estadoanimo FROM frase WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("FraseDAO.buscarPorId: " + e.getMessage());
        }
        return null;
    }

    // ─── SELECT BY ESTADO DE ÁNIMO ─────────────────────────────────────────────
    // Devuelve UNA frase aleatoria que coincida con el estado de ánimo elegido.
    // Útil para mostrar al usuario al ingresar.

    public Frase buscarPorEstadoAnimo(String estadoAnimo) {
        String sql = """
                SELECT id, imagen, autor, categoria, estadoanimo
                FROM frase
                WHERE LOWER(estadoanimo) = LOWER(?)
                ORDER BY RANDOM()
                LIMIT 1
                """;
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estadoAnimo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("FraseDAO.buscarPorEstadoAnimo: " + e.getMessage());
        }
        return null;
    }

    // Devuelve TODAS las frases de un estado de ánimo (por si necesitas listarlas).
    public List<Frase> listarPorEstadoAnimo(String estadoAnimo) {
        List<Frase> lista = new ArrayList<>();
        String sql = """
                SELECT id, imagen, autor, categoria, estadoanimo
                FROM frase
                WHERE LOWER(estadoanimo) = LOWER(?)
                ORDER BY id
                """;
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estadoAnimo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("FraseDAO.listarPorEstadoAnimo: " + e.getMessage());
        }
        return lista;
    }

    // Devuelve los estados de ánimo distintos que existen en BD
    // (para poblar el selector del usuario al ingresar).
    public List<String> listarEstadosAnimo() {
        List<String> estados = new ArrayList<>();
        String sql = "SELECT DISTINCT estadoanimo FROM frase WHERE estadoanimo IS NOT NULL ORDER BY estadoanimo";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) estados.add(rs.getString("estadoanimo"));

        } catch (SQLException e) {
            System.err.println("FraseDAO.listarEstadosAnimo: " + e.getMessage());
        }
        return estados;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean actualizar(Frase frase) {
        String sql = "UPDATE frase SET imagen = ?, autor = ?, categoria = ?, estadoanimo = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, frase.getImagen());
            ps.setString(2, frase.getAutor());
            ps.setString(3, frase.getCategoria());
            ps.setString(4, frase.getEstadoAnimo());
            ps.setInt(5, frase.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("FraseDAO.actualizar: " + e.getMessage());
            return false;
        }
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean eliminar(int id) {
        String sql = "DELETE FROM frase WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("FraseDAO.eliminar: " + e.getMessage());
            return false;
        }
    }

    // ─── MAPPER ────────────────────────────────────────────────────────────────

    private Frase mapear(ResultSet rs) throws SQLException {
        return new Frase(
                rs.getInt("id"),
                rs.getString("imagen"),
                rs.getString("autor"),
                rs.getString("categoria"),
                rs.getString("estadoanimo")
        );
    }
}