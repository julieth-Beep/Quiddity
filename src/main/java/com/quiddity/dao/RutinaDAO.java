package com.quiddity.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Rutina;
import com.quiddity.util.ConexionDB;

public class RutinaDAO {

    /**
     * Devuelve las rutinas recomendadas para un usuario según sus
     * características (avatar). Regla de negocio:
     *
     * - Una rutina con un atributo en NULL se considera "universal" para esa
     * característica (aplica a todos). - Si el usuario tiene un valor en una
     * característica (ej. tipo_piel='grasa'), la rutina entra si su tipo_piel
     * coincide EXACTO con ese valor o si es NULL. - Entre las distintas
     * características (piel, cabello, tono, forma de cara, tipo de cuerpo) se
     * combina con AND: la rutina solo se descarta si tiene un valor específico
     * en alguna característica y ese valor no coincide con el del usuario.
     *
     * Si el usuario aún no tiene avatar/características configuradas (caract ==
     * null), se devuelven solo las rutinas 100% universales (todas sus columnas
     * de filtro en NULL).
     *
     * NOTA: las comparaciones usan NULLIF(columna, '') para que una cadena
     * vacía guardada por error en la base se trate igual que NULL (universal),
     * en lugar de excluir la rutina para todo el mundo.
     */
    public List<Rutina> obtenerRecomendadasParaUsuario(Caracteristicas caract) {
        List<Rutina> lista = new ArrayList<>();

        if (caract == null) {
            // Sin perfil: solo universales (todos los campos NULL o '')
            String sql = "SELECT * FROM rutina "
                    + "WHERE NULLIF(tipo_piel, '') IS NULL AND NULLIF(tipo_cabello, '') IS NULL "
                    + "AND NULLIF(tono_piel, '') IS NULL AND NULLIF(forma_cara, '') IS NULL "
                    + "AND NULLIF(tipo_cuerpo, '') IS NULL "
                    + "ORDER BY categoria, nombre";
            try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            } catch (Exception e) {
                System.err.println("[RutinaDAO] Error obtenerRecomendadasParaUsuario (sin caract): " + e.getMessage());
            }
            return lista;
        }

