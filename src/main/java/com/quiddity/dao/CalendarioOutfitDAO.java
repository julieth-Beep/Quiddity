package com.quiddity.dao;

import com.quiddity.model.CalendarioOutfit;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

public class CalendarioOutfitDAO {

    /** Asignar look a una fecha del calendario */
    public boolean crear(CalendarioOutfit co) throws SQLException {
        String sql = "INSERT INTO calendario_outfit (idusuario, idlook, fecha, orden, momento_dia, ocasion, nota) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, co.getIdUsuario());
            ps.setInt(2, co.getIdLook());
            ps.setDate(3, co.getFecha());
            ps.setInt(4, co.getOrden() == 0 ? 1 : co.getOrden());
            ps.setString(5, co.getMomentoDia());
            ps.setString(6, co.getOcasion());
            ps.setString(7, co.getNota());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    co.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /**
     * Looks asignados a un día específico — con JOIN para traer la imagen.
     * Usado para renderizar cada celda del calendario (Imagen 8).
     */
    public List<CalendarioOutfit> listarPorDia(int idUsuario, Date fecha) throws SQLException {
        List<CalendarioOutfit> lista = new ArrayList<>();
        String sql = "SELECT co.*, lg.imagen_generada, lg.prompt_ia "
                + "FROM calendario_outfit co "
                + "JOIN look_generado lg ON co.idlook = lg.id "
                + "WHERE co.idusuario = ? AND co.fecha = ? "
                + "ORDER BY co.orden";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setDate(2, fecha);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /**
     * Looks de un mes completo — para cargar todo el calendario de una vez.
     * formato mes: "YYYY-MM"
     */
    public List<CalendarioOutfit> listarPorMes(int idUsuario, String mes) throws SQLException {
        YearMonth ym = YearMonth.parse(mes);
        Date inicio = Date.valueOf(ym.atDay(1));
        Date fin = Date.valueOf(ym.atEndOfMonth());

        List<CalendarioOutfit> lista = new ArrayList<>();
        String sql = "SELECT co.*, lg.imagen_generada, lg.prompt_ia "
                + "FROM calendario_outfit co "
                + "JOIN look_generado lg ON co.idlook = lg.id "
                + "WHERE co.idusuario = ? AND co.fecha BETWEEN ? AND ? "
                + "ORDER BY co.fecha, co.orden";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setDate(2, inicio);
            ps.setDate(3, fin);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /** Actualizar nota, momento u ocasión de una asignación */
    public boolean actualizar(CalendarioOutfit co) throws SQLException {
        String sql = "UPDATE calendario_outfit SET momento_dia=?, ocasion=?, nota=? "
                + "WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, co.getMomentoDia());
            ps.setString(2, co.getOcasion());
            ps.setString(3, co.getNota());
            ps.setInt(4, co.getId());
            ps.setInt(5, co.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    /** Quitar look de una fecha del calendario */
    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = "DELETE FROM calendario_outfit WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    private CalendarioOutfit mapear(ResultSet rs) throws SQLException {
        CalendarioOutfit co = new CalendarioOutfit(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getInt("idlook"),
                rs.getDate("fecha"),
                rs.getInt("orden"),
                rs.getString("momento_dia"),
                rs.getString("ocasion"),
                rs.getString("nota"));
        co.setImagenGenerada(rs.getString("imagen_generada"));
        co.setPromptIA(rs.getString("prompt_ia"));
        return co;
    }
}