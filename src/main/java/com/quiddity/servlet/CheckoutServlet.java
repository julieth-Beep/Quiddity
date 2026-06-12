package com.quiddity.servlet;

import com.quiddity.dao.CarritoDAO;
import com.quiddity.dao.DireccionDAO;
import com.quiddity.dao.PedidoDAO;
import com.quiddity.model.Carrito;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Direccion;
import com.quiddity.model.Pedido;
import com.quiddity.model.PedidoItem;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * CheckoutServlet
 *
 * GET  /checkout  → muestra formulario con resumen del carrito + direcciones + método de pago
 * POST /checkout  → valida stock, crea pedido, vacía carrito, redirige a compraExitosa
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int ROL_USUARIO   = 3;
    private static final int ROL_COMPRADOR = 2;

    private final CarritoDAO   carritoDAO   = new CarritoDAO();
    private final DireccionDAO direccionDAO = new DireccionDAO();
    private final PedidoDAO    pedidoDAO    = new PedidoDAO();

    // ── GET: mostrar formulario de checkout ───────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/carrito");
            return;
        }

        double total = carritoDAO.getTotalCarrito(usuario.getId());
        List<Direccion> direcciones = direccionDAO.listarPorUsuario(usuario.getId());

        req.setAttribute("items",       items);
        req.setAttribute("total",       total);
        req.setAttribute("direcciones", direcciones);
        req.getRequestDispatcher("/comprador/checkout.jsp").forward(req, resp);
    }

    // ── POST: procesar el pedido ──────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        String metodoPago  = req.getParameter("metodoPago");
        String notas       = req.getParameter("notas");
        int    direccionId = parseInt(req.getParameter("direccionId"), 0);

        // Si el usuario ingresó una dirección nueva
        String nuevaDireccion = req.getParameter("nuevaDireccion");
        if (nuevaDireccion != null && !nuevaDireccion.isBlank()) {
            Direccion d = new Direccion();
            d.setUsuarioId(usuario.getId());
            d.setDepartamento(req.getParameter("departamento"));
            d.setCiudad(req.getParameter("ciudad"));
            d.setBarrio(req.getParameter("barrio"));
            d.setDireccion(nuevaDireccion);
            d.setEsRural("true".equals(req.getParameter("esRural")));
            d.setDescripcionRural(req.getParameter("descripcionRural"));
            d.setPredeterminada("true".equals(req.getParameter("guardarDireccion")));

            if (!direccionDAO.crear(d)) {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=No+se+pudo+guardar+la+dirección");
                return;
            }
            // Tomar el id de la dirección recién creada (primera en la lista, ordenada por id DESC)
            List<Direccion> dirs = direccionDAO.listarPorUsuario(usuario.getId());
            if (!dirs.isEmpty()) direccionId = dirs.get(0).getId();
        }

        if (direccionId <= 0 || metodoPago == null || metodoPago.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=Completa+todos+los+campos+requeridos");
            return;
        }

        // Validar que la dirección pertenece al usuario
        Direccion direccion = direccionDAO.obtenerPorId(direccionId);
        if (direccion == null || direccion.getUsuarioId() != usuario.getId()) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=Dirección+no+válida");
            return;
        }

        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/carrito");
            return;
        }

        // Armar el objeto Pedido
        Pedido pedido = new Pedido();
        pedido.setUsuarioId(usuario.getId());
        pedido.setDireccionId(direccionId);
        pedido.setMetodo_pago(metodoPago);
        pedido.setNotas(notas);

        for (Carrito item : items) {
            PedidoItem pi = new PedidoItem();
            pi.setCatalogoId(item.getCatalogoId());
            pi.setCantidad(item.getCantidad());
            Catalogo prod = item.getProducto();
            pi.setPrecioUnitario(prod != null ? prod.getPrecio() : item.getSubtotal() / item.getCantidad());
            pedido.getItems().add(pi);
        }

        // Crear pedido en BD (transacción: pedido + items + descuento de stock)
        int pedidoId = pedidoDAO.crearPedido(pedido);
        if (pedidoId == -1) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=Stock+insuficiente+para+uno+de+los+productos");
            return;
        }

        carritoDAO.vaciarCarrito(usuario.getId());

        // Guardar datos para compraExitosa.jsp
        HttpSession session = req.getSession();
        session.setAttribute("ultimaCompraTotal",     pedido.calcularTotal());
        session.setAttribute("ultimaCompraItems",     items.size());
        session.setAttribute("ultimaCompraPedidoId",  pedidoId);
        session.setAttribute("ultimaCompraDireccion", direccion.getDireccionCompleta());
        session.setAttribute("ultimaCompraMetodo",    metodoPago);

        resp.sendRedirect(req.getContextPath() + "/compraExitosa");
    }

    private Usuario usuarioAutenticado(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getIdRol() != ROL_USUARIO && u.getIdRol() != ROL_COMPRADOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return u;
    }

    private int parseInt(String valor, int defecto) {
        try { return Integer.parseInt(valor); }
        catch (NumberFormatException | NullPointerException e) { return defecto; }
    }
    
}