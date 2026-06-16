package com.quiddity.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.LookGeneradoDAO;
import com.quiddity.dao.PedidoDAO;
import com.quiddity.dao.PrendaDAO;
import com.quiddity.dao.RutinaDAO;
import com.quiddity.dao.UsuarioDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.LookGenerado;
import com.quiddity.model.Pedido;
import com.quiddity.model.Prenda;
import com.quiddity.model.Rutina;
import com.quiddity.model.Usuario;

/**
 * UsuarioDashboardServlet
 *
 * GET /panel → dashboard personal del usuario autenticado con rol USUARIO
 *
 * Carga todos los datos necesarios para el dashboard:
 *   - Características del perfil (tipo de piel, forma de cara, tono)
 *   - KPIs: pedidos, prendas en closet, rutinas, looks favoritos
 *   - Último pedido con estado
 *   - Rutinas filtradas por tipo de piel
 *   - Looks favoritos (máximo 3 para preview)
 *   - Prendas recientes del closet (máximo 6 para sidebar)
 */
@WebServlet("/panel")
public class UsuarioDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CaracteristicasDAO caracteristicasDAO = new CaracteristicasDAO();
    private final PrendaDAO          prendaDAO          = new PrendaDAO();
    private final PedidoDAO          pedidoDAO          = new PedidoDAO();
    private final RutinaDAO          rutinaDAO          = new RutinaDAO();
    private final LookGeneradoDAO    lookDAO            = new LookGeneradoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── Verificar sesión ──────────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Solo rol USUARIO (idRol == 2). Admin va a /admin/dashboard
        if (usuario.getIdRol() != UsuarioDAO.ROL_USUARIO) {
            resp.sendRedirect(req.getContextPath() +
                    (usuario.getIdRol() == UsuarioDAO.ROL_ADMIN ? "/admin/dashboard" : "/login"));
            return;
        }

        int idUsuario = usuario.getId();

        // ── 1. Características del perfil ─────────────────────────────────────
        Caracteristicas caract = null;
        try {
            caract = caracteristicasDAO.obtenerPorUsuario(idUsuario);
        } catch (Exception ignored) {}
        req.setAttribute("caract", caract);

        String tipoPiel = (caract != null && caract.getTipoPiel() != null)
                ? caract.getTipoPiel() : null;

        // ── 2. Prendas del closet ─────────────────────────────────────────────
        List<Prenda> todasPrendas = new ArrayList<>();
        try {
            todasPrendas = prendaDAO.listarPorUsuario(idUsuario);
        } catch (Exception ignored) {}

        req.setAttribute("totalPrendas", todasPrendas.size());

        // Últimas 6 prendas para sidebar
        List<Prenda> prendasRecientes = todasPrendas.size() > 6
                ? todasPrendas.subList(0, 6)
                : new ArrayList<>(todasPrendas);
        req.setAttribute("prendasRecientes", prendasRecientes);

        // ── 3. Pedidos ────────────────────────────────────────────────────────
        List<Pedido> pedidos = new ArrayList<>();
        try {
            pedidos = pedidoDAO.getHistorialPorUsuario(idUsuario);
        } catch (Exception ignored) {}

        req.setAttribute("totalPedidos", pedidos.size());
        req.setAttribute("ultimoPedido", pedidos.isEmpty() ? null : pedidos.get(0));

        // ── 4. Rutinas filtradas por tipo de piel ─────────────────────────────
        List<Rutina> rutinas = new ArrayList<>();
        try {
            if (caract != null) {
                rutinas = rutinaDAO.listarPorCaracteristicas(caract);
            } else {
                rutinas = rutinaDAO.listarTodas();
            }
        } catch (Exception ignored) {}

        req.setAttribute("totalRutinas", rutinas.size());
        // Primera rutina como "rutina del día"
        req.setAttribute("rutinaDelDia", rutinas.isEmpty() ? null : rutinas.get(0));

        // ── 5. Looks / Outfits favoritos ──────────────────────────────────────
        List<LookGenerado> favoritos = new ArrayList<>();
        try {
            favoritos = lookDAO.listarFavoritos(idUsuario);
        } catch (Exception ignored) {}

        req.setAttribute("totalFavoritos", favoritos.size());
        // Máximo 3 para preview
        List<LookGenerado> favoritosPreview = favoritos.size() > 3
                ? favoritos.subList(0, 3)
                : new ArrayList<>(favoritos);
        req.setAttribute("favoritosPreview", favoritosPreview);

        // ── 6. Frase del día (si existe en sesión desde EstadoAnimoServlet) ───
        // Ya viene en session.getAttribute("fraseActual") — no hace falta cargarla

        // ── Forward al JSP ────────────────────────────────────────────────────
        req.setAttribute("seccionActiva", "dashboard");
        req.getRequestDispatcher("/WEB-INF/usuario/dashboard.jsp").forward(req, resp);
    }
}