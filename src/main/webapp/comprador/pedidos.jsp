<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Pedido" %>
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

    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    if (pedidos == null) pedidos = new java.util.ArrayList<Pedido>();

    String msgExito = request.getParameter("exito");
    String msgError = request.getParameter("error");
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pedidos | Quiddity</title>
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
        .pedido-card { border: 1px solid rgba(135,114,118,0.15); transition: all 0.2s ease; }
        .pedido-card:hover { border-color: rgba(154,58,90,0.3); box-shadow: 0 4px 20px rgba(154,58,90,0.06); }
        .estado-badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; }
        .estado-pendiente { background: #fef3c7; color: #92400e; }
        .estado-procesando { background: #dbeafe; color: #1e40af; }
        .estado-enviado { background: #d1fae5; color: #065f46; }
        .estado-entregado { background: #f0fdf4; color: #166534; }
        .estado-cancelado { background: #fff1f2; color: #9a3a5a; }
        .nav-icon { position: relative; }
        .nav-icon .badge-count { position: absolute; top: -6px; right: -6px; background: #9a3a5a; color: white; font-size: 9px; width: 16px; height: 16px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-family: 'Manrope', sans-serif; font-weight: 700; }
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
        <a href="<%= ctx %>/pedidos" class="text-primary nav-icon transition-colors" title="Mis Pedidos">
            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400;">receipt_long</span>
            <% if (pedidos != null && !pedidos.isEmpty()) { %>
                <span class="badge-count"><%= pedidos.size() %></span>
            <% } %>
        </a>
        <!-- MENÚ DE USUARIO CON CLICK (reemplaza el div con group) -->
        <div class="relative" id="user-menu-container">
            <button id="user-menu-btn"
                class="flex items-center gap-2 hover:text-primary transition-colors"
                style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase;">
                <%= user.getNombre() %>
                <span id="user-menu-icon" class="material-symbols-outlined text-sm transition-transform duration-200">expand_more</span>
            </button>
            <div id="user-menu-dropdown"
                class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden z-50 rounded-md">
                <% if (user.getIdRol() == 1) { %>
                    <a href="<%= ctx %>/admin/dashboard" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } else if (user.getIdRol() == 3) { %>
                    <a href="<%= ctx %>/usuario/dashboard" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } else { %>
                    <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } %>
                <a href="<%= ctx %>/pedidos" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant font-semibold">Mis Pedidos</a>
                <a href="<%= ctx %>/carrito" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Carrito</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<main class="pt-36 pb-24 px-container-margin">
    <div class="max-w-5xl mx-auto">

        <!-- Titulo -->
        <div class="mb-10 border-b border-outline/15 pb-6">
            <span style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase; color:#9a3a5a;">
                Historial de compras
            </span>
            <h1 style="font-family:'EB Garamond',serif; font-size:clamp(32px,4vw,52px); font-style:italic;" class="mt-2">
                Mis Pedidos
            </h1>
        </div>

        <!-- Mensajes flash -->
        <% if (msgExito != null) { %>
            <div class="flash flash-ok">✓ <%= msgExito %></div>
        <% } %>
        <% if (msgError != null) { %>
            <div class="flash flash-err">✕ <%= msgError %></div>
        <% } %>

        <% if (pedidos.isEmpty()) { %>
            <!-- Sin pedidos -->
            <div class="text-center py-24 border border-outline/15">
                <span class="material-symbols-outlined text-6xl text-outline/40 block mb-4">receipt_long</span>
                <p style="font-family:'EB Garamond',serif; font-size:24px; font-style:italic;" class="text-on-surface-variant mb-2">
                    Aún no tienes pedidos
                </p>
                <p class="text-sm text-outline mb-8">Explora nuestro catálogo y realiza tu primera compra.</p>
                <a href="<%= ctx %>/catalogo"
                   class="inline-block bg-primary text-white px-10 py-3"
                   style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase;">
                    Explorar Catálogo
                </a>
            </div>

        <% } else { %>
            <!-- Lista de pedidos -->
            <div class="space-y-4">
                <% for (Pedido p : pedidos) {
                    String estadoClass = "estado-pendiente";
                    String estadoLabel = p.getEstado() != null ? p.getEstado().name() : "PENDIENTE";
                    String estLower = estadoLabel.toLowerCase();
                    if (estLower.contains("proces")) estadoClass = "estado-procesando";
                    else if (estLower.contains("envi")) estadoClass = "estado-enviado";
                    else if (estLower.contains("entreg")) estadoClass = "estado-entregado";
                    else if (estLower.contains("cancel")) estadoClass = "estado-cancelado";

                    int cantItems = p.getCantidadItems();
                    double total = p.getTotal();
                    ZonedDateTime fecha = p.getCreadoEn();
                    String fechaStr = fecha != null ? dtf.format(fecha) : "—";
                %>
                <a href="<%= ctx %>/pedidos?id=<%= p.getId() %>"
                   class="pedido-card block p-6 bg-white">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <!-- Info izquierda -->
                        <div class="flex-1">
                            <div class="flex items-center gap-3 mb-2">
                                <h3 style="font-family:'EB Garamond',serif; font-size:20px;" class="text-on-surface">
                                    Pedido 
                                </h3>
                                <span class="estado-badge <%= estadoClass %>">
                                    <%= estadoLabel %>
                                </span>
                            </div>
                            <div class="flex items-center gap-4 text-sm text-on-surface-variant">
                                <span class="flex items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size:14px;">calendar_today</span>
                                    <%= fechaStr %>
                                </span>
                                <span class="flex items-center gap-1">
                                    <span class="material-symbols-outlined" style="font-size:14px;">inventory_2</span>
                                    <%= cantItems %> producto<%= cantItems != 1 ? "s" : "" %>
                                </span>
                            </div>
                        </div>
                        <!-- Total + flecha -->
                        <div class="flex items-center gap-6">
                            <div class="text-right">
                                <p class="text-xs text-outline uppercase tracking-wider mb-1">Total</p>
                                <p style="font-family:'EB Garamond',serif; font-size:24px; color:#9a3a5a;" class="font-semibold">
                                    $<%= df.format(total) %>
                                </p>
                            </div>
                            <span class="material-symbols-outlined text-outline/40">chevron_right</span>
                        </div>
                    </div>
                </a>
                <% } %>
            </div>
        <% } %>
    </div>
</main>

<footer class="border-t border-outline/10 py-10 px-container-margin text-center">
    <p style="font-family:'Manrope',sans-serif; font-size:10px; letter-spacing:0.2em; text-transform:uppercase; color:#877276;">
        © 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.
    </p>
</footer>

<!-- ── Script para menú con click ── -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var container = document.getElementById('user-menu-container');
        if (!container) return;

        var btn = document.getElementById('user-menu-btn');
        var dropdown = document.getElementById('user-menu-dropdown');
        var icon = document.getElementById('user-menu-icon');

        function toggleMenu(e) {
            e.stopPropagation();
            var isOpen = dropdown.classList.contains('hidden');
            if (isOpen) {
                dropdown.classList.remove('hidden');
                icon.textContent = 'expand_less';
            } else {
                dropdown.classList.add('hidden');
                icon.textContent = 'expand_more';
            }
        }

        btn.addEventListener('click', toggleMenu);

        // Cerrar al hacer clic fuera del menú
        document.addEventListener('click', function(e) {
            if (!container.contains(e.target)) {
                dropdown.classList.add('hidden');
                icon.textContent = 'expand_more';
            }
        });

        // Cerrar con tecla Escape
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && !dropdown.classList.contains('hidden')) {
                dropdown.classList.add('hidden');
                icon.textContent = 'expand_more';
            }
        });
    });
</script>

</body>
</html>