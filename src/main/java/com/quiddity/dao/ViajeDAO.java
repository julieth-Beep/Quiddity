package com.quiddity.dao;

import com.quiddity.model.Prenda;
import com.quiddity.model.Viaje;
import com.quiddity.model.ViajeOutfit;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ViajeDAO {

    // ── VIAJE ─────────────────────────────────────────────────────────────────

    /** Crear viaje nuevo */
    public boolean crear(Viaje v) throws SQLException {
        String sql = "INSERT INTO viaje (idusuario, destino, fecha_inicio, fecha_fin, clima_esperado, latitud, longitud, notas) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, v.getIdUsuario());
            ps.setString(2, v.getDestino());
            ps.setDate(3, v.getFechaInicio());
            ps.setDate(4, v.getFechaFin());
            ps.setString(5, v.getClimaEsperado());
            if (v.getLatitud() != null)
                ps.setDouble(6, v.getLatitud());
            else
                ps.setNull(6, Types.DOUBLE);
            if (v.getLongitud() != null)
                ps.setDouble(7, v.getLongitud());
            else
                ps.setNull(7, Types.DOUBLE);
            ps.setString(8, v.getNotas());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    v.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Todos los viajes del usuario ordenados por fecha más próxima */
    public List<Viaje> listarPorUsuario(int idUsuario) throws SQLException {
        List<Viaje> lista = new ArrayList<>();
        String sql = "SELECT * FROM viaje WHERE idusuario = ? ORDER BY fecha_inicio DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    public Viaje obtenerPorIdYUsuario(int id, int idUsuario) throws SQLException {
        String sql = "SELECT * FROM viaje WHERE id = ? AND idusuario = ?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        }
        return null;
    }

    public boolean actualizar(Viaje v) throws SQLException {
        String sql = "UPDATE viaje SET destino=?, fecha_inicio=?, fecha_fin=?, clima_esperado=?, "
                + "latitud=?, longitud=?, notas=? WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getDestino());
            ps.setDate(2, v.getFechaInicio());
            ps.setDate(3, v.getFechaFin());
            ps.setString(4, v.getClimaEsperado());
            if (v.getLatitud() != null)
                ps.setDouble(5, v.getLatitud());
            else
                ps.setNull(5, Types.DOUBLE);
            if (v.getLongitud() != null)
                ps.setDouble(6, v.getLongitud());
            else
                ps.setNull(6, Types.DOUBLE);
            ps.setString(7, v.getNotas());
            ps.setInt(8, v.getId());
            ps.setInt(9, v.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = "DELETE FROM viaje WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    // ── VIAJE OUTFIT ──────────────────────────────────────────────────────────

    /** Asignar look generado a un día del viaje (Imagen 10) */
    public boolean asignarLook(ViajeOutfit vo) throws SQLException {
        String sql = "INSERT INTO viaje_outfit (idviaje, idoutfit, idlook_generado, dia, motivo, tipo) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, vo.getIdViaje());
            if (vo.getIdOutfit() != null)
                ps.setInt(2, vo.getIdOutfit());
            else
                ps.setNull(2, Types.INTEGER);
            if (vo.getIdLookGenerado() != null)
                ps.setInt(3, vo.getIdLookGenerado());
            else
                ps.setNull(3, Types.INTEGER);
            ps.setDate(4, vo.getDia());
            ps.setString(5, vo.getMotivo());
            ps.setString(6, vo.getTipo() != null ? vo.getTipo() : "look");
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    vo.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /**
     * Listar todos los outfits/looks de un viaje con JOIN.
     * Devuelve imagen, prompt, clima y ocasión para mostrar en la UI (Imagen 10).
     */
    public List<ViajeOutfit> listarOutfitsDelViaje(int idViaje, int idUsuario) throws SQLException {
        List<ViajeOutfit> lista = new ArrayList<>();

        // Validar que el viaje pertenece al usuario
        if (obtenerPorIdYUsuario(idViaje, idUsuario) == null)
            return lista;

        String sql = "SELECT vo.*, "
                + "o.clima AS outfit_clima, o.ocasion AS outfit_ocasion, "
                + "lg.imagen_generada, lg.prompt_ia "
                + "FROM viaje_outfit vo "
                + "LEFT JOIN outfit o       ON vo.idoutfit = o.id "
                + "LEFT JOIN look_generado lg ON vo.idlook_generado = lg.id "
                + "WHERE vo.idviaje = ? "
                + "ORDER BY vo.dia";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ViajeOutfit vo = mapearViajeOutfit(rs);
                lista.add(vo);
            }
        }
        return lista;
    }

    /** Quitar look de un día del viaje */
    public boolean eliminarOutfit(int idViajeOutfit, int idUsuario) throws SQLException {
        String sql = "DELETE FROM viaje_outfit "
                + "WHERE id = ? AND idviaje IN (SELECT id FROM viaje WHERE idusuario = ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idViajeOutfit);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Recomendar prendas del closet según clima del viaje.
     * Devuelve prendas cuya temporada coincide con el clima detectado.
     */
    public List<Prenda> recomendarPrendas(int idUsuario, String climaEsperado) throws SQLException {
        List<Prenda> lista = new ArrayList<>();
        // Mapear clima → temporada
        String temporada = mapearClimaATemporada(climaEsperado);
        String sql = "SELECT * FROM prenda WHERE idusuario = ? "
                + "AND (temporada = ? OR temporada = 'todas') ORDER BY tipo";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, temporada);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapearPrenda(rs));
        }
        return lista;
    }

    // ── MAPEO ─────────────────────────────────────────────────────────────────

    private Viaje mapear(ResultSet rs) throws SQLException {
        return new Viaje(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getString("destino"),
                rs.getDate("fecha_inicio"),
                rs.getDate("fecha_fin"),
                rs.getString("clima_esperado"),
                rs.getObject("latitud") != null ? rs.getDouble("latitud") : null,
                rs.getObject("longitud") != null ? rs.getDouble("longitud") : null,
                rs.getString("notas"),
                rs.getTimestamp("creado_en"));
    }

    private ViajeOutfit mapearViajeOutfit(ResultSet rs) throws SQLException {
        ViajeOutfit vo = new ViajeOutfit(
                rs.getInt("id"),
                rs.getInt("idviaje"),
                rs.getObject("idoutfit") != null ? rs.getInt("idoutfit") : null,
                rs.getObject("idlook_generado") != null ? rs.getInt("idlook_generado") : null,
                rs.getDate("dia"),
                rs.getString("motivo"),
                rs.getString("tipo"));
        vo.setClimaOutfit(rs.getString("outfit_clima"));
        vo.setOcasionOutfit(rs.getString("outfit_ocasion"));
        vo.setImagenGenerada(rs.getString("imagen_generada"));
        vo.setPromptIA(rs.getString("prompt_ia"));
        return vo;
    }

    private Prenda mapearPrenda(ResultSet rs) throws SQLException {
        return new Prenda(
                rs.getInt("id"),
                rs.getInt("idusuario"),
                rs.getString("tipo"),
                rs.getString("color"),
                rs.getString("estilo"),
                rs.getString("imagen"),
                rs.getString("temporada"));
    }

    private String mapearClimaATemporada(String clima) {
        if (clima == null)
            return "todas";
        String c = clima.toLowerCase();
        if (c.contains("frio") || c.contains("frío") || c.contains("nieve") || c.contains("neva"))
            return "invierno";
        if (c.contains("calor") || c.contains("caluroso") || c.contains("sol"))
            return "verano";
        if (c.contains("lluv") || c.contains("fresc"))
            return "otono";
        if (c.contains("templa"))
            return "primavera";
        return "todas";
    }
}