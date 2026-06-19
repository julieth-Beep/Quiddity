package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.quiddity.model.Catalogo;
import com.quiddity.model.CatalogoImagen;
import com.quiddity.util.ConexionDB;

public class CatalogoDAO {

    // ═══════════════════════════════════════════════════════════════════════
    // CRUD BÁSICO (existente, sin cambios en firma)
    // ═══════════════════════════════════════════════════════════════════════

    public boolean crear(Catalogo catalogo) {
        String sql = "INSERT INTO catalogo (nombre, descripcion, componentes, precio, stock, imagen, categoria, marca) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, catalogo.getNombre());
            ps.setString(2, catalogo.getDescripcion());
            ps.setString(3, catalogo.getComponentes());
            ps.setDouble(4, catalogo.getPrecio());
            ps.setInt(5, catalogo.getStock());
            ps.setString(6, catalogo.getImagen());
            ps.setString(7, catalogo.getCategoria());
            ps.setString(8, catalogo.getMarca());

            int affected = ps.executeUpdate();
            
            // Obtener el ID generado para poder insertar imágenes adicionales
            if (affected > 0 && !catalogo.getImagenes().isEmpty()) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        for (CatalogoImagen img : catalogo.getImagenes()) {
                            img.setCatalogoId(newId);
                            agregarImagen(img);
                        }
                    }
                }
            }
            return affected > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al crear: " + e.getMessage());
            return false;
        }
    }

    public List<Catalogo> listarTodos() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapearConImagenes(rs, con));

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    public Catalogo obtenerPorId(int id) {
        String sql = "SELECT * FROM catalogo WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapearConImagenes(rs, con);
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al obtener por id: " + e.getMessage());
        }
        return null;
    }

    public List<Catalogo> listarPorCategoria(String categoria) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(categoria) = LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearConImagenes(rs, con));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar por categoría: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarPorMarca(String marca) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(marca) = LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, marca);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearConImagenes(rs, con));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar por marca: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> buscarPorNombre(String termino) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE LOWER(nombre) LIKE LOWER(?) ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + termino + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearConImagenes(rs, con));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al buscar por nombre: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarConStock() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE stock > 0 ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapearConImagenes(rs, con));

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar con stock: " + e.getMessage());
        }
        return lista;
    }

    public boolean actualizar(Catalogo catalogo) {
        String sql = "UPDATE catalogo SET nombre = ?, descripcion = ?, componentes = ?, " +
                "precio = ?, stock = ?, imagen = ?, categoria = ?, marca = ? " +
                "WHERE id = ?";
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

    public boolean descontarStock(int id, int cantidad) {
        String sql = "UPDATE catalogo SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            ps.setInt(3, cantidad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al descontar stock: " + e.getMessage());
            return false;
        }
    }

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

    // ─── SOFT DELETE ─────────────────────────────────────────────────────────

    public boolean desactivar(int id) {
        String sql = "UPDATE catalogo SET activo = false WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al desactivar: " + e.getMessage());
            return false;
        }
    }

    public boolean activar(int id) {
        String sql = "UPDATE catalogo SET activo = true WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al activar: " + e.getMessage());
            return false;
        }
    }

    // ─── LISTAR FILTRADOS ────────────────────────────────────────────────────

    public List<Catalogo> listarActivos() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE activo = true ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapearConImagenes(rs, con));
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar activos: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarInactivos() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE activo = false ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapearConImagenes(rs, con));
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar inactivos: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarBajoStock(int umbral) {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE stock > 0 AND stock < ? ORDER BY stock ASC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, umbral);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearConImagenes(rs, con));
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar bajo stock: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarSinStock() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo WHERE stock = 0 ORDER BY nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapearConImagenes(rs, con));
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar sin stock: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> listarTodosAdmin() {
        List<Catalogo> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo ORDER BY activo DESC, nombre";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapearConImagenes(rs, con));
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al listar todos (admin): " + e.getMessage());
        }
        return lista;
    }

    // ─── GESTIÓN DE STOCK INLINE ─────────────────────────────────────────────

    public boolean actualizarStock(int id, int nuevoStock) {
        if (nuevoStock < 0) return false;
        String sql = "UPDATE catalogo SET stock = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nuevoStock);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al actualizar stock: " + e.getMessage());
            return false;
        }
    }

    public boolean aumentarStock(int id, int cantidad) {
        if (cantidad <= 0) return false;
        String sql = "UPDATE catalogo SET stock = stock + ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al aumentar stock: " + e.getMessage());
            return false;
        }
    }

    public boolean disminuirStock(int id, int cantidad) {
        if (cantidad <= 0) return false;
        String sql = "UPDATE catalogo SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            ps.setInt(3, cantidad);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al disminuir stock: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarImagen(int id, String nuevaRutaImagen) {
        String sql = "UPDATE catalogo SET imagen = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaRutaImagen);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al actualizar imagen: " + e.getMessage());
            return false;
        }
    }

    // ─── CATEGORÍAS CON CONTEO ───────────────────────────────────────────────

    public List<Map<String, Object>> getCategoriaConConteo() {
        List<Map<String, Object>> resultado = new ArrayList<>();
        String sql = "SELECT categoria, COUNT(*) AS total, " +
                "SUM(CASE WHEN activo = true THEN 1 ELSE 0 END) AS activos, " +
                "SUM(CASE WHEN stock = 0 THEN 1 ELSE 0 END) AS sin_stock " +
                "FROM catalogo " +
                "GROUP BY categoria " +
                "ORDER BY categoria";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new java.util.LinkedHashMap<>();
                fila.put("categoria", rs.getString("categoria"));
                fila.put("total", rs.getInt("total"));
                fila.put("activos", rs.getInt("activos"));
                fila.put("sin_stock", rs.getInt("sin_stock"));
                resultado.add(fila);
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al obtener categorías con conteo: " + e.getMessage());
        }
        return resultado;
    }

    // ─── BÚSQUEDA CON FILTROS COMBINADOS ─────────────────────────────────────

    public List<Catalogo> buscarConFiltros(String categoria, String estado, String termino) {
        List<Catalogo> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM catalogo WHERE 1=1");

        if (categoria != null && !categoria.isBlank())
            sql.append(" AND LOWER(categoria) = LOWER(?)");
        if (termino != null && !termino.isBlank())
            sql.append(" AND LOWER(nombre) LIKE LOWER(?)");
        if (estado != null) {
            switch (estado) {
                case "activo" -> sql.append(" AND activo = true AND stock > 0");
                case "inactivo" -> sql.append(" AND activo = false");
                case "bajo_stock" -> sql.append(" AND activo = true AND stock > 0 AND stock < 10");
                case "sin_stock" -> sql.append(" AND stock = 0");
            }
        }

        sql.append(" ORDER BY nombre");

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (categoria != null && !categoria.isBlank())
                ps.setString(idx++, categoria);
            if (termino != null && !termino.isBlank())
                ps.setString(idx++, "%" + termino + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapearConImagenes(rs, con));
            }

        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al buscar con filtros: " + e.getMessage());
        }
        return lista;
    }

    public List<Catalogo> obtenerPorIds(List<Integer> ids) {
        List<Catalogo> resultado = new ArrayList<>();
        if (ids == null || ids.isEmpty()) {
            return resultado;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(ids.size(), "?"));
        String sql = "SELECT * FROM catalogo WHERE id IN (" + placeholders + ") AND activo = true ORDER BY nombre";

        try (Connection conn = ConexionDB.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    resultado.add(mapearConImagenes(rs, conn));
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al obtener por IDs: " + e.getMessage());
        }
        return resultado;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // NUEVOS MÉTODOS: GESTIÓN DE IMÁGENES ADICIONALES
    // ═══════════════════════════════════════════════════════════════════════

    /**
     * Obtiene todas las imágenes de un producto
     */
    public List<CatalogoImagen> getImagenesByProducto(int catalogoId) {
        List<CatalogoImagen> lista = new ArrayList<>();
        String sql = "SELECT * FROM catalogo_imagenes WHERE catalogo_id = ? ORDER BY es_principal DESC, orden ASC, id ASC";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, catalogoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearImagen(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al obtener imágenes: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Agrega una imagen adicional
     */
    public boolean agregarImagen(CatalogoImagen imagen) {
        String sql = "INSERT INTO catalogo_imagenes (catalogo_id, ruta_imagen, orden, es_principal) VALUES (?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, imagen.getCatalogoId());
            ps.setString(2, imagen.getRutaImagen());
            ps.setInt(3, imagen.getOrden());
            ps.setBoolean(4, imagen.isEsPrincipal());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al agregar imagen: " + e.getMessage());
            return false;
        }
    }

    /**
     * Elimina una imagen por ID
     */
    public boolean eliminarImagen(int imagenId) {
        String sql = "DELETE FROM catalogo_imagenes WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, imagenId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al eliminar imagen: " + e.getMessage());
            return false;
        }
    }

    /**
     * Elimina TODAS las imágenes de un producto (útil para hard delete)
     */
    public boolean eliminarImagenesByProducto(int catalogoId) {
        String sql = "DELETE FROM catalogo_imagenes WHERE catalogo_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, catalogoId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al eliminar imágenes del producto: " + e.getMessage());
            return false;
        }
    }

    /**
     * Establece una imagen como principal
     */
    public boolean setImagenPrincipal(int catalogoId, int imagenId) {
        // El trigger en PostgreSQL ya se encarga de quitar principal a las demás
        String sql = "UPDATE catalogo_imagenes SET es_principal = true WHERE id = ? AND catalogo_id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, imagenId);
            ps.setInt(2, catalogoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al setear imagen principal: " + e.getMessage());
            return false;
        }
    }

    /**
     * Actualiza el orden de una imagen
     */
    public boolean actualizarOrdenImagen(int imagenId, int nuevoOrden) {
        String sql = "UPDATE catalogo_imagenes SET orden = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nuevoOrden);
            ps.setInt(2, imagenId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CatalogoDAO] Error al actualizar orden: " + e.getMessage());
            return false;
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // MAPPERS
    // ═══════════════════════════════════════════════════════════════════════

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

    /**
     * Mapea un Catalogo Y carga sus imágenes adicionales
     */
    private Catalogo mapearConImagenes(ResultSet rs, Connection con) throws SQLException {
        Catalogo c = mapear(rs);
        // Cargar imágenes adicionales usando la misma conexión
        c.setImagenes(getImagenesByProducto(c.getId()));
        return c;
    }

    private CatalogoImagen mapearImagen(ResultSet rs) throws SQLException {
        return new CatalogoImagen(
                rs.getInt("id"),
                rs.getInt("catalogo_id"),
                rs.getString("ruta_imagen"),
                rs.getInt("orden"),
                rs.getBoolean("es_principal"));
    }
}