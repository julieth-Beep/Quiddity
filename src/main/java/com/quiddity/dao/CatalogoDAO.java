package com.quiddity.dao;

import com.quiddity.model.Catalogo;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CatalogoDAO {

    // ─── INSERT ────────────────────────────────────────────────────────────────

    public boolean crear(Catalogo catalogo) {
        String sql = """
                INSERT INTO catalogo (nombre, descripcion, componentes, precio, stock, imagen, categoria, marca)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, catalogo.getNombre());
            ps.setString(2, catalogo.getDescripcion());
            ps.setString(3, catalogo.getComponentes());
            ps.setDouble(4, catalogo.getPrecio());
            ps.setInt(5, catalogo.getStock());
            ps.setString(6, catalogo.getImagen());
            ps.setString(7, catalogo.getCategoria());
            ps.setString(8, catalogo.getMarca());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al crear: " + e.getMessage());
            return false;
        }
    }

    // ─── SELECT ALL ────────────────────────────────────────────────────────────

    public List<Catalogo> listarTodos() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT BY ID ──────────────────────────────────────────────────────────

    public Catalogo obtenerPorId(int id) {
        String sql = "SELECT * FROM catalogo WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al obtener por id: " + e.getMessage());
        }
        return null;
    }

    // ─── SELECT BY CATEGORIA ───────────────────────────────────────────────────

    public List<Catalogo> listarPorCategoria(String categoria) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(categoria) = LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar por categoría: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT BY MARCA ───────────────────────────────────────────────────────

    public List<Catalogo> listarPorMarca(String marca) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(marca) = LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, marca);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar por marca: " + e.getMessage());
        }
        return lista;
    }

    // ─── BÚSQUEDA POR NOMBRE ───────────────────────────────────────────────────
    // Para barra de búsqueda — coincidencia parcial.

    public List<Catalogo> buscarPorNombre(String termino) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(nombre) LIKE LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + termino + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al buscar por nombre: " + e.getMessage());
        }
        return lista;
    }

    // ─── LISTAR CON STOCK DISPONIBLE ───────────────────────────────────────────

    public List<Catalogo> listarConStock() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE stock > 0 ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar con stock: " + e.getMessage());
        }
        return lista;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean actualizar(Catalogo catalogo) {
        String sql = """
                UPDATE catalogo SET nombre = ?, descripcion = ?, componentes = ?,
                precio = ?, stock = ?, imagen = ?, categoria = ?, marca = ?
                WHERE id = ?
                """;
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, catalogo.getNombre());
            ps.setString(2, catalogo.getDescripcion());
            ps.setString(3, catalogo.getComponentes());
            ps.setDouble(4, catalogo.getPrecio());
            ps.setInt(5, catalogo.getStock());
            ps.setString(6, catalogo.getImagen());
            ps.setString(7, catalogo.getCategoria());
            ps.setString(8, catalogo.getMarca());
            ps.setInt(9, catalogo.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    // ─── UPDATE STOCK (descontar al comprar) ───────────────────────────────────

    public boolean descontarStock(int id, int cantidad) {
        String sql = "UPDATE catalogo SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            ps.setInt(3, cantidad); // evita stock negativo

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al descontar stock: " + e.getMessage());
            return false;
        }
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean eliminar(int id) {
        String sql = "DELETE FROM catalogo WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    // ─── MAPPER ────────────────────────────────────────────────────────────────

    private Catalogo mapear(ResultSet rs) throws SQLException {
        return new Catalogo(
                rs.getInt("id"),
                rs.getString("nombre"),
                rs.getString("descripcion"),
                rs.getString("componentes"),
                rs.getDouble("precio"),
                rs.getInt("stock"),
                rs.getString("imagen"),
                rs.getString("categoria"),
                rs.getString("marca"),
                rs.getBoolean("meGusta")
        );
    }
}