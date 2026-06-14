package com.quiddity.dao;

import com.quiddity.model.OutfitPrenda;
import com.quiddity.model.Prenda;
import com.quiddity.util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OutfitPrendaDAO {

    // ✅ Agregar prenda al outfit — valida que prenda y outfit son del usuario
    public boolean agregar(OutfitPrenda op, int idUsuario) throws SQLException {
        // Verificar que el outfit pertenece al usuario
        String checkOutfit = "SELECT id FROM outfit WHERE id=? AND idusuario=?";
        // Verificar que la prenda pertenece al usuario
        String checkPrenda = "SELECT id FROM prenda WHERE id=? AND idusuario=?";
        String sql = "INSERT INTO outfitprenda (idoutfit, idprenda) VALUES (?, ?)";

        try (Connection con = ConexionDB.getConnection()) {
            // Validar outfit
            try (PreparedStatement ps = con.prepareStatement(checkOutfit)) {
                ps.setInt(1, op.getIdOutfit());
                ps.setInt(2, idUsuario);
                if (!ps.executeQuery().next())
                    return false;
            }
            // Validar prenda
            try (PreparedStatement ps = con.prepareStatement(checkPrenda)) {
                ps.setInt(1, op.getIdPrenda());
                ps.setInt(2, idUsuario);
                if (!ps.executeQuery().next())
                    return false;
            }
            // Insertar relación
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, op.getIdOutfit());
                ps.setInt(2, op.getIdPrenda());
                return ps.executeUpdate() > 0;
            }
        }
    }

    // ✅ Listar prendas de un outfit con JOIN — validando usuario
    public List<OutfitPrenda> listarPorOutfit(int idOutfit, int idUsuario) throws SQLException {
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
                OutfitPrenda op = new OutfitPrenda(
                        rs.getInt("id"),
                        rs.getInt("idoutfit"),
                        rs.getInt("idprenda"));
                Prenda p = new Prenda(
                        rs.getInt("idprenda"),
                        rs.getInt("idusuario"),
                        rs.getString("tipo"),
                        rs.getString("color"),
                        rs.getString("estilo"),
                        rs.getString("imagen"),
                        rs.getString("temporada"));
                op.setPrenda(p);
                lista.add(op);
            }
        }
        return lista;
    }

    // ✅ Eliminar prenda del outfit — validando usuario
    public boolean eliminar(int id, int idUsuario) throws SQLException {
        String sql = """
                DELETE FROM outfitprenda
                WHERE id = ?
                AND idoutfit IN (SELECT id FROM outfit WHERE idusuario = ?)
                """;
        try (Connection con = ConexionDB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }
}