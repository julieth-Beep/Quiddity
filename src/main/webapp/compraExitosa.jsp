<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();

    Double total    = (Double)  request.getAttribute("total");
    Integer numItems = (Integer) request.getAttribute("numItems");
    if (total == null)    total = 0.0;
    if (numItems == null) numItems = 0;

    DecimalFormat df = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compra Exitosa | Quiddity</title>
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect" />
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&family=Manrope:wght@200..800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#9a3a5a",
                        "secondary": "#516617",
                        "tertiary": "#88495a",
                        "background": "#ffffff",
                        "surface": "#ffffff",
                        "on-surface": "#1c1b1d",
                        "on-surface-variant": "#544246",
                        "outline": "#877276",
                        "surface-variant": "#f1ecef"
                    },
                    borderRadius: { DEFAULT: "0px", lg: "0px", xl: "0px", full: "9999px" },
                    spacing: {
                        "container-margin": "80px",
                        "element-gap": "24px",
                        "gutter": "32px",
                        "section-gap": "120px"
                    },
                    fontFamily: {
                        "headline-md": ["EB Garamond"],
                        "display-lg":  ["EB Garamond"],
                        "body-lg":     ["Manrope"],
                        "headline-lg": ["EB Garamond"],
                        "body-md":     ["Manrope"],
                        "label-md":    ["Manrope"]
                    },
                    fontSize: {
                        "headline-md": ["32px", { lineHeight: "40px", fontWeight: "400" }],
                        "display-lg":  ["64px", { lineHeight: "72px", letterSpacing: "-0.01em", fontWeight: "400" }],
                        "body-lg":     ["20px", { lineHeight: "32px", fontWeight: "400" }],
                        "headline-lg": ["48px", { lineHeight: "56px", fontWeight: "400" }],
                        "body-md":     ["16px", { lineHeight: "24px", fontWeight: "400" }],
                        "label-md":    ["13px", { lineHeight: "20px", letterSpacing: "0.1em", fontWeight: "600" }]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        #announcement-bar { background-color: #c4a9a2; height: 42px; }
        @keyframes checkDraw {
            from { stroke-dashoffset: 100; }
            to   { stroke-dashoffset: 0; }
        }
        .check-path {
            stroke-dasharray: 100;
            stroke-dashoffset: 100;
            animation: checkDraw 0.6s ease forwards 0.3s;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-up { animation: fadeUp 0.5s ease forwards; }
        .fade-up-1 { opacity: 0; animation: fadeUp 0.5s ease forwards 0.5s; }
        .fade-up-2 { opacity: 0; animation: fadeUp 0.5s ease forwards 0.7s; }
        .fade-up-3 { opacity: 0; animation: fadeUp 0.5s ease forwards 0.9s; }
    </style>
</head>
<body class="bg-white font-body-md text-on-surface">

    <!-- ANNOUNCEMENT BAR -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000</p>
    </div>

    <!-- HEADER -->
    <header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300" style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp">
                <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1>
            </a>
            <nav class="hidden md:flex gap-8">
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="<%= ctx %>/comprador/catalogo.jsp">Shop</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Nuestra historia</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Apothecary</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Blog</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <a href="<%= ctx %>/carrito" class="text-on-surface hover:text-primary relative">
                <span class="material-symbols-outlined">shopping_bag</span>
            </a>
            <div class="relative group">
                <button class="flex items-center gap-2 font-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                    <%= user.getNombre() %> <span class="material-symbols-outlined text-sm">expand_more</span>
                </button>
                <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                    <a href="<%= ctx %>/comprador/perfil.jsp"  class="block px-4 py-2 text-sm hover:bg-surface-variant">Mi Perfil</a>
                    <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm hover:bg-surface-variant">Mis Compras</a>
                    <div class="border-t my-1"></div>
                    <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
                </div>
            </div>
        </div>
    </header>

    <!-- MAIN -->
    <main class="min-h-screen flex items-center justify-center px-container-margin" style="padding-top: 120px; padding-bottom: 80px;">
        <div class="max-w-lg w-full text-center">

            <!-- Ícono animado -->
            <div class="fade-up flex justify-center mb-8">
                <div class="w-24 h-24 rounded-full border-2 border-primary flex items-center justify-center">
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path class="check-path" d="M10 26L20 36L38 14"
                              stroke="#9a3a5a" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
            </div>

            <!-- Título -->
            <h1 class="fade-up-1 font-display-lg text-4xl md:text-5xl italic text-on-surface mb-3">
                ¡Gracias por tu compra!
            </h1>

            <!-- Subtítulo -->
            <p class="fade-up-1 text-on-surface-variant mb-10">
                Tu pedido ha sido confirmado y está siendo procesado.
            </p>

            <!-- Resumen -->
            <div class="fade-up-2 border border-outline/20 bg-surface-variant/30 p-8 mb-8 text-left">
                <h2 class="font-label-md text-xs uppercase tracking-widest text-on-surface-variant mb-5">Resumen del pedido</h2>
                <div class="flex justify-between items-center py-3 border-b border-outline/10">
                    <span class="text-on-surface-variant text-sm">Productos</span>
                    <span class="font-medium"><%= numItems %> <%= numItems == 1 ? "artículo" : "artículos" %></span>
                </div>
                <div class="flex justify-between items-center py-3 border-b border-outline/10">
                    <span class="text-on-surface-variant text-sm">Envío</span>
                    <span class="font-medium text-secondary">Gratis</span>
                </div>
                <div class="flex justify-between items-center pt-4">
                    <span class="font-label-md text-xs uppercase tracking-widest">Total pagado</span>
                    <span class="font-display-lg text-2xl text-primary">$<%= df.format(total) %></span>
                </div>
            </div>

            <!-- Info de seguimiento -->
            <p class="fade-up-2 text-sm text-on-surface-variant mb-10">
                Recibirás un correo a <strong><%= user.getEmail() %></strong> con los detalles y el seguimiento de tu pedido.
            </p>

            <!-- Acciones -->
            <div class="fade-up-3 flex flex-col sm:flex-row gap-4 justify-center">
                <a href="<%= ctx %>/comprador/compras.jsp"
                   class="inline-flex items-center justify-center gap-2 border border-primary text-primary px-8 py-3 font-label-md text-xs uppercase tracking-widest hover:bg-primary hover:text-white transition-colors duration-200">
                    <span class="material-symbols-outlined text-base">receipt_long</span>
                    Ver mis compras
                </a>
                <a href="<%= ctx %>/comprador/catalogo.jsp"
                   class="inline-flex items-center justify-center gap-2 bg-primary text-white px-8 py-3 font-label-md text-xs uppercase tracking-widest hover:bg-tertiary transition-colors duration-200">
                    <span class="material-symbols-outlined text-base">storefront</span>
                    Seguir comprando
                </a>
            </div>

        </div>
    </main>

</body>
</html>
