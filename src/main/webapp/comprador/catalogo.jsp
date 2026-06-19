<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Catalogo" %>
<%@ page import="com.quiddity.model.CatalogoImagen" %>
<%@ page import="java.util.*" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || (user.getIdRol() != 2 && user.getIdRol() != 3)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();

    List<Catalogo> productos = (List<Catalogo>) request.getAttribute("productos");
    if (productos == null) { productos = new java.util.ArrayList<Catalogo>(); }
%>
<%!
    private String determinarSubcat(String imagen, String categoria) {
        if (imagen == null) return categoria != null ? categoria.toLowerCase() : "";
        String ruta = imagen.toLowerCase();
        if (ruta.contains("brocha")) return "brochas";
        if (ruta.contains("esponja") || ruta.contains("blender") || ruta.contains("set")) return "esponjas";
        if (ruta.contains("base") || ruta.contains("paleta") || ruta.contains("sombras")) return "maquillaje";
        if (ruta.contains("rouge") || ruta.contains("labial")) return "maquillaje";
        if (ruta.contains("lunar") || ruta.contains("iluminador")) return "maquillaje";
        if (ruta.contains("mask") || ruta.contains("mascarilla") || ruta.contains("clay") || ruta.contains("charcoal")) return "mascarillas";
        if (ruta.contains("serum") || ruta.contains("elixir") || ruta.contains("midnight") || ruta.contains("hyaluronic")) return "serums";
        if (ruta.contains("cream") || ruta.contains("velvet") || ruta.contains("night") || ruta.contains("spf")) return "hidratantes";
        if (ruta.contains("micelar") || ruta.contains("tonico") || ruta.contains("rosa")) return "tonicos";
        if (ruta.contains("enzima") || ruta.contains("exfoliante")) return "exfoliantes";
        if (ruta.contains("vetiver") || ruta.contains("cedar") || ruta.contains("edt")) return "edt";
        if (ruta.contains("bloom") || ruta.contains("rose") || ruta.contains("edp")) return "edp";
        if (ruta.contains("set") || ruta.contains("trio") || ruta.contains("discovery")) return "sets-olfativos";
        if (ruta.contains("shampoo") || ruta.contains("acondicionador") || ruta.contains("botanical")) return "shampoos";
        if (ruta.contains("keratina") || ruta.contains("deep") || ruta.contains("mascarilla")) return "mascarillas-capilar";
        if (ruta.contains("argan") || ruta.contains("aceite")) return "aceites-capilares";
        if (ruta.contains("sugar") || ruta.contains("cafe") || ruta.contains("coffee")) return "exfoliantes-corp";
        if (ruta.contains("jazmin") || ruta.contains("coco") || ruta.contains("locion") || ruta.contains("butter")) return "lociones";
        if (ruta.contains("seco") || ruta.contains("anticelulitis") || ruta.contains("firming")) return "aceites-corp";
        if (ruta.contains("antimanchas") || ruta.contains("tratamiento") || ruta.contains("even")) return "tratamientos-corp";
        return categoria != null ? categoria.toLowerCase() : "";
    }

    private String determinarGrupo(String subcat, String categoria) {
        if (subcat == null) return null;
        String s = subcat.toLowerCase();
        if ("mascarillas".equals(s) || "serums".equals(s) || "hidratantes".equals(s) ||
            "tonicos".equals(s) || "exfoliantes".equals(s)) return "facial";
        if ("exfoliantes-corp".equals(s) || "lociones".equals(s) ||
            "aceites-corp".equals(s) || "tratamientos-corp".equals(s)) return "corporal";
        return null;
    }

    private String determinarCategoria(String imagen, String categoriaBD) {
        if (imagen == null) return categoriaBD != null ? categoriaBD.toLowerCase() : "belleza";
        String ruta = imagen.toLowerCase();
        if (ruta.contains("belleza") || ruta.contains("makeup") || ruta.contains("brocha") ||
            ruta.contains("esponja") || ruta.contains("blender") || ruta.contains("base") ||
            ruta.contains("paleta") || ruta.contains("rouge") || ruta.contains("lunar")) return "belleza";
        if (ruta.contains("cuidado") || ruta.contains("skincare") || ruta.contains("serum") ||
            ruta.contains("cream") || ruta.contains("mask") || ruta.contains("tonico") ||
            ruta.contains("exfoliante") || ruta.contains("spf") || ruta.contains("micelar")) return "cuidado";
        if (ruta.contains("perfume") || ruta.contains("edt") || ruta.contains("edp") ||
            ruta.contains("vetiver") || ruta.contains("bloom") || ruta.contains("rose")) return "perfumes";
        if (ruta.contains("cabello") || ruta.contains("shampoo") || ruta.contains("acondicionador") ||
            ruta.contains("keratina") || ruta.contains("argan") || ruta.contains("serumcapilar")) return "cabello";
        if (ruta.contains("corporal") || ruta.contains("locion") || ruta.contains("butter") ||
            ruta.contains("aceite") || ruta.contains("anticelulitis") || ruta.contains("tratamiento")) return "cuidado";
        return categoriaBD != null ? categoriaBD.toLowerCase() : "belleza";
    }

    private String buildImagenSrc(String imgRaw, String ctx) {
        if (imgRaw == null || imgRaw.trim().isEmpty()) return "";
        imgRaw = imgRaw.trim();
        if (imgRaw.startsWith("http")) return imgRaw;
        String limpio = imgRaw.replaceFirst("^uploads/catalogo/", "");
        return ctx + "/uploads/catalogo/" + limpio;
    }
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>QUIDDITY | Catálogo</title>
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
    #catalog-hero { position: relative; width: 100%; height: 56vh; min-height: 360px; overflow: hidden; }
    #hero-video { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; transition: opacity 0.6s ease; }

    .cat-chip { display: inline-flex; align-items: center; gap: 6px; padding: 10px 22px; border: 1.5px solid rgba(154,58,90,0.25); font-family: 'Manrope', sans-serif; font-size: 11px; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; color: #544246; cursor: pointer; transition: all 0.22s ease; background: white; white-space: nowrap; }
    .cat-chip:hover { border-color: #9a3a5a; color: #9a3a5a; }
    .cat-chip.active { background: #9a3a5a; border-color: #9a3a5a; color: white; }

    .subcat-chip { display: inline-flex; align-items: center; padding: 7px 16px; border: 1px solid rgba(135,114,118,0.30); font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; color: #877276; cursor: pointer; transition: all 0.2s ease; background: transparent; white-space: nowrap; }
    .subcat-chip:hover { border-color: #9a3a5a; color: #9a3a5a; }
    .subcat-chip.active { background: #f1ecef; border-color: #9a3a5a; color: #9a3a5a; }

    .chips-scroll { display: flex; gap: 10px; overflow-x: auto; scrollbar-width: none; padding-bottom: 4px; }
    .chips-scroll::-webkit-scrollbar { display: none; }
    .chips-divider { height: 1px; background: rgba(135,114,118,0.12); margin: 0; }

    .btn-fav { position: absolute; top: 10px; right: 10px; width: 32px; height: 32px; background: rgba(255,255,255,0.92); backdrop-filter: blur(4px); border-radius: 50%; border: none; display: flex; align-items: center; justify-content: center; cursor: pointer; box-shadow: 0 2px 10px rgba(0,0,0,0.10); transition: transform 0.18s ease, background 0.18s ease; z-index: 5; }
    .btn-fav:hover { transform: scale(1.13); background: #fff0f4; }
    .btn-fav .material-symbols-outlined { font-size: 17px; color: #c4a9a2; font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; transition: color 0.18s, font-variation-settings 0.18s; line-height: 1; }
    .btn-fav.active .material-symbols-outlined { color: #9a3a5a; font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    .btn-fav.pop { animation: heartPop 0.32s cubic-bezier(.36,.07,.19,.97); }
    @keyframes heartPop { 0%{transform:scale(1)} 40%{transform:scale(1.45)} 70%{transform:scale(0.92)} 100%{transform:scale(1)} }

    .product-card { opacity: 1; transition: opacity 0.25s ease; }

    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(28,27,29,0.70); backdrop-filter: blur(6px); z-index: 1000; align-items: center; justify-content: center; padding: 40px; }
    .modal-overlay.active { display: flex !important; }
    .modal-content { background: white; max-width: 960px; width: 100%; max-height: 92vh; overflow-y: auto; position: relative; animation: modalIn 0.32s cubic-bezier(0.16,1,0.3,1); }
    @keyframes modalIn { from{opacity:0;transform:translateY(24px) scale(0.98)} to{opacity:1;transform:translateY(0) scale(1)} }
    .modal-close { position: absolute; top: 18px; right: 18px; width: 38px; height: 38px; background: white; border: 1px solid rgba(135,114,118,0.25); display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 10; transition: all 0.2s; }
    .modal-close:hover { background: #f1ecef; transform: rotate(90deg); }

    .qty-row { display: flex; align-items: center; gap: 0; border: 1px solid rgba(135,114,118,0.35); width: fit-content; }
    .qty-btn { width: 44px; height: 44px; background: transparent; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; font-family: 'Manrope', sans-serif; font-size: 18px; font-weight: 300; color: #544246; transition: background 0.18s, color 0.18s; user-select: none; }
    .qty-btn:hover:not(:disabled) { background: #f1ecef; color: #9a3a5a; }
    .qty-btn:disabled { opacity: 0.3; cursor: not-allowed; }
    .qty-display { width: 52px; height: 44px; text-align: center; font-family: 'Manrope', sans-serif; font-size: 15px; font-weight: 600; color: #1c1b1d; border-left: 1px solid rgba(135,114,118,0.25); border-right: 1px solid rgba(135,114,118,0.25); display: flex; align-items: center; justify-content: center; background: #fafafa; }

    .modal-total-row { display: flex; align-items: center; justify-content: space-between; padding: 16px 0; border-top: 1px solid rgba(135,114,118,0.15); border-bottom: 1px solid rgba(135,114,118,0.15); margin: 20px 0; }

    .stock-bar-track { height: 3px; background: #f1ecef; width: 100%; margin-top: 6px; }
    .stock-bar-fill  { height: 3px; background: #9a3a5a; transition: width 0.4s ease; }

    #cart-toast { position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%) translateY(80px); background: #1c1b1d; color: white; padding: 14px 28px; font-family: 'Manrope', sans-serif; font-size: 12px; letter-spacing: 0.1em; text-transform: uppercase; z-index: 2000; transition: transform 0.4s cubic-bezier(0.16,1,0.3,1), opacity 0.4s; opacity: 0; display: flex; align-items: center; gap: 10px; white-space: nowrap; }
    #cart-toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }

    .marca-pill { display: inline-block; padding: 4px 12px; background: #f1ecef; font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 600; letter-spacing: 0.15em; text-transform: uppercase; color: #877276; margin-bottom: 12px; }
    .modal-img-wrap { position: relative; background: #f7f4f5; overflow: hidden; }
    .modal-img-wrap img { display: block; width: 100%; height: 100%; object-fit: cover; }
    .modal-img-placeholder { display: flex; align-items: center; justify-content: center; color: #c4a9a2; }

    /* ═══ CARRUSEL DEL MODAL ═══ */
    #modalCarouselTrack img { user-select: none; -webkit-user-drag: none; }
    #carouselPrev:hover, #carouselNext:hover { background: white !important; transform: translateY(-50%) scale(1.1); }
    .carousel-dot-active { background: #9a3a5a !important; width: 24px !important; border-radius: 4px !important; }
    .carousel-dot-inactive { background: rgba(255,255,255,0.5); width: 8px; border-radius: 50%; }

    @media (max-width: 768px) { .modal-overlay { padding: 16px; } .modal-content { max-height: 95vh; } }
</style>
</head>
<body class="bg-white font-body-md text-on-surface selection:bg-primary/10">

<!-- TOAST -->
<div id="cart-toast">
    <span class="material-symbols-outlined" style="font-size:16px;font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">check_circle</span>
    <span id="cart-toast-msg">Producto agregado al carrito</span>
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
<header id="main-header" class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300" style="top: 42px;">
    <div class="flex items-center gap-12">
        <a href="<%= ctx %>/index.jsp">
            <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1>
        </a>
        <nav class="hidden md:flex gap-8">
            <a class="font-label-md text-label-md uppercase text-primary border-b border-primary pb-0.5" href="<%= ctx %>/catalogo">Shop</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Nuestra historia</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Apothecary</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Blog</a>
        </nav>
    </div>
    <div class="flex items-center gap-6">
        <button class="text-on-surface hover:text-primary transition-colors">
            <span class="material-symbols-outlined">search</span>
        </button>
        <a href="<%= ctx %>/comprador/favoritos.jsp" class="text-on-surface hover:text-primary transition-colors relative">
            <span class="material-symbols-outlined">favorite</span>
            <span id="fav-badge" class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full items-center justify-center hidden">0</span>
        </a>
        <a href="<%= ctx %>/carrito" class="text-on-surface hover:text-primary transition-colors relative">
            <span class="material-symbols-outlined">shopping_bag</span>
        </a>
        <!-- ICONO HISTORIAL / PEDIDOS -->
        <a href="<%= ctx %>/pedidos" class="text-on-surface hover:text-primary transition-colors relative" title="Mis Pedidos">
            <span class="material-symbols-outlined">receipt_long</span>
        </a>
        <div class="relative" id="user-menu-container">
            <button id="user-menu-btn" class="flex items-center gap-2 font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary transition-colors">
                <%= user.getNombre() %>
                <span id="user-menu-icon" class="material-symbols-outlined text-sm transition-transform duration-200">expand_more</span>
            </button>
            <div id="user-menu-dropdown" class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden z-50 rounded-md">
                <a href="<%= ctx %>/comprador/perfil.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <a href="<%= ctx %>/pedidos" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Pedidos</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/carrito" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Carrito</a>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<main style="padding-top: 42px;">
    <!-- HERO VIDEO -->
    <section id="catalog-hero">
        <video id="hero-video" autoplay muted loop playsinline>
            <source id="hero-video-src" src="<%= ctx %>/uploads/videos/mixed/4.mp4" type="video/mp4">
        </video>
        <div class="absolute inset-0" style="background: linear-gradient(to right, rgba(15,10,12,0.60) 0%, rgba(15,10,12,0.25) 55%, rgba(15,10,12,0.05) 100%);"></div>
        <div class="relative z-10 h-full flex flex-col justify-end pb-14 px-container-margin">
            <div id="hero-text-wrapper" style="transition: opacity 0.3s ease;">
                <span id="hero-label" class="block font-label-md text-[10px] tracking-[0.35em] text-white/70 uppercase mb-4">Explora nuestra selección</span>
                <h2 id="hero-title" class="font-display-lg text-white italic mb-3 leading-tight" style="font-size:clamp(32px,4vw,56px);">Todo el Catálogo</h2>
                <p id="hero-subtitle" class="font-body-md text-white/60 text-sm max-w-sm tracking-wide">Descubre nuestra gama completa de productos botánicos.</p>
            </div>
        </div>
    </section>

    <!-- CHIPS NAVEGACIÓN -->
    <div class="sticky z-40 bg-white border-b border-on-surface/5 shadow-sm" style="top: calc(42px + 72px);">
        <div class="max-w-[1440px] mx-auto px-container-margin">
            <div class="chips-scroll py-5 gap-3" id="cat-row">
                <button class="cat-chip active" data-cat="all"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/4.mp4"
                        data-hero-label="Explora nuestra selección"
                        data-hero-title="Todo el Catálogo"
                        data-hero-sub="Descubre nuestra gama completa de productos botánicos.">
                    <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span> Todo
                </button>
                <button class="cat-chip" data-cat="belleza"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/3.mp4"
                        data-hero-label="Colección Belleza"
                        data-hero-title="Belleza & Maquillaje"
                        data-hero-sub="Herramientas y cosméticos que realzan tu belleza natural.">
                    <span class="material-symbols-outlined" style="font-size:14px;">face_retouching_natural</span> Belleza
                </button>
                <button class="cat-chip" data-cat="cuidado"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/2.mp4"
                        data-hero-label="Ritual de Cuidado"
                        data-hero-title="Cuidado de la Piel"
                        data-hero-sub="Skincare botánico clínicamente comprobado.">
                    <span class="material-symbols-outlined" style="font-size:14px;">spa</span> Cuidado
                </button>
                <button class="cat-chip" data-cat="perfumes"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/dior.mp4"
                        data-hero-label="Fragancias Botánicas"
                        data-hero-title="Perfumes & Fragancias"
                        data-hero-sub="Aromas naturales que cuentan una historia única.">
                    <span class="material-symbols-outlined" style="font-size:14px;">water_drop</span> Perfumes
                </button>
                <button class="cat-chip" data-cat="cabello"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/hair2.mp4"
                        data-hero-label="Cuidado Capilar"
                        data-hero-title="Cuidado del Cabello"
                        data-hero-sub="Rituales capilares con activos botánicos puros.">
                    <span class="material-symbols-outlined" style="font-size:14px;">self_improvement</span> Cabello
                </button>
            </div>
            <div id="subcat-divider" class="chips-divider" style="display:none;"></div>
            <div id="subcat-row" class="chips-scroll pb-3 gap-2" style="display:none; padding-top: 12px;"></div>
            <div id="subsubcat-divider" class="chips-divider" style="display:none;"></div>
            <div id="subsubcat-row" class="chips-scroll pb-4 gap-2" style="display:none; padding-top: 10px;"></div>
        </div>
    </div>

    <!-- SECTION HEADER -->
    <section class="max-w-[1440px] mx-auto px-container-margin pt-16 pb-6">
        <div class="flex justify-between items-end">
            <div>
                <span id="section-label" class="font-label-md text-label-md text-primary uppercase tracking-[0.2em] mb-3 block">Todos los productos</span>
                <h3 class="font-headline-lg text-headline-lg" id="section-title">Catálogo</h3>
            </div>
            <p id="product-count" class="font-label-md text-[10px] text-on-surface-variant uppercase tracking-[0.15em]"></p>
        </div>
    </section>

    <!-- PRODUCT GRID -->
    <section class="max-w-[1440px] mx-auto px-container-margin pb-section-gap">
        <% if (productos.isEmpty()) { %>
        <div class="flex flex-col items-center justify-center py-32 text-center">
            <span class="material-symbols-outlined text-6xl text-outline/40 mb-6">inventory_2</span>
            <p class="font-headline-md text-2xl text-on-surface-variant mb-2">No hay productos disponibles</p>
            <p class="font-body-md text-sm text-outline">El catálogo está vacío por el momento.</p>
        </div>
        <% } else { %>
        <div id="product-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-gutter">
            <%
            for (Catalogo prod : productos) {
                String subcat = determinarSubcat(prod.getImagen(), prod.getCategoria());
                String grupo  = determinarGrupo(subcat, prod.getCategoria());
                String cat    = determinarCategoria(prod.getImagen(), prod.getCategoria());

                boolean esNuevo      = prod.getId() >= 35;
                boolean esBestSeller = prod.getPrecio() >= 100000 || prod.getId() % 7 == 0;

                // ── CORRECCIÓN RUTA IMAGEN ──────────────────────────────
                String imagenSrc = buildImagenSrc(prod.getImagen(), ctx);

                String nombreSafe = prod.getNombre()      != null ? prod.getNombre().replace("\"","&quot;").replace("'","&#39;")      : "";
                String descSafe   = prod.getDescripcion() != null ? prod.getDescripcion().replace("\"","&quot;").replace("'","&#39;") : "";
                String compSafe   = prod.getComponentes() != null ? prod.getComponentes().replace("\"","&quot;").replace("'","&#39;") : "";
                String marcaSafe  = prod.getMarca()       != null ? prod.getMarca().replace("\"","&quot;").replace("'","&#39;")       : "";
                String subcatLabel = (subcat != null && !subcat.isEmpty())
                    ? subcat.substring(0,1).toUpperCase() + subcat.substring(1).replace("-"," ")
                    : "";

                // ═══ CONSTRUIR JSON DE IMÁGENES PARA EL CARRUSEL ═══
                StringBuilder imagenesJson = new StringBuilder("[");
                if (!imagenSrc.isEmpty()) {
                    imagenesJson.append("\"").append(imagenSrc.replace("\"", "\\\"")).append("\"");
                }
                List<CatalogoImagen> imgs = prod.getImagenes();
                if (imgs != null) {
                    for (CatalogoImagen img : imgs) {
                        if (!img.isEsPrincipal()) {
                            String imgSrcAdd = buildImagenSrc(img.getRutaImagen(), ctx);
                            if (!imgSrcAdd.isEmpty()) {
                                if (imagenesJson.length() > 1) imagenesJson.append(",");
                                imagenesJson.append("\"").append(imgSrcAdd.replace("\"", "\\\"")).append("\"");
                            }
                        }
                    }
                }
                imagenesJson.append("]");
            %>
            <div class="product-card group"
                 data-cat="<%= cat %>"
                 data-group="<%= grupo != null ? grupo : "" %>"
                 data-subcat="<%= subcat %>"
                 data-id="<%= prod.getId() %>"
                 data-nombre="<%= nombreSafe %>"
                 data-precio="<%= prod.getPrecio() %>"
                 data-stock="<%= prod.getStock() %>"
                 data-descripcion="<%= descSafe %>"
                 data-componentes="<%= compSafe %>"
                 data-marca="<%= marcaSafe %>"
                 data-imagen="<%= imagenSrc %>"
                 data-imagenes='<%= imagenesJson.toString() %>'
                 data-subcat-label="<%= subcatLabel %>">

                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative cursor-pointer"
                     onclick="openProductModal(<%= prod.getId() %>)">
                    <% if (!imagenSrc.isEmpty()) { %>
                        <img alt="<%= prod.getNombre() %>"
                             class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                             src="<%= imagenSrc %>" />
                    <% } else { %>
                        <div class="w-full h-full flex items-center justify-center text-outline">
                            <span class="material-symbols-outlined text-6xl">image</span>
                        </div>
                    <% } %>

                    <% if (esNuevo) { %>
                        <span class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                    <% } else if (esBestSeller) { %>
                        <span class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best Seller</span>
                    <% } %>

                    <% if (prod.getStock() == 0) { %>
                        <div class="absolute inset-0 bg-white/60 flex items-center justify-center">
                            <span class="font-label-md text-[10px] tracking-[0.2em] uppercase text-on-surface-variant">Sin stock</span>
                        </div>
                    <% } %>

                    <button class="btn-fav" data-id="<%= prod.getId() %>"
                            onclick="event.stopPropagation(); toggleFav(this)" title="Añadir a favoritos">
                        <span class="material-symbols-outlined">favorite</span>
                    </button>
                </div>

                <div class="flex justify-between items-start">
                    <div class="flex-1 pr-3">
                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1"><%= subcatLabel %></p>
                        <h4 class="font-headline-md text-[18px] leading-tight mb-2"><%= prod.getNombre() %></h4>
                        <p class="font-body-md text-primary text-sm">$<%= String.format("%,.0f", prod.getPrecio()) %></p>
                    </div>
                    <button onclick="openProductModal(<%= prod.getId() %>)"
                            class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all flex-shrink-0 mt-1"
                            title="Ver detalle">
                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                    </button>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </section>
</main>

<!-- ═══ MODAL DETALLE PRODUCTO CON CARRUSEL ═══ -->
<div id="productModal" class="modal-overlay" onclick="closeModalOnOverlay(event)">
    <div class="modal-content">
        <button class="modal-close" onclick="closeProductModal()">
            <span class="material-symbols-outlined">close</span>
        </button>
        <div class="grid md:grid-cols-2">
            
            <!-- ═══ CARRUSEL DE IMÁGENES ═══ -->
            <div class="modal-img-wrap" style="position:relative;overflow:hidden;background:#f7f4f5;min-height:300px;">
                <div id="modalCarousel" style="position:relative;width:100%;height:100%;min-height:300px;">
                    <div id="modalCarouselTrack" style="display:flex;transition:transform 0.4s cubic-bezier(0.16,1,0.3,1);height:100%;">
                        <!-- Slides inyectados por JS -->
                    </div>
                </div>
                
                <!-- Controles (solo si hay múltiples) -->
                <button id="carouselPrev" onclick="carouselMove(-1); event.stopPropagation();" 
                        style="position:absolute;left:16px;top:50%;transform:translateY(-50%);width:40px;height:40px;border-radius:50%;border:none;background:rgba(255,255,255,0.92);backdrop-filter:blur(4px);cursor:pointer;display:none;z-index:10;box-shadow:0 2px 12px rgba(0,0,0,0.15);align-items:center;justify-content:center;transition:all 0.2s;">
                    <span class="material-symbols-outlined" style="font-size:20px;color:#544246;">chevron_left</span>
                </button>
                <button id="carouselNext" onclick="carouselMove(1); event.stopPropagation();"
                        style="position:absolute;right:16px;top:50%;transform:translateY(-50%);width:40px;height:40px;border-radius:50%;border:none;background:rgba(255,255,255,0.92);backdrop-filter:blur(4px);cursor:pointer;display:none;z-index:10;box-shadow:0 2px 12px rgba(0,0,0,0.15);align-items:center;justify-content:center;transition:all 0.2s;">
                    <span class="material-symbols-outlined" style="font-size:20px;color:#544246;">chevron_right</span>
                </button>
                
                <!-- Indicadores -->
                <div id="carouselDots" style="position:absolute;bottom:16px;left:50%;transform:translateX(-50%);display:flex;gap:8px;z-index:10;"></div>
                
                <!-- Placeholder (cuando no hay imágenes) -->
                <div id="modalImagePlaceholder" class="modal-img-placeholder" style="position:absolute;inset:0;display:none;align-items:center;justify-content:center;">
                    <span class="material-symbols-outlined text-8xl">spa</span>
                </div>
            </div>
            
            <!-- Info del producto -->
            <div class="flex flex-col p-8 md:p-10 justify-between">
                <div>
                    <div class="flex items-center gap-3 mb-4">
                        <span id="modalMarca" class="marca-pill"></span>
                        <span id="modalSubcat" class="font-label-md text-[10px] text-on-surface-variant uppercase tracking-wider"></span>
                    </div>
                    <h2 id="modalNombre" class="font-display-lg text-3xl md:text-4xl italic mb-3 leading-tight" style="font-family:'EB Garamond',serif;"></h2>
                    <p id="modalPrecio" class="font-headline-md text-2xl text-primary mb-5"></p>
                    <div class="border-t border-outline/15 pt-5 mb-5">
                        <p id="modalDescripcion" class="text-on-surface-variant text-sm leading-relaxed mb-3"></p>
                        <p id="modalComponentesWrap" class="text-xs text-outline/70 leading-relaxed" style="display:none;">
                            <span class="font-semibold uppercase tracking-wider text-on-surface-variant/60">Ingredientes: </span>
                            <span id="modalComponentes"></span>
                        </p>
                    </div>
                    <div class="mb-5">
                        <div class="flex items-center justify-between mb-1">
                            <span id="modalStockLabel" class="font-label-md text-[10px] uppercase tracking-wider text-on-surface-variant"></span>
                            <span id="modalStockNum" class="font-label-md text-[10px] uppercase tracking-wider text-primary"></span>
                        </div>
                        <div class="stock-bar-track">
                            <div id="modalStockBar" class="stock-bar-fill" style="width:0%;"></div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center gap-4 mb-5">
                        <span class="font-label-md text-[11px] uppercase tracking-wider text-on-surface-variant">Cantidad</span>
                        <div class="qty-row">
                            <button class="qty-btn" id="btnMinus" onclick="changeQty(-1)">−</button>
                            <div class="qty-display" id="qtyDisplay">1</div>
                            <button class="qty-btn" id="btnPlus" onclick="changeQty(+1)">+</button>
                        </div>
                    </div>
                    <div class="modal-total-row">
                        <span class="font-label-md text-[11px] uppercase tracking-wider text-on-surface-variant">Total</span>
                        <span id="modalTotal" class="font-display-lg text-2xl text-primary" style="font-family:'EB Garamond',serif;"></span>
                    </div>
                    <button id="addToCartBtn" onclick="submitToCart()"
                            class="w-full py-4 bg-primary text-white font-label-md text-[11px] uppercase tracking-[0.2em] hover:bg-[#7a2e48] transition-all disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-2">
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
<footer class="bg-white border-t border-on-surface/5 py-24 px-container-margin">
    <div class="max-w-[1440px] mx-auto grid grid-cols-1 md:grid-cols-4 gap-gutter">
        <div class="md:col-span-1">
            <h2 class="font-display-lg text-headline-md text-primary tracking-[0.2em] uppercase mb-8">Quiddity</h2>
            <p class="text-body-md text-on-surface-variant max-w-[240px]">Redefining botanical skincare through the lens of modern science and timeless purity.</p>
        </div>
        <div>
            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">Explore</h6>
            <ul class="space-y-4">
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">All Collections</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Bestsellers</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Gift Sets</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Bundles</a></li>
            </ul>
        </div>
        <div>
            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">Support</h6>
            <ul class="space-y-4">
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Shipping &amp; Returns</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Track Order</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Sustainability</a></li>
                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">FAQ</a></li>
            </ul>
        </div>
        <div>
            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">Follow</h6>
            <div class="flex gap-4 mb-8">
                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">IN</i></a>
                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">FB</i></a>
                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">PT</i></a>
            </div>
            <p class="text-xs text-on-surface-variant uppercase tracking-widest">Join our Newsletter</p>
            <div class="mt-4 flex border-b border-on-surface pb-2">
                <input class="bg-transparent border-none focus:ring-0 w-full text-sm uppercase tracking-widest placeholder:text-outline/40" placeholder="email address" type="email" />
                <button class="material-symbols-outlined text-sm">east</button>
            </div>
        </div>
    </div>
    <div class="max-w-[1440px] mx-auto mt-24 pt-8 border-t border-outline/10 flex flex-col md:flex-row justify-between items-center gap-4">
        <p class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em]">© 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
        <div class="flex gap-8">
            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary" href="#">Privacy</a>
            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary" href="#">Terms</a>
            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary" href="#">Accessibility</a>
        </div>
    </div>
</footer>

<script>
var currentProductId = null;
var currentQty       = 1;
var currentStock     = 0;
var currentPrecio    = 0;

// ═══════════════════════════════════════════════════════════════════════
// CARRUSEL DE IMÁGENES DEL MODAL
// ═══════════════════════════════════════════════════════════════════════

var carouselCurrent = 0;
var carouselImages = [];
var carouselTouchStartX = 0;

function initCarousel(imagenes) {
    carouselImages = imagenes || [];
    carouselCurrent = 0;
    
    var track = document.getElementById('modalCarouselTrack');
    var dots = document.getElementById('carouselDots');
    var prev = document.getElementById('carouselPrev');
    var next = document.getElementById('carouselNext');
    var placeholder = document.getElementById('modalImagePlaceholder');
    
    track.innerHTML = '';
    dots.innerHTML = '';
    
    if (carouselImages.length === 0) {
        placeholder.style.display = 'flex';
        prev.style.display = 'none';
        next.style.display = 'none';
        return;
    }
    
    placeholder.style.display = 'none';
    
    // Mostrar controles solo si hay múltiples imágenes
    if (carouselImages.length > 1) {
        prev.style.display = 'flex';
        next.style.display = 'flex';
    } else {
        prev.style.display = 'none';
        next.style.display = 'none';
    }
    
    carouselImages.forEach(function(src, idx) {
        // Slide
        var slide = document.createElement('div');
        slide.style.cssText = 'min-width:100%;height:100%;display:flex;align-items:center;justify-content:center;';
        slide.innerHTML = '<img src="' + src + '" alt="" style="width:100%;height:100%;object-fit:cover;display:block;">';
        track.appendChild(slide);
        
        // Dot
        var dot = document.createElement('button');
        dot.style.cssText = 'width:8px;height:8px;border-radius:50%;border:none;cursor:pointer;transition:all 0.3s ease;background:' + (idx === 0 ? '#9a3a5a' : 'rgba(255,255,255,0.5)') + ';';
        dot.onclick = function(e) { e.stopPropagation(); carouselGoTo(idx); };
        dots.appendChild(dot);
    });
    
    updateCarouselPosition();
    
    // Touch/swipe support
    var carousel = document.getElementById('modalCarousel');
    carousel.addEventListener('touchstart', function(e) {
        carouselTouchStartX = e.changedTouches[0].screenX;
    }, {passive: true});
    
    carousel.addEventListener('touchend', function(e) {
        var diff = carouselTouchStartX - e.changedTouches[0].screenX;
        if (Math.abs(diff) > 50) {
            if (diff > 0) carouselMove(1);
            else carouselMove(-1);
        }
    }, {passive: true});
}

function carouselMove(dir) {
    if (carouselImages.length <= 1) return;
    carouselCurrent += dir;
    if (carouselCurrent < 0) carouselCurrent = carouselImages.length - 1;
    if (carouselCurrent >= carouselImages.length) carouselCurrent = 0;
    updateCarouselPosition();
}

function carouselGoTo(idx) {
    carouselCurrent = idx;
    updateCarouselPosition();
}

function updateCarouselPosition() {
    var track = document.getElementById('modalCarouselTrack');
    track.style.transform = 'translateX(-' + (carouselCurrent * 100) + '%)';
    
    var dots = document.getElementById('carouselDots').children;
    for (var i = 0; i < dots.length; i++) {
        if (i === carouselCurrent) {
            dots[i].style.background = '#9a3a5a';
            dots[i].style.width = '24px';
            dots[i].style.borderRadius = '4px';
        } else {
            dots[i].style.background = 'rgba(255,255,255,0.5)';
            dots[i].style.width = '8px';
            dots[i].style.borderRadius = '50%';
        }
    }
}

// Modificar openProductModal para usar el carrusel
function openProductModal(productId) {
    var card = document.querySelector('.product-card[data-id="' + productId + '"]');
    if (!card) return;
    
    currentProductId = productId;
    currentQty = 1;
    currentStock = parseInt(card.getAttribute('data-stock')) || 0;
    currentPrecio = parseFloat(card.getAttribute('data-precio')) || 0;

    // ── Inicializar carrusel ──
    var imagenesAttr = card.getAttribute('data-imagenes');
    var imagenes = [];
    try {
        imagenes = JSON.parse(imagenesAttr || '[]');
    } catch(e) {
        var img = card.getAttribute('data-imagen');
        if (img) imagenes = [img];
    }
    initCarousel(imagenes);

    document.getElementById('modalNombre').textContent = card.getAttribute('data-nombre') || '';

    var marca = card.getAttribute('data-marca') || '';
    var marcaEl = document.getElementById('modalMarca');
    marcaEl.textContent = marca;
    marcaEl.style.display = marca ? 'inline-block' : 'none';

    document.getElementById('modalSubcat').textContent = card.getAttribute('data-subcat-label') || '';
    document.getElementById('modalPrecio').textContent = '$' + formatPeso(currentPrecio) + ' / und.';

    var desc = card.getAttribute('data-descripcion') || '';
    document.getElementById('modalDescripcion').textContent = desc.trim() !== '' ? desc : 'Sin descripción disponible.';

    var comp = card.getAttribute('data-componentes') || '';
    var compWrap = document.getElementById('modalComponentesWrap');
    if (comp.trim() !== '') {
        document.getElementById('modalComponentes').textContent = comp;
        compWrap.style.display = 'block';
    } else {
        compWrap.style.display = 'none';
    }

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
        lbl.textContent = 'Sin stock disponible';
        num.textContent = '';
        bar.style.width = '0%';
        bar.style.background = '#d1d5db';
        btn.disabled = true;
        btn.textContent = 'Sin Stock';
    } else if (currentStock <= 5) {
        lbl.textContent = '¡Últimas unidades!';
        num.textContent = currentStock + ' disponibles';
        bar.style.width = pct + '%';
        bar.style.background = '#b45f06';
        btn.disabled = false;
        btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">shopping_bag</span> Agregar al Carrito';
    } else {
        lbl.textContent = 'En stock';
        num.textContent = currentStock + ' disponibles';
        bar.style.width = pct + '%';
        bar.style.background = '#9a3a5a';
        btn.disabled = false;
        btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">shopping_bag</span> Agregar al Carrito';
    }
}

function resetQty() { currentQty = 1; renderQty(); }

function changeQty(delta) {
    var next = currentQty + delta;
    if (next < 1) return;
    if (next > currentStock) { showModalError('Solo hay ' + currentStock + ' unidades disponibles.'); return; }
    hideModalError();
    currentQty = next;
    renderQty();
}

function renderQty() {
    document.getElementById('qtyDisplay').textContent = currentQty;
    document.getElementById('btnMinus').disabled = (currentQty <= 1);
    document.getElementById('btnPlus').disabled  = (currentQty >= currentStock);
    document.getElementById('modalTotal').textContent = '$' + formatPeso(currentQty * currentPrecio);
}

function submitToCart() {
    if (!currentProductId || currentStock === 0) return;
    if (currentQty > currentStock) { showModalError('Stock insuficiente.'); return; }
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '<%= ctx %>/carrito';
    var fields = { accion: 'agregar', catalogoId: currentProductId, cantidad: currentQty };
    Object.entries(fields).forEach(function(pair) {
        var inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = pair[0]; inp.value = pair[1];
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

document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeProductModal(); });

function showToast(msg) {
    var t = document.getElementById('cart-toast');
    document.getElementById('cart-toast-msg').textContent = msg;
    t.classList.add('show');
    setTimeout(function() { t.classList.remove('show'); }, 2800);
}

function formatPeso(n) { return Math.round(n).toLocaleString('es-CO'); }
function showModalError(msg) { var el = document.getElementById('modalError'); el.textContent = msg; el.style.display = 'block'; }
function hideModalError() { document.getElementById('modalError').style.display = 'none'; }

var FAV_KEY = 'quiddity_favs';
function getFavs()     { return JSON.parse(localStorage.getItem(FAV_KEY) || '[]'); }
function saveFavs(arr) { localStorage.setItem(FAV_KEY, JSON.stringify(arr)); }

function toggleFav(btn) {
    var id = parseInt(btn.getAttribute('data-id'));
    var favs = getFavs();
    var idx  = favs.indexOf(id);
    if (idx === -1) {
        favs.push(id);
        btn.classList.add('active');
        btn.classList.remove('pop'); void btn.offsetWidth; btn.classList.add('pop');
    } else {
        favs.splice(idx, 1);
        btn.classList.remove('active');
    }
    saveFavs(favs);
    updateFavBadge();
}

function updateFavBadge() {
    var count = getFavs().length;
    var badge = document.getElementById('fav-badge');
    if (!badge) return;
    if (count > 0) { badge.textContent = count; badge.style.display = 'flex'; }
    else           { badge.style.display = 'none'; }
}

var SUBCATS = {
    'all': [],
    'belleza': [
        { key: 'brochas',    label: 'Brochas' },
        { key: 'esponjas',   label: 'Esponjas' },
        { key: 'maquillaje', label: 'Maquillaje' }
    ],
    'cuidado': [
        { key: 'facial',   label: 'Facial', subs: [
            { key: 'mascarillas', label: 'Mascarillas' },
            { key: 'serums',      label: 'Serums' },
            { key: 'hidratantes', label: 'Hidratantes' },
            { key: 'tonicos',     label: 'Tónicos' },
            { key: 'exfoliantes', label: 'Exfoliantes' }
        ]},
        { key: 'corporal', label: 'Corporal', subs: [
            { key: 'exfoliantes-corp',  label: 'Exfoliantes' },
            { key: 'lociones',          label: 'Lociones & Mantecas' },
            { key: 'aceites-corp',      label: 'Aceites Corporales' },
            { key: 'tratamientos-corp', label: 'Tratamientos' }
        ]}
    ],
    'perfumes': [
        { key: 'edt',           label: 'EDT' },
        { key: 'edp',           label: 'EDP' },
        { key: 'sets-olfativos', label: 'Sets Olfativos' }
    ],
    'cabello': [
        { key: 'shampoos',            label: 'Shampoo & Acondicionador' },
        { key: 'mascarillas-capilar', label: 'Mascarillas Capilares' },
        { key: 'aceites-capilares',   label: 'Aceites & Serums' }
    ]
};

var SECTION_META = {
    'all':      { label: 'Todos los productos',  title: 'Catálogo' },
    'belleza':  { label: 'Colección Belleza',    title: 'Belleza & Maquillaje' },
    'cuidado':  { label: 'Ritual de Cuidado',    title: 'Cuidado de la Piel' },
    'perfumes': { label: 'Fragancias Botánicas', title: 'Perfumes & Fragancias' },
    'cabello':  { label: 'Cuidado Capilar',      title: 'Cuidado del Cabello' }
};

var activeCat = 'all', activeGroup = null, activeSubcat = null;

function filterProducts() {
    var cards = document.querySelectorAll('.product-card');
    var visible = 0;
    cards.forEach(function(card) {
        var cat   = card.getAttribute('data-cat');
        var group = card.getAttribute('data-group');
        var sub   = card.getAttribute('data-subcat');
        var show  = false;
        if (activeCat === 'all') {
            show = true;
        } else if (cat === activeCat) {
            if (isCatGrouped(activeCat)) {
                show = !activeGroup || (group === activeGroup && (!activeSubcat || sub === activeSubcat));
            } else {
                show = !activeSubcat || sub === activeSubcat;
            }
        }
        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    var meta     = SECTION_META[activeCat];
    var subs     = SUBCATS[activeCat] || [];
    var groupObj = activeGroup ? subs.find(function(s){ return s.key === activeGroup; }) : null;
    var subObj   = null;
    if (activeSubcat) {
        var pool = (groupObj && groupObj.subs) ? groupObj.subs : subs;
        subObj   = pool.find(function(s){ return s.key === activeSubcat; }) || null;
    }
    var title = subObj ? subObj.label : groupObj ? groupObj.label : meta.title;
    document.getElementById('section-label').textContent = meta.label;
    document.getElementById('section-title').textContent = title;
    document.getElementById('product-count').textContent = visible + ' producto' + (visible !== 1 ? 's' : '');
}

function isCatGrouped(cat) {
    var subs = SUBCATS[cat] || [];
    return subs.length > 0 && subs[0].subs !== undefined;
}

function renderSubcats(cat) {
    var row = document.getElementById('subcat-row');
    var divider = document.getElementById('subcat-divider');
    var subs = SUBCATS[cat] || [];
    hideSubsubcats();
    if (subs.length === 0) { row.style.display = 'none'; divider.style.display = 'none'; row.innerHTML = ''; return; }
    divider.style.display = 'block';
    row.style.display = 'flex';
    var grouped = isCatGrouped(cat);
    row.innerHTML = '<button class="subcat-chip active" data-sub="all-sub">Todos</button>' +
        subs.map(function(s){ return '<button class="subcat-chip" data-sub="' + s.key + '">' + s.label + '</button>'; }).join('');
    row.querySelectorAll('.subcat-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            row.querySelectorAll('.subcat-chip').forEach(function(c){ c.classList.remove('active'); });
            chip.classList.add('active');
            var subKey = chip.getAttribute('data-sub');
            if (subKey === 'all-sub') {
                activeGroup = null; activeSubcat = null; hideSubsubcats();
            } else if (grouped) {
                activeGroup = subKey; activeSubcat = null;
                var gObj = subs.find(function(s){ return s.key === subKey; });
                if (gObj && gObj.subs && gObj.subs.length > 0) renderSubsubcats(gObj.subs);
                else hideSubsubcats();
            } else {
                activeGroup = null; hideSubsubcats(); activeSubcat = subKey;
            }
            filterProducts();
        });
    });
}

function renderSubsubcats(subs) {
    var subRow = document.getElementById('subsubcat-row');
    var subDiv = document.getElementById('subsubcat-divider');
    subDiv.style.display = 'block'; subRow.style.display = 'flex';
    subRow.innerHTML = '<button class="subcat-chip active" data-subsub="all-subsub">Todos</button>' +
        subs.map(function(s){ return '<button class="subcat-chip" data-subsub="' + s.key + '">' + s.label + '</button>'; }).join('');
    subRow.querySelectorAll('.subcat-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            subRow.querySelectorAll('.subcat-chip').forEach(function(c){ c.classList.remove('active'); });
            chip.classList.add('active');
            var k = chip.getAttribute('data-subsub');
            activeSubcat = k === 'all-subsub' ? null : k;
            filterProducts();
        });
    });
}

function hideSubsubcats() {
    var subRow = document.getElementById('subsubcat-row');
    var subDiv = document.getElementById('subsubcat-divider');
    subRow.style.display = 'none'; subDiv.style.display = 'none';
    subRow.innerHTML = ''; activeSubcat = null;
}

document.querySelectorAll('.cat-chip').forEach(function(chip) {
    chip.addEventListener('click', function() {
        document.querySelectorAll('.cat-chip').forEach(function(c){ c.classList.remove('active'); });
        chip.classList.add('active');
        activeCat = chip.getAttribute('data-cat');
        activeGroup = null;
        updateHero(chip);
        renderSubcats(activeCat);
        filterProducts();
    });
});

function updateHero(btn) {
    var videoSrc = btn.getAttribute('data-hero-video');
    var label    = btn.getAttribute('data-hero-label');
    var title    = btn.getAttribute('data-hero-title');
    var sub      = btn.getAttribute('data-hero-sub');
    if (videoSrc) {
        var video = document.getElementById('hero-video');
        var source = document.getElementById('hero-video-src');
        source.setAttribute('src', videoSrc);
        video.load(); video.play();
    }
    var wrapper = document.getElementById('hero-text-wrapper');
    if (wrapper) {
        wrapper.style.opacity = '0';
        setTimeout(function() {
            document.getElementById('hero-label').textContent    = label || '';
            document.getElementById('hero-title').textContent    = title || '';
            document.getElementById('hero-subtitle').textContent = sub   || '';
            wrapper.style.opacity = '1';
        }, 280);
    }
}

function closeAnnouncementBar() {
    document.getElementById('announcement-bar').style.display = 'none';
    document.getElementById('main-header').style.top = '0px';
    document.querySelectorAll('.sticky').forEach(function(el){ el.style.top = '72px'; });
}

window.addEventListener('scroll', function() {
    var header = document.getElementById('main-header');
    if (window.scrollY > 10) { header.classList.add('py-2'); header.classList.remove('py-4'); }
    else                     { header.classList.remove('py-2'); header.classList.add('py-4'); }
});

document.addEventListener('DOMContentLoaded', function() {
    var favs = getFavs();
    document.querySelectorAll('.btn-fav').forEach(function(btn) {
        if (favs.includes(parseInt(btn.getAttribute('data-id')))) btn.classList.add('active');
    });
    updateFavBadge();
    filterProducts();
    var params = new URLSearchParams(window.location.search);
    if (params.get('exito')) showToast(decodeURIComponent(params.get('exito')));
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

        document.addEventListener('click', function(e) {
            if (!container.contains(e.target)) {
                dropdown.classList.add('hidden');
                icon.textContent = 'expand_more';
            }
        });

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