<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.dao.UsuarioDAO" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || (user.getIdRol() != 2 && user.getIdRol() != 3)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    String nombreCompleto = user.getNombre() + (user.getApellido() != null ? " " + user.getApellido() : "");
    String iniciales = "";
    if (user.getNombre() != null && user.getNombre().length() > 0) {
        iniciales += user.getNombre().charAt(0);
        if (user.getApellido() != null && user.getApellido().length() > 0)
            iniciales += user.getApellido().charAt(0);
        else if (user.getNombre().length() > 1)
            iniciales += user.getNombre().charAt(1);
        else iniciales += "U";
    } else {
        iniciales = "U";
    }
    iniciales = iniciales.toUpperCase();

    String rolLabel = user.getIdRol() == 2 ? "Comprador" : "Usuario";

    String perfilExito = (String) session.getAttribute("perfilExito");
    String perfilError = (String) session.getAttribute("perfilError");
    session.removeAttribute("perfilExito");
    session.removeAttribute("perfilError");
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil | Quiddity</title>
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
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: #ffffff; }
        ::-webkit-scrollbar-thumb { background: #e6e1e4; }
        #announcement-bar { background-color: #c4a9a2; height: 42px; }

        .profile-sidebar {
            background: #fff;
            border-right: 1px solid rgba(154,58,90,0.08);
            padding: 32px 24px;
        }
        .stat-pill { background: #f1ecef; padding: 12px 10px; text-align: center; }
        .stat-num { font-family: 'EB Garamond', serif; font-size: 22px; }

        .alert-success {
            background: #e6f4ea; border-left: 4px solid #516617;
            padding: 12px 16px; display: flex; align-items: center; gap: 10px; margin-bottom: 20px;
        }
        .alert-error {
            background: #fee2e2; border-left: 4px solid #9a3a5a;
            padding: 12px 16px; display: flex; align-items: center; gap: 10px; margin-bottom: 20px;
        }

        /* Modal advertencia rol */
        #modalRol {
            display: none;
            position: fixed; inset: 0; z-index: 200;
            background: rgba(0,0,0,0.45);
            align-items: center; justify-content: center;
        }
        #modalRol.open { display: flex; }
        .modal-box {
            background: #fff;
            padding: 36px 32px;
            max-width: 420px; width: 90%;
            border-top: 4px solid #9a3a5a;
        }
    </style>
</head>
<body class="bg-white font-body-md text-on-surface">

<!-- MODAL ADVERTENCIA CAMBIO DE ROL -->
<div id="modalRol">
    <div class="modal-box">
        <div class="flex items-center gap-3 mb-4">
            <span class="material-symbols-outlined text-primary" style="font-size:28px">warning</span>
            <h3 class="font-headline-md text-xl">Cambiar tipo de cuenta</h3>
        </div>
        <p class="text-sm text-on-surface-variant mb-2" id="modalMensaje"></p>
        <ul class="text-sm text-on-surface-variant mb-6 list-disc list-inside space-y-1" id="modalLista"></ul>
        <div class="flex gap-3 justify-end">
            <button onclick="cerrarModal()"
                class="border border-outline/30 text-on-surface text-[11px] font-bold uppercase tracking-wider px-6 py-2 hover:bg-surface-variant transition">
                Cancelar
            </button>
            <button onclick="confirmarRol()"
                class="bg-primary text-white text-[11px] font-bold uppercase tracking-wider px-6 py-2 hover:bg-tertiary transition">
                Confirmar
            </button>
        </div>
    </div>
</div>

<!-- ANNOUNCEMENT BAR -->
<div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
    <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
        NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
    </p>
    <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white transition-colors">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<!-- HEADER -->
<header id="main-header"
    class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
    style="top: 42px;">
    <div class="flex items-center gap-12">
        <a href="<%= ctx %>/index.jsp">
            <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1>
        </a>
        <nav class="hidden md:flex gap-8">
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="<%= ctx %>/catalogo">Shop</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Nuestra historia</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Apothecary</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Blog</a>
        </nav>
    </div>
    <div class="flex items-center gap-6">
        <button class="text-on-surface hover:text-primary"><span class="material-symbols-outlined">search</span></button>
        <a href="<%= ctx %>/comprador/favoritos.jsp" class="text-on-surface hover:text-primary relative">
            <span class="material-symbols-outlined">favorite</span>
            <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center">3</span>
        </a>
        <a href="<%= ctx %>/carrito.jsp" class="text-on-surface hover:text-primary relative">
            <span class="material-symbols-outlined">shopping_bag</span>
            <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center">2</span>
        </a>
        <div class="relative" id="user-menu-container">
            <button id="user-menu-btn" class="flex items-center gap-2 font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                <%= user.getNombre() %>
                <span id="user-menu-icon" class="material-symbols-outlined text-sm">expand_more</span>
            </button>
            <div id="user-menu-dropdown" class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden z-50">
                <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Compras</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/pedidos" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Pedidos</a>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<!-- MAIN -->
<main class="pt-32 pb-section-gap px-container-margin">
    <div class="max-w-7xl ml-0 mr-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- SIDEBAR -->
        <div class="lg:col-span-1 profile-sidebar">
            <div class="flex flex-col items-center text-center mb-6">
                <!-- Avatar con foto o iniciales -->
                <div class="w-40 h-40 rounded-full overflow-hidden bg-gradient-to-tr from-primary to-tertiary p-[2px] mx-auto mb-3 flex-shrink-0">
                    <div class="w-full h-full rounded-full overflow-hidden bg-surface-variant flex items-center justify-center" id="sidebarAvatarWrap">
                        <% if (user.getFotoPerfil() != null && !user.getFotoPerfil().isBlank()) { %>
                            <img src="<%= ctx %>/foto-perfil/<%= user.getFotoPerfil() %>"
                                 class="w-full h-full object-cover" id="sidebarAvatarImg" alt="Foto">
                        <% } else { %>
                            <span class="font-serif text-4xl text-primary" id="sidebarIniciales"><%= iniciales %></span>
                            <img src="" class="w-full h-full object-cover hidden" id="sidebarAvatarImg" alt="">
                        <% } %>
                    </div>
                </div>
                <h2 class="font-headline-md text-xl"><%= nombreCompleto %></h2>
                <span class="text-xs text-primary font-bold uppercase tracking-widest bg-primary/10 px-3 py-1 mt-1">
                    <%= rolLabel %>
                </span>
            </div>

            <div class="grid grid-cols-2 gap-3 mb-8">
                <div class="stat-pill"><span class="stat-num block">12</span><span class="text-[9px] uppercase tracking-wider">Pedidos</span></div>
                <div class="stat-pill"><span class="stat-num block">5</span><span class="text-[9px] uppercase tracking-wider">Favoritos</span></div>
                <div class="stat-pill"><span class="stat-num block">1,240</span><span class="text-[9px] uppercase tracking-wider">Puntos</span></div>
                <div class="stat-pill"><span class="stat-num block">Silver</span><span class="text-[9px] uppercase tracking-wider">Nivel</span></div>
            </div>
        </div>

        <!-- CONTENIDO DERECHO -->
        <div class="lg:col-span-2 space-y-8">

            <!-- Alertas flash -->
            <% if (perfilExito != null) { %>
                <div class="alert-success">
                    <span class="material-symbols-outlined" style="color:#516617">check_circle</span>
                    <span><%= perfilExito %></span>
                </div>
            <% } else if (perfilError != null) { %>
                <div class="alert-error">
                    <span class="material-symbols-outlined" style="color:#9a3a5a">error</span>
                    <span><%= perfilError %></span>
                </div>
            <% } %>

            <!-- FOTO DE PERFIL -->
            <div>
                <h3 class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6 py-4">Foto de perfil</h3>
                <form action="<%= ctx %>/perfil" method="post" enctype="multipart/form-data" id="formFoto">
                    <div class="flex items-center gap-6 flex-wrap">
                        <!-- Preview -->
                        <div class="w-20 h-20 rounded-full overflow-hidden bg-surface-variant flex items-center justify-center flex-shrink-0">
                            <% if (user.getFotoPerfil() != null && !user.getFotoPerfil().isBlank()) { %>
                                <img src="<%= ctx %>/foto-perfil/<%= user.getFotoPerfil() %>"
                                     class="w-full h-full object-cover" id="fotoPreviewImg" alt="Foto">
                            <% } else { %>
                                <span class="font-serif text-2xl text-primary" id="fotoIniciales"><%= iniciales %></span>
                                <img src="" class="w-full h-full object-cover hidden" id="fotoPreviewImg" alt="">
                            <% } %>
                        </div>
                        <div class="flex-1">
                            <label for="fotoInput"
                                class="cursor-pointer inline-flex items-center gap-2 border border-outline/30 px-5 py-2 text-[11px] font-bold uppercase tracking-wider hover:border-primary hover:text-primary transition">
                                <span class="material-symbols-outlined text-base">upload</span>
                                Seleccionar imagen
                            </label>
                            <input type="file" name="foto" id="fotoInput" accept="image/*" class="hidden">
                            <p class="text-[10px] text-outline mt-2">JPG, PNG o WEBP — máx. 5 MB</p>
                            <p class="text-[10px] text-outline mt-1" id="fotoNombre"></p>
                        </div>
                        <button type="submit" id="btnSubirFoto" disabled
                            class="bg-primary text-white text-[11px] font-bold uppercase tracking-wider px-6 py-2 hover:bg-tertiary transition disabled:opacity-40 disabled:cursor-not-allowed">
                            Subir foto
                        </button>
                    </div>
                </form>
            </div>

            <!-- DATOS PERSONALES -->
            <div>
                <h3 class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6 py-4">Datos personales</h3>
                <form action="<%= ctx %>/perfil" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <input type="hidden" name="accion" value="actualizarInfo">
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Nombre</label>
                        <input type="text" name="nombre" value="<%= user.getNombre() != null ? user.getNombre() : "" %>"
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition" required>
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Apellido</label>
                        <input type="text" name="apellido" value="<%= user.getApellido() != null ? user.getApellido() : "" %>"
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Correo electrónico</label>
                        <input type="email" name="email" value="<%= user.getEmail() %>"
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition" required>
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Usuario</label>
                        <input type="text" value="<%= user.getUserName() %>" disabled
                            class="w-full border-b border-outline/20 py-2 bg-surface-variant/50 cursor-not-allowed">
                        <p class="text-[9px] text-outline mt-1">No se puede modificar</p>
                    </div>
                    <!-- Documento: solo lectura para no-admin -->
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Documento / ID</label>
                        <input type="text" value="<%= user.getDocumento() != null ? user.getDocumento() : "" %>" disabled
                            class="w-full border-b border-outline/20 py-2 bg-surface-variant/50 cursor-not-allowed">
                        <p class="text-[9px] text-outline mt-1">Solo puede modificarlo un administrador</p>
                    </div>
                    <div class="md:col-span-2">
                        <button type="submit"
                            class="bg-primary text-white text-[11px] font-bold uppercase tracking-wider px-8 py-3 hover:bg-tertiary transition">
                            Guardar cambios
                        </button>
                    </div>
                </form>
            </div>

            <!-- TIPO DE CUENTA -->
            <div>
                <h3 class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6 py-4">Tipo de cuenta</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Comprador -->
                    <div class="border-2 p-5 cursor-pointer transition rol-card <%= user.getIdRol() == 2 ? "border-primary bg-primary/5" : "border-outline/20 hover:border-primary/40" %>"
                         onclick="seleccionarRol(2, this)">
                        <div class="flex items-center gap-3 mb-2">
                            <span class="material-symbols-outlined text-primary">shopping_bag</span>
                            <span class="font-bold text-sm uppercase tracking-wider">Comprador</span>
                            <% if (user.getIdRol() == 2) { %>
                                <span class="ml-auto text-[9px] bg-primary text-white px-2 py-0.5 font-bold uppercase">Actual</span>
                            <% } %>
                        </div>
                        <p class="text-[11px] text-outline">Puedes agregar productos al carrito y realizar compras.</p>
                    </div>
                    <!-- Usuario -->
                    <div class="border-2 p-5 cursor-pointer transition rol-card <%= user.getIdRol() == 3 ? "border-primary bg-primary/5" : "border-outline/20 hover:border-primary/40" %>"
                         onclick="seleccionarRol(3, this)">
                        <div class="flex items-center gap-3 mb-2">
                            <span class="material-symbols-outlined text-primary">style</span>
                            <span class="font-bold text-sm uppercase tracking-wider">Usuario</span>
                            <% if (user.getIdRol() == 3) { %>
                                <span class="ml-auto text-[9px] bg-primary text-white px-2 py-0.5 font-bold uppercase">Actual</span>
                            <% } %>
                        </div>
                        <p class="text-[11px] text-outline">Accedes a funciones de estilo y recomendaciones personalizadas.</p>
                    </div>
                </div>
                <!-- Form oculto cambio de rol -->
                <form id="formCambiarRol" action="<%= ctx %>/perfil" method="post" class="mt-4 hidden">
                    <input type="hidden" name="accion" value="cambiarRol">
                    <input type="hidden" name="nuevoRol" id="nuevoRolInput" value="">
                    <button type="submit"
                        class="bg-primary text-white text-[11px] font-bold uppercase tracking-wider px-8 py-3 hover:bg-tertiary transition">
                        Confirmar cambio de rol
                    </button>
                </form>
            </div>

            <!-- SEGURIDAD -->
            <div>
                <h3 class="font-headline-md text-2xl italic border-b border-outline/10 pb-3 mb-6 py-4">Seguridad</h3>
                <form action="<%= ctx %>/perfil" method="post" class="space-y-5 max-w-lg">
                    <input type="hidden" name="accion" value="cambiarPassword">
                    <div>
                        <div class="flex items-center justify-between mb-1">
                            <label class="block text-[10px] font-bold uppercase tracking-wider text-outline">Contraseña actual</label>
                            <a href="<%= ctx %>/recuperar" class="text-[10px] font-bold uppercase tracking-wider text-primary hover:underline">
                                ¿Olvidaste tu contraseña?
                            </a>
                        </div>
                        <input type="password" name="passwordActual" required
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Nueva contraseña</label>
                        <input type="password" name="passwordNueva" required minlength="8"
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold uppercase tracking-wider text-outline mb-1">Confirmar nueva contraseña</label>
                        <input type="password" name="passwordConfirmar" required minlength="8"
                            class="w-full border-b border-outline/20 py-2 focus:border-primary outline-none transition">
                    </div>
                    <button type="submit"
                        class="border border-primary text-primary text-[11px] font-bold uppercase tracking-wider px-8 py-3 hover:bg-primary hover:text-white transition">
                        Actualizar contraseña
                    </button>
                </form>
            </div>

        </div><!-- /col-span-2 -->
    </div>
</main>

<!-- FOOTER -->
<footer class="bg-white border-t border-on-surface/3 py-10 px-container-margin">
    <div class="max-w-[1440px] mx-auto text-center text-on-surface-variant text-xs">
        <p>© 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
    </div>
</footer>

<script>
    // ── Announcement bar ──────────────────────────────────────────────────
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

    // ── Foto preview ──────────────────────────────────────────────────────
    document.getElementById('fotoInput').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (!file) return;
        if (file.size > 5 * 1024 * 1024) { alert('La imagen supera 5 MB.'); this.value = ''; return; }

        const reader = new FileReader();
        reader.onload = function(ev) {
            // Preview en el form
            const img = document.getElementById('fotoPreviewImg');
            const ini = document.getElementById('fotoIniciales');
            img.src = ev.target.result;
            img.classList.remove('hidden');
            if (ini) ini.classList.add('hidden');

            // Preview en el sidebar
            const sidebarImg = document.getElementById('sidebarAvatarImg');
            const sidebarIni = document.getElementById('sidebarIniciales');
            sidebarImg.src = ev.target.result;
            sidebarImg.classList.remove('hidden');
            if (sidebarIni) sidebarIni.classList.add('hidden');

            document.getElementById('fotoNombre').textContent = file.name;
            document.getElementById('btnSubirFoto').disabled = false;
        };
        reader.readAsDataURL(file);
    });

    // ── Modal cambio de rol ───────────────────────────────────────────────
    const rolActual = <%= user.getIdRol() %>;
    let rolPendiente = null;

    function seleccionarRol(nuevoRol, card) {
        if (nuevoRol === rolActual) return;
        rolPendiente = nuevoRol;

        const modal = document.getElementById('modalRol');
        const msg   = document.getElementById('modalMensaje');
        const lista = document.getElementById('modalLista');

        if (nuevoRol === 3) {
            msg.textContent = 'Estás a punto de cambiar tu cuenta a Usuario. Ten en cuenta que:';
            lista.innerHTML = '<li>Perderás acceso al carrito de compras</li><li>No podrás realizar compras directas</li><li>Podrás volver a Comprador cuando quieras</li>';
        } else {
            msg.textContent = 'Estás a punto de cambiar tu cuenta a Comprador. Con esto podrás:';
            lista.innerHTML = '<li>Agregar productos al carrito</li><li>Realizar compras en la tienda</li>';
        }

        modal.classList.add('open');
    }

    function cerrarModal() {
        document.getElementById('modalRol').classList.remove('open');
        rolPendiente = null;
    }

    function confirmarRol() {
        if (rolPendiente === null) return;
        document.getElementById('nuevoRolInput').value = rolPendiente;
        document.getElementById('formCambiarRol').classList.remove('hidden');
        document.getElementById('modalRol').classList.remove('open');
        document.getElementById('formCambiarRol').submit();
    }

    // Cerrar modal al hacer clic fuera
    document.getElementById('modalRol').addEventListener('click', function(e) {
        if (e.target === this) cerrarModal();
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('user-menu-btn');
        var dropdown = document.getElementById('user-menu-dropdown');
        var icon = document.getElementById('user-menu-icon');
        var container = document.getElementById('user-menu-container');

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

        // Opcional: cerrar al presionar Escape
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && !dropdown.classList.contains('hidden')) {
                dropdown.classList.add('hidden');
                icon.textContent = 'expand_more';
            }
        });
    });
</script>
    <%@ include file="chatbot.jsp" %>

</body>
</html>
