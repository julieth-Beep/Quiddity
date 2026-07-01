<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Carrito" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    DecimalFormat df = new DecimalFormat("#,###");

    List<Carrito> items = (List<Carrito>) request.getAttribute("items");
    Double totalGeneral = (Double) request.getAttribute("total");
    if (items == null) items = new java.util.ArrayList<Carrito>();
    if (totalGeneral == null) totalGeneral = 0.0;

    String msgExito = request.getParameter("exito");
    String msgError = request.getParameter("error");
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Carrito | Quiddity</title>
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
        .qty-input {
            width: 56px; height: 36px;
            text-align: center;
            border: 1px solid rgba(135,114,118,0.35);
            font-family: 'Manrope', sans-serif;
            font-size: 14px; font-weight: 600;
        }
        .qty-input:focus { outline: none; border-color: #9a3a5a; }
        .flash { padding: 12px 20px; font-family: 'Manrope', sans-serif; font-size: 12px;
                 letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 24px; }
        .flash-ok  { background: #f0fdf4; color: #166534; border-left: 3px solid #166534; }
        .flash-err { background: #fff1f2; color: #9a3a5a; border-left: 3px solid #9a3a5a; }
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
<div class="relative" id="user-menu-container">
    <button id="user-menu-btn"
        class="flex items-center gap-2 hover:text-primary transition-colors"
        style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase;">
        <%= user.getNombre() %>
        <span id="user-menu-icon" class="material-symbols-outlined text-sm transition-transform duration-200">expand_more</span>
    </button>
    <div id="user-menu-dropdown" class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden z-50 rounded-md">
                <% if (user.getIdRol() == 1) { %>
                    <a href="<%= ctx %>/admin/dashboard" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } else if (user.getIdRol() == 3) { %>
                    <a href="<%= ctx %>/usuario/dashboard" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } else { %>
                    <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <% } %>
                <a href="<%= ctx %>/pedidos" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Pedidos</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/carrito" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Carrito</a>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
</div>
</header>

<main class="pt-36 pb-24 px-container-margin">
    <div class="max-w-5xl mx-auto">

        <!-- Título -->
        <div class="mb-10 border-b border-outline/15 pb-6">
            <span style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase; color:#9a3a5a;">
                Mi selección
            </span>
            <h1 style="font-family:'EB Garamond',serif; font-size:clamp(32px,4vw,52px); font-style:italic;" class="mt-2">
                Carrito de compras
            </h1>
        </div>

        <!-- Mensajes flash -->
        <% if (msgExito != null) { %>
            <div class="flash flash-ok">✓ <%= msgExito %></div>
        <% } %>
        <% if (msgError != null) { %>
            <div class="flash flash-err">✕ <%= msgError %></div>
        <% } %>

        <% if (items.isEmpty()) { %>
            <!-- Carrito vacío -->
            <div class="text-center py-24 border border-outline/15">
                <span class="material-symbols-outlined text-6xl text-outline/40 block mb-4">shopping_bag</span>
                <p style="font-family:'EB Garamond',serif; font-size:24px; font-style:italic;" class="text-on-surface-variant mb-2">
                    Tu carrito está vacío
                </p>
                <p class="text-sm text-outline mb-8">Agrega productos desde el catálogo para comenzar.</p>
                <a href="<%= ctx %>/catalogo"
                   class="inline-block bg-primary text-white px-10 py-3"
                   style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase;">
                    Explorar Catálogo
                </a>
            </div>

        <% } else { %>
            <div class="flex flex-col lg:flex-row gap-12">

                <!-- ── LISTA DE PRODUCTOS ─────────────────────────────── -->
                <div class="flex-1">
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="border-b border-outline/20">
                                <th class="pb-4 text-left" style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">Producto</th>
                                <th class="pb-4 text-right" style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">Precio</th>
                                <th class="pb-4 text-center" style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">Cantidad</th>
                                <th class="pb-4 text-right" style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase; color:#877276;">Subtotal</th>
                                <th class="pb-4"></th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Carrito item : items) { %>
                            <tr class="border-b border-outline/10 hover:bg-surface-variant/20 transition">

                                <!-- Producto -->
                                <td class="py-6 pr-4">
                                    <div class="flex gap-4 items-center">
                                        <div class="w-20 h-20 bg-surface-variant overflow-hidden flex-shrink-0">
                                            <% if (item.getProducto().getImagen() != null && !item.getProducto().getImagen().isEmpty()) { %>
                                                <img src="<%= ctx %>/<%= item.getProducto().getImagen() %>" 
                                                alt="<%= item.getProducto().getNombre() %>" 
                                                class="w-full h-full object-cover" />
                                            <% } else { %>
                                                <div class="w-full h-full flex items-center justify-center text-outline">
                                                    <span class="material-symbols-outlined">image</span>
                                                </div>
                                            <% } %>
                                        </div>
                                        <div>
                                            <p class="text-xs text-outline mb-1" style="letter-spacing:0.1em; text-transform:uppercase;">
                                                <%= item.getProducto().getCategoria() != null ? item.getProducto().getCategoria() : "" %>
                                            </p>
                                            <h3 style="font-family:'EB Garamond',serif; font-size:18px;">
                                                <%= item.getProducto().getNombre() %>
                                            </h3>
                                            <% if (item.getProducto().getMarca() != null && !item.getProducto().getMarca().isEmpty()) { %>
                                                <p class="text-xs text-outline/70 mt-1"><%= item.getProducto().getMarca() %></p>
                                            <% } %>
                                        </div>
                                    </div>
                                </td>

                                <!-- Precio unitario -->
                                <td class="py-6 text-right text-sm text-on-surface-variant whitespace-nowrap">
                                    $<%= df.format(item.getProducto().getPrecio()) %>
                                </td>

                                <!-- Cantidad -->
                                <td class="py-6 text-center">
                                    <form action="<%= ctx %>/carrito" method="post"
                                          class="flex items-center justify-center gap-2">
                                        <input type="hidden" name="accion" value="actualizar">
                                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                        <input type="number" name="cantidad"
                                               value="<%= item.getCantidad() %>"
                                               min="0" max="<%= item.getProducto().getStock() %>"
                                               class="qty-input" />
                                        <button type="submit"
                                                class="text-on-surface-variant hover:text-primary transition"
                                                title="Actualizar cantidad">
                                            <span class="material-symbols-outlined" style="font-size:18px;">refresh</span>
                                        </button>
                                    </form>
                                </td>

                                <!-- Subtotal -->
                                <td class="py-6 text-right font-semibold whitespace-nowrap">
                                    $<%= df.format(item.getSubtotal()) %>
                                </td>

                                <!-- Eliminar -->
                                <td class="py-6 text-center">
                                    <form action="<%= ctx %>/carrito" method="post"
                                          onsubmit="return confirm('¿Eliminar este producto del carrito?')">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                        <button type="submit"
                                                class="text-outline/60 hover:text-red-500 transition"
                                                title="Eliminar">
                                            <span class="material-symbols-outlined" style="font-size:20px;">delete</span>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>

                    <!-- Botón seguir comprando -->
                    <div class="mt-6">
                        <a href="<%= ctx %>/catalogo"
                           class="inline-flex items-center gap-2 text-primary hover:underline"
                           style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.15em; text-transform:uppercase;">
                            <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span>
                            Seguir comprando
                        </a>
                    </div>
                </div>

                <!-- ── RESUMEN / IR A CHECKOUT ──────────────────────────────── -->
                <div class="w-full lg:w-80 flex-shrink-0">
                    <div class="border border-outline/20 p-8">
                        <h3 style="font-family:'EB Garamond',serif; font-size:24px; font-style:italic;" class="mb-6">
                            Resumen del pedido
                        </h3>

                        <!-- Desglose de ítems -->
                        <div class="space-y-3 mb-5 max-h-48 overflow-y-auto pr-1">
                        <% for (Carrito item : items) { %>
                            <div class="flex justify-between text-sm text-on-surface-variant">
                                <span class="truncate max-w-[160px]">
                                    <%= item.getProducto().getNombre() %>
                                    <span class="text-outline">× <%= item.getCantidad() %></span>
                                </span>
                                <span class="ml-2 whitespace-nowrap">$<%= df.format(item.getSubtotal()) %></span>
                            </div>
                        <% } %>
                        </div>

                        <div class="border-t border-outline/15 pt-4 mb-2">
                            <div class="flex justify-between text-sm text-on-surface-variant mb-2">
                                <span>Subtotal</span>
                                <span>$<%= df.format(totalGeneral) %></span>
                            </div>
                            <div class="flex justify-between text-sm text-on-surface-variant mb-4">
                                <span>Envío</span>
                                <span class="text-outline">Calculado en checkout</span>
                            </div>
                            <div class="flex justify-between font-semibold text-lg border-t border-outline/15 pt-4">
                                <span style="font-family:'EB Garamond',serif;">Total</span>
                                <span style="color:#9a3a5a;">$<%= df.format(totalGeneral) %></span>
                            </div>
                        </div>

                        <!-- IR AL CHECKOUT -->
                        <a href="<%= ctx %>/checkout"
                           class="block w-full py-4 bg-primary text-white hover:bg-tertiary transition text-center"
                           style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase;">
                            <span class="material-symbols-outlined inline-block mr-2" style="font-size:16px;vertical-align:middle;">lock</span>
                            Hacer pedido
                        </a>

                        <!-- Vaciar carrito -->
                        <form action="<%= ctx %>/carrito" method="post" class="mt-3"
                              onsubmit="return confirm('¿Vaciar todo el carrito?')">
                            <input type="hidden" name="accion" value="vaciar">
                            <button type="submit"
                                    class="w-full py-3 border border-outline/30 text-on-surface-variant hover:border-red-400 hover:text-red-500 transition"
                                    style="font-family:'Manrope',sans-serif; font-size:10px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase;">
                                Vaciar carrito
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        <% } %>
    </div>
</main>

<footer class="border-t border-outline/10 py-10 px-container-margin text-center">
    <p style="font-family:'Manrope',sans-serif; font-size:10px; letter-spacing:0.2em; text-transform:uppercase; color:#877276;">
        © 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.
    </p>
</footer>

<script>
    // ── Menú de usuario con click (no hover) ──
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