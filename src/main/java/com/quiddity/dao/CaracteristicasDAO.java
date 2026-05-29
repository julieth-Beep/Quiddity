package com.quiddity.dao;

import com.quiddity.model.Caracteristicas;
import com.quiddity.util.ConexionDB;

import java.sql.*;
<<<<<<< HEAD

public class CaracteristicasDAO {

    // ─────────────────────────────────────────────
    // Obtener caracteristicas por usuario (via avatar)
    // ─────────────────────────────────────────────
    public Caracteristicas obtenerPorUsuario(int idUsuario) {
        String sql = "SELECT c.* FROM caracteristicas c " +
                     "INNER JOIN avatar a ON a.idcaracteristicas = c.id " +
                     "WHERE a.idusuario = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
=======
import java.util.ArrayList;
import java.util.List;

public class CaracteristicasDAO {

    public int crear(Caracteristicas c) {
        String sql = "INSERT INTO caracteristicas (tonopiel, formacara, tipocuerpo, tipocabello, tipopiel) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getTonoPiel());
            ps.setString(2, c.getFormaCara());
            ps.setString(3, c.getTipoCuerpo());
            ps.setString(4, c.getTipoCabello());
            ps.setString(5, c.getTipoPiel());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error crear: " + e.getMessage());
        }
        return -1;
    }

    public Caracteristicas obtenerPorUsuario(int idUsuario) {
        String sql = "SELECT c.* FROM caracteristicas c " +
                "INNER JOIN avatar a ON a.idcaracteristicas = c.id " +
                "WHERE a.idusuario = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error obtenerPorUsuario: " + e.getMessage());
        }
        return null;
    }

    // ─────────────────────────────────────────────
    // Crear caracteristicas + vincular en avatar
    // ─────────────────────────────────────────────
    public boolean crearParaUsuario(int idUsuario, Caracteristicas c) {
        String sqlCaract = "INSERT INTO caracteristicas (tonopiel, formacara, tipocuerpo, tipocabello, tipopiel) " +
<<<<<<< HEAD
                           "VALUES (?, ?, ?, ?, ?)";
=======
                "VALUES (?, ?, ?, ?, ?)";
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
        String sqlAvatar = "INSERT INTO avatar (idusuario, idcaracteristicas) VALUES (?, ?)";

        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            int idCaract;
            try (PreparedStatement ps = con.prepareStatement(sqlCaract, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, c.getTonoPiel());
                ps.setString(2, c.getFormaCara());
                ps.setString(3, c.getTipoCuerpo());
                ps.setString(4, c.getTipoCabello());
                ps.setString(5, c.getTipoPiel());
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
<<<<<<< HEAD
                if (!keys.next()) { con.rollback(); return false; }
=======
                if (!keys.next()) {
                    con.rollback();
                    return false;
                }
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
                idCaract = keys.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement(sqlAvatar)) {
                ps.setInt(1, idUsuario);
                ps.setInt(2, idCaract);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error crearParaUsuario: " + e.getMessage());
<<<<<<< HEAD
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
=======
            if (con != null)
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
            return false;
        } finally {
            ConexionDB.close(con);
        }
    }

<<<<<<< HEAD
=======
    public List<Caracteristicas> obtenerTodos() {
        List<Caracteristicas> lista = new ArrayList<>();
        String sql = "SELECT * FROM caracteristicas ORDER BY id DESC";

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error obtenerTodos: " + e.getMessage());
        }
        return lista;
    }

    public List<Caracteristicas> buscar(String criterio) {
        List<Caracteristicas> lista = new ArrayList<>();
        String sql = "SELECT * FROM caracteristicas WHERE " +
                "tonopiel ILIKE ? OR formacara ILIKE ? OR tipocuerpo ILIKE ? OR " +
                "tipocabello ILIKE ? OR tipopiel ILIKE ? " +
                "ORDER BY id DESC";

        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String like = "%" + criterio + "%";
            for (int i = 1; i <= 5; i++) {
                ps.setString(i, like);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error buscar: " + e.getMessage());
        }
        return lista;
    }

>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    // ─────────────────────────────────────────────
    // Actualizar solo formacara (usado por el escaneo facial)
    // ─────────────────────────────────────────────
    public boolean actualizarFormaCara(int idUsuario, String formaCara) {
        Caracteristicas existente = obtenerPorUsuario(idUsuario);

        if (existente != null) {
            String sql = "UPDATE caracteristicas SET formacara = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
<<<<<<< HEAD
                 PreparedStatement ps = con.prepareStatement(sql)) {
=======
                    PreparedStatement ps = con.prepareStatement(sql)) {
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
                ps.setString(1, formaCara);
                ps.setInt(2, existente.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                System.err.println("[CaracteristicasDAO] Error actualizarFormaCara: " + e.getMessage());
                return false;
            }
        } else {
            Caracteristicas nueva = new Caracteristicas();
            nueva.setFormaCara(formaCara);
            return crearParaUsuario(idUsuario, nueva);
        }
    }

