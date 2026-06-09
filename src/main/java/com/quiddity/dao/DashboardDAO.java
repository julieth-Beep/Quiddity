package com.quiddity.dao;

import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.quiddity.util.ConexionDB;

public class DashboardDAO {
    
    /**
     * KPIs principales del dashboard
     */
    public Map<String, Object> obtenerKPIs() {
        Map<String, Object> kpis = new LinkedHashMap<>();
        
        String sql = "SELECT " +
            "(SELECT COUNT(*) FROM usuario) as total_usuarios, " +
            "(SELECT COUNT(*) FROM usuario WHERE creado_en >= CURRENT_DATE) as nuevos_hoy, " +
            "(SELECT COUNT(*) FROM catalogo WHERE stock > 0) as total_productos, " +
            "(SELECT COUNT(*) FROM catalogo WHERE stock <= 5) as productos_bajos, " +
            "(SELECT COUNT(*) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE)) as pedidos_mes, " +
            "(SELECT COALESCE(SUM(total), 0) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE)) as ingresos_mes";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                kpis.put("totalUsuarios", rs.getInt("total_usuarios"));
                kpis.put("nuevosHoy", rs.getInt("nuevos_hoy"));
                kpis.put("totalProductos", rs.getInt("total_productos"));
                kpis.put("productosBajos", rs.getInt("productos_bajos"));
                kpis.put("totalPedidos", rs.getInt("pedidos_mes"));
                kpis.put("ingresosMes", rs.getDouble("ingresos_mes"));
                
                kpis.put("tendenciaPedidos", calcularTendenciaPedidos(con));
                kpis.put("tendenciaIngresos", calcularTendenciaIngresos(con));
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener KPIs: " + e.getMessage());
        }
        
        return kpis;
    }
    
    private double calcularTendenciaPedidos(Connection con) throws SQLException {
        String sql = "SELECT " +
            "(SELECT COUNT(*) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE)) as actual, " +
            "(SELECT COUNT(*) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')) as anterior";
        
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                int actual = rs.getInt("actual");
                int anterior = rs.getInt("anterior");
                if (anterior > 0) {
                    return ((double)(actual - anterior) / anterior) * 100;
                }
            }
        }
        return 0.0;
    }
    
    private double calcularTendenciaIngresos(Connection con) throws SQLException {
        String sql = "SELECT " +
            "COALESCE((SELECT SUM(total) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE)), 0) as actual, " +
            "COALESCE((SELECT SUM(total) FROM pedido WHERE DATE_TRUNC('month', creado_en) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')), 0) as anterior";
        
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                double actual = rs.getDouble("actual");
                double anterior = rs.getDouble("anterior");
                if (anterior > 0) {
                    return ((actual - anterior) / anterior) * 100;
                }
            }
        }
        return 0.0;
    }
    
    /**
     * Mapa de calor: actividad por hora últimos 7 días
     * Combina pedidos y registros de usuario como "actividad"
     */
    public List<Map<String, Object>> obtenerActividadHeatmap() {
        List<Map<String, Object>> datos = new ArrayList<>();
        
        String sql = "SELECT " +
            "EXTRACT(DOW FROM creado_en)::int as dia_semana, " +
            "EXTRACT(HOUR FROM creado_en)::int as hora, " +
            "COUNT(*) as total, " +
            "'pedido' as tipo " +
            "FROM pedido " +
            "WHERE creado_en >= CURRENT_DATE - INTERVAL '7 days' " +
            "GROUP BY dia_semana, hora " +
            "UNION ALL " +
            "SELECT " +
            "EXTRACT(DOW FROM creado_en)::int as dia_semana, " +
            "EXTRACT(HOUR FROM creado_en)::int as hora, " +
            "COUNT(*) as total, " +
            "'registro' as tipo " +
            "FROM usuario " +
            "WHERE creado_en >= CURRENT_DATE - INTERVAL '7 days' " +
            "GROUP BY dia_semana, hora " +
            "ORDER BY dia_semana, hora";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> fila = new LinkedHashMap<>();
                fila.put("dia", rs.getInt("dia_semana"));
                fila.put("hora", rs.getInt("hora"));
                fila.put("total", rs.getInt("total"));
                fila.put("tipo", rs.getString("tipo"));
                datos.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener heatmap: " + e.getMessage());
        }
        
        return datos;
    }
    
    /**
     * Últimos pedidos para el feed en vivo
     */
    public List<Map<String, Object>> obtenerUltimosPedidos() {
        List<Map<String, Object>> pedidos = new ArrayList<>();
        
        String sql = "SELECT " +
            "p.id, " +
            "p.estado, " +
            "p.total, " +
            "p.creado_en, " +
            "p.actualizado_en, " +
            "u.nombre as usuario_nombre, " +
            "u.apellido as usuario_apellido, " +
            "u.fotoperfil as usuario_avatar, " +
            "EXTRACT(EPOCH FROM (NOW() - p.actualizado_en))/60 as minutos_en_estado, " +
            "(SELECT c.nombre FROM pedido_item pi JOIN catalogo c ON pi.catalogo_id = c.id " +
            " WHERE pi.pedido_id = p.id ORDER BY pi.precio_unitario DESC LIMIT 1) as producto_principal " +
            "FROM pedido p " +
            "JOIN usuario u ON p.usuarioid = u.id " +
            "ORDER BY p.creado_en DESC " +
            "LIMIT 10";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> pedido = new LinkedHashMap<>();
                pedido.put("id", rs.getInt("id"));
                pedido.put("estado", rs.getString("estado"));
                pedido.put("total", rs.getDouble("total"));
                pedido.put("usuarioNombre", rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellido"));
                pedido.put("usuarioAvatar", rs.getString("usuario_avatar"));
                pedido.put("productoPrincipal", rs.getString("producto_principal"));
                
                int minutos = rs.getInt("minutos_en_estado");
                pedido.put("minutosEnEstado", minutos);
                pedido.put("alerta", minutos > 120 && !"ENTREGADO".equals(rs.getString("estado")) && !"CANCELADO".equals(rs.getString("estado")));
                
                if (minutos < 60) {
                    pedido.put("tiempoLegible", minutos + " min");
                } else {
                    pedido.put("tiempoLegible", (minutos / 60) + "h " + (minutos % 60) + "m");
                }
                
                pedidos.add(pedido);
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener pedidos: " + e.getMessage());
        }
        
        return pedidos;
    }
    
    /**
     * Top 5 productos más vendidos con tendencia últimos 7 días
     */
    public List<Map<String, Object>> obtenerTopProductos() {
        List<Map<String, Object>> productos = new ArrayList<>();
        
        String sql = "WITH ventas_diarias AS (" +
            "SELECT " +
                "c.id, " +
                "c.nombre, " +
                "c.categoria, " +
                "DATE(p.creado_en) as fecha, " +
                "COALESCE(SUM(pi.cantidad), 0) as cantidad " +
            "FROM catalogo c " +
            "LEFT JOIN pedido_item pi ON c.id = pi.catalogo_id " +
            "LEFT JOIN pedido p ON pi.pedido_id = p.id AND p.creado_en >= CURRENT_DATE - INTERVAL '7 days' " +
            "GROUP BY c.id, c.nombre, c.categoria, DATE(p.creado_en) " +
            "), " +
            "totales AS (" +
            "SELECT id, nombre, categoria, SUM(cantidad) as total_vendido " +
            "FROM ventas_diarias " +
            "GROUP BY id, nombre, categoria " +
            "ORDER BY total_vendido DESC " +
            "LIMIT 5" +
            ") " +
            "SELECT t.*, " +
            "ARRAY_AGG(vd.cantidad ORDER BY vd.fecha) FILTER (WHERE vd.fecha IS NOT NULL) as tendencia " +
            "FROM totales t " +
            "LEFT JOIN ventas_diarias vd ON t.id = vd.id " +
            "GROUP BY t.id, t.nombre, t.categoria, t.total_vendido " +
            "ORDER BY t.total_vendido DESC";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> prod = new LinkedHashMap<>();
                prod.put("id", rs.getInt("id"));
                prod.put("nombre", rs.getString("nombre"));
                prod.put("categoria", rs.getString("categoria"));
                prod.put("totalVendido", rs.getInt("total_vendido"));
                
                Array arr = rs.getArray("tendencia");
                List<Integer> tendencia = new ArrayList<>();
                if (arr != null) {
                    ResultSet arrRs = arr.getResultSet();
                    while (arrRs.next()) {
                        tendencia.add(arrRs.getInt(2));
                    }
                }
                // Si no hay tendencia, crear array de 7 ceros
                if (tendencia.isEmpty()) {
                    for (int i = 0; i < 7; i++) tendencia.add(0);
                }
                prod.put("tendencia", tendencia);
                
                if (tendencia.size() >= 2) {
                    int ultimo = tendencia.get(tendencia.size() - 1);
                    int anterior = tendencia.get(tendencia.size() - 2);
                    prod.put("tendenciaDireccion", ultimo >= anterior ? "up" : "down");
                } else {
                    prod.put("tendenciaDireccion", "up");
                }
                
                productos.add(prod);
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener top productos: " + e.getMessage());
        }
        
        return productos;
    }
    
    /**
     * Calendario de ventas tipo GitHub (último mes)
     */
    public List<Map<String, Object>> obtenerCalendarioVentas() {
        List<Map<String, Object>> dias = new ArrayList<>();
        
        String sql = "SELECT " +
            "d.fecha, " +
            "COALESCE(SUM(p.total), 0) as ventas " +
            "FROM generate_series(" +
            "DATE_TRUNC('month', CURRENT_DATE)::date, " +
            "(DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::date, " +
            "'1 day'::interval" +
            ") d(fecha) " +
            "LEFT JOIN pedido p ON DATE(p.creado_en) = d.fecha " +
            "GROUP BY d.fecha " +
            "ORDER BY d.fecha";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            double maxVentas = 0;
            List<Map<String, Object>> temp = new ArrayList<>();
            
            while (rs.next()) {
                Map<String, Object> dia = new LinkedHashMap<>();
                double ventas = rs.getDouble("ventas");
                if (ventas > maxVentas) maxVentas = ventas;
                
                dia.put("fecha", rs.getDate("fecha"));
                dia.put("ventas", ventas);
                temp.add(dia);
            }
            
            for (Map<String, Object> dia : temp) {
                double ventas = (Double) dia.get("ventas");
                int intensidad = 0;
                if (ventas > 0 && maxVentas > 0) {
                    if (ventas <= maxVentas * 0.25) intensidad = 1;
                    else if (ventas <= maxVentas * 0.5) intensidad = 2;
                    else if (ventas <= maxVentas * 0.75) intensidad = 3;
                    else intensidad = 4;
                }
                dia.put("intensidad", intensidad);
                dia.put("esRecord", ventas == maxVentas && ventas > 0);
                dias.add(dia);
            }
            
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener calendario: " + e.getMessage());
        }
        
        return dias;
    }
    
    /**
     * Mapa de burbujas por categoría
     */
    public List<Map<String, Object>> obtenerCategoriasBurbujas() {
        List<Map<String, Object>> categorias = new ArrayList<>();
        
        String sql = "WITH ventas_actual AS (" +
            "SELECT c.categoria, COUNT(pi.id) as cantidad " +
            "FROM catalogo c " +
            "LEFT JOIN pedido_item pi ON c.id = pi.catalogo_id " +
            "LEFT JOIN pedido p ON pi.pedido_id = p.id " +
            "AND p.creado_en >= CURRENT_DATE - INTERVAL '7 days' " +
            "WHERE c.categoria IS NOT NULL " +
            "GROUP BY c.categoria" +
            "), " +
            "ventas_anterior AS (" +
            "SELECT c.categoria, COUNT(pi.id) as cantidad " +
            "FROM catalogo c " +
            "LEFT JOIN pedido_item pi ON c.id = pi.catalogo_id " +
            "LEFT JOIN pedido p ON pi.pedido_id = p.id " +
            "AND p.creado_en BETWEEN CURRENT_DATE - INTERVAL '14 days' " +
            "AND CURRENT_DATE - INTERVAL '7 days' " +
            "WHERE c.categoria IS NOT NULL " +
            "GROUP BY c.categoria" +
            ") " +
            "SELECT va.categoria as nombre, va.cantidad as ventas, " +
            "CASE WHEN va.cantidad > COALESCE(vb.cantidad, 0) THEN 'up' " +
            "WHEN va.cantidad < COALESCE(vb.cantidad, 0) THEN 'down' " +
            "ELSE 'stable' END as tendencia " +
            "FROM ventas_actual va " +
            "LEFT JOIN ventas_anterior vb ON va.categoria = vb.categoria " +
            "ORDER BY va.cantidad DESC";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> cat = new LinkedHashMap<>();
                cat.put("nombre", rs.getString("nombre"));
                cat.put("ventas", rs.getInt("ventas"));
                cat.put("tendencia", rs.getString("tendencia"));
                categorias.add(cat);
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener categorías: " + e.getMessage());
        }
        
        return categorias;
    }
    
    /**
     * Radar de salud de la plataforma (hoy vs ayer)
     * 6 ejes: Ventas, Stock, Usuarios nuevos, Pedidos atendidos
     * (Escaneos y Reseñas no existen en el esquema, se omiten o se simulan)
     */
    public Map<String, Object> obtenerSaludRadar() {
        Map<String, Object> radar = new LinkedHashMap<>();
        
        String sql = "SELECT " +
            // Hoy
            "(SELECT COUNT(*) FROM pedido WHERE DATE(creado_en) = CURRENT_DATE) as ventas_hoy, " +
            "(SELECT COUNT(*) FROM catalogo WHERE stock > 0) as stock_hoy, " +
            "(SELECT COUNT(*) FROM usuario WHERE DATE(creado_en) = CURRENT_DATE) as usuarios_hoy, " +
            "(SELECT COUNT(*) FROM pedido WHERE estado = 'ENTREGADO' AND DATE(actualizado_en) = CURRENT_DATE) as atendidos_hoy, " +
            // Ayer
            "(SELECT COUNT(*) FROM pedido WHERE DATE(creado_en) = CURRENT_DATE - 1) as ventas_ayer, " +
            "(SELECT COUNT(*) FROM catalogo WHERE stock > 0) as stock_ayer, " +
            "(SELECT COUNT(*) FROM usuario WHERE DATE(creado_en) = CURRENT_DATE - 1) as usuarios_ayer, " +
            "(SELECT COUNT(*) FROM pedido WHERE estado = 'ENTREGADO' AND DATE(actualizado_en) = CURRENT_DATE - 1) as atendidos_ayer";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            if (rs.next()) {
                radar.put("ventas", new Integer[]{rs.getInt("ventas_ayer"), rs.getInt("ventas_hoy")});
                radar.put("stock", new Integer[]{rs.getInt("stock_ayer"), rs.getInt("stock_hoy")});
                radar.put("usuarios", new Integer[]{rs.getInt("usuarios_ayer"), rs.getInt("usuarios_hoy")});
                radar.put("atendidos", new Integer[]{rs.getInt("atendidos_ayer"), rs.getInt("atendidos_hoy")});
                // Simular escaneos y reseñas (no existen en el esquema)
                radar.put("escaneos", new Integer[]{0, 0});
                radar.put("resenas", new Integer[]{0, 0});
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener salud radar: " + e.getMessage());
        }
        
        return radar;
    }
    
    /**
     * Actividad reciente de usuarios (últimos registros y pedidos)
     */
    public List<Map<String, Object>> obtenerActividadReciente() {
        List<Map<String, Object>> actividades = new ArrayList<>();
        
        String sql = "SELECT 'registro' as tipo, u.nombre, u.apellido, u.email, u.fotoperfil, " +
            "u.creado_en as fecha, 'Nuevo registro' as accion, 'completado' as estado " +
            "FROM usuario u " +
            "WHERE u.creado_en >= CURRENT_DATE - INTERVAL '3 days' " +
            "UNION ALL " +
            "SELECT 'pedido' as tipo, u.nombre, u.apellido, u.email, u.fotoperfil, " +
            "p.creado_en as fecha, 'Nuevo pedido' as accion, p.estado " +
            "FROM pedido p " +
            "JOIN usuario u ON p.usuarioid = u.id " +
            "WHERE p.creado_en >= CURRENT_DATE - INTERVAL '3 days' " +
            "ORDER BY fecha DESC " +
            "LIMIT 10";
        
        try (Connection con = ConexionDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> act = new LinkedHashMap<>();
                act.put("tipo", rs.getString("tipo"));
                act.put("usuario", rs.getString("nombre") + " " + rs.getString("apellido"));
                act.put("email", rs.getString("email"));
                act.put("avatar", rs.getString("fotoperfil"));
                act.put("accion", rs.getString("accion"));
                act.put("estado", rs.getString("estado"));
                
                Timestamp ts = rs.getTimestamp("fecha");
                long diffMin = (System.currentTimeMillis() - ts.getTime()) / (1000 * 60);
                if (diffMin < 60) {
                    act.put("tiempo", "Hace " + diffMin + " min");
                } else if (diffMin < 1440) {
                    act.put("tiempo", "Hace " + (diffMin / 60) + " horas");
                } else {
                    act.put("tiempo", "Hace " + (diffMin / 1440) + " días");
                }
                
                actividades.add(act);
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] Error al obtener actividad: " + e.getMessage());
        }
        
        return actividades;
    }
}