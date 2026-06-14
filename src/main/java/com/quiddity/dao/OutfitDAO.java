package com.quiddity.dao;

import com.quiddity.model.Outfit;
import com.quiddity.model.OutfitPrenda;
import com.quiddity.model.Prenda;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OutfitDAO {

    // ── OUTFIT ────────────────────────────────────────────────────────────────

    /** Crear outfit vacío — se le agregan prendas después */
    public boolean crear(Outfit o) throws SQLException {
        String sql = "INSERT INTO outfit (clima, ocasion, idusuario) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, o.getClima());
            ps.setString(2, o.getOcasion());
            ps.setInt(3, o.getIdUsuario());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    o.setId(rs.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Listar todos los outfits del usuario */
    public List<Outfit> listarPorUsuario(int idUsuario) throws SQLException {
        List<Outfit> lista = new ArrayList<>();
        String sql = "SELECT * FROM outfit WHERE idusuario = ? ORDER BY id DESC";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    /**
     * Obtener outfit CON sus prendas incluidas (JOIN completo).
     * Usado antes de generar el look con IA.
     */
    public Outfit obtenerConPrendas(int idOutfit, int idUsuario) throws SQLException {
        String sqlOutfit = "SELECT * FROM outfit WHERE id = ? AND idusuario = ?";
        String sqlPrendas = """
                SELECT p.* FROM prenda p
                JOIN outfitprenda op ON p.id = op.idprenda
                WHERE op.idoutfit = ?
                """;

        try (Connection con = ConexionDB.getConnection()) {
            Outfit outfit = null;

            try (PreparedStatement ps = con.prepareStatement(sqlOutfit)) {
                ps.setInt(1, idOutfit);
                ps.setInt(2, idUsuario);
                ResultSet rs = ps.executeQuery();
                if (rs.next())
                    outfit = mapear(rs);
            }

            if (outfit == null)
                return null;

            List<Prenda> prendas = new ArrayList<>();
            try (PreparedStatement ps = con.prepareStatement(sqlPrendas)) {
                ps.setInt(1, idOutfit);
                ResultSet rs = ps.executeQuery();
                while (rs.next())
                    prendas.add(mapearPrenda(rs));
            }
            outfit.setPrendas(prendas);
            return outfit;
        }
    }

    public Outfit obtenerPorIdYUsuario(int id, int idUsuario) throws SQLException {
        String sql = "SELECT * FROM outfit WHERE id = ? AND idusuario = ?";
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

    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = "DELETE FROM outfit WHERE id=? AND idusuario=?";
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    // ── OUTFIT PRENDA (relación) ───────────────────────────────────────────────

    /** Agregar prenda al outfit validando que ambos son del usuario */
    public boolean agregarPrenda(OutfitPrenda op, int idUsuario) throws SQLException {
        String checkOutfit = "SELECT id FROM outfit WHERE id=? AND idusuario=?";
        String checkPrenda = "SELECT id FROM prenda WHERE id=? AND idusuario=?";
        String sql = "INSERT INTO outfitprenda (idoutfit, idprenda) VALUES (?, ?)";

        try (Connection con = ConexionDB.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(checkOutfit)) {
                ps.setInt(1, op.getIdOutfit());
                ps.setInt(2, idUsuario);
                if (!ps.executeQuery().next())
                    return false;
            }
            try (PreparedStatement ps = con.prepareStatement(checkPrenda)) {
                ps.setInt(1, op.getIdPrenda());
                ps.setInt(2, idUsuario);
                if (!ps.executeQuery().next())
                    return false;
            }
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, op.getIdOutfit());
                ps.setInt(2, op.getIdPrenda());
                return ps.executeUpdate() > 0;
            }
        }
    }

    /** Listar prendas de un outfit con JOIN */
    public List<OutfitPrenda> listarPrendasDeOutfit(int idOutfit, int idUsuario) throws SQLException {
        List<OutfitPrenda> lista = new ArrayList<>();
        String sql = """
                SELECT op.id, op.idoutfit, op.idprenda,
                       p.idusuario, p.tipo, p.color, p.estilo, p.imagen, p.temporada
                FROM outfitprenda op
                JOIN prenda p ON op.idprenda = p.id
                JOIN outfit o ON op.idoutfit = o.id
                WHERE op.idoutfit = ? AND o.idusuario = ?
                """;
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idOutfit);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OutfitPrenda op = new OutfitPrenda(rs.getInt("id"), rs.getInt("idoutfit"), rs.getInt("idprenda"));
                Prenda p = mapearPrenda(rs);
                op.setPrenda(p);
                lista.add(op);
            }
        }
        return lista;
    }

    /** Eliminar prenda del outfit validando usuario */
    public boolean eliminarPrenda(int idRelacion, int idUsuario) throws SQLException {
        String sql = """
                DELETE FROM outfitprenda
                WHERE id = ? AND idoutfit IN (SELECT id FROM outfit WHERE idusuario = ?)
                """;
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idRelacion);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    // ── MAPEO ─────────────────────────────────────────────────────────────────

    private Outfit mapear(ResultSet rs) throws SQLException {
        return new Outfit(
                rs.getInt("id"),
                rs.getString("clima"),
                rs.getString("ocasion"),
                rs.getInt("idusuario"));
    }

    private Prenda mapearPrenda(ResultSet rs) throws SQLException {
        return new Prenda(
                rs.getInt("idprenda"),
                rs.getInt("idusuario"),
                rs.getString("tipo"),
                rs.getString("color"),
                rs.getString("estilo"),
                rs.getString("imagen"),
                rs.getString("temporada"));
    }
}