<<<<<<< HEAD
=======
    public Caracteristicas obtenerPorId(int id) {
        String sql = "SELECT * FROM caracteristicas WHERE id = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error obtenerPorId: " + e.getMessage());
        }
        return null;
    }

>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    // ─────────────────────────────────────────────
    // Actualizar todas las características
    // ─────────────────────────────────────────────
    public boolean actualizar(Caracteristicas c) {
        String sql = "UPDATE caracteristicas SET tonopiel = ?, formacara = ?, tipocuerpo = ?, " +
<<<<<<< HEAD
                     "tipocabello = ?, tipopiel = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
=======
                "tipocabello = ?, tipopiel = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
            ps.setString(1, c.getTonoPiel());
            ps.setString(2, c.getFormaCara());
            ps.setString(3, c.getTipoCuerpo());
            ps.setString(4, c.getTipoCabello());
            ps.setString(5, c.getTipoPiel());
            ps.setInt(6, c.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error actualizar: " + e.getMessage());
            return false;
        }
    }

<<<<<<< HEAD
    // ─────────────────────────────────────────────
    // MAPPER
    // ─────────────────────────────────────────────
=======
    public boolean eliminarPorUsuario(int idUsuario) {
        Connection con = null;
        try {
            con = ConexionDB.getConnection();
            con.setAutoCommit(false);

            // 1. Obtener el id de características vinculado al usuario
            Integer idCaract = null;
            String sqlSelect = "SELECT idcaracteristicas FROM avatar WHERE idusuario = ? LIMIT 1";
            try (PreparedStatement ps = con.prepareStatement(sqlSelect)) {
                ps.setInt(1, idUsuario);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    idCaract = rs.getInt("idcaracteristicas");
                }
            }

            if (idCaract != null) {
                // 2. Eliminar referencia en avatar
                try (PreparedStatement ps = con.prepareStatement("DELETE FROM avatar WHERE idusuario = ?")) {
                    ps.setInt(1, idUsuario);
                    ps.executeUpdate();
                }

                // 3. Eliminar características
                try (PreparedStatement ps = con.prepareStatement("DELETE FROM caracteristicas WHERE id = ?")) {
                    ps.setInt(1, idCaract);
                    ps.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error eliminarPorUsuario: " + e.getMessage());
            if (con != null)
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            return false;
        } finally {
            ConexionDB.close(con);
        }
    }

    // Verifica si un registro existe por ID
    public boolean existe(int id) {
        String sql = "SELECT 1 FROM caracteristicas WHERE id = ? LIMIT 1";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error existe: " + e.getMessage());
            return false;
        }
    }

    public long contar() {
        String sql = "SELECT COUNT(*) FROM caracteristicas";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getLong(1);
        } catch (Exception e) {
            System.err.println("[CaracteristicasDAO] Error contar: " + e.getMessage());
        }
        return 0;
    }

    public void actualizarTonoPiel(int idUsuario, String tonoPiel) {
        Caracteristicas existente = obtenerPorUsuario(idUsuario);

        if (existente != null) {
            String sql = "UPDATE caracteristicas SET tonopiel = ? WHERE id = ?";
            try (Connection con = ConexionDB.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, tonoPiel);
                ps.setInt(2, existente.getId());
                ps.executeUpdate();
            } catch (Exception e) {
                System.err.println("[CaracteristicasDAO] Error actualizarTonoPiel: " + e.getMessage());
            }
        } else {
            Caracteristicas nueva = new Caracteristicas();
            nueva.setTonoPiel(tonoPiel);
            crearParaUsuario(idUsuario, nueva);
        }
    }

    // MAPPER
>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
    private Caracteristicas mapear(ResultSet rs) throws SQLException {
        Caracteristicas c = new Caracteristicas();
        c.setId(rs.getInt("id"));
        c.setTonoPiel(rs.getString("tonopiel"));
        c.setFormaCara(rs.getString("formacara"));
        c.setTipoCuerpo(rs.getString("tipocuerpo"));
        c.setTipoCabello(rs.getString("tipocabello"));
        c.setTipoPiel(rs.getString("tipopiel"));
        return c;
    }
<<<<<<< HEAD
=======

>>>>>>> 5eb99d191c19e43d122b59f68bfb5dbbe3e1bfd4
}