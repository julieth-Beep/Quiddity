package com.quiddity.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiddity.dao.CarritoDAO;
import com.quiddity.dao.DireccionDAO;
import com.quiddity.model.Carrito;
import com.quiddity.model.Direccion;
import com.quiddity.model.Usuario;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final DireccionDAO direccionDAO = new DireccionDAO();
    private final CarritoDAO   carritoDAO   = new CarritoDAO(); // ← agregar

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Direcciones
        List<Direccion> direcciones = direccionDAO.listarPorUsuario(usuario.getId());
        req.setAttribute("direcciones", direcciones);

        // ── CARRITO ───────────────────────────────────────────────────────
        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        double total = items.stream().mapToDouble(Carrito::getSubtotal).sum();
        req.setAttribute("itemsCarrito", items);
        req.setAttribute("totalCarrito", total);
        // ─────────────────────────────────────────────────────────────────

        req.getRequestDispatcher("/comprador/checkout.jsp").forward(req, resp);
    }
}