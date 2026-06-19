package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.quiddity.model.Catalogo;
import com.quiddity.util.ConexionDB;

public class CatalogoEstadisticasDAO {

    // ─── TOP N MÁS VENDIDOS ────────────────────────────────────────────────────
    public List<Map<String, Object>> getTopVendidos(int limite) {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT c.id, c.nombre, c.categoria, c.marca, c.imagen, c.precio, "
                + "SUM(pi.cantidad) AS total_vendido, "
                + "SUM(pi.cantidad * pi.precio_unitario) AS ingresos "
                + "FROM pedido_item pi "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "GROUP BY c.id, c.nombre, c.categoria, c.marca, c.imagen, c.precio "
                + "ORDER BY total_vendido DESC "
                + "LIMIT ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new LinkedHashMap<>();
                    fila.put("id", rs.getInt("id"));
                    fila.put("nombre", rs.getString("nombre"));
                    fila.put("categoria", rs.getString("categoria"));
                    fila.put("marca", rs.getString("marca"));
                    fila.put("imagen", rs.getString("imagen"));
                    fila.put("precio", rs.getDouble("precio"));
                    fila.put("totalVendido", rs.getInt("total_vendido"));
                    fila.put("ingresos", rs.getDouble("ingresos"));
                    resultado.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getTopVendidos: " + e.getMessage());
        }
        return resultado;
    }

    // ─── VENTAS POR CATEGORÍA ─────────────────────────────────────────────────
    public List<Map<String, Object>> getVentasPorCategoria() {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT c.categoria, "
                + "SUM(pi.cantidad) AS unidades_vendidas, "
                + "SUM(pi.cantidad * pi.precio_unitario) AS ingresos "
                + "FROM pedido_item pi "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "GROUP BY c.categoria "
                + "ORDER BY ingresos DESC";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new LinkedHashMap<>();
                fila.put("categoria", rs.getString("categoria"));
                fila.put("unidadesVendidas", rs.getInt("unidades_vendidas"));
                fila.put("ingresos", rs.getDouble("ingresos"));
                resultado.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getVentasPorCategoria: " + e.getMessage());
        }
        return resultado;
    }

    // ─── PRODUCTOS SIN VENTAS EN LOS ÚLTIMOS N DÍAS ───────────────────────────
    public List<Catalogo> getProductosSinVentas(int dias) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = String.format(
                "SELECT * FROM catalogo "
                + "WHERE id NOT IN ( "
                + "    SELECT DISTINCT pi.catalogo_id "
                + "    FROM pedido_item pi "
                + "    JOIN pedido p ON pi.pedido_id = p.id "
                + "    WHERE p.creado_en >= NOW() - INTERVAL '%d days' "
                + "      AND p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + ") "
                + "ORDER BY nombre", dias);
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getProductosSinVentas: " + e.getMessage());
        }
        return lista;
    }

    // ─── INGRESOS TOTALES ─────────────────────────────────────────────────────
    public double getIngresosTotales() {
        String sql
                = "SELECT COALESCE(SUM(pi.cantidad * pi.precio_unitario), 0) AS total "
                + "FROM pedido_item pi "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO')";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getIngresosTotales: " + e.getMessage());
        }
        return 0;
    }

    // ─── INGRESOS POR CATEGORÍA ───────────────────────────────────────────────
    public List<Map<String, Object>> getIngresosPorCategoria() {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT c.categoria, "
                + "SUM(pi.cantidad * pi.precio_unitario) AS ingresos, "
                + "COUNT(DISTINCT p.id) AS num_pedidos "
                + "FROM pedido_item pi "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "GROUP BY c.categoria "
                + "ORDER BY ingresos DESC";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new LinkedHashMap<>();
                fila.put("categoria", rs.getString("categoria"));
                fila.put("ingresos", rs.getDouble("ingresos"));
                fila.put("numPedidos", rs.getInt("num_pedidos"));
                resultado.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getIngresosPorCategoria: " + e.getMessage());
        }
        return resultado;
    }

    // ─── MAPPER (copia del de CatalogoDAO) ────────────────────────────────────
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
                rs.getBoolean("me_gusta"),
                rs.getBoolean("activo"));
    }

    // ─── TOP VENDIDOS POR PERÍODO
    // ──────────────────────────────────────────────────
    public List<Map<String, Object>> getTopVendidosPorPeriodo(int limite,
            java.time.LocalDate desde,
            java.time.LocalDate hasta) {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT c.id, c.nombre, c.categoria, c.marca, c.imagen, c.precio, "
                + "SUM(pi.cantidad) AS total_vendido, "
                + "SUM(pi.cantidad * pi.precio_unitario) AS ingresos "
                + "FROM pedido_item pi "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "  AND p.creado_en >= ? "
                + "  AND p.creado_en <= ? "
                + "GROUP BY c.id, c.nombre, c.categoria, c.marca, c.imagen, c.precio "
                + "ORDER BY total_vendido DESC "
                + "LIMIT ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(desde.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(hasta.atTime(23, 59, 59)));
            ps.setInt(3, limite);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new LinkedHashMap<>();
                    fila.put("id", rs.getInt("id"));
                    fila.put("nombre", rs.getString("nombre"));
                    fila.put("categoria", rs.getString("categoria"));
                    fila.put("marca", rs.getString("marca"));
                    fila.put("imagen", rs.getString("imagen"));
                    fila.put("precio", rs.getDouble("precio"));
                    fila.put("totalVendido", rs.getInt("total_vendido"));
                    fila.put("ingresos", rs.getDouble("ingresos"));
                    resultado.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getTopVendidosPorPeriodo: " + e.getMessage());
        }
        return resultado;
    }

    // ─── VENTAS POR CATEGORÍA EN PERÍODO
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getVentasPorCategoriaPeriodo(java.time.LocalDate desde,
            java.time.LocalDate hasta) {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT c.categoria, "
                + "SUM(pi.cantidad) AS unidades_vendidas, "
                + "SUM(pi.cantidad * pi.precio_unitario) AS ingresos, "
                + "COUNT(DISTINCT p.id) AS num_pedidos "
                + "FROM pedido_item pi "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "  AND p.creado_en >= ? "
                + "  AND p.creado_en <= ? "
                + "GROUP BY c.categoria "
                + "ORDER BY ingresos DESC";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(desde.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(hasta.atTime(23, 59, 59)));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new LinkedHashMap<>();
                    fila.put("categoria", rs.getString("categoria"));
                    fila.put("unidadesVendidas", rs.getInt("unidades_vendidas"));
                    fila.put("ingresos", rs.getDouble("ingresos"));
                    fila.put("numPedidos", rs.getInt("num_pedidos"));
                    resultado.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getVentasPorCategoriaPeriodo: " + e.getMessage());
        }
        return resultado;
    }

    // ─── INGRESOS TOTALES POR PERÍODO
    // ─────────────────────────────────────────────
    public Map<String, Object> getResumenPeriodo(java.time.LocalDate desde,
            java.time.LocalDate hasta) {
        Map<String, Object> resumen = new LinkedHashMap<>();
        String sql
                = "SELECT "
                + "COALESCE(SUM(pi.cantidad * pi.precio_unitario), 0) AS ingresos_totales, "
                + "COALESCE(SUM(pi.cantidad), 0) AS unidades_totales, "
                + "COUNT(DISTINCT p.id) AS num_pedidos, "
                + "COUNT(DISTINCT p.usuarioid) AS num_clientes "
                + "FROM pedido_item pi "
                + "JOIN pedido p ON pi.pedido_id = p.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "  AND p.creado_en >= ? "
                + "  AND p.creado_en <= ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(desde.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(hasta.atTime(23, 59, 59)));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    resumen.put("ingresosTotales", rs.getDouble("ingresos_totales"));
                    resumen.put("unidadesTotales", rs.getInt("unidades_totales"));
                    resumen.put("numPedidos", rs.getInt("num_pedidos"));
                    resumen.put("numClientes", rs.getInt("num_clientes"));
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getResumenPeriodo: " + e.getMessage());
        }
        return resumen;
    }

    // ─── DATOS COMPLETOS PARA EXPORTAR A EXCEL
    // ────────────────────────────────────
    public List<Map<String, Object>> getDatosExportacion(java.time.LocalDate desde,
            java.time.LocalDate hasta) {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql
                = "SELECT p.id AS pedido_id, "
                + "p.creado_en, "
                + "p.estado, "
                + "p.total AS pedido_total, "
                + "u.nombre || ' ' || u.apellido AS cliente, "
                + "u.email AS cliente_email, "
                + "u.documento AS cliente_documento, "
                + "d.departamento, d.ciudad, "
                + "c.nombre AS producto, "
                + "c.categoria, "
                + "c.marca, "
                + "pi.cantidad, "
                + "pi.precio_unitario, "
                + "(pi.cantidad * pi.precio_unitario) AS subtotal "
                + "FROM pedido p "
                + "JOIN usuario u ON p.usuarioid = u.id "
                + "JOIN direccion d ON p.direccionid = d.id "
                + "JOIN pedido_item pi ON pi.pedido_id = p.id "
                + "JOIN catalogo c ON pi.catalogo_id = c.id "
                + "WHERE p.estado NOT IN ('CANCELADO', 'DEVUELTO') "
                + "  AND p.creado_en >= ? "
                + "  AND p.creado_en <= ? "
                + "ORDER BY p.creado_en DESC, p.id, c.nombre";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(desde.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(hasta.atTime(23, 59, 59)));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new LinkedHashMap<>();
                    fila.put("pedidoId", rs.getInt("pedido_id"));
                    fila.put("fecha", rs.getTimestamp("creado_en")
                            .toInstant()
                            .atZone(java.time.ZoneId.of("America/Bogota"))
                            .toLocalDateTime());
                    fila.put("estado", rs.getString("estado"));
                    fila.put("pedidoTotal", rs.getDouble("pedido_total"));
                    fila.put("cliente", rs.getString("cliente"));
                    fila.put("clienteEmail", rs.getString("cliente_email"));
                    fila.put("clienteDocumento", rs.getString("cliente_documento"));
                    fila.put("departamento", rs.getString("departamento"));
                    fila.put("ciudad", rs.getString("ciudad"));
                    fila.put("producto", rs.getString("producto"));
                    fila.put("categoria", rs.getString("categoria"));
                    fila.put("marca", rs.getString("marca"));
                    fila.put("cantidad", rs.getInt("cantidad"));
                    fila.put("precioUnitario", rs.getDouble("precio_unitario"));
                    fila.put("subtotal", rs.getDouble("subtotal"));
                    resultado.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoEstadisticasDAO] Error en getDatosExportacion: " + e.getMessage());
        }
        return resultado;
    }
}