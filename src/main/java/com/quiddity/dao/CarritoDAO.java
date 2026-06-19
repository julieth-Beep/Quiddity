package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiddity.model.Carrito;
import com.quiddity.model.Catalogo;
import com.quiddity.util.ConexionDB;

public class CarritoDAO {

    // Traer todos los ítems del carrito de un usuario con datos del producto
    public List<Carrito> getCarritoByUsuario(int usuarioId) {
        List<Carrito> items = new ArrayList<>();
        String sql = "SELECT c.id, c.usuarioid, c.catalogoid, c.cantidad, " +
                     "p.id AS pid, p.nombre, p.descripcion, p.precio, " +
                     "p.stock, p.imagen, p.categoria, p.marca, p.componentes " +
                     "FROM carrito c " +
                     "JOIN catalogo p ON c.catalogoid = p.id " +
                     "WHERE c.usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Carrito item = new Carrito();
                    item.setId(rs.getInt("id"));
                    item.setUsuarioId(rs.getInt("usuarioid"));
                    item.setCatalogoId(rs.getInt("catalogoid"));
                    item.setCantidad(rs.getInt("cantidad"));

                    Catalogo prod = new Catalogo();
                    prod.setId(rs.getInt("pid"));
                    prod.setNombre(rs.getString("nombre"));
                    prod.setDescripcion(rs.getString("descripcion"));
                    prod.setPrecio(rs.getDouble("precio"));
                    prod.setStock(rs.getInt("stock"));
                    prod.setImagen(rs.getString("imagen"));
                    prod.setCategoria(rs.getString("categoria"));
                    prod.setMarca(rs.getString("marca"));
                    prod.setComponentes(rs.getString("componentes"));

                    item.setProducto(prod);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al obtener carrito: " + e.getMessage());
        }
        return items;
    }

    // Agregar producto — si ya existe solo suma cantidad
    public boolean agregarItem(int usuarioId, int catalogoId, int cantidad) {
        String sqlCheck = "SELECT id, cantidad FROM carrito WHERE usuarioid = ? AND catalogoid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlCheck)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, catalogoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int nuevaCantidad = rs.getInt("cantidad") + cantidad;
                    int itemId = rs.getInt("id");
                    return actualizarCantidad(itemId, nuevaCantidad);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al verificar ítem: " + e.getMessage());
            return false;
        }

        String sql = "INSERT INTO carrito (usuarioid, catalogoid, cantidad) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, catalogoId);
            ps.setInt(3, cantidad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al agregar ítem: " + e.getMessage());
            return false;
        }
    }

    // Actualizar cantidad de un ítem
    public boolean actualizarCantidad(int itemId, int cantidad) {
        String sql = "UPDATE carrito SET cantidad = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cantidad);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al actualizar cantidad: " + e.getMessage());
            return false;
        }
    }

    // Eliminar un ítem del carrito
    public boolean eliminarItem(int itemId) {
        String sql = "DELETE FROM carrito WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al eliminar ítem: " + e.getMessage());
            return false;
        }
    }

    // Vaciar carrito completo (después de confirmar pedido)
    public boolean vaciarCarrito(int usuarioId) {
        String sql = "DELETE FROM carrito WHERE usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            return ps.executeUpdate() >= 0;

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al vaciar carrito: " + e.getMessage());
            return false;
        }
    }

    // Categorías distintas del carrito
    public List<String> getCategoriasDelCarrito(int usuarioId) {
        List<String> categorias = new ArrayList<>();
        String sql = "SELECT DISTINCT p.categoria " +
                     "FROM carrito c " +
                     "JOIN catalogo p ON c.catalogoid = p.id " +
                     "WHERE c.usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) categorias.add(rs.getString("categoria"));
            }

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al obtener categorías: " + e.getMessage());
        }
        return categorias;
    }

    // Total del carrito
    public double getTotalCarrito(int usuarioId) {
        String sql = "SELECT SUM(p.precio * c.cantidad) AS total " +
                     "FROM carrito c " +
                     "JOIN catalogo p ON c.catalogoid = p.id " +
                     "WHERE c.usuarioid = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
            }

        } catch (SQLException e) {
            System.err.println("[CarritoDAO] Error al calcular total: " + e.getMessage());
        }
        return 0;
    }
}