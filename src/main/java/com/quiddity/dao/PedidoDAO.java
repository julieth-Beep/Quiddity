package com.quiddity.dao;

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

import com.quiddity.model.Catalogo;
import com.quiddity.model.Direccion;
import com.quiddity.model.Pedido;
import com.quiddity.model.PedidoItem;
import com.quiddity.util.ConexionDB;

public class PedidoDAO {

    // ─── MAPPERS ───────────────────────────────────────────────────────────────

    private Pedido mapearPedido(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setId(rs.getInt("id"));
        p.setUsuarioId(rs.getInt("usuarioid"));
        p.setDireccionId(rs.getInt("direccionid"));
        p.setEstadoDesdeString(rs.getString("estado"));
        p.setTotal(rs.getDouble("total"));
        p.setNotas(rs.getString("notas"));
        p.setMetodo_pago(rs.getString("metodo_pago"));

        Timestamp creadoEn = rs.getTimestamp("creado_en");
        if (creadoEn != null)
            p.setCreadoEn(creadoEn.toInstant()
                    .atZone(java.time.ZoneId.of("America/Bogota")));

        Timestamp actualizadoEn = rs.getTimestamp("actualizado_en");
        if (actualizadoEn != null)
            p.setActualizadoEn(actualizadoEn.toInstant()
                    .atZone(java.time.ZoneId.of("America/Bogota")));

        return p;
    }

    private PedidoItem mapearItem(ResultSet rs) throws SQLException {
        PedidoItem item = new PedidoItem();
        item.setId(rs.getInt("item_id"));
        item.setPedidoId(rs.getInt("pedidoid"));
        item.setCatalogoId(rs.getInt("catalogoid"));
        item.setCantidad(rs.getInt("cantidad"));
        item.setPrecioUnitario(rs.getDouble("precio_unitario"));

        // Datos del producto (JOIN)
        Catalogo prod = new Catalogo();
        prod.setId(rs.getInt("catalogoid"));
        prod.setNombre(rs.getString("prod_nombre"));
        prod.setImagen(rs.getString("prod_imagen"));
        prod.setCategoria(rs.getString("prod_categoria"));
        prod.setMarca(rs.getString("prod_marca"));
        item.setProducto(prod);

        return item;
    }

    // ─── INSERT — crear pedido completo en transacción ─────────────────────────
    // Crea la cabecera del pedido + todos sus ítems + descuenta stock.
    // Todo o nada: si falla algo se hace rollback.

    public int crearPedido(Pedido pedido) {
        String sqlPedido = "INSERT INTO pedido (usuarioid, direccionid, estado, total, notas) " +
                "VALUES (?, ?, ?, ?, ?)";
        String sqlItem = "INSERT INTO pedido_item (pedido_id, catalogo_id, cantidad, precio_unitario, subtotal) " +
                "VALUES (?, ?, ?, ?, ?)";
        String sqlStock = "UPDATE catalogo SET stock = stock - ? WHERE id = ? AND stock >= ?";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // 1. Insertar cabecera y recuperar el id generado
            int pedidoId = -1;
            try (PreparedStatement ps = con.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, pedido.getUsuarioId());
                ps.setInt(2, pedido.getDireccionId());
                ps.setString(3, Pedido.Estado.PENDIENTE.name());
                ps.setDouble(4, pedido.calcularTotal());
                ps.setString(5, pedido.getNotas());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next())
                        pedidoId = keys.getInt(1);
                }
            }

            if (pedidoId == -1)
                throw new SQLException("No se obtuvo el id del pedido generado.");

            // 2. Insertar ítems y descontar stock
            for (PedidoItem item : pedido.getItems()) {
                double subtotal = item.getCantidad() * item.getPrecioUnitario();
                try (PreparedStatement psItem = con.prepareStatement(sqlItem)) {
                    psItem.setInt(1, pedidoId);
                    psItem.setInt(2, item.getCatalogoId());
                    psItem.setInt(3, item.getCantidad());
                    psItem.setDouble(4, item.getPrecioUnitario());
                    psItem.setDouble(5, subtotal);
                    psItem.executeUpdate();
                }

                try (PreparedStatement psStock = con.prepareStatement(sqlStock)) {
                    psStock.setInt(1, item.getCantidad());
                    psStock.setInt(2, item.getCatalogoId());
                    psStock.setInt(3, item.getCantidad()); // evita stock negativo
                    int filas = psStock.executeUpdate();
                    if (filas == 0)
                        throw new SQLException(
                                "Stock insuficiente para el producto id=" + item.getCatalogoId());
                }
            }

            con.commit();
            return pedidoId;

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al crear pedido: " + e.getMessage());
            try {
                if (con != null)
                    con.rollback();
            } catch (SQLException ex) {
                /* ignorar */ }
            return -1;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException ex) {
                /* ignorar */ }
        }
    }

    // ─── SELECT — historial completo del usuario (solo cabeceras) ──────────────

    public List<Pedido> getHistorialPorUsuario(int usuarioId) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, d.departamento, d.ciudad, d.barrio, " +
                "d.direccion AS dir_direccion, d.es_rural, d.descripcion_rural, " +
                "COALESCE(SUM(pi.cantidad), 0) AS cantidad_items " +
                "FROM pedido p " +
                "JOIN direccion d ON p.direccionid = d.id " +
                "LEFT JOIN pedido_item pi ON pi.pedido_id = p.id " +
                "WHERE p.usuarioid = ? " +
                "GROUP BY p.id, d.departamento, d.ciudad, d.barrio, " +
                "d.direccion, d.es_rural, d.descripcion_rural " +
                "ORDER BY p.creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = mapearPedido(rs);
                    p.setCantidadItems(rs.getInt("cantidad_items"));

                    Direccion d = new Direccion();
                    d.setId(p.getDireccionId());
                    d.setDepartamento(rs.getString("departamento"));
                    d.setCiudad(rs.getString("ciudad"));
                    d.setBarrio(rs.getString("barrio"));
                    d.setDireccion(rs.getString("dir_direccion"));
                    d.setEsRural(rs.getBoolean("es_rural"));
                    d.setDescripcionRural(rs.getString("descripcion_rural"));
                    p.setDireccion(d);
                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al obtener historial: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT — detalle de un pedido con sus ítems ───────────────────────────

    public Pedido getDetallePedido(int pedidoId, int usuarioId) {
        String sqlPedido = "SELECT p.*, d.departamento, d.ciudad, d.barrio, " +
                "d.direccion AS dir_direccion, d.es_rural, d.descripcion_rural " +
                "FROM pedido p " +
                "JOIN direccion d ON p.direccionid = d.id " +
                "WHERE p.id = ? AND p.usuarioid = ?";
        String sqlItems = "SELECT pi.id AS item_id, pi.pedido_id AS pedidoid, pi.catalogo_id AS catalogoid, " +
                "pi.cantidad, pi.precio_unitario, pi.subtotal, " +
                "c.nombre AS prod_nombre, c.imagen AS prod_imagen, " +
                "c.categoria AS prod_categoria, c.marca AS prod_marca " +
                "FROM pedido_item pi " +
                "JOIN catalogo c ON pi.catalogo_id = c.id " +
                "WHERE pi.pedido_id = ?";
        try (Connection con = ConexionDB.getConnection()) {

            Pedido pedido = null;
            try (PreparedStatement ps = con.prepareStatement(sqlPedido)) {
                ps.setInt(1, pedidoId);
                ps.setInt(2, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        pedido = mapearPedido(rs);
                        Direccion d = new Direccion();
                        d.setId(pedido.getDireccionId());
                        d.setDepartamento(rs.getString("departamento"));
                        d.setCiudad(rs.getString("ciudad"));
                        d.setBarrio(rs.getString("barrio"));
                        d.setDireccion(rs.getString("dir_direccion"));
                        d.setEsRural(rs.getBoolean("es_rural"));
                        d.setDescripcionRural(rs.getString("descripcion_rural"));
                        pedido.setDireccion(d);
                    }
                }
            }

            if (pedido == null)
                return null;

            try (PreparedStatement ps = con.prepareStatement(sqlItems)) {
                ps.setInt(1, pedidoId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next())
                        pedido.getItems().add(mapearItem(rs));
                }
            }

            return pedido;

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al obtener detalle: " + e.getMessage());
        }
        return null;
    }

    // ─── SELECT — todos los pedidos (admin) ────────────────────────────────────

    public List<Pedido> getTodos() {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT * FROM pedido ORDER BY creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapearPedido(rs));

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al listar todos: " + e.getMessage());
        }
        return lista;
    }

    // ─── SELECT — filtrar por estado (admin) ───────────────────────────────────

    public List<Pedido> getPorEstado(Pedido.Estado estado) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT * FROM pedido WHERE estado = ? ORDER BY creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearPedido(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al filtrar por estado: " + e.getMessage());
        }
        return lista;
    }

    // ─── UPDATE — cambiar estado ───────────────────────────────────────────────

    public boolean cambiarEstado(int pedidoId, Pedido.Estado nuevoEstado) {
        String sql = "UPDATE pedido SET estado = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado.name());
            ps.setInt(2, pedidoId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al cambiar estado: " + e.getMessage());
            return false;
        }
    }

    // ─── UPDATE — cancelar (solo si todavía es cancelable) ────────────────────
    // Devuelve el stock de los ítems y marca el pedido como CANCELADO.

    public boolean cancelarPedido(int pedidoId, int usuarioId) {
        String sqlVerificar = "SELECT estado FROM pedido WHERE id = ? AND usuarioid = ?";
        String sqlCancelar = "UPDATE pedido SET estado = 'CANCELADO' WHERE id = ?";
        String sqlRestaurar = "UPDATE catalogo SET stock = stock + ? WHERE id = ?";
        String sqlItems = "SELECT catalogo_id, cantidad FROM pedido_item WHERE pedidoid = ?";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // 1. Verificar que el pedido pertenece al usuario y es cancelable
            try (PreparedStatement ps = con.prepareStatement(sqlVerificar)) {
                ps.setInt(1, pedidoId);
                ps.setInt(2, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next())
                        throw new SQLException("Pedido no encontrado.");
                    Pedido.Estado estadoActual = Pedido.Estado.valueOf(rs.getString("estado"));
                    if (estadoActual == Pedido.Estado.ENVIADO
                            || estadoActual == Pedido.Estado.ENTREGADO
                            || estadoActual == Pedido.Estado.CANCELADO
                            || estadoActual == Pedido.Estado.DEVUELTO) {
                        throw new SQLException("El pedido en estado " + estadoActual + " no puede cancelarse.");
                    }
                }
            }

            // 2. Restaurar stock por cada ítem
            try (PreparedStatement psItems = con.prepareStatement(sqlItems)) {
                psItems.setInt(1, pedidoId);
                try (ResultSet rs = psItems.executeQuery()) {
                    while (rs.next()) {
                        try (PreparedStatement psRestaurar = con.prepareStatement(sqlRestaurar)) {
                            psRestaurar.setInt(1, rs.getInt("cantidad"));
                            psRestaurar.setInt(2, rs.getInt("catalogoid"));
                            psRestaurar.executeUpdate();
                        }
                    }
                }
            }

            // 3. Cambiar estado
            try (PreparedStatement ps = con.prepareStatement(sqlCancelar)) {
                ps.setInt(1, pedidoId);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al cancelar pedido: " + e.getMessage());
            try {
                if (con != null)
                    con.rollback();
            } catch (SQLException ex) {
                /* ignorar */ }
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException ex) {
                /* ignorar */ }
        }
    }
    // ─── FILTROS COMBINADOS
    // ────────────────────────────────────────────────────────
    // estado, fechaInicio, fechaFin y usuarioId pueden ser null para ignorarlos

    public List<Pedido> buscarConFiltros(String estado, java.time.LocalDate fechaInicio,
            java.time.LocalDate fechaFin, Integer usuarioId) {
        List<Pedido> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, u.nombre AS usu_nombre, u.apellido AS usu_apellido, " +
                "u.email AS usu_email, " +
                "d.departamento, d.ciudad, d.barrio, " +
                "d.direccion AS dir_direccion, d.es_rural, d.descripcion_rural " +
                "FROM pedido p " +
                "JOIN usuario u ON p.usuarioid = u.id " +
                "JOIN direccion d ON p.direccionid = d.id " +
                "WHERE 1=1 ");

        if (estado != null && !estado.isBlank())
            sql.append(" AND p.estado = ?");
        if (fechaInicio != null)
            sql.append(" AND p.creado_en >= ?");
        if (fechaFin != null)
            sql.append(" AND p.creado_en <= ?");
        if (usuarioId != null)
            sql.append(" AND p.usuarioid = ?");

        sql.append(" ORDER BY p.creado_en DESC");

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (estado != null && !estado.isBlank())
                ps.setString(idx++, estado);
            if (fechaInicio != null)
                ps.setTimestamp(idx++,
                        Timestamp.valueOf(fechaInicio.atStartOfDay()));
            if (fechaFin != null)
                ps.setTimestamp(idx++,
                        Timestamp.valueOf(fechaFin.atTime(23, 59, 59)));
            if (usuarioId != null)
                ps.setInt(idx++, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = mapearPedido(rs);
                    // Usuario resumido
                    p.setNombreUsuario(rs.getString("usu_nombre") + " " + rs.getString("usu_apellido"));
                    p.setEmailUsuario(rs.getString("usu_email"));
                    // Dirección
                    Direccion d = new Direccion();
                    d.setId(p.getDireccionId());
                    d.setDepartamento(rs.getString("departamento"));
                    d.setCiudad(rs.getString("ciudad"));
                    d.setBarrio(rs.getString("barrio"));
                    d.setDireccion(rs.getString("dir_direccion"));
                    d.setEsRural(rs.getBoolean("es_rural"));
                    d.setDescripcionRural(rs.getString("descripcion_rural"));
                    p.setDireccion(d);
                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al buscar con filtros: " + e.getMessage());
        }
        return lista;
    }

    // ─── DETALLE COMPLETO (admin — sin validar usuarioId)
    // ─────────────────────────

    public Pedido getDetallePedidoAdmin(int pedidoId) {
        String sqlPedido = "SELECT p.*, u.nombre AS usu_nombre, u.apellido AS usu_apellido, " +
                "u.email AS usu_email, u.documento AS usu_documento, " +
                "d.departamento, d.ciudad, d.barrio, " +
                "d.direccion AS dir_direccion, d.es_rural, d.descripcion_rural " +
                "FROM pedido p " +
                "JOIN usuario u ON p.usuarioid = u.id " +
                "JOIN direccion d ON p.direccionid = d.id " +
                "WHERE p.id = ?";
        String sqlItems = "SELECT pi.id AS item_id, pi.pedido_id AS pedidoid, pi.catalogo_id AS catalogoid, " +
                "pi.cantidad, pi.precio_unitario, pi.subtotal, " +
                "c.nombre AS prod_nombre, c.imagen AS prod_imagen, " +
                "c.categoria AS prod_categoria, c.marca AS prod_marca " +
                "FROM pedido_item pi " +
                "JOIN catalogo c ON pi.catalogo_id = c.id " +
                "WHERE pi.pedido_id = ?";

        try (Connection con = ConexionDB.getConnection()) {

            Pedido pedido = null;

            try (PreparedStatement ps = con.prepareStatement(sqlPedido)) {
                ps.setInt(1, pedidoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        pedido = mapearPedido(rs);
                        pedido.setNombreUsuario(rs.getString("usu_nombre") + " " + rs.getString("usu_apellido"));
                        pedido.setEmailUsuario(rs.getString("usu_email"));
                        pedido.setDocumentoUsuario(rs.getString("usu_documento"));

                        Direccion d = new Direccion();
                        d.setId(pedido.getDireccionId());
                        d.setDepartamento(rs.getString("departamento"));
                        d.setCiudad(rs.getString("ciudad"));
                        d.setBarrio(rs.getString("barrio"));
                        d.setDireccion(rs.getString("dir_direccion"));
                        d.setEsRural(rs.getBoolean("es_rural"));
                        d.setDescripcionRural(rs.getString("descripcion_rural"));
                        pedido.setDireccion(d);
                    }
                }
            }

            if (pedido == null)
                return null;

            try (PreparedStatement ps = con.prepareStatement(sqlItems)) {
                ps.setInt(1, pedidoId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next())
                        pedido.getItems().add(mapearItem(rs));
                }
            }

            return pedido;

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al obtener detalle admin: " + e.getMessage());
        }
        return null;
    }

    // ─── AVANZAR ESTADO (solo permite la transición válida)
    // ───────────────────────
    // PENDIENTE → EN_PROCESO → ENTREGADO

    public boolean avanzarEstado(int pedidoId) {
        String sqlConsulta = "SELECT estado FROM pedido WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sqlConsulta)) {

            ps.setInt(1, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return false;

                Pedido.Estado estadoActual = Pedido.Estado.valueOf(rs.getString("estado"));
                Pedido.Estado siguienteEstado = null;
                switch (estadoActual) {
                    case PENDIENTE:
                        siguienteEstado = Pedido.Estado.EN_PROCESO;
                        break;
                    case EN_PROCESO:
                        siguienteEstado = Pedido.Estado.ENTREGADO;
                        break;
                    default:
                        siguienteEstado = null; // ENTREGADO, CANCELADO, DEVUELTO no avanzan
                }

                if (siguienteEstado == null)
                    return false;

                return cambiarEstado(pedidoId, siguienteEstado);
            }

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al avanzar estado: " + e.getMessage());
            return false;
        }
    }

    // ─── CONTEO POR ESTADO (para tarjetas de resumen en el panel)
    // ─────────────────

    public Map<String, Integer> getConteoPorEstado() {
        Map<String, Integer> conteo = new LinkedHashMap<>();
        String sql = "SELECT estado, COUNT(*) AS total FROM pedido GROUP BY estado";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                conteo.put(rs.getString("estado"), rs.getInt("total"));
        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al contar por estado: " + e.getMessage());
        }
        return conteo;
    }

    // ─── BUSCAR USUARIO POR NOMBRE O EMAIL (para el filtro de usuario)
    // ────────────

    public List<Pedido> buscarPorNombreUsuario(String termino) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.nombre AS usu_nombre, u.apellido AS usu_apellido, " +
                "u.email AS usu_email, " +
                "d.departamento, d.ciudad, d.barrio, " +
                "d.direccion AS dir_direccion, d.es_rural, d.descripcion_rural " +
                "FROM pedido p " +
                "JOIN usuario u ON p.usuarioid = u.id " +
                "JOIN direccion d ON p.direccionid = d.id " +
                "WHERE LOWER(CONCAT(u.nombre, ' ', u.apellido)) LIKE LOWER(?) " +
                "   OR LOWER(u.email) LIKE LOWER(?) " +
                "ORDER BY p.creado_en DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String like = "%" + termino + "%";
            ps.setString(1, like);
            ps.setString(2, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = mapearPedido(rs);
                    p.setNombreUsuario(rs.getString("usu_nombre") + " " + rs.getString("usu_apellido"));
                    p.setEmailUsuario(rs.getString("usu_email"));
                    Direccion d = new Direccion();
                    d.setId(p.getDireccionId());
                    d.setDepartamento(rs.getString("departamento"));
                    d.setCiudad(rs.getString("ciudad"));
                    d.setBarrio(rs.getString("barrio"));
                    d.setDireccion(rs.getString("dir_direccion"));
                    d.setEsRural(rs.getBoolean("es_rural"));
                    d.setDescripcionRural(rs.getString("descripcion_rural"));
                    p.setDireccion(d);
                    p.setMetodo_pago(rs.getString("metodo_pago"));
                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("[PedidoDAO] Error al buscar por nombre usuario: " + e.getMessage());
        }
        return lista;
    }
}