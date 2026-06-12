<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Pedido" %>
<%@ page import="com.quiddity.model.PedidoItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    DecimalFormat df = new DecimalFormat("#,###");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    Pedido pedido = (Pedido) request.getAttribute("pedido");
    if (pedido == null) {
        response.sendRedirect(ctx + "/pedidos");
        return;
    }

    List<PedidoItem> items = pedido.getItems();
    if (items == null) items = new java.util.ArrayList<PedidoItem>();

    String msgExito = request.getParameter("exito");
    String msgError = request.getParameter("error");

    // Determinar clase del estado
    String estadoClass = "estado-pendiente";
    String estadoLabel = pedido.getEstado() != null ? pedido.getEstado().name() : "PENDIENTE";
    String estLower = estadoLabel.toLowerCase();
    if (estLower.contains("proces")) estadoClass = "estado-procesando";
    else if (estLower.contains("envi")) estadoClass = "estado-enviado";
    else if (estLower.contains("entreg")) estadoClass = "estado-entregado";
    else if (estLower.contains("cancel")) estadoClass = "estado-cancelado";

    ZonedDateTime fecha = pedido.getCreadoEn();
    String fechaStr = fecha != null ? dtf.format(fecha) : "—";

    String metodoPago = pedido.getMetodo_pago() != null ? pedido.getMetodo_pago() : "No especificado";
    String direccion = "";
    if (pedido.getDireccion() != null && pedido.getDireccion().getDireccionCompleta() != null) {
        direccion = pedido.getDireccion().getDireccionCompleta();
    }
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido | Quiddity</title>
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect" />
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&family=Manrope:wght@200..800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#9a3a5a",
                        "tertiary": "#88495a",
                        "on-surface": "#1c1b1d",
                        "on-surface-variant": "#544246",
                        "outline": "#877276",
                        "surface-variant": "#f1ecef"
                    },
                    borderRadius: { DEFAULT: "0px", lg: "0px", xl: "0px", full: "9999px" },
                    spacing: {
                        "container-margin": "80px",
                        "section-gap": "120px"
                    },
                    fontFamily: {
                        "display-lg": ["EB Garamond"],
                        "headline-md": ["EB Garamond"],
                        "label-md": ["Manrope"],
                        "body-md": ["Manrope"]
                    },
                    fontSize: {
                        "headline-md": ["32px", { lineHeight: "40px" }],
                        "display-lg": ["64px", { lineHeight: "72px" }],
                        "label-md": ["13px", { lineHeight: "20px", letterSpacing: "0.1em", fontWeight: "600" }]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        #announcement-bar { background-color: #c4a9a2; height: 42px; }
        .flash { padding: 12px 20px; font-family: 'Manrope', sans-serif; font-size: 12px;
                 letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 24px; }
        .flash-ok  { background: #f0fdf4; color: #166534; border-left: 3px solid #166534; }
        .flash-err { background: #fff1f2; color: #9a3a5a; border-left: 3px solid #9a3a5a; }
        .estado-badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; }
        .estado-pendiente { background: #fef3c7; color: #92400e; }
        .estado-procesando { background: #dbeafe; color: #1e40af; }
        .estado-enviado { background: #d1fae5; color: #065f46; }
        .estado-entregado { background: #f0fdf4; color: #166534; }
        .estado-cancelado { background: #fff1f2; color: #9a3a5a; }
        .info-card { border: 1px solid rgba(135,114,118,0.15); padding: 24px; }
        .info-label { font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600; letter-spacing: 0.15em; text-transform: uppercase; color: #877276; margin-bottom: 6px; }
        .info-value { font-family: 'Manrope', sans-serif; font-size: 14px; color: #1c1b1d; }
        .item-row { border-bottom: 1px solid rgba(135,114,118,0.10); padding: 16px 0; }
        .item-row:last-child { border-bottom: none; }
        .back-link { display: inline-flex; align-items: center; gap: 6px; font-family: 'Manrope', sans-serif; font-size: 11px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: #9a3a5a; transition: opacity 0.2s; }
        .back-link:hover { opacity: 0.7; }
        .total-row { border-top: 2px solid rgba(135,114,118,0.20); padding-top: 16px; margin-top: 8px; }
    </style>
</head>
<body class="bg-white text-on-surface" style="font-family:'Manrope',sans-serif;">

<!-- ANNOUNCEMENT BAR -->
<div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
    <p style="font-family:'Manrope',sans-serif; font-size:11px; letter-spacing:0.3em; color:white; text-transform:uppercase;">
        NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
    </p>
    <button onclick="document.getElementById('announcement-bar').style.display='none'; document.getElementById('main-header').style.top='0'"
            class="absolute right-6 text-white/60 hover:text-white">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<!-- HEADER -->
<header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5" style="top:42px;">
    <div class="flex items-center gap-12">
        <a href="<%= ctx %>/index.jsp">
            <h1 style="font-family:'EB Garamond',serif; font-size:24px; letter-spacing:0.2em; color:#9a3a5a; text-transform:uppercase;">Quiddity</h1>
        </a>
        <nav class="hidden md:flex gap-8">
            <a style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase;"
               class="hover:text-primary transition-colors"
               href="<%= ctx %>/catalogo">Shop</a>
            <a style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase;"
               class="hover:text-primary transition-colors" href="#">Nuestra historia</a>
        </nav>
    </div>
    <div class="flex items-center gap-6">
        <a href="<%= ctx %>/catalogo" class="text-on-surface hover:text-primary transition-colors">
            <span class="material-symbols-outlined">arrow_back</span>
        </a>
        <a href="<%= ctx %>/carrito" class="text-on-surface hover:text-primary transition-colors relative">
            <span class="material-symbols-outlined">shopping_bag</span>
        </a>
        <!-- ICONO HISTORIAL / PEDIDOS -->
        <a href="<%= ctx %>/pedidos" class="text-primary transition-colors relative" title="Mis Pedidos">
            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400;">receipt_long</span>
        </a>
        <div class="relative group">
            <button class="flex items-center gap-2 hover:text-primary"
                    style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase;">
                <%= user.getNombre() %>
                <span class="material-symbols-outlined text-sm">expand_more</span>
            </button>
            <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <a href="<%= ctx %>/pedidos" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant font-semibold">Mis Pedidos</a>
                <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Compras</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<main class="pt-36 pb-24 px-container-margin">
    <div class="max-w-4xl mx-auto">

        <!-- Volver -->
        <a href="<%= ctx %>/pedidos" class="back-link mb-8">
            <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span>
            Volver al historial
        </a>

        <!-- Titulo + Estado -->
        <div class="mb-10 border-b border-outline/15 pb-6">
            <div class="flex items-center gap-4 mb-3">
                <span style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase; color:#9a3a5a;">
                    Detalle del pedido
                </span>
                <span class="estado-badge <%= estadoClass %>"><%= estadoLabel %></span>
            </div>
            <h1 style="font-family:'EB Garamond',serif; font-size:clamp(32px,4vw,48px); font-style:italic;">
                Pedido 
            </h1>
        </div>

        <!-- Mensajes flash -->
        <% if (msgExito != null) { %>
            <div class="flash flash-ok">✓ <%= msgExito %></div>
        <% } %>
        <% if (msgError != null) { %>
            <div class="flash flash-err">✕ <%= msgError %></div>
        <% } %>

        <!-- Info general -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-10">
            <div class="info-card">
                <p class="info-label">Fecha del pedido</p>
                <p class="info-value flex items-center gap-2">
                    <span class="material-symbols-outlined text-outline" style="font-size:16px;">calendar_today</span>
                    <%= fechaStr %>
                </p>
            </div>
            <div class="info-card">
                <p class="info-label">Metodo de pago</p>
                <p class="info-value flex items-center gap-2">
                    <span class="material-symbols-outlined text-outline" style="font-size:16px;">credit_card</span>
                    <%= metodoPago %>
                </p>
            </div>
            <div class="info-card">
                <p class="info-label">Direccion de envio</p>
                <p class="info-value flex items-center gap-2">
                    <span class="material-symbols-outlined text-outline" style="font-size:16px;">location_on</span>
                    <%= direccion.isEmpty() ? "No especificada" : direccion %>
                </p>
            </div>
        </div>

        <!-- Items del pedido -->
        <div class="border border-outline/15 p-8 mb-8">
            <h3 style="font-family:'EB Garamond',serif; font-size:22px; font-style:italic;" class="mb-6">
                Productos
            </h3>

            <% if (items.isEmpty()) { %>
                <p class="text-sm text-outline text-center py-8">No hay productos en este pedido.</p>
            <% } else { %>
                <!-- Header tabla -->
                <div class="hidden md:grid grid-cols-12 gap-4 pb-3 border-b border-outline/15 mb-2"
                     style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">
                    <div class="col-span-6">Producto</div>
                    <div class="col-span-2 text-center">Cantidad</div>
                    <div class="col-span-2 text-right">Precio unit.</div>
                    <div class="col-span-2 text-right">Subtotal</div>
                </div>

                <% for (PedidoItem item : items) {
                    String nombreProd = item.getProducto() != null ? item.getProducto().getNombre() : "Producto";
                    int cantidad = item.getCantidad();
                    double precioUnit = item.getPrecioUnitario();
                    double subtotal = cantidad * precioUnit;
                %>
                <div class="item-row grid grid-cols-1 md:grid-cols-12 gap-4 items-center">
                    <!-- Producto -->
                    <div class="col-span-6">
                        <p style="font-family:'EB Garamond',serif; font-size:16px;"><%= nombreProd %></p>
                    </div>
                    <!-- Cantidad -->
                    <div class="col-span-2 text-center">
                        <span class="md:hidden text-xs text-outline uppercase tracking-wider mr-2">Cantidad:</span>
                        <span style="font-family:'Manrope',sans-serif; font-size:14px; font-weight:600;"><%= cantidad %></span>
                    </div>
                    <!-- Precio unit -->
                    <div class="col-span-2 text-right">
                        <span class="md:hidden text-xs text-outline uppercase tracking-wider mr-2">Precio:</span>
                        <span style="font-family:'Manrope',sans-serif; font-size:14px;">$<%= df.format(precioUnit) %></span>
                    </div>
                    <!-- Subtotal -->
                    <div class="col-span-2 text-right">
                        <span class="md:hidden text-xs text-outline uppercase tracking-wider mr-2">Subtotal:</span>
                        <span style="font-family:'Manrope',sans-serif; font-size:14px; font-weight:600; color:#9a3a5a;">$<%= df.format(subtotal) %></span>
                    </div>
                </div>
                <% } %>

                <!-- Total -->
                <div class="total-row flex justify-between items-center">
                    <span style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">
                        Total del pedido
                    </span>
                    <span style="font-family:'EB Garamond',serif; font-size:28px; color:#9a3a5a; font-weight:600;">
                        $<%= df.format(pedido.getTotal()) %>
                    </span>
                </div>
            <% } %>
        </div>

        <!-- Boton volver -->
        <div class="text-center">
            <a href="<%= ctx %>/pedidos"
               class="inline-flex items-center gap-2 bg-primary text-white px-10 py-3 hover:bg-tertiary transition"
               style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase;">
                <span class="material-symbols-outlined" style="font-size:16px;">receipt_long</span>
                Ver todos mis pedidos
            </a>
        </div>

    </div>
</main>

<footer class="border-t border-outline/10 py-10 px-container-margin text-center">
    <p style="font-family:'Manrope',sans-serif; font-size:10px; letter-spacing:0.2em; text-transform:uppercase; color:#877276;">
        © 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.
    </p>
</footer>

</body>
</html>