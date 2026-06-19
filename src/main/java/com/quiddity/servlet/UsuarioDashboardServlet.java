package com.quiddity.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.FraseDAO;
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
import com.quiddity.util.ClimaUtil;
import com.quiddity.util.HuggingFaceUtil;
import com.quiddity.util.PromptBuilder;

/**
 * UsuarioDashboardServlet
 *
 * GET /panel -> dashboard personal del usuario autenticado con rol USUARIO
 * POST /panel/generar-outfit-clima -> genera outfit segun clima GPS
 */
@WebServlet({ "/panel", "/panel/*" })
public class UsuarioDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CaracteristicasDAO caracteristicasDAO = new CaracteristicasDAO();
    private final PrendaDAO prendaDAO = new PrendaDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final RutinaDAO rutinaDAO = new RutinaDAO();
    private final LookGeneradoDAO lookDAO = new LookGeneradoDAO();
    private final FraseDAO fraseDAO = new FraseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println(">>>>>>>>>> ENTRO AL DOGET DEL DASHBOARD <<<<<<<<<<");

        resp.setContentType("text/html;charset=UTF-8");

        // Evitar que el navegador sirva esta página desde caché/bfcache.
        // Sin esto, al volver con el botón "atrás" o navegación SPA-like,
        // Chrome puede reusar el HTML viejo sin volver a golpear el servlet,
        // por lo que los datos (prendas, KPIs) quedan desactualizados.
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (usuario.getIdRol() != UsuarioDAO.ROL_USUARIO) {
            resp.sendRedirect(req.getContextPath() +
                    (usuario.getIdRol() == UsuarioDAO.ROL_ADMIN ? "/admin/dashboard" : "/login"));
            return;
        }

        int idUsuario = usuario.getId();

        // 1. Caracteristicas del perfil
        Caracteristicas caract = null;
        try {
            caract = caracteristicasDAO.obtenerPorUsuario(idUsuario);
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando caracteristicas: " + e.getMessage());
        }
        req.setAttribute("caract", caract);

        // 2. Prendas del closet
        // 2. Prendas del closet
        List<Prenda> todasPrendas = new ArrayList<>();
        try {
            todasPrendas = prendaDAO.listarPorUsuario(idUsuario);
            todasPrendas.sort((a, b) -> Integer.compare(b.getId(), a.getId()));
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando prendas: " + e.getMessage());
        }

        // LOG TEMPORAL DE DIAGNOSTICO — borrar después de confirmar el bug
        System.out.println("[DEBUG Dashboard] idUsuario=" + idUsuario);
        System.out.println("[DEBUG Dashboard] totalPrendas encontradas=" + todasPrendas.size());
        if (!todasPrendas.isEmpty()) {
            System.out.println("[DEBUG Dashboard] primera prenda (debería ser la más reciente): id="
                    + todasPrendas.get(0).getId() + " imagen=" + todasPrendas.get(0).getImagen());
        }

        req.setAttribute("totalPrendas", todasPrendas.size());

        List<Prenda> prendasRecientes;
        if (todasPrendas.size() > 6) {
            prendasRecientes = new ArrayList<>(todasPrendas.subList(0, 6));
        } else {
            prendasRecientes = new ArrayList<>(todasPrendas);
        }
        req.setAttribute("prendasRecientes", prendasRecientes);

        // 3. Pedidos
        List<Pedido> pedidos = new ArrayList<>();
        try {
            pedidos = pedidoDAO.getHistorialPorUsuario(idUsuario);
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando pedidos: " + e.getMessage());
        }

        req.setAttribute("totalPedidos", pedidos.size());
        req.setAttribute("ultimoPedido", pedidos.isEmpty() ? null : pedidos.get(0));

                // 4. Rutinas favoritas del usuario
        List<Rutina> rutinasFavoritas = new ArrayList<>();
        try {
            System.out.println("[Dashboard] Solicitando rutinas favoritas para idUsuario=" + idUsuario);
            rutinasFavoritas = rutinaDAO.listarFavoritasPorUsuario(idUsuario);
            System.out.println("[Dashboard] Rutinas favoritas recibidas: " + rutinasFavoritas.size());
            if (!rutinasFavoritas.isEmpty()) {
                System.out.println("[Dashboard] Primera rutina favorita: " + rutinasFavoritas.get(0).getNombre());
            }
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando rutinas favoritas: " + e.getMessage());
            e.printStackTrace();
        }

        req.setAttribute("totalRutinas", rutinasFavoritas.size());
        req.setAttribute("rutinaDelDia", rutinasFavoritas.isEmpty() ? null : rutinasFavoritas.get(0));
        // 5. Looks favoritos
        List<LookGenerado> favoritos = new ArrayList<>();
        try {
            favoritos = lookDAO.listarFavoritos(idUsuario);
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando favoritos: " + e.getMessage());
        }

        req.setAttribute("totalFavoritos", favoritos.size());

        List<LookGenerado> favoritosPreview = favoritos.size() > 3
                ? new ArrayList<>(favoritos.subList(0, 3))
                : new ArrayList<>(favoritos);
        req.setAttribute("favoritosPreview", favoritosPreview);

        // 6. Look del Dia (el mas reciente generado, NO favorito)
        LookGenerado lookDelDia = null;
        try {
            List<LookGenerado> looksGenerados = lookDAO.listarPorUsuario(idUsuario);
            if (looksGenerados != null && !looksGenerados.isEmpty()) {
                lookDelDia = looksGenerados.get(0);
            }
        } catch (Exception e) {
            System.err.println("[Dashboard] Error cargando look del dia: " + e.getMessage());
        }
        if (lookDelDia == null && !favoritos.isEmpty()) {
            lookDelDia = favoritos.get(0);
        }
        req.setAttribute("lookDelDia", lookDelDia);

        // 7. Frase del dia
        if (session.getAttribute("fraseActual") == null) {
            try {
                com.quiddity.model.Frase frase = fraseDAO.obtenerAleatoria();
                if (frase != null) {
                    session.setAttribute("fraseActual", frase);
                }
            } catch (Exception e) {
                System.err.println("[Dashboard] Error cargando frase: " + e.getMessage());
            }
        }
        System.out.println("[DEBUG Dashboard] SETEANDO ATRIBUTOS: totalPrendas=" + todasPrendas.size() 
    + ", totalPedidos=" + pedidos.size() 
    + ", totalRutinas=" + rutinasFavoritas.size() 
    + ", totalFavoritos=" + favoritos.size());

        req.setAttribute("seccionActiva", "dashboard");
        req.getRequestDispatcher("/WEB-INF/usuario/dashboard.jsp").forward(req, resp);
    }

    // ========================================================================
    // POST /panel/generar-outfit-clima
    // ========================================================================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if ("/generar-outfit-clima".equals(pathInfo)) {
            generarOutfitPorClima(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void generarOutfitPorClima(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            resp.setStatus(401);
            out.print("{\"error\":\"Sesion expirada\"}");
            return;
        }

        int idUsuario = usuario.getId();

        try {
            double lat = Double.parseDouble(req.getParameter("lat"));
            double lon = Double.parseDouble(req.getParameter("lon"));

            // SIN FALLBACK - si no hay clima, error
            ClimaUtil.ClimaData clima = ClimaUtil.obtenerPorCoordenadas(lat, lon);
            if (clima == null) {
                resp.setStatus(503);
                out.print("{\"error\":\"No se pudo obtener el clima. Verifica tu conexion o intenta mas tarde.\"}");
                return;
            }

            Caracteristicas caract = null;
            try {
                caract = caracteristicasDAO.obtenerPorUsuario(idUsuario);
            } catch (Exception e) {
                System.err.println("[Dashboard] Sin caracteristicas: " + e.getMessage());
            }

            String estilo = clima.getEstiloSugerido();
            String ocasion = "diario";
            String descClima = clima.getCondicion().toLowerCase() + " " + Math.round(clima.tempC) + "C";

            String prompt = PromptBuilder.buildRecomendacion(estilo, ocasion, descClima, caract);

            String rutaImagen = HuggingFaceUtil.generarLook(prompt, req);

            if (rutaImagen == null) {
                resp.setStatus(500);
                out.print("{\"error\":\"No se pudo generar la imagen. Intenta de nuevo.\"}");
                return;
            }

            LookGenerado lg = new LookGenerado();
            lg.setIdUsuario(idUsuario);
            lg.setImagenGenerada(rutaImagen);
            lg.setPromptIA(prompt);
            lg.setEsManual(false);
            lg.setFavorito(false);
            lookDAO.crear(lg);

            out.print("{"
                    + "\"id\":" + lg.getId()
                    + ",\"imagen\":\"" + escaparJson(rutaImagen) + "\""
                    + ",\"ciudad\":\"" + escaparJson(clima.ciudad) + "\""
                    + ",\"temp\":\"" + clima.getTempFormateada() + "\""
                    + ",\"condicion\":\"" + escaparJson(clima.getCondicion()) + "\""
                    + ",\"estilo\":\"" + escaparJson(estilo) + "\""
                    + ",\"mensaje\":\"Look generado para " + escaparJson(clima.getCondicion()) + "\""
                    + "}");

        } catch (Exception e) {
            System.err.println("[Dashboard] Error generando outfit: " + e.getMessage());
            resp.setStatus(500);
            out.print("{\"error\":\"" + escaparJson(e.getMessage()) + "\"}");
        }
    }

    private String escaparJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}