package com.quiddity.servlet;

import com.quiddity.dao.CarritoDAO;
import com.quiddity.dao.CatalogoDAO;
import com.quiddity.model.Carrito;
import com.quiddity.model.Catalogo;
import com.quiddity.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * CarritoServlet
 *
 * Accesible por ROL_USUARIO (3) y ROL_COMPRADOR (2).
 *
 * GET  /carrito                   → muestra el carrito del usuario
 * GET  /compraExitosa             → página de confirmación post-compra
 * POST /carrito?accion=agregar    → agrega producto al carrito
 * POST /carrito?accion=actualizar → cambia cantidad de un ítem
 * POST /carrito?accion=eliminar   → elimina un ítem del carrito
 * POST /carrito?accion=confirmar  → confirma la compra, descuenta stock y vacía carrito
 */
@WebServlet(urlPatterns = {"/carrito", "/compraExitosa"})
public class CarritoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int ROL_USUARIO   = 3;
    private static final int ROL_COMPRADOR = 2;

    private final CarritoDAO  carritoDAO  = new CarritoDAO();
    private final CatalogoDAO catalogoDAO = new CatalogoDAO();

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        // ── GET /compraExitosa ────────────────────────────────────────────────
        if (uri.endsWith("/compraExitosa")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            // Pasar los datos guardados por accionConfirmar a la vista
            req.setAttribute("total",      session.getAttribute("ultimaCompraTotal"));
            req.setAttribute("numItems",   session.getAttribute("ultimaCompraItems"));
            // Limpiar de la sesión para que no reaparezcan si recarga
            session.removeAttribute("ultimaCompraTotal");
            session.removeAttribute("ultimaCompraItems");

            req.getRequestDispatcher("/compraExitosa.jsp").forward(req, resp);
            return;
        }

        // ── GET /carrito ──────────────────────────────────────────────────────
        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        double total        = carritoDAO.getTotalCarrito(usuario.getId());

        req.setAttribute("items", items);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/carrito.jsp").forward(req, resp);
    }

    // ── POST: acciones del carrito ────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Usuario usuario = usuarioAutenticado(req, resp);
        if (usuario == null) return;

        String accion = req.getParameter("accion");
        if (accion == null) {
            resp.sendRedirect(req.getContextPath() + "/carrito");
            return;
        }

        switch (accion) {
            case "agregar"    -> accionAgregar(req, resp, usuario);
            case "actualizar" -> accionActualizar(req, resp, usuario);
            case "eliminar"   -> accionEliminar(req, resp);
            case "confirmar" -> resp.sendRedirect(req.getContextPath() + "/checkout");
            default           -> resp.sendRedirect(req.getContextPath() + "/carrito");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // AGREGAR PRODUCTO AL CARRITO
    // ─────────────────────────────────────────────────────────────────────────
    private void accionAgregar(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException {

        int catalogoId = parseInt(req.getParameter("catalogoId"), 0);
        int cantidad   = parseInt(req.getParameter("cantidad"), 1);

        if (catalogoId <= 0 || cantidad <= 0) {
            redirigirConMensaje(req, resp, "/carrito", "error", "Datos inválidos.");
            return;
        }

        Catalogo producto = catalogoDAO.obtenerPorId(catalogoId);
        if (producto == null) {
            redirigirConMensaje(req, resp, "/comprador/catalogo.jsp", "error", "Producto no encontrado.");
            return;
        }
        if (producto.getStock() < cantidad) {
            redirigirConMensaje(req, resp, "/comprador/catalogo.jsp", "error",
                    "Stock insuficiente. Solo hay " + producto.getStock() + " unidades disponibles.");
            return;
        }

        boolean ok = carritoDAO.agregarItem(usuario.getId(), catalogoId, cantidad);
        if (ok) {
            redirigirConMensaje(req, resp, "/carrito", "exito", "Producto agregado al carrito.");
        } else {
            redirigirConMensaje(req, resp, "/comprador/catalogo.jsp", "error", "No se pudo agregar el producto.");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ACTUALIZAR CANTIDAD DE UN ÍTEM
    // ─────────────────────────────────────────────────────────────────────────
    private void accionActualizar(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws IOException {

        int itemId   = parseInt(req.getParameter("itemId"), 0);
        int cantidad = parseInt(req.getParameter("cantidad"), 0);

        if (itemId <= 0) {
            redirigirConMensaje(req, resp, "/carrito", "error", "Datos inválidos.");
            return;
        }

        // cantidad = 0 → eliminar directamente
        if (cantidad == 0) {
            carritoDAO.eliminarItem(itemId);
            redirigirConMensaje(req, resp, "/carrito", "exito", "Producto eliminado del carrito.");
            return;
        }

        // Verificar stock antes de actualizar
        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());
        Carrito itemActual = items.stream()
                .filter(i -> i.getId() == itemId)
                .findFirst().orElse(null);

        if (itemActual != null && itemActual.getProducto() != null) {
            if (itemActual.getProducto().getStock() < cantidad) {
                redirigirConMensaje(req, resp, "/carrito", "error",
                        "Solo hay " + itemActual.getProducto().getStock() + " unidades disponibles.");
                return;
            }
        }

        carritoDAO.actualizarCantidad(itemId, cantidad);
        resp.sendRedirect(req.getContextPath() + "/carrito");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ELIMINAR UN ÍTEM
    // ─────────────────────────────────────────────────────────────────────────
    private void accionEliminar(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int itemId = parseInt(req.getParameter("itemId"), 0);
        if (itemId > 0) carritoDAO.eliminarItem(itemId);
        resp.sendRedirect(req.getContextPath() + "/carrito");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // CONFIRMAR COMPRA: verifica stock → descuenta → vacía carrito
    // ─────────────────────────────────────────────────────────────────────────
    private void accionConfirmar(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws ServletException, IOException {

        List<Carrito> items = carritoDAO.getCarritoByUsuario(usuario.getId());

        if (items.isEmpty()) {
            redirigirConMensaje(req, resp, "/carrito", "error", "Tu carrito está vacío.");
            return;
        }

        // 1. Verificar stock de todos los productos antes de tocar nada
        for (Carrito item : items) {
            Catalogo producto = catalogoDAO.obtenerPorId(item.getCatalogoId());
            if (producto == null) {
                redirigirConMensaje(req, resp, "/carrito", "error",
                        "El producto \"" + item.getCatalogoId() + "\" ya no está disponible.");
                return;
            }
            if (producto.getStock() < item.getCantidad()) {
                redirigirConMensaje(req, resp, "/carrito", "error",
                        "Stock insuficiente para \"" + producto.getNombre() +
                        "\". Disponible: " + producto.getStock() + " unidades.");
                return;
            }
        }

        // 2. Descontar stock de cada producto
        for (Carrito item : items) {
            boolean descontado = catalogoDAO.descontarStock(item.getCatalogoId(), item.getCantidad());
            if (!descontado) {
                redirigirConMensaje(req, resp, "/carrito", "error",
                        "Error al procesar la compra. Inténtalo de nuevo.");
                return;
            }
        }

        // 3. Vaciar el carrito
        carritoDAO.vaciarCarrito(usuario.getId());

        // 4. Guardar datos de la compra en sesión para la página de confirmación
        double total = items.stream().mapToDouble(Carrito::getSubtotal).sum();
        req.getSession().setAttribute("ultimaCompraTotal", total);
        req.getSession().setAttribute("ultimaCompraItems", items.size());

        resp.sendRedirect(req.getContextPath() + "/compraExitosa");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────────────────────────────────

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

    private void redirigirConMensaje(HttpServletRequest req, HttpServletResponse resp,
                                     String destino, String tipo, String mensaje)
            throws IOException {
        String encoded = java.net.URLEncoder.encode(mensaje, "UTF-8");
        resp.sendRedirect(req.getContextPath() + destino + "?" + tipo + "=" + encoded);
    }

    private int parseInt(String valor, int defecto) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException | NullPointerException e) {
            return defecto;
        }
    }
}