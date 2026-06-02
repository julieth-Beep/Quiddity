package com.quiddity.dao;

import com.quiddity.model.Rutina;
import com.quiddity.model.RutinaPaso;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RutinaDAO {

    // ══════════════════════════════════════════════
    //  RUTINA — CRUD
    // ══════════════════════════════════════════════

    /**
     * Crea una rutina con sus pasos en una sola transacción.
     * Retorna el id generado, o -1 si falla.
     */
    public int crear(Rutina rutina, List<RutinaPaso> pasos) {
        String sqlRutina = "INSERT INTO rutina (idusuario, nombre, objetivo) VALUES (?, ?, ?)";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            int idRutina;
            try (PreparedStatement ps = con.prepareStatement(sqlRutina, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, rutina.getIdUsuario());
                ps.setString(2, rutina.getNombre());
                ps.setString(3, rutina.getObjetivo());
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) {
                    con.rollback();
                    return -1;
                }
                idRutina = keys.getInt(1);
            }

            if (pasos != null && !pasos.isEmpty()) {
                insertarPasos(con, idRutina, pasos);
            }

            con.commit();
            return idRutina;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error crear: " + e.getMessage());
            e.printStackTrace();
            rollback(con);
            return -1;
        } finally {
            ConexionDB.close(con);
        }
    }

    /**
     * Crea una rutina sin pasos.
     */
    public int crear(Rutina rutina) {
        return crear(rutina, null);
    }

    /**
     * Obtiene una rutina por su id.
     */
    public Rutina obtenerPorId(int id) {
        String sql = "SELECT * FROM rutina WHERE id = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapearRutina(rs);

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error obtenerPorId: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lista todas las rutinas de un usuario.
     */
    public List<Rutina> listarPorUsuario(int idUsuario) {
        List<Rutina> lista = new ArrayList<>();
        String sql = "SELECT * FROM rutina WHERE idusuario = ? ORDER BY id DESC";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapearRutina(rs));

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error listarPorUsuario: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Lista todas las rutinas (uso administrativo).
     */
    public List<Rutina> listarTodas() {
        List<Rutina> lista = new ArrayList<>();
        String sql = "SELECT * FROM rutina ORDER BY id DESC";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapearRutina(rs));

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error listarTodas: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Actualiza nombre y objetivo de una rutina.
     */
    public boolean actualizar(Rutina rutina) {
        String sql = "UPDATE rutina SET nombre = ?, objetivo = ? WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rutina.getNombre());
            ps.setString(2, rutina.getObjetivo());
            ps.setInt(3, rutina.getId());
            ps.setInt(4, rutina.getIdUsuario());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error actualizar: " + e.getMessage());
            return false;
        }
    }

    /**
     * Actualiza la rutina y reemplaza completamente sus pasos.
     */
    public boolean actualizarConPasos(Rutina rutina, List<RutinaPaso> pasos) {
        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // 1. Actualizar cabecera
            String sqlRutina = "UPDATE rutina SET nombre = ?, objetivo = ? WHERE id = ? AND idusuario = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlRutina)) {
                ps.setString(1, rutina.getNombre());
                ps.setString(2, rutina.getObjetivo());
                ps.setInt(3, rutina.getId());
                ps.setInt(4, rutina.getIdUsuario());
                if (ps.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 2. Borrar pasos anteriores
            eliminarPasos(con, rutina.getId());

            // 3. Insertar los nuevos pasos
            if (pasos != null && !pasos.isEmpty()) {
                insertarPasos(con, rutina.getId(), pasos);
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error actualizarConPasos: " + e.getMessage());
            e.printStackTrace();
            rollback(con);
            return false;
        } finally {
            ConexionDB.close(con);
        }
    }

    /**
     * Elimina una rutina y en cascada sus pasos.
     */
    public boolean eliminar(int idRutina, int idUsuario) {
        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // Verificar que la rutina pertenece al usuario
            String sqlCheck = "SELECT id FROM rutina WHERE id = ? AND idusuario = ? LIMIT 1";
            try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
                ps.setInt(1, idRutina);
                ps.setInt(2, idUsuario);
                if (!ps.executeQuery().next()) {
                    con.rollback();
                    return false;
                }
            }

            eliminarPasos(con, idRutina);

            String sqlRutina = "DELETE FROM rutina WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlRutina)) {
                ps.setInt(1, idRutina);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error eliminar: " + e.getMessage());
            e.printStackTrace();
            rollback(con);
            return false;
        } finally {
            ConexionDB.close(con);
        }
    }

    public long contarPorUsuario(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM rutina WHERE idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong(1);

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error contarPorUsuario: " + e.getMessage());
        }
        return 0;
    }

    // ══════════════════════════════════════════════
    //  RUTINA PASO — operaciones individuales
    // ══════════════════════════════════════════════

    /**
     * Lista los pasos de una rutina ordenados por el campo orden.
     */
    public List<RutinaPaso> listarPasos(int idRutina) {
        List<RutinaPaso> pasos = new ArrayList<>();
        String sql = "SELECT * FROM rutinapaso WHERE idrutina = ? ORDER BY orden ASC";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idRutina);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) pasos.add(mapearPaso(rs));

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error listarPasos: " + e.getMessage());
        }
        return pasos;
    }

    /**
     * Agrega un paso a una rutina existente.
     * El orden se asigna automáticamente como (máximo actual + 1).
     */
    public boolean agregarPaso(RutinaPaso paso) {
        String sqlOrden = "SELECT COALESCE(MAX(orden), 0) + 1 FROM rutinapaso WHERE idrutina = ?";
        String sqlInsert = "INSERT INTO rutinapaso (idrutina, orden, descripcion) VALUES (?, ?, ?)";

        try (Connection con = ConexionDB.getConnection()) {
            int siguienteOrden;
            try (PreparedStatement ps = con.prepareStatement(sqlOrden)) {
                ps.setInt(1, paso.getIdRutina());
                ResultSet rs = ps.executeQuery();
                siguienteOrden = rs.next() ? rs.getInt(1) : 1;
            }

            try (PreparedStatement ps = con.prepareStatement(sqlInsert)) {
                ps.setInt(1, paso.getIdRutina());
                ps.setInt(2, siguienteOrden);
                ps.setString(3, paso.getDescripcion());
                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error agregarPaso: " + e.getMessage());
            return false;
        }
    }

    /**
     * Actualiza la descripción y el orden de un paso.
     */
    public boolean actualizarPaso(RutinaPaso paso) {
        String sql = "UPDATE rutinapaso SET descripcion = ?, orden = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, paso.getDescripcion());
            ps.setInt(2, paso.getOrden());
            ps.setInt(3, paso.getId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error actualizarPaso: " + e.getMessage());
            return false;
        }
    }

    /**
     * Elimina un paso específico por su id.
     */
    public boolean eliminarPaso(int idPaso) {
        String sql = "DELETE FROM rutinapaso WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPaso);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error eliminarPaso: " + e.getMessage());
            return false;
        }
    }

    // ══════════════════════════════════════════════
    //  HELPERS PRIVADOS
    // ══════════════════════════════════════════════

    private void insertarPasos(Connection con, int idRutina, List<RutinaPaso> pasos) throws SQLException {
        String sql = "INSERT INTO rutinapaso (idrutina, orden, descripcion) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < pasos.size(); i++) {
                RutinaPaso p = pasos.get(i);
                ps.setInt(1, idRutina);
                ps.setInt(2, p.getOrden() > 0 ? p.getOrden() : i + 1);
                ps.setString(3, p.getDescripcion());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void eliminarPasos(Connection con, int idRutina) throws SQLException {
        String sql = "DELETE FROM rutinapaso WHERE idrutina = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idRutina);
            ps.executeUpdate();
        }
    }

    private void rollback(Connection con) {
        if (con != null) {
            try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    private Rutina mapearRutina(ResultSet rs) throws SQLException {
        Rutina r = new Rutina();
        r.setId(rs.getInt("id"));
        r.setIdUsuario(rs.getInt("idusuario"));
        r.setNombre(rs.getString("nombre"));
        r.setObjetivo(rs.getString("objetivo"));
        return r;
    }

    private RutinaPaso mapearPaso(ResultSet rs) throws SQLException {
        RutinaPaso p = new RutinaPaso();
        p.setId(rs.getInt("id"));
        p.setIdRutina(rs.getInt("idrutina"));
        p.setOrden(rs.getInt("orden"));
        p.setDescripcion(rs.getString("descripcion"));
        return p;
    }
}