        // Con perfil: la rutina aplica si CADA campo definido en la rutina coincide con el usuario
        // (campos NULL o '' en la rutina = universal para esa característica, siempre pasa)
        String sql = "SELECT * FROM rutina WHERE "
                + "(NULLIF(tipo_piel, '')    IS NULL OR ? IS NULL OR tipo_piel    = ?) AND "
                + "(NULLIF(tipo_cabello, '') IS NULL OR ? IS NULL OR tipo_cabello = ?) AND "
                + "(NULLIF(tono_piel, '')    IS NULL OR ? IS NULL OR tono_piel    = ?) AND "
                + "(NULLIF(forma_cara, '')   IS NULL OR ? IS NULL OR forma_cara   = ?) AND "
                + "(NULLIF(tipo_cuerpo, '')  IS NULL OR ? IS NULL OR tipo_cuerpo  = ?) "
                + "ORDER BY categoria, nombre";

        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, caract.getTipoPiel());
            ps.setString(2, caract.getTipoPiel());
            ps.setString(3, caract.getTipoCabello());
            ps.setString(4, caract.getTipoCabello());
            ps.setString(5, caract.getTonoPiel());
            ps.setString(6, caract.getTonoPiel());
            ps.setString(7, caract.getFormaCara());
            ps.setString(8, caract.getFormaCara());
            ps.setString(9, caract.getTipoCuerpo());
            ps.setString(10, caract.getTipoCuerpo());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error obtenerRecomendadasParaUsuario: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Variante para filtrar además por categoría (ej. solo "Maquillaje" o solo
     * "Cuidado Capilar") manteniendo la misma lógica de match.
     */
    public List<Rutina> obtenerRecomendadasPorCategoria(Caracteristicas caract, String categoria) {
        List<Rutina> lista = new ArrayList<>();

        String sql = "SELECT * FROM rutina WHERE categoria = ? AND "
                + "(NULLIF(tipo_piel, '')    IS NULL OR ? IS NULL OR tipo_piel    = ?) AND "
                + "(NULLIF(tipo_cabello, '') IS NULL OR ? IS NULL OR tipo_cabello = ?) AND "
                + "(NULLIF(tono_piel, '')    IS NULL OR ? IS NULL OR tono_piel    = ?) AND "
                + "(NULLIF(forma_cara, '')   IS NULL OR ? IS NULL OR forma_cara   = ?) AND "
                + "(NULLIF(tipo_cuerpo, '')  IS NULL OR ? IS NULL OR tipo_cuerpo  = ?) "
                + "ORDER BY nombre";

        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);
            ps.setString(2, caract != null ? caract.getTipoPiel() : null);
            ps.setString(3, caract != null ? caract.getTipoPiel() : null);
            ps.setString(4, caract != null ? caract.getTipoCabello() : null);
            ps.setString(5, caract != null ? caract.getTipoCabello() : null);
            ps.setString(6, caract != null ? caract.getTonoPiel() : null);
            ps.setString(7, caract != null ? caract.getTonoPiel() : null);
            ps.setString(8, caract != null ? caract.getFormaCara() : null);
            ps.setString(9, caract != null ? caract.getFormaCara() : null);
            ps.setString(10, caract != null ? caract.getTipoCuerpo() : null);
            ps.setString(11, caract != null ? caract.getTipoCuerpo() : null);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error obtenerRecomendadasPorCategoria: " + e.getMessage());
        }

        return lista;
    }

    public List<Rutina> obtenerTodas() {
        List<Rutina> lista = new ArrayList<>();
        String sql = "SELECT * FROM rutina ORDER BY categoria, nombre";

        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error obtenerTodas: " + e.getMessage());
        }
        return lista;
    }

    public Rutina obtenerPorId(int id) {
        String sql = "SELECT * FROM rutina WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error obtenerPorId: " + e.getMessage());
        }
        return null;
    }

    public boolean marcarFavorito(int idRutina, boolean favorito) {
        String sql = "UPDATE rutina SET favoritos = ? WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, favorito ? "true" : "false");
            ps.setInt(2, idRutina);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error marcarFavorito: " + e.getMessage());
            return false;
        }
    }

    public boolean guardar(Rutina r) {
        String sql = "INSERT INTO rutina (nombre, objetivo, url, favoritos, categoria, subcategoria, "
                + "tipo_piel, tipo_cabello, tono_piel, forma_cara, tipo_cuerpo) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getNombre());
            ps.setString(2, r.getObjetivo());
            ps.setString(3, r.getUrl());
            ps.setString(4, r.getFavoritos() != null ? r.getFavoritos() : "false");
            ps.setString(5, r.getCategoria());
            ps.setString(6, r.getSubcategoria());
            ps.setString(7, emptyToNull(r.getTipoPiel()));
            ps.setString(8, emptyToNull(r.getTipoCabello()));
            ps.setString(9, emptyToNull(r.getTonoPiel()));
            ps.setString(10, emptyToNull(r.getFormaCara()));
            ps.setString(11, emptyToNull(r.getTipoCuerpo()));
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error guardar: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Rutina r) {
        String sql = "UPDATE rutina SET nombre=?, objetivo=?, url=?, favoritos=?, categoria=?, subcategoria=?, "
                + "tipo_piel=?, tipo_cabello=?, tono_piel=?, forma_cara=?, tipo_cuerpo=? WHERE id=?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getNombre());
            ps.setString(2, r.getObjetivo());
            ps.setString(3, r.getUrl());
            ps.setString(4, r.getFavoritos() != null ? r.getFavoritos() : "false");
            ps.setString(5, r.getCategoria());
            ps.setString(6, r.getSubcategoria());
            ps.setString(7, emptyToNull(r.getTipoPiel()));
            ps.setString(8, emptyToNull(r.getTipoCabello()));
            ps.setString(9, emptyToNull(r.getTonoPiel()));
            ps.setString(10, emptyToNull(r.getFormaCara()));
            ps.setString(11, emptyToNull(r.getTipoCuerpo()));
            ps.setInt(12, r.getId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error actualizar: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM rutina WHERE id = ?";
        try (Connection con = ConexionDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[RutinaDAO] Error eliminar: " + e.getMessage());
            return false;
        }
    }

    /**
     * Convierte cadenas vacías o solo espacios en NULL, para que las
     * características "sin valor" se guarden siempre como NULL real y no
     * rompan el match de rutinas universales/generales.
     */
    private String emptyToNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    private Rutina mapear(ResultSet rs) throws SQLException {
        Rutina r = new Rutina();
        r.setId(rs.getInt("id"));
        r.setIdUsuario(rs.getInt("idusuario"));
        r.setNombre(rs.getString("nombre"));
        r.setObjetivo(rs.getString("objetivo"));
        r.setUrl(rs.getString("url"));
        r.setFavoritos(rs.getString("favoritos"));
        r.setCategoria(rs.getString("categoria"));
        r.setSubcategoria(rs.getString("subcategoria"));
        r.setTipoPiel(rs.getString("tipo_piel"));
        r.setTipoCabello(rs.getString("tipo_cabello"));
        r.setTonoPiel(rs.getString("tono_piel"));
        r.setFormaCara(rs.getString("forma_cara"));
        r.setTipoCuerpo(rs.getString("tipo_cuerpo"));
        return r;
    }
}