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

import com.quiddity.dao.CarritoDAO;
import com.quiddity.dao.CatalogoDAO;
import com.quiddity.dao.DireccionDAO;
import com.quiddity.dao.PedidoDAO;
import com.quiddity.model.Carrito;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Pedido;
import com.quiddity.model.PedidoItem;
import com.quiddity.model.Usuario;

@WebServlet("/pedido")
public class PedidoServlet extends HttpServlet {

    private final CarritoDAO carritoDAO = new CarritoDAO();
    private final CatalogoDAO catalogoDAO = new CatalogoDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final DireccionDAO direccionDAO = new DireccionDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        int direccionId = parseInt(req.getParameter("direccionId"), 0);
        String metodoPago = req.getParameter("metodoPago");
        String notas = req.getParameter("notas");

        if (direccionId <= 0 || metodoPago == null || metodoPago.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/comprador/checkout?error=DatosInvalidos");
            return;
        }

        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/carrito?error=CarritoVacio");
            return;
        }

        // 1. Verificar stock
        for (Carrito item : items) {
            Catalogo producto = catalogoDAO.obtenerPorId(item.getCatalogoId());
            if (producto == null || producto.getStock() < item.getCantidad()) {
                String msg = producto == null ? "Producto no disponible"
                        : "Stock insuficiente para " + producto.getNombre();
                resp.sendRedirect(req.getContextPath() + "/carrito?error=" +
                        java.net.URLEncoder.encode(msg, "UTF-8"));
                return;
            }
        }

        // 2. Descontar stock
        for (Carrito item : items) {
            catalogoDAO.descontarStock(item.getCatalogoId(), item.getCantidad());
        }

        // 3. Crear el pedido en BD
        double total = items.stream().mapToDouble(Carrito::getSubtotal).sum();

        Pedido pedido = new Pedido();
        pedido.setUsuarioId(usuario.getId());
        pedido.setDireccionId(direccionId);
        pedido.setMetodo_pago(metodoPago);
        pedido.setNotas(notas);
        pedido.setTotal(total);

        // Convertir ítems del carrito a PedidoItem
        List<PedidoItem> pedidoItems = new ArrayList<>();
        for (Carrito c : items) {
            PedidoItem pi = new PedidoItem();
            pi.setCatalogoId(c.getCatalogoId());
            pi.setCantidad(c.getCantidad());
            pi.setPrecioUnitario(c.getProducto().getPrecio());
            pedidoItems.add(pi);
        }
        pedido.setItems(pedidoItems);

        int pedidoId = pedidoDAO.crearPedido(pedido); // debe retornar el id generado

        // 4. Vaciar carrito
        carritoDAO.vaciarCarrito(usuario.getId());

        // 5. Redirigir a compraExitosa
        session.setAttribute("ultimaCompraTotal", total);
        session.setAttribute("ultimaCompraItems", items.size());
        session.setAttribute("ultimaCompraPedidoId", pedidoId);

        resp.sendRedirect(req.getContextPath() + "/compraExitosa");
    }

    private int parseInt(String valor, int defecto) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException | NullPointerException e) {
            return defecto;
        }
    }
}
