package com.quiddity.controlador;

import com.quiddity.model.Carrito;
import com.quiddity.model.Catalogo;
import com.quiddity.util.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarritoDAO {

    // Traer todos los ítems del carrito de un usuario con datos del producto
    public List<Carrito> getCarritoByUsuario(int usuarioId) {
        List<Carrito> items = new ArrayList<>();
        String sql = "SELECT c.id, c.usuario_id, c.catalogo_id, c.cantidad, p.nombre, p.descripcion, p.precio, p.stock, p.imagen, p.categoria, p.marca, p.componentes"  
        + "FROM carrito c JOIN catalogo p ON c.catalogo_id = p.id WHERE c.usuario_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Carrito item = new Carrito();
                item.setId(rs.getInt("id"));
                item.setUsuarioId(rs.getInt("usuario_id"));
                item.setCatalogoId(rs.getInt("catalogo_id"));
                item.setCantidad(rs.getInt("cantidad"));

                Catalogo prod = new Catalogo();
                prod.setId(rs.getInt("catalogo_id"));
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Agregar producto — si ya existe solo suma cantidad
    public boolean agregarItem(int usuarioId, int catalogoId, int cantidad) {
        // Verificar si ya está en el carrito
        String sqlCheck = "SELECT id, cantidad FROM carrito WHERE usuario_id = ? AND catalogo_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlCheck)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, catalogoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Ya existe → actualizar cantidad
                int nuevaCantidad = rs.getInt("cantidad") + cantidad;
                int itemId = rs.getInt("id");
                return actualizarCantidad(itemId, nuevaCantidad);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // No existe → insertar
        String sql = "INSERT INTO carrito (usuario_id, catalogo_id, cantidad) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, catalogoId);
            ps.setInt(3, cantidad);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
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
            e.printStackTrace();
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
            e.printStackTrace();
            return false;
        }
    }

    // Vaciar carrito completo (después de confirmar pedido)
    public boolean vaciarCarrito(int usuarioId) {
        String sql = "DELETE FROM carrito WHERE usuario_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Categorías distintas del carrito (para el video)
    public List<String> getCategoriasDelCarrito(int usuarioId) {
        List<String> categorias = new ArrayList<>();
        String sql = "SELECT DISTINCT p.categoria FROM carrito c" +
            "JOIN catalogo p ON c.catalogo_id = p.id WHERE c.usuario_id = ? ";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) categorias.add(rs.getString("categoria"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorias;
    }

    // Total del carrito
    public double getTotalCarrito(int usuarioId) {
        String sql = "SELECT SUM(p.precio * c.cantidad) AS total FROM carrito c" +
            "JOIN catalogo p ON c.catalogo_id = p.id WHERE c.usuario_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}