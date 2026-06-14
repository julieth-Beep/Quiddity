package com.quiddity.servlet;

import com.quiddity.dao.CaracteristicasDAO;
import com.quiddity.dao.PrendaDAO;
import com.quiddity.model.Caracteristicas;
import com.quiddity.model.Prenda;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * ClosetServlet — carga la página principal del closet (Imagen 1 y 2)
 *
 * GET /closet → closet.jsp con prendas y datos del avatar
 */
@WebServlet("/closet")
public class ClosetServlet extends HttpServlet {

    private final PrendaDAO prendaDAO = new PrendaDAO();
    private final CaracteristicasDAO caractDAO = new CaracteristicasDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Usuario usuario = getUsuario(req);
        if (usuario == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int idUsuario = usuario.getId();

        // Cargar características del avatar
        Caracteristicas caract = caractDAO.obtenerPorUsuario(idUsuario);
        req.setAttribute("caract", caract);

        // Cargar todas las prendas
        List<Prenda> prendas = new ArrayList<>();
        try {
            prendas = prendaDAO.listarPorUsuario(idUsuario);
        } catch (Exception e) {
            System.err.println("[ClosetServlet] Error cargando prendas: " + e.getMessage());
        }
        req.setAttribute("prendas", prendas);

        // Contar por tipo para los tabs (Imagen 1)
        long tops = prendas.stream().filter(p -> "tops".equalsIgnoreCase(p.getTipo())).count();
        long bottoms = prendas.stream().filter(p -> "bottoms".equalsIgnoreCase(p.getTipo())).count();
        long outerwear = prendas.stream().filter(p -> "outerwear".equalsIgnoreCase(p.getTipo())).count();
        long shoes = prendas.stream().filter(p -> "shoes".equalsIgnoreCase(p.getTipo())).count();
        long accesorios = prendas.stream().filter(p -> "accessories".equalsIgnoreCase(p.getTipo())).count();
        long dresses = prendas.stream().filter(p -> "dresses".equalsIgnoreCase(p.getTipo())).count();

        req.setAttribute("countTops", tops);
        req.setAttribute("countBottoms", bottoms);
        req.setAttribute("countOuterwear", outerwear);
        req.setAttribute("countShoes", shoes);
        req.setAttribute("countAccesorios", accesorios);
        req.setAttribute("countDresses", dresses);
        req.setAttribute("totalPrendas", prendas.size());

        req.setAttribute("seccionActiva", "closet");
        req.getRequestDispatcher("/WEB-INF/usuario/closet.jsp").forward(req, res);
    }

    private Usuario getUsuario(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s == null ? null : (Usuario) s.getAttribute("usuario");
    }
}