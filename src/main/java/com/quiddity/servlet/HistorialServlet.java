package com.quiddity.servlet;

import com.quiddity.dao.PedidoDAO;
import com.quiddity.model.Pedido;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * GET /pedidos        → historial de pedidos del usuario
 * GET /pedidos?id=123 → detalle de un pedido específico
 */
@WebServlet("/pedidos")
public class HistorialServlet extends HttpServlet {

    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            int pedidoId = parseInt(idParam, -1);
            Pedido pedido = pedidoDAO.getDetallePedido(pedidoId, usuario.getId());
            if (pedido == null) {
                resp.sendRedirect(req.getContextPath() + "/pedidos?error=NoEncontrado");
                return;
            }
            req.setAttribute("pedido", pedido);
            req.getRequestDispatcher("/comprador/pedidoDetalle.jsp").forward(req, resp);
            return;
        }

        List<Pedido> historial = pedidoDAO.getHistorialPorUsuario(usuario.getId());
        req.setAttribute("pedidos", historial);
        req.getRequestDispatcher("/comprador/pedidos.jsp").forward(req, resp);
    }

    private int parseInt(String valor, int defecto) {
        try { return Integer.parseInt(valor); }
        catch (NumberFormatException | NullPointerException e) { return defecto; }
    }
}