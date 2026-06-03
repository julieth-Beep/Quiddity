<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Catalogo" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || (user.getIdRol() != 2 && user.getIdRol() != 3)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    
    // DATOS DE EJEMPLO (mientras no tengas FavoritoDAO)
    List<Catalogo> favoritos = new ArrayList<>();
    Catalogo p1 = new Catalogo();
    p1.setId(1);
    p1.setNombre("Radiance Elixir");
    p1.setPrecio(84000);
    p1.setImagen("uploads/catalogo/cuidado/skinCare/serum/gold.jpg");
    favoritos.add(p1);
    
    Catalogo p2 = new Catalogo();
    p2.setId(2);
    p2.setNombre("Velvet Cloud Cream");
    p2.setPrecio(62000);
    p2.setImagen("uploads/catalogo/cuidado/skinCare/cremas/cream.jpg");
    favoritos.add(p2);
    
    Catalogo p3 = new Catalogo();
    p3.setId(3);
    p3.setNombre("Base Botánica SPF");
    p3.setPrecio(89000);
    p3.setImagen("uploads/catalogo/belleza/makeUp/base/base.jpg");
    favoritos.add(p3);
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Favoritos | Quiddity</title>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;1,400;1,500&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        #announcement-bar { background-color: #c4a9a2; height: 42px; }
    </style>
</head>
<body class="bg-white font-body-md">

    <!-- ANNOUNCEMENT BAR (copiar de catalogo.jsp) -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000</p>
        <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white"><span class="material-symbols-outlined">close</span></button>
    </div>

    <!-- HEADER (igual que en catalogo.jsp) -->
    <header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-20 py-4 border-b" style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp"><h1 class="font-serif text-3xl tracking-[0.2em] text-primary uppercase">Quiddity</h1></a>
            <nav class="hidden md:flex gap-8">
                <a class="text-xs uppercase hover:text-primary" href="<%= ctx %>/comprador/catalogo.jsp">Shop</a>
                <a class="text-xs uppercase hover:text-primary" href="#">Nuestra historia</a>
                <a class="text-xs uppercase hover:text-primary" href="#">Apothecary</a>
                <a class="text-xs uppercase hover:text-primary" href="#">Blog</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <a href="<%= ctx %>/comprador/favoritos.jsp" class="relative">
                <span class="material-symbols-outlined">favorite</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full"><%= favoritos.size() %></span>
            </a>
            <a href="<%= ctx %>/carrito.jsp" class="relative">
                <span class="material-symbols-outlined">shopping_bag</span>
                <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full">2</span>
            </a>
            <div class="relative group">
                <button class="flex items-center gap-2 text-xs uppercase"><%= user.getNombre() %> <span class="material-symbols-outlined text-sm">expand_more</span></button>
                <div class="absolute right-0 mt-2 w-48 bg-white shadow hidden group-hover:block">
                    <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm">Mi Perfil</a>
                    <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm">Mis Compras</a>
                    <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary">Cerrar sesión</a>
                </div>
            </div>
        </div>
    </header>

    <main class="pt-32 pb-20 px-20">
        <div class="max-w-7xl mx-auto">
            <h1 class="font-serif text-4xl italic mb-8">Productos favoritos</h1>
            <% if (favoritos.isEmpty()) { %>
                <p class="text-center text-gray-500">No tienes productos favoritos aún.</p>
            <% } else { %>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                    <% for (Catalogo p : favoritos) { %>
                        <div class="group">
                            <div class="aspect-[4/5] overflow-hidden bg-gray-100 mb-4">
                                <img src="<%= ctx %>/<%= p.getImagen() %>" class="w-full h-full object-cover group-hover:scale-105 transition">
                            </div>
                            <h3 class="font-serif text-xl"><%= p.getNombre() %></h3>
                            <p class="text-primary font-bold">$<%= String.format("%,d", (int)p.getPrecio()) %></p>
                            <button onclick="quitarFavorito(<%= p.getId() %>)" class="mt-2 text-primary text-sm underline">Quitar de favoritos</button>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="border-t py-12 text-center text-xs text-gray-400">
        <p>© 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
    </footer>

    <script>
        function closeAnnouncementBar() {
            document.getElementById('announcement-bar').style.display = 'none';
            document.getElementById('main-header').style.top = '0px';
        }
        function quitarFavorito(id) {
            alert('Funcionalidad en desarrollo: quitar favorito ' + id);
            // Aquí llamarás a un servlet /favoritos/eliminar?id=...
        }
    </script>
</body>
</html>