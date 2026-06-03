<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Carrito" %>
<%@ page import="com.quiddity.dao.CarritoDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    // Solo usuarios logueados (compradores o usuarios) pueden ver carrito
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    DecimalFormat df = new DecimalFormat("#,###");
    CarritoDAO carritoDAO = new CarritoDAO();
    List<Carrito> items = carritoDAO.getCarritoByUsuario(user.getId());
    double totalGeneral = carritoDAO.getTotalCarrito(user.getId());
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
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #e6e1e4;
            padding: 6px;
            font-size: 14px;
        }
    </style>
</head>
<body class="bg-white font-body-md text-on-surface">

    <!-- ANNOUNCEMENT BAR -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000</p>
        <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
    </div>

    <!-- HEADER (versión comprador, igual que en otras páginas) -->
    <header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300" style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp"><h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1></a>
            <nav class="hidden md:flex gap-8">
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="<%= ctx %>/comprador/catalogo.jsp">Shop</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Nuestra historia</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Apothecary</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary" href="#">Blog</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <button class="text-on-surface hover:text-primary"><span class="material-symbols-outlined">search</span></button>
            <a href="<%= ctx %>/comprador/favoritos.jsp" class="text-on-surface hover:text-primary relative">
                <span class="material-symbols-outlined">favorite</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full">3</span>
            </a>
            <a href="<%= ctx %>/carrito.jsp" class="text-primary relative">
                <span class="material-symbols-outlined">shopping_bag</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full"><%= items.size() %></span>
            </a>
            <div class="relative group">
                <button class="flex items-center gap-2 font-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                    <%= user.getNombre() %> <span class="material-symbols-outlined text-sm">expand_more</span>
                </button>
                <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                    <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm hover:bg-surface-variant">Mi Perfil</a>
                    <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm hover:bg-surface-variant">Mis Compras</a>
                    <div class="border-t my-1"></div>
                    <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="pt-32 pb-section-gap px-container-margin">
        <div class="max-w-6xl mx-auto">
            <h1 class="font-display-lg text-4xl md:text-5xl italic mb-2">Carrito de compras</h1>
            <p class="text-on-surface-variant mb-8">Revisa y modifica los productos que deseas adquirir.</p>

            <% if (items.isEmpty()) { %>
                <div class="text-center py-16 border border-outline/20 bg-surface-variant/30">
                    <span class="material-symbols-outlined text-5xl text-outline mb-4">shopping_bag</span>
                    <p class="text-on-surface-variant">Tu carrito está vacío.</p>
                    <a href="<%= ctx %>/comprador/catalogo.jsp" class="inline-block mt-4 text-primary underline">Seguir comprando →</a>
                </div>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead class="border-b border-outline/20">
                            <tr class="font-label-md text-xs uppercase text-on-surface-variant tracking-wider">
                                <th class="pb-4">Producto</th>
                                <th class="pb-4">Precio</th>
                                <th class="pb-4">Cantidad</th>
                                <th class="pb-4">Subtotal</th>
                                <th class="pb-4"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Carrito item : items) { 
                                double subtotal = item.getSubtotal();
                            %>
                                <tr class="border-b border-outline/10 hover:bg-surface-variant/30 transition" id="fila-<%= item.getId() %>">
                                    <td class="py-5">
                                        <div class="flex gap-4 items-center">
                                            <div class="w-20 h-20 bg-surface-variant overflow-hidden">
                                                <img src="<%= ctx %>/<%= item.getProducto().getImagen() %>" alt="<%= item.getProducto().getNombre() %>" class="w-full h-full object-cover">
                                            </div>
                                            <div>
                                                <h3 class="font-headline-md text-lg"><%= item.getProducto().getNombre() %></h3>
                                                <p class="text-xs text-on-surface-variant"><%= item.getProducto().getCategoria() %></p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-5">$<%= df.format(item.getProducto().getPrecio()) %></td>
                                    <td class="py-5">
                                        <form action="<%= ctx %>/carrito/actualizar" method="post" class="flex items-center gap-2">
                                            <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                            <input type="number" name="cantidad" value="<%= item.getCantidad() %>" min="1" max="<%= item.getProducto().getStock() %>" class="quantity-input border-outline/30 focus:border-primary">
                                            <button type="submit" class="text-primary hover:bg-primary/10 p-1 rounded-full">
                                                <span class="material-symbols-outlined text-sm">refresh</span>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="py-5 font-medium">$<%= df.format(subtotal) %></td>
                                    <td class="py-5">
                                        <a href="<%= ctx %>/carrito/eliminar?itemId=<%= item.getId() %>" class="text-on-surface-variant hover:text-red-500 transition" onclick="return confirm('¿Eliminar este producto?')">
                                            <span class="material-symbols-outlined">delete</span>
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Resumen y totales -->
                <div class="mt-10 flex flex-col md:flex-row justify-end border-t border-outline/20 pt-8">
                    <div class="w-full md:w-80 p-6 bg-surface-variant/30">
                        <h3 class="font-headline-md text-2xl mb-4">Resumen</h3>
                        <div class="flex justify-between py-2">
                            <span>Subtotal</span>
                            <span>$<%= df.format(totalGeneral) %></span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-outline/10 mb-4">
                            <span>Envío</span>
                            <span>Calculado en checkout</span>
                        </div>
                        <div class="flex justify-between font-bold text-lg">
                            <span>Total</span>
                            <span>$<%= df.format(totalGeneral) %></span>
                        </div>
                        <div class="mt-6 flex gap-3">
                            <a href="<%= ctx %>/carrito/vaciar" class="flex-1 text-center border border-outline text-on-surface-variant font-label-md text-xs uppercase py-3 hover:border-red-400 hover:text-red-500 transition" onclick="return confirm('¿Vaciar todo el carrito?')">
                                Vaciar
                            </a>
                            <a href="<%= ctx %>/checkout" class="flex-1 text-center bg-primary text-white font-label-md text-xs uppercase py-3 hover:bg-tertiary transition">
                                Proceder al pago
                            </a>
                        </div>
                    </div>
                </div>
                <div class="mt-6 text-center">
                    <a href="<%= ctx %>/comprador/catalogo.jsp" class="inline-flex items-center gap-2 text-primary font-label-md text-xs uppercase tracking-wider hover:underline">
                        <span class="material-symbols-outlined text-sm">arrow_back</span>
                        Seguir comprando
                    </a>
                </div>
            <% } %>
        </div>
    </main>

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
        window.addEventListener('scroll', () => {
            const header = document.getElementById('main-header');
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