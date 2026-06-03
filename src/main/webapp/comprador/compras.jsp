<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="java.util.*" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    // Solo compradores o usuarios (rol 2 o 3) pueden acceder
    if (user == null || (user.getIdRol() != 2 && user.getIdRol() != 3)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    
    // DATOS DE EJEMPLO - Después conecta con tu base de datos
    // Cada pedido es un Map con los campos: id, fecha, total, estado
    List<Map<String, Object>> pedidos = new ArrayList<>();
    
    Map<String, Object> pedido1 = new HashMap<>();
    pedido1.put("id", "Q-1001");
    pedido1.put("fecha", "15/05/2026");
    pedido1.put("total", 156000);
    pedido1.put("estado", "Entregado");
    pedidos.add(pedido1);
    
    Map<String, Object> pedido2 = new HashMap<>();
    pedido2.put("id", "Q-1002");
    pedido2.put("fecha", "28/05/2026");
    pedido2.put("total", 84000);
    pedido2.put("estado", "En proceso");
    pedidos.add(pedido2);
    
    Map<String, Object> pedido3 = new HashMap<>();
    pedido3.put("id", "Q-1003");
    pedido3.put("fecha", "02/06/2026");
    pedido3.put("total", 214000);
    pedido3.put("estado", "Pendiente");
    pedidos.add(pedido3);
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Compras | Quiddity</title>
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
                        "display-lg": ["EB Garamond"],
                        "body-lg": ["Manrope"],
                        "headline-lg": ["EB Garamond"],
                        "body-md": ["Manrope"],
                        "label-md": ["Manrope"]
                    },
                    fontSize: {
                        "headline-md": ["32px", { lineHeight: "40px", fontWeight: "400" }],
                        "display-lg": ["64px", { lineHeight: "72px", letterSpacing: "-0.01em", fontWeight: "400" }],
                        "body-lg": ["20px", { lineHeight: "32px", fontWeight: "400" }],
                        "headline-lg": ["48px", { lineHeight: "56px", fontWeight: "400" }],
                        "body-md": ["16px", { lineHeight: "24px", fontWeight: "400" }],
                        "label-md": ["13px", { lineHeight: "20px", letterSpacing: "0.1em", fontWeight: "600" }]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: #ffffff; }
        ::-webkit-scrollbar-thumb { background: #e6e1e4; }
        #announcement-bar { background-color: #c4a9a2; height: 42px; }
        .estado-entregado { background: #e6f4ea; color: #2b4413; }
        .estado-proceso  { background: #fff3e0; color: #b45f06; }
        .estado-pendiente { background: #fee2e2; color: #9a3a5a; }
    </style>
</head>
<body class="bg-white font-body-md text-on-surface">

    <!-- ANNOUNCEMENT BAR -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
            NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
        </p>
        <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white transition-colors">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
    </div>

    <!-- HEADER COMPRADOR (mismo que en catalogo.jsp) -->
    <header id="main-header"
        class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
        style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp"><h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1></a>
            <nav class="hidden md:flex gap-8">
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="<%= ctx %>/comprador/catalogo.jsp">Shop</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Nuestra historia</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Apothecary</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Blog</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <button class="text-on-surface hover:text-primary"><span class="material-symbols-outlined">search</span></button>
            <a href="<%= ctx %>/comprador/favoritos.jsp" class="text-on-surface hover:text-primary relative">
                <span class="material-symbols-outlined">favorite</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full">3</span>
            </a>
            <a href="<%= ctx %>/carrito.jsp" class="text-on-surface hover:text-primary relative">
                <span class="material-symbols-outlined">shopping_bag</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full">2</span>
            </a>
            <div class="relative group">
                <button class="flex items-center gap-2 font-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                    <%= user.getNombre() %> <span class="material-symbols-outlined text-sm">expand_more</span>
                </button>
                <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                    <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                    <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm text-primary bg-surface-variant">Mis Compras</a>
                    <div class="border-t my-1"></div>
                    <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="pt-32 pb-section-gap px-container-margin">
        <div class="max-w-6xl mx-auto">
            <h1 class="font-display-lg text-4xl md:text-5xl italic mb-2">Mis compras</h1>
            <p class="text-on-surface-variant mb-8">Revisa el estado de tus pedidos y accede a sus detalles.</p>

            <% if (pedidos.isEmpty()) { %>
                <div class="text-center py-16 border border-outline/20 bg-surface-variant/30">
                    <span class="material-symbols-outlined text-5xl text-outline mb-4">receipt_long</span>
                    <p class="text-on-surface-variant">No has realizado ninguna compra todavía.</p>
                    <a href="<%= ctx %>/comprador/catalogo.jsp" class="inline-block mt-4 text-primary underline">Explorar productos →</a>
                </div>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead class="border-b border-outline/20">
                            <tr class="font-label-md text-xs uppercase text-on-surface-variant tracking-wider">
                                <th class="pb-4">N° Pedido</th>
                                <th class="pb-4">Fecha</th>
                                <th class="pb-4">Total</th>
                                <th class="pb-4">Estado</th>
                                <th class="pb-4"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> pedido : pedidos) { 
                                String estado = (String) pedido.get("estado");
                                String claseEstado = "";
                                if ("Entregado".equals(estado)) claseEstado = "estado-entregado";
                                else if ("En proceso".equals(estado)) claseEstado = "estado-proceso";
                                else if ("Pendiente".equals(estado)) claseEstado = "estado-pendiente";
                            %>
                                <tr class="border-b border-outline/10 hover:bg-surface-variant/30 transition">
                                    <td class="py-5 font-medium">#<%= pedido.get("id") %></td>
                                    <td class="py-5"><%= pedido.get("fecha") %></td>
                                    <td class="py-5">$<%= String.format("%,d", pedido.get("total")) %></td>
                                    <td class="py-5">
                                        <span class="inline-block px-3 py-1 text-[10px] font-bold uppercase tracking-wider rounded-sm <%= claseEstado %>">
                                            <%= estado %>
                                        </span>
                                    </td>
                                    <td class="py-5">
                                        <a href="<%= ctx %>/comprador/detalle-pedido?id=<%= pedido.get("id") %>" 
                                           class="text-primary text-sm underline hover:no-underline flex items-center gap-1">
                                            Ver detalle
                                            <span class="material-symbols-outlined text-sm">arrow_forward</span>
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>

            <!-- Enlace rápido de regreso al catálogo -->
            <div class="mt-12 text-center">
                <a href="<%= ctx %>/comprador/catalogo.jsp" class="inline-flex items-center gap-2 text-primary font-label-md text-xs uppercase tracking-wider hover:underline">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    Seguir comprando
                </a>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer class="bg-white border-t border-on-surface/5 py-16 px-container-margin">
        <div class="max-w-[1440px] mx-auto text-center text-on-surface-variant text-xs">
            <p>© 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
        </div>
    </footer>

    <script>
        function closeAnnouncementBar() {
            document.getElementById('announcement-bar').style.display = 'none';
            document.getElementById('main-header').style.top = '0px';
        }
        window.addEventListener('scroll', function() {
            var header = document.getElementById('main-header');
            if (window.scrollY > 10) {
                header.classList.add('py-2');
                header.classList.remove('py-4');
            } else {
                header.classList.remove('py-2');
                header.classList.add('py-4');
            }
        });
    </script>
</body>
</html>