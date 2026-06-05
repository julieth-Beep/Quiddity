<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || (user.getIdRol() != 2 && user.getIdRol() != 3)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>QUIDDITY | Favoritos</title>
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
                    "gutter": "32px",
                    "section-gap": "120px"
                },
                fontFamily: {
                    "display-lg": ["EB Garamond"],
                    "headline-md": ["EB Garamond"],
                    "label-md": ["Manrope"],
                    "body-md": ["Manrope"]
                }
            }
        }
    }
</script>
<style>
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
    ::-webkit-scrollbar { width: 4px; }
    ::-webkit-scrollbar-track { background: #fff; }
    ::-webkit-scrollbar-thumb { background: #e6e1e4; }
    #announcement-bar { background-color: #c4a9a2; height: 42px; }

    /* Cards igual que catálogo */
    .fav-card { transition: opacity 0.25s ease; }
    .btn-fav {
        position: absolute; top: 10px; right: 10px;
        width: 32px; height: 32px;
        background: rgba(255,255,255,0.92); backdrop-filter: blur(4px);
        border-radius: 50%; border: none;
        display: flex; align-items: center; justify-content: center;
        cursor: pointer;
        box-shadow: 0 2px 10px rgba(0,0,0,0.10);
        transition: transform 0.18s ease, background 0.18s ease;
        z-index: 5;
    }
    .btn-fav:hover { transform: scale(1.13); background: #fff0f4; }
    .btn-fav .material-symbols-outlined {
        font-size: 17px; color: #9a3a5a; line-height: 1;
        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    .btn-fav.pop { animation: heartPop 0.32s cubic-bezier(.36,.07,.19,.97); }
    @keyframes heartPop {
        0%   { transform: scale(1); }
        40%  { transform: scale(1.45); }
        70%  { transform: scale(0.92); }
        100% { transform: scale(1); }
    }

    /* Modal igual que catálogo */
    .modal-overlay {
        display: none; position: fixed; inset: 0;
        background: rgba(28,27,29,0.70); backdrop-filter: blur(6px);
        z-index: 1000; align-items: center; justify-content: center; padding: 40px;
    }
    .modal-overlay.active { display: flex !important; }
    .modal-content {
        background: white; max-width: 960px; width: 100%;
        max-height: 92vh; overflow-y: auto; position: relative;
        animation: modalIn 0.32s cubic-bezier(0.16, 1, 0.3, 1);
    }
    @keyframes modalIn {
        from { opacity: 0; transform: translateY(24px) scale(0.98); }
        to   { opacity: 1; transform: translateY(0) scale(1); }
    }
    .modal-close {
        position: absolute; top: 18px; right: 18px;
        width: 38px; height: 38px; background: white;
        border: 1px solid rgba(135,114,118,0.25);
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; z-index: 10; transition: all 0.2s;
    }
    .modal-close:hover { background: #f1ecef; transform: rotate(90deg); }

    .qty-row { display: flex; align-items: center; gap: 0; border: 1px solid rgba(135,114,118,0.35); width: fit-content; }
    .qty-btn {
        width: 44px; height: 44px; background: transparent; border: none;
        cursor: pointer; display: flex; align-items: center; justify-content: center;
        font-family: 'Manrope', sans-serif; font-size: 18px; font-weight: 300;
        color: #544246; transition: background 0.18s, color 0.18s; user-select: none;
    }
    .qty-btn:hover:not(:disabled) { background: #f1ecef; color: #9a3a5a; }
    .qty-btn:disabled { opacity: 0.3; cursor: not-allowed; }
    .qty-display {
        width: 52px; height: 44px; text-align: center;
        font-family: 'Manrope', sans-serif; font-size: 15px; font-weight: 600;
        color: #1c1b1d;
        border-left: 1px solid rgba(135,114,118,0.25);
        border-right: 1px solid rgba(135,114,118,0.25);
        display: flex; align-items: center; justify-content: center;
        background: #fafafa;
    }
    .modal-total-row {
        display: flex; align-items: center; justify-content: space-between;
        padding: 16px 0;
        border-top: 1px solid rgba(135,114,118,0.15);
        border-bottom: 1px solid rgba(135,114,118,0.15);
        margin: 20px 0;
    }
    .stock-bar-track { height: 3px; background: #f1ecef; width: 100%; margin-top: 6px; }
    .stock-bar-fill  { height: 3px; background: #9a3a5a; transition: width 0.4s ease; }
    .marca-pill {
        display: inline-block; padding: 4px 12px; background: #f1ecef;
        font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600;
        letter-spacing: 0.15em; text-transform: uppercase; color: #877276; margin-bottom: 12px;
    }
    .modal-img-wrap { position: relative; background: #f7f4f5; }
    .modal-img-placeholder { display: flex; align-items: center; justify-content: center; color: #c4a9a2; }

    /* Toast */
    #cart-toast {
        position: fixed; bottom: 32px; left: 50%;
        transform: translateX(-50%) translateY(80px);
        background: #1c1b1d; color: white;
        padding: 14px 28px;
        font-family: 'Manrope', sans-serif; font-size: 12px;
        letter-spacing: 0.1em; text-transform: uppercase;
        z-index: 2000; transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.4s;
        opacity: 0; display: flex; align-items: center; gap: 10px; white-space: nowrap;
    }
    #cart-toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }

    /* Estado vacío animado */
    .empty-heart { animation: pulse 2.5s ease-in-out infinite; }
    @keyframes pulse {
        0%, 100% { transform: scale(1); opacity: 0.4; }
        50%       { transform: scale(1.08); opacity: 0.7; }
    }
</style>
</head>
<body class="bg-white text-on-surface" style="font-family:'Manrope',sans-serif;">

<!-- TOAST -->
<div id="cart-toast">
    <span class="material-symbols-outlined" style="font-size:16px; font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">check_circle</span>
    <span id="cart-toast-msg">Producto agregado al carrito</span>
</div>

<!-- ANNOUNCEMENT BAR -->
<div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
    <p style="font-family:'Manrope',sans-serif; font-size:11px; letter-spacing:0.3em; color:white; text-transform:uppercase;">
        NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
    </p>
    <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white transition-colors">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<!-- HEADER — idéntico al catálogo -->
<header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300" style="top:42px;">
    <div class="flex items-center gap-12">
        <a href="<%= ctx %>/index.jsp">
            <h1 style="font-family:'EB Garamond',serif; font-size:24px; letter-spacing:0.2em; color:#9a3a5a; text-transform:uppercase;">Quiddity</h1>
        </a>
        <nav class="hidden md:flex gap-8">
            <a class="font-label-md text-[11px] uppercase tracking-widest hover:text-primary transition-colors"
               href="<%= ctx %>/catalogo">Shop</a>
            <a class="font-label-md text-[11px] uppercase tracking-widest hover:text-primary transition-colors" href="#">Nuestra historia</a>
            <a class="font-label-md text-[11px] uppercase tracking-widest hover:text-primary transition-colors" href="#">Apothecary</a>
            <a class="font-label-md text-[11px] uppercase tracking-widest hover:text-primary transition-colors" href="#">Blog</a>
        </nav>
    </div>
    <div class="flex items-center gap-6">
        <button class="text-on-surface hover:text-primary transition-colors">
            <span class="material-symbols-outlined">search</span>
        </button>
        <!-- Favoritos activo -->
        <a href="<%= ctx %>/comprador/favoritos.jsp" class="text-primary relative">
            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">favorite</span>
            <span id="fav-badge" class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full items-center justify-center hidden">0</span>
        </a>
        <a href="<%= ctx %>/carrito" class="text-on-surface hover:text-primary transition-colors relative">
            <span class="material-symbols-outlined">shopping_bag</span>
        </a>
        <div class="relative group">
            <button class="flex items-center gap-2 font-label-md text-[11px] uppercase tracking-widest text-on-surface hover:text-primary">
                <%= user.getNombre() %>
                <span class="material-symbols-outlined text-sm">expand_more</span>
            </button>
            <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Compras</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<main style="padding-top: calc(42px + 72px);">

    <!-- HERO BANNER (estático, sin video) -->
    <section class="relative w-full overflow-hidden" style="height:28vh; min-height:200px; background:#1c1117;">
        <div class="absolute inset-0" style="background: linear-gradient(135deg, #2a0e1a 0%, #4a1a2e 50%, #1c1117 100%); opacity:0.9;"></div>
        <!-- Patrón decorativo -->
        <div class="absolute inset-0 opacity-10" style="background-image: repeating-linear-gradient(45deg, #9a3a5a 0, #9a3a5a 1px, transparent 0, transparent 50%); background-size: 20px 20px;"></div>
        <div class="relative z-10 h-full flex flex-col justify-end pb-10 px-container-margin">
            <span class="block font-label-md text-[10px] tracking-[0.35em] text-white/60 uppercase mb-3">Tu selección personal</span>
            <h2 style="font-family:'EB Garamond',serif; font-size:clamp(28px,4vw,48px); font-style:italic; color:white;" class="leading-tight">
                Lista de Favoritos
            </h2>
        </div>
    </section>

    <!-- SECTION HEADER -->
    <section class="max-w-[1440px] mx-auto px-container-margin pt-12 pb-6">
        <div class="flex justify-between items-end">
            <div>
                <span class="font-label-md text-[11px] text-primary uppercase tracking-[0.2em] mb-3 block">
                    Guardados
                </span>
                <h3 style="font-family:'EB Garamond',serif; font-size:36px;" id="section-title">Mis Favoritos</h3>
            </div>
            <div class="flex items-center gap-4">
                <p id="fav-count" class="font-label-md text-[10px] text-on-surface-variant uppercase tracking-[0.15em]"></p>
                <button onclick="limpiarTodos()"
                        id="btn-limpiar"
                        class="font-label-md text-[10px] uppercase tracking-widest text-outline hover:text-red-500 transition-colors border border-outline/20 hover:border-red-300 px-4 py-2"
                        style="display:none;">
                    Limpiar todo
                </button>
            </div>
        </div>
    </section>

    <!-- GRID DE FAVORITOS -->
    <section class="max-w-[1440px] mx-auto px-container-margin pb-section-gap">

        <!-- Estado vacío -->
        <div id="empty-state" class="hidden flex-col items-center justify-center py-32 text-center">
            <span class="material-symbols-outlined empty-heart block mb-6"
                  style="font-size:72px; color:#c4a9a2; font-variation-settings:'FILL' 1,'wght' 300,'GRAD' 0,'opsz' 48;">
                favorite
            </span>
            <p style="font-family:'EB Garamond',serif; font-size:28px; font-style:italic;" class="text-on-surface-variant mb-3">
                Aún no tienes favoritos
            </p>
            <p class="text-sm text-outline mb-10 max-w-xs">
                Guarda los productos que más te gustan dándoles ♡ desde el catálogo.
            </p>
            <a href="<%= ctx %>/catalogo"
               class="inline-block bg-primary text-white px-10 py-4"
               style="font-family:'Manrope',sans-serif; font-size:11px; font-weight:600; letter-spacing:0.2em; text-transform:uppercase;">
                Explorar Catálogo
            </a>
        </div>

        <!-- Grid (se llena con JS desde localStorage) -->
        <div id="fav-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-gutter">
            <!-- Las cards se insertan dinámicamente -->
        </div>

        <!-- Skeleton loader mientras carga -->
        <div id="fav-skeleton" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-gutter">
            <% for (int i = 0; i < 4; i++) { %>
            <div class="animate-pulse">
                <div class="aspect-[4/5] bg-surface-variant mb-4"></div>
                <div class="h-3 bg-surface-variant w-1/3 mb-2"></div>
                <div class="h-5 bg-surface-variant w-2/3 mb-2"></div>
                <div class="h-4 bg-surface-variant w-1/4"></div>
            </div>
            <% } %>
        </div>
    </section>
</main>

<!-- ═══════════════════════════════════════════════════════════
     MODAL DETALLE — idéntico al catálogo
════════════════════════════════════════════════════════════ -->
<div id="productModal" class="modal-overlay" onclick="closeModalOnOverlay(event)">
    <div class="modal-content">
        <button class="modal-close" onclick="closeProductModal()">
            <span class="material-symbols-outlined">close</span>
        </button>
        <div class="grid md:grid-cols-2">
            <div class="modal-img-wrap aspect-square md:aspect-auto md:min-h-[520px]">
                <img id="modalImage" src="" alt="" class="w-full h-full object-cover" style="display:none;" />
                <div id="modalImagePlaceholder" class="modal-img-placeholder w-full h-full min-h-[300px]">
                    <span class="material-symbols-outlined text-8xl">spa</span>
                </div>
            </div>
            <div class="flex flex-col p-8 md:p-10 justify-between">
                <div>
                    <div class="flex items-center gap-3 mb-4">
                        <span id="modalMarca" class="marca-pill"></span>
                        <span id="modalSubcat" class="font-label-md text-[10px] text-on-surface-variant uppercase tracking-wider"></span>
                    </div>
                    <h2 id="modalNombre" class="font-display-lg text-3xl md:text-4xl italic mb-3 leading-tight"
                        style="font-family:'EB Garamond',serif;"></h2>
                    <p id="modalPrecio" class="font-headline-md text-2xl text-primary mb-5"></p>
                    <div class="border-t border-outline/15 pt-5 mb-5">
                        <p id="modalDescripcion" class="text-on-surface-variant text-sm leading-relaxed mb-3"></p>
                    </div>
                    <div class="mb-5">
                        <div class="flex items-center justify-between mb-1">
                            <span id="modalStockLabel" class="font-label-md text-[10px] uppercase tracking-wider text-on-surface-variant"></span>
                            <span id="modalStockNum"   class="font-label-md text-[10px] uppercase tracking-wider text-primary"></span>
                        </div>
                        <div class="stock-bar-track"><div id="modalStockBar" class="stock-bar-fill" style="width:0%;"></div></div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center gap-4 mb-5">
                        <span class="font-label-md text-[11px] uppercase tracking-wider text-on-surface-variant">Cantidad</span>
                        <div class="qty-row">
                            <button class="qty-btn" id="btnMinus" onclick="changeQty(-1)">−</button>
                            <div class="qty-display" id="qtyDisplay">1</div>
                            <button class="qty-btn" id="btnPlus"  onclick="changeQty(+1)">+</button>
                        </div>
                    </div>
                    <div class="modal-total-row">
                        <span class="font-label-md text-[11px] uppercase tracking-wider text-on-surface-variant">Total</span>
                        <span id="modalTotal" class="font-display-lg text-2xl text-primary" style="font-family:'EB Garamond',serif;"></span>
                    </div>
                    <button id="addToCartBtn" onclick="submitToCart()"
                            class="w-full py-4 bg-primary text-white font-label-md text-[11px] uppercase tracking-[0.2em] hover:bg-tertiary transition-all disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined" style="font-size:16px;">shopping_bag</span>
                        Agregar al Carrito
                    </button>
                    <p id="modalError" class="text-[11px] text-[#b3261e] mt-3 text-center tracking-wide" style="display:none;"></p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer class="bg-white border-t border-on-surface/5 py-16 px-container-margin">
    <div class="max-w-[1440px] mx-auto flex flex-col md:flex-row justify-between items-center gap-6">
        <h2 style="font-family:'EB Garamond',serif; font-size:20px; letter-spacing:0.2em; color:#9a3a5a; text-transform:uppercase;">Quiddity</h2>
        <p style="font-family:'Manrope',sans-serif; font-size:10px; letter-spacing:0.2em; text-transform:uppercase; color:#877276;">
            © 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.
        </p>
    </div>
</footer>

<!-- ═══════════════════════════════════════════════════════════
     SCRIPTS
════════════════════════════════════════════════════════════ -->
<script>
var CTX = '<%= ctx %>';
var FAV_KEY = 'quiddity_favs';

// ── Estado modal ──────────────────────────────────────────────────────────────
var currentProductId = null;
var currentQty       = 1;
var currentStock     = 0;
var currentPrecio    = 0;

// ── Favoritos desde localStorage ─────────────────────────────────────────────
function getFavs()     { return JSON.parse(localStorage.getItem(FAV_KEY) || '[]'); }
function saveFavs(arr) { localStorage.setItem(FAV_KEY, JSON.stringify(arr)); }

function removeFav(id) {
    var favs = getFavs().filter(function(f){ return f !== id; });
    saveFavs(favs);
    // Quitar card con animación
    var card = document.querySelector('.fav-card[data-id="' + id + '"]');
    if (card) {
        card.style.transition = 'opacity 0.3s, transform 0.3s';
        card.style.opacity = '0';
        card.style.transform = 'scale(0.92)';
        setTimeout(function(){ card.remove(); checkEmpty(); updateCounts(); }, 320);
    }
}

function limpiarTodos() {
    if (!confirm('¿Eliminar todos tus favoritos?')) return;
    saveFavs([]);
    document.getElementById('fav-grid').innerHTML = '';
    checkEmpty();
    updateCounts();
}

// ── Construir grid desde localStorage + fetch de datos ───────────────────────
// Los datos del producto los tenemos en el data-* que guardamos al hacer like
// desde el catálogo. Si no están, usamos solo el ID.

function buildGrid() {
    var favIds = getFavs();
    var skeleton = document.getElementById('fav-skeleton');
    var grid = document.getElementById('fav-grid');

    // Leer cache de productos del catálogo (guardada en localStorage)
    var prodCache = JSON.parse(localStorage.getItem('quiddity_prod_cache') || '{}');

    if (favIds.length === 0) {
        skeleton.style.display = 'none';
        checkEmpty();
        return;
    }

    grid.innerHTML = '';

    favIds.forEach(function(id) {
        var prod = prodCache[id];
        var card = document.createElement('div');
        card.className = 'fav-card group';
        card.setAttribute('data-id', id);

        if (prod) {
            card.setAttribute('data-nombre',      prod.nombre      || '');
            card.setAttribute('data-precio',       prod.precio      || 0);
            card.setAttribute('data-stock',        prod.stock       || 0);
            card.setAttribute('data-descripcion',  prod.descripcion || '');
            card.setAttribute('data-marca',        prod.marca       || '');
            card.setAttribute('data-imagen',       prod.imagen      || '');
            card.setAttribute('data-subcat-label', prod.subcatLabel || '');

            var imgHtml = prod.imagen
                ? '<img src="' + prod.imagen + '" alt="' + escHtml(prod.nombre) + '" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" />'
                : '<div class="w-full h-full flex items-center justify-center text-outline"><span class="material-symbols-outlined text-6xl">image</span></div>';

            card.innerHTML =
                '<div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative cursor-pointer" onclick="openProductModal(' + id + ')">' +
                    imgHtml +
                    '<button class="btn-fav" data-id="' + id + '" onclick="event.stopPropagation(); quitarFavorito(' + id + ')" title="Quitar de favoritos">' +
                        '<span class="material-symbols-outlined">favorite</span>' +
                    '</button>' +
                '</div>' +
                '<div class="flex justify-between items-start">' +
                    '<div class="flex-1 pr-3">' +
                        '<p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">' + escHtml(prod.subcatLabel || '') + '</p>' +
                        '<h4 style="font-family:\'EB Garamond\',serif; font-size:18px; line-height:1.3;" class="mb-2">' + escHtml(prod.nombre || 'Producto') + '</h4>' +
                        '<p class="text-sm text-primary">$' + formatPeso(prod.precio) + '</p>' +
                    '</div>' +
                    '<button onclick="openProductModal(' + id + ')"' +
                            ' class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all flex-shrink-0 mt-1">' +
                        '<span class="material-symbols-outlined" style="font-size:16px;">add</span>' +
                    '</button>' +
                '</div>';
        } else {
            // Sin cache: mostrar placeholder con ID
            card.innerHTML =
                '<div class="aspect-[4/5] bg-surface-variant mb-5 relative flex items-center justify-center">' +
                    '<span class="material-symbols-outlined text-5xl text-outline/40">image_not_supported</span>' +
                    '<button class="btn-fav" data-id="' + id + '" onclick="event.stopPropagation(); quitarFavorito(' + id + ')" title="Quitar de favoritos">' +
                        '<span class="material-symbols-outlined">favorite</span>' +
                    '</button>' +
                '</div>' +
                '<p class="text-sm text-on-surface-variant">Producto #' + id + '</p>' +
                '<p class="text-xs text-outline mt-1">Visita el catálogo para ver los detalles</p>';
        }

        grid.appendChild(card);
    });

    skeleton.style.display = 'none';
    checkEmpty();
    updateCounts();
}

function quitarFavorito(id) {
    removeFav(id);
}

function checkEmpty() {
    var favIds = getFavs();
    var empty  = document.getElementById('empty-state');
    var btnL   = document.getElementById('btn-limpiar');
    if (favIds.length === 0) {
        empty.classList.remove('hidden');
        empty.style.display = 'flex';
        if (btnL) btnL.style.display = 'none';
    } else {
        empty.style.display = 'none';
        if (btnL) btnL.style.display = 'inline-block';
    }
}

function updateCounts() {
    var count = getFavs().length;
    var countEl = document.getElementById('fav-count');
    var badge   = document.getElementById('fav-badge');
    if (countEl) countEl.textContent = count + ' producto' + (count !== 1 ? 's' : '') + ' guardados';
    if (badge) {
        if (count > 0) { badge.textContent = count; badge.style.display = 'flex'; }
        else           { badge.style.display = 'none'; }
    }
}

// ── Modal (idéntico al catálogo) ──────────────────────────────────────────────
function openProductModal(productId) {
    var card = document.querySelector('.fav-card[data-id="' + productId + '"]');
    if (!card) return;

    currentProductId = productId;
    currentQty       = 1;
    currentStock     = parseInt(card.getAttribute('data-stock')) || 0;
    currentPrecio    = parseFloat(card.getAttribute('data-precio')) || 0;

    document.getElementById('modalNombre').textContent    = card.getAttribute('data-nombre')      || '';
    document.getElementById('modalDescripcion').textContent = card.getAttribute('data-descripcion') || 'Sin descripción disponible.';
    document.getElementById('modalSubcat').textContent    = card.getAttribute('data-subcat-label') || '';
    document.getElementById('modalPrecio').textContent    = '$' + formatPeso(currentPrecio) + ' / und.';

    var marca = card.getAttribute('data-marca') || '';
    var marcaEl = document.getElementById('modalMarca');
    marcaEl.textContent    = marca;
    marcaEl.style.display  = marca ? 'inline-block' : 'none';

    var imgSrc = card.getAttribute('data-imagen') || '';
    var imgEl  = document.getElementById('modalImage');
    var phEl   = document.getElementById('modalImagePlaceholder');
    if (imgSrc) { imgEl.src = imgSrc; imgEl.style.display = 'block'; phEl.style.display = 'none'; }
    else        { imgEl.style.display = 'none'; phEl.style.display = 'flex'; }

    actualizarStockUI();
    resetQty();
    document.getElementById('modalError').style.display = 'none';
    document.getElementById('productModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function actualizarStockUI() {
    var lbl = document.getElementById('modalStockLabel');
    var num = document.getElementById('modalStockNum');
    var bar = document.getElementById('modalStockBar');
    var btn = document.getElementById('addToCartBtn');
    var pct = Math.min(100, Math.round((currentStock / 50) * 100));
    if (currentStock === 0) {
        lbl.textContent = 'Sin stock disponible'; num.textContent = '';
        bar.style.width = '0%'; bar.style.background = '#d1d5db';
        btn.disabled = true; btn.textContent = 'Sin Stock';
    } else if (currentStock <= 5) {
        lbl.textContent = '¡Últimas unidades!'; num.textContent = currentStock + ' disponibles';
        bar.style.width = pct + '%'; bar.style.background = '#b45f06';
        btn.disabled = false;
        btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">shopping_bag</span> Agregar al Carrito';
    } else {
        lbl.textContent = 'En stock'; num.textContent = currentStock + ' disponibles';
        bar.style.width = pct + '%'; bar.style.background = '#9a3a5a';
        btn.disabled = false;
        btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">shopping_bag</span> Agregar al Carrito';
    }
}

function resetQty() { currentQty = 1; renderQty(); }
function changeQty(delta) {
    var next = currentQty + delta;
    if (next < 1 || next > currentStock) return;
    currentQty = next; renderQty();
}
function renderQty() {
    document.getElementById('qtyDisplay').textContent = currentQty;
    document.getElementById('btnMinus').disabled = (currentQty <= 1);
    document.getElementById('btnPlus').disabled  = (currentQty >= currentStock);
    document.getElementById('modalTotal').textContent = '$' + formatPeso(currentQty * currentPrecio);
}

function submitToCart() {
    if (!currentProductId || currentStock === 0) return;
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = CTX + '/carrito';
    [['accion','agregar'],['catalogoId', currentProductId],['cantidad', currentQty]].forEach(function(p){
        var inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = p[0]; inp.value = p[1];
        form.appendChild(inp);
    });
    document.body.appendChild(form);
    closeProductModal();
    showToast('Agregando al carrito…');
    form.submit();
}

function closeProductModal() {
    document.getElementById('productModal').classList.remove('active');
    document.body.style.overflow = '';
    currentProductId = null;
}
function closeModalOnOverlay(e) {
    if (e.target === document.getElementById('productModal')) closeProductModal();
}
document.addEventListener('keydown', function(e){ if (e.key === 'Escape') closeProductModal(); });

// ── Toast ─────────────────────────────────────────────────────────────────────
function showToast(msg) {
    var t = document.getElementById('cart-toast');
    document.getElementById('cart-toast-msg').textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2800);
}

// ── Helpers ───────────────────────────────────────────────────────────────────
function formatPeso(n) { return Math.round(n).toLocaleString('es-CO'); }
function escHtml(s) {
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// ── Header scroll ─────────────────────────────────────────────────────────────
function closeAnnouncementBar() {
    document.getElementById('announcement-bar').style.display = 'none';
    document.getElementById('main-header').style.top = '0px';
    document.querySelectorAll('.sticky').forEach(function(el){ el.style.top = '72px'; });
}
window.addEventListener('scroll', function() {
    var h = document.getElementById('main-header');
    if (window.scrollY > 10) { h.style.padding = '8px 80px'; }
    else                     { h.style.padding = '16px 80px'; }
});

// ── Init ──────────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {
    buildGrid();
    updateCounts();
});
</script>
</body>
</html>