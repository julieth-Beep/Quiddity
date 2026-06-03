<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.quiddity.model.Usuario" %>
        <%@ page import="com.quiddity.dao.UsuarioDAO" %>
            <% Usuario user=(Usuario) session.getAttribute("usuario"); if (user==null || (user.getIdRol() !=2 &&
                user.getIdRol() !=3)) { response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; }
                String ctx=request.getContextPath(); String nombreCompleto=user.getNombre() + (user.getApellido() !=null
                ? " " + user.getApellido() : "" ); String iniciales="" ; if (user.getNombre() !=null &&
                user.getNombre().length()> 0) {
                iniciales += user.getNombre().charAt(0);
                if (user.getApellido() != null && user.getApellido().length() > 0) iniciales +=
                user.getApellido().charAt(0);
                else if (user.getNombre().length() > 1) iniciales += user.getNombre().charAt(1);
                else iniciales += "U";
                } else {
                iniciales = "U";
                }
                iniciales = iniciales.toUpperCase();
                %>
                <!DOCTYPE html>
                <html class="light" lang="es">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Mi Perfil | Quiddity</title>
                    <link href="https://fonts.googleapis.com" rel="preconnect" />
                    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&family=Manrope:wght@200..800&display=swap"
                        rel="stylesheet" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                        rel="stylesheet" />
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
                                        "surface-container-low": "#ffffff",
                                        "surface-container-lowest": "#ffffff",
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
                        /* Estilos globales (los mismos de tu catalogo.jsp) */
                        .material-symbols-outlined {
                            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
                        }

                        ::-webkit-scrollbar {
                            width: 4px;
                        }

                        ::-webkit-scrollbar-track {
                            background: #ffffff;
                        }

                        ::-webkit-scrollbar-thumb {
                            background: #e6e1e4;
                        }

                        #announcement-bar {
                            background-color: #c4a9a2;
                            height: 42px;
                        }

                        /* Estilos específicos para el perfil (sidebar, tarjetas, etc.) */
                        .profile-sidebar {
                            background: #fff;
                            border-right: 1px solid rgba(154, 58, 90, 0.08);
                            padding: 32px 24px;
                            border-radius: 0;
                        }

                        .avatar-ring {
                            width: 80px;
                            height: 80px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #9a3a5a, #88495a);
                            padding: 2px;
                        }

                        .avatar-inner {
                            width: 100%;
                            height: 100%;
                            border-radius: 50%;
                            background: #f1ecef;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-family: 'EB Garamond', serif;
                            font-size: 28px;
                            color: #9a3a5a;
                        }

                        .stat-pill {
                            background: #f1ecef;
                            padding: 12px 10px;
                            text-align: center;
                        }

                        .stat-num {
                            font-family: 'EB Garamond', serif;
                            font-size: 22px;
                        }

                        .nav-item {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 10px 12px;
                            font-size: 11px;
                            font-weight: 600;
                            letter-spacing: 0.12em;
                            text-transform: uppercase;
                            color: #544246;
                            transition: all 0.2s;
                            border-left: 2px solid transparent;
                        }

                        .nav-item.active {
                            color: #9a3a5a;
                            border-left-color: #9a3a5a;
                            background: rgba(154, 58, 90, 0.05);
                        }

                        .nav-item:hover {
                            background: rgba(154, 58, 90, 0.04);
                            color: #9a3a5a;
                        }

                        .order-card {
                            background: #fff;
                            border: 1px solid rgba(154, 58, 90, 0.08);
                            padding: 16px 18px;
                            transition: all 0.25s;
                        }

                        .order-card:hover {
                            border-color: rgba(154, 58, 90, 0.2);
                        }

                        .order-card-value {
                            font-family: 'EB Garamond', serif;
                            font-size: 24px;
                        }

                        .alert-success {
                            background: #e6f4ea;
                            border-left: 4px solid #516617;
                            padding: 12px 16px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            margin-bottom: 20px;
                        }

                        .alert-error {
                            background: #fee2e2;
                            border-left: 4px solid #9a3a5a;
                            padding: 12px 16px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            margin-bottom: 20px;
                        }

                        .fav-chip {
                            border: 1.5px solid rgba(154, 58, 90, 0.2);
                            padding: 6px 14px;
                            font-size: 10px;
                            font-weight: 600;
                            letter-spacing: 0.12em;
                            text-transform: uppercase;
                            color: #544246;
                            cursor: pointer;
                            transition: all 0.2s;
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .fav-chip:hover {
                            border-color: #9a3a5a;
                            color: #9a3a5a;
                        }

                        .fav-chip.active {
                            background: rgba(154, 58, 90, 0.08);
                            color: #9a3a5a;
                            border-color: #9a3a5a;
                        }
                    </style>
                </head>

                <body class="bg-white font-body-md text-on-surface">

                    <!-- ANNOUNCEMENT BAR (igual que en catalogo.jsp) -->
                    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
                        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
                            NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
                        </p>
                        <button onclick="closeAnnouncementBar()"
                            class="absolute right-6 text-white/60 hover:text-white transition-colors">
                            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
                        </button>
                    </div>

                    <!-- HEADER (exactamente igual que en catalogo.jsp) -->
                    <header id="main-header"
                        class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
                        style="top: 42px;">
                        <div class="flex items-center gap-12">
                            <a href="<%= ctx %>/index.jsp">
                                <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">
                                    Quiddity</h1>
                            </a>
                            <nav class="hidden md:flex gap-8">
                                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                    href="<%= ctx %>/comprador/catalogo.jsp">Shop</a>
                                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                    href="#">Nuestra historia</a>
                                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                    href="#">Apothecary</a>
                                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                    href="#">Blog</a>
                            </nav>
                        </div>
                        <div class="flex items-center gap-6">
                            <button class="text-on-surface hover:text-primary"><span
                                    class="material-symbols-outlined">search</span></button>
                            <a href="<%= ctx %>/comprador/favoritos.jsp"
                                class="text-on-surface hover:text-primary relative">
                                <span class="material-symbols-outlined">favorite</span>
                                <span
                                    class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center">3</span>
                            </a>
                            <a href="<%= ctx %>/carrito.jsp" class="text-on-surface hover:text-primary relative">
                                <span class="material-symbols-outlined">shopping_bag</span>
                                <span
                                    class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center">2</span>
                            </a>
                            <div class="relative group">
                                <button
                                    class="flex items-center gap-2 font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                                    <%= user.getNombre() %>
                                        <span class="material-symbols-outlined text-sm">expand_more</span>
                                </button>
                                <div
                                    class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                                    <a href="<%= ctx %>/comprador/perfil.jsp"
                                        class="block px-4 py-2 text-sm text-primary bg-surface-variant">Mi Perfil</a>
                                    <a href="<%= ctx %>/comprador/compras.jsp"
                                        class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis
                                        Compras</a>
                                    <div class="border-t my-1"></div>
                                    <a href="<%= ctx %>/logout"
                                        class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar
                                        sesión</a>
                                </div>
                            </div>
                        </div>
                    </header>

                    <!-- MAIN: aquí va todo el contenido del perfil (sidebar + formulario) -->
                    <main class="pt-32 pb-section-gap px-container-margin">
                        <div class="max-w-7xl ml-0 mr-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

                            <!-- SIDEBAR IZQUIERDO (perfil) -->
                            <div class="lg:col-span-1 profile-sidebar">
                                <div class="flex flex-col items-center text-center mb-6">
                                    <div
                                        class="w-40 h-40 rounded-full bg-gradient-to-tr from-primary to-tertiary p-[2px] mx-auto mb-3">
                                        <div
                                            class="w-full h-full rounded-full bg-surface-variant flex items-center justify-center font-serif text-4xl text-primary">
                                            <%= iniciales %>
                                        </div>
                                    </div>
                                    <h2 class="font-headline-md text-xl">
                                        <%= nombreCompleto %>
                                    </h2>
                                    <span
                                        class="text-xs text-primary font-bold uppercase tracking-widest bg-primary/10 px-3 py-1 mt-1">Comprador</span>
                                </div>

                                <div class="grid grid-cols-2 gap-3 mb-8">
                                    <div class="stat-pill"><span class="stat-num block">12</span><span
                                            class="text-[9px] uppercase tracking-wider">Pedidos</span></div>
                                    <div class="stat-pill"><span class="stat-num block">5</span><span
                                            class="text-[9px] uppercase tracking-wider">Favoritos</span></div>
                                    <div class="stat-pill"><span class="stat-num block">1,240</span><span
                                            class="text-[9px] uppercase tracking-wider">Puntos</span></div>
                                    <div class="stat-pill"><span class="stat-num block">Silver</span><span
                                            class="text-[9px] uppercase tracking-wider">Nivel</span></div>
                                </div>




                            </div>

                            <!-- CONTENIDO DERECHO (formularios) -->
                            <div class="lg:col-span-2 space-y-8">
                                <!-- Alertas dinámicas -->
                                <% String exito=(String) session.getAttribute("perfilExito"); String error=(String)
                                    session.getAttribute("perfilError"); if (exito !=null) {
                                    session.removeAttribute("perfilExito"); %>
                                    <div class="alert-success">
                                        <span class="material-symbols-outlined text-secondary">check_circle</span>
                                        <span>
                                            <%= exito %>
                                        </span>
                                    </div>
                                    <% } else if (error !=null) { session.removeAttribute("perfilError"); %>
                                        <div class="alert-error">
                                            <span class="material-symbols-outlined text-primary">error</span>
                                            <span>
                                                <%= error %>
                                            </span>
                                        </div>
                                        <% } %>

                                            <!-- Datos personales -->
                                            <div>
                                                <h3
                                                    class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6 py-6">
                                                    Datos personales</h3>
                                                <form action="<%= ctx %>/comprador/actualizar-perfil" method="post"
                                                    class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                    <input type="hidden" name="accion" value="actualizarDatos">
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Nombre</label>
                                                        <input type="text" name="nombre"
                                                            value="<%= user.getNombre() != null ? user.getNombre() : "" %>"
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Apellido</label>
                                                        <input type="text" name="apellido"
                                                            value="<%= user.getApellido() != null ? user.getApellido() : "" %>"
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Correo
                                                            electrónico</label>
                                                        <input type="email" name="email" value="<%= user.getEmail() %>"
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Usuario</label>
                                                        <input type="text" value="<%= user.getUserName() %>" disabled
                                                            class="w-full border-b border-outline/20 py-2 bg-surface-variant/50 cursor-not-allowed">
                                                        <p class="text-[9px] text-outline mt-1">No se puede modificar
                                                        </p>
                                                    </div>
                                                    <div class="md:col-span-2">
                                                        <button type="submit"
                                                            class="bg-primary text-white text-[11px] font-bold uppercase tracking-wider px-8 py-3 hover:bg-tertiary transition">Guardar
                                                            cambios</button>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Cambiar contraseña -->
                                            <div>
                                                <h3
                                                    class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6">
                                                    Seguridad</h3>
                                                <form action="<%= ctx %>/comprador/actualizar-perfil" method="post"
                                                    class="space-y-5 max-w-lg">
                                                    <input type="hidden" name="accion" value="cambiarPassword">
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Contraseña
                                                            actual</label>
                                                        <input type="password" name="contrasenaActual" required
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Nueva
                                                            contraseña</label>
                                                        <input type="password" name="nuevaContrasena" required
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Confirmar
                                                            nueva contraseña</label>
                                                        <input type="password" name="confirmarContrasena" required
                                                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                                                    </div>
                                                    <button type="submit"
                                                        class="border border-primary text-primary text-[11px] font-bold uppercase tracking-wider px-8 py-3 hover:bg-primary hover:text-white transition">Actualizar
                                                        contraseña</button>
                                                </form>
                                            </div>

                            </div>
                        </div>
                    </main>

                    <!-- FOOTER (igual que en catalogo.jsp) -->
                    <footer class="bg-white border-t border-on-surface/3 py-10 px-container-margin">
                        <div class="max-w-[1440px] mx-auto text-center text-on-surface-variant text-xs">
                            <p>© 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
                        </div>
                    </footer>

                    <script>
                        function closeAnnouncementBar() {
                            document.getElementById('announcement-bar').style.display = 'none';
                            document.getElementById('main-header').style.top = '0px';
                        }
                        window.addEventListener('scroll', function () {
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