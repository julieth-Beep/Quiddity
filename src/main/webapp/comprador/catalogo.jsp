<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.quiddity.model.Usuario" %>
        <% Usuario user=(Usuario) session.getAttribute("usuario"); if (user==null || (user.getIdRol() !=2 &&
            user.getIdRol() !=3)) { response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } String
            ctx=request.getContextPath(); %>
            <!DOCTYPE html>
            <html class="light" lang="es">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>QUIDDITY | Catálogo</title>
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

                    /* ── HERO ── */
                    #catalog-hero {
                        position: relative;
                        width: 100%;
                        height: 56vh;
                        min-height: 360px;
                        overflow: hidden;
                    }

                    #hero-video {
                        position: absolute;
                        inset: 0;
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        transition: opacity 0.6s ease;
                    }

                    /* ── CHIPS CATEGORÍA PRINCIPAL ── */
                    .cat-chip {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 10px 22px;
                        border: 1.5px solid rgba(154, 58, 90, 0.25);
                        font-family: 'Manrope', sans-serif;
                        font-size: 11px;
                        font-weight: 600;
                        letter-spacing: 0.12em;
                        text-transform: uppercase;
                        color: #544246;
                        cursor: pointer;
                        transition: all 0.22s ease;
                        background: white;
                        white-space: nowrap;
                    }

                    .cat-chip:hover {
                        border-color: #9a3a5a;
                        color: #9a3a5a;
                    }

                    .cat-chip.active {
                        background: #9a3a5a;
                        border-color: #9a3a5a;
                        color: white;
                    }

                    /* ── CHIPS SUBCATEGORÍA (nivel 2 y 3) ── */
                    .subcat-chip {
                        display: inline-flex;
                        align-items: center;
                        padding: 7px 16px;
                        border: 1px solid rgba(135, 114, 118, 0.30);
                        font-family: 'Manrope', sans-serif;
                        font-size: 10px;
                        font-weight: 600;
                        letter-spacing: 0.12em;
                        text-transform: uppercase;
                        color: #877276;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        background: transparent;
                        white-space: nowrap;
                    }

                    .subcat-chip:hover {
                        border-color: #9a3a5a;
                        color: #9a3a5a;
                    }

                    .subcat-chip.active {
                        background: #f1ecef;
                        border-color: #9a3a5a;
                        color: #9a3a5a;
                    }

                    /* ── CHIPS NIVEL 3: ligeramente más pequeños para distinguirlos ── */
                    .subsubcat-chip {
                        display: inline-flex;
                        align-items: center;
                        padding: 5px 13px;
                        border: 1px solid rgba(135, 114, 118, 0.22);
                        font-family: 'Manrope', sans-serif;
                        font-size: 9px;
                        font-weight: 600;
                        letter-spacing: 0.14em;
                        text-transform: uppercase;
                        color: #a08888;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        background: transparent;
                        white-space: nowrap;
                    }

                    .subsubcat-chip:hover {
                        border-color: #9a3a5a;
                        color: #9a3a5a;
                    }

                    .subsubcat-chip.active {
                        background: #fff7f9;
                        border-color: #9a3a5a;
                        color: #9a3a5a;
                    }

                    /* ── SCROLL CHIPS ── */
                    .chips-scroll {
                        display: flex;
                        gap: 10px;
                        overflow-x: auto;
                        scrollbar-width: none;
                        padding-bottom: 4px;
                    }

                    .chips-scroll::-webkit-scrollbar {
                        display: none;
                    }

                    /* ── SEPARADORES ── */
                    .chips-divider {
                        height: 1px;
                        background: rgba(135, 114, 118, 0.12);
                        margin: 0;
                    }

                    /* ── BOTÓN FAVORITO CORAZÓN ── */
                    .btn-fav {
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        width: 32px;
                        height: 32px;
                        background: rgba(255, 255, 255, 0.92);
                        backdrop-filter: blur(4px);
                        border-radius: 50%;
                        border: none;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.10);
                        transition: transform 0.18s ease, background 0.18s ease;
                        z-index: 5;
                    }

                    .btn-fav:hover {
                        transform: scale(1.13);
                        background: #fff0f4;
                    }

                    .btn-fav .material-symbols-outlined {
                        font-size: 17px;
                        color: #c4a9a2;
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        transition: color 0.18s, font-variation-settings 0.18s;
                        line-height: 1;
                    }

                    .btn-fav.active .material-symbols-outlined {
                        color: #9a3a5a;
                        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                    }

                    .btn-fav.pop {
                        animation: heartPop 0.32s cubic-bezier(.36, .07, .19, .97);
                    }

                    @keyframes heartPop {
                        0% {
                            transform: scale(1);
                        }

                        40% {
                            transform: scale(1.45);
                        }

                        70% {
                            transform: scale(0.92);
                        }

                        100% {
                            transform: scale(1);
                        }
                    }

                    /* ── CARD ── */
                    .product-card {
                        opacity: 1;
                        transition: opacity 0.25s ease;
                    }

                    .product-card[style*="none"] {
                        display: none !important;
                    }
                </style>
            </head>

            <body class="bg-white font-body-md text-on-surface selection:bg-primary/10">

                <!-- ══ ANNOUNCEMENT BAR ══ -->
                <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
                    <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
                        NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
                    </p>
                    <button onclick="closeAnnouncementBar()"
                        class="absolute right-6 text-white/60 hover:text-white transition-colors">
                        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
                    </button>
                </div>

                <!-- ══ HEADER ══ -->
                <header id="main-header"
                    class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
                    style="top: 42px;">
                    <div class="flex items-center gap-12">
                        <a href="<%= ctx %>/index.jsp">
                            <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">
                                Quiddity</h1>
                        </a>
                        <nav class="hidden md:flex gap-8">
                            <a class="font-label-md text-label-md uppercase text-primary border-b border-primary pb-0.5"
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
                        <button class="text-on-surface hover:text-primary transition-colors">
                            <span class="material-symbols-outlined">search</span>
                        </button>
                        <a href="<%= ctx %>/comprador/favoritos.jsp"
                            class="text-on-surface hover:text-primary transition-colors relative">
                            <span class="material-symbols-outlined">favorite</span>
                            <span id="fav-badge"
                                class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full items-center justify-center hidden">0</span>
                        </a>
                        <a href="<%= ctx %>/carrito.jsp"
                            class="text-on-surface hover:text-primary transition-colors relative">
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
                                    class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi
                                    Perfil</a>
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

                <main style="padding-top: 42px;">

                    <!-- ══ HERO VIDEO ══ -->
                    <section id="catalog-hero">
                        <video id="hero-video" autoplay muted loop playsinline>
                            <source id="hero-video-src" src="<%= ctx %>/uploads/videos/mixed/4.mp4" type="video/mp4">
                        </video>
                        <div class="absolute inset-0"
                            style="background: linear-gradient(to right, rgba(15,10,12,0.60) 0%, rgba(15,10,12,0.25) 55%, rgba(15,10,12,0.05) 100%);">
                        </div>
                        <div class="relative z-10 h-full flex flex-col justify-end pb-14 px-container-margin">
                            <div id="hero-text-wrapper" style="transition: opacity 0.3s ease;">
                                <span id="hero-label"
                                    class="block font-label-md text-[10px] tracking-[0.35em] text-white/70 uppercase mb-4">Explora
                                    nuestra selección</span>
                                <h2 id="hero-title" class="font-display-lg text-white italic mb-3 leading-tight"
                                    style="font-size:clamp(32px,4vw,56px);">Todo el Catálogo</h2>
                                <p id="hero-subtitle" class="font-body-md text-white/60 text-sm max-w-sm tracking-wide">
                                    Descubre nuestra gama completa de productos botánicos.</p>
                            </div>
                        </div>
                    </section>

                    <!-- ══ CHIPS DE NAVEGACIÓN ══ -->
                    <div class="sticky z-40 bg-white border-b border-on-surface/5 shadow-sm"
                        style="top: calc(42px + 72px);">
                        <div class="max-w-[1440px] mx-auto px-container-margin">

                            <!-- FILA 1: Categorías principales -->
                            <div class="chips-scroll py-5 gap-3" id="cat-row">
                                <button class="cat-chip active" data-cat="all"
                                    data-hero-video="<%= ctx %>/uploads/videos/mixed/4.mp4"
                                    data-hero-label="Explora nuestra selección" data-hero-title="Todo el Catálogo"
                                    data-hero-sub="Descubre nuestra gama completa de productos botánicos.">
                                    <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span>
                                    Todo
                                </button>
                                <button class="cat-chip" data-cat="belleza"
                                    data-hero-video="<%= ctx %>/uploads/videos/mixed/3.mp4"
                                    data-hero-label="Colección Belleza" data-hero-title="Belleza & Maquillaje"
                                    data-hero-sub="Herramientas y cosméticos que realzan tu belleza natural.">
                                    <span class="material-symbols-outlined"
                                        style="font-size:14px;">face_retouching_natural</span> Belleza
                                </button>
                                <button class="cat-chip" data-cat="cuidado"
                                    data-hero-video="<%= ctx %>/uploads/videos/mixed/2.mp4"
                                    data-hero-label="Ritual de Cuidado" data-hero-title="Cuidado de la Piel"
                                    data-hero-sub="Skincare botánico clínicamente comprobado.">
                                    <span class="material-symbols-outlined" style="font-size:14px;">spa</span> Cuidado
                                </button>
                                <button class="cat-chip" data-cat="perfumes"
                                    data-hero-video="<%= ctx %>/uploads/videos/mixed/dior.mp4"
                                    data-hero-label="Fragancias Botánicas" data-hero-title="Perfumes & Fragancias"
                                    data-hero-sub="Aromas naturales que cuentan una historia única.">
                                    <span class="material-symbols-outlined" style="font-size:14px;">water_drop</span>
                                    Perfumes
                                </button>
                                <button class="cat-chip" data-cat="cabello"
                                    data-hero-video="<%= ctx %>/uploads/videos/mixed/hair2.mp4"
                                    data-hero-label="Cuidado Capilar" data-hero-title="Cuidado del Cabello"
                                    data-hero-sub="Rituales capilares con activos botánicos puros.">
                                    <span class="material-symbols-outlined"
                                        style="font-size:14px;">self_improvement</span> Cabello
                                </button>
                            </div>

                            <!-- SEPARADOR NIVEL 2 -->
                            <div id="subcat-divider" class="chips-divider" style="display:none;"></div>

                            <!-- FILA 2: Grupos / Subcategorías directas -->
                            <div id="subcat-row" class="chips-scroll pb-3 gap-2"
                                style="display:none; padding-top: 12px;"></div>

                            <!-- SEPARADOR NIVEL 3 -->
                            <div id="subsubcat-divider" class="chips-divider" style="display:none;"></div>

                            <!-- FILA 3: Sub-subcategorías (tercer nivel, solo aplica a grupos anidados) -->
                            <div id="subsubcat-row" class="chips-scroll pb-4 gap-2"
                                style="display:none; padding-top: 10px;"></div>

                        </div>
                    </div>

                    <!-- ══ SECTION HEADER ══ -->
                    <section class="max-w-[1440px] mx-auto px-container-margin pt-16 pb-6">
                        <div class="flex justify-between items-end">
                            <div>
                                <span id="section-label"
                                    class="font-label-md text-label-md text-primary uppercase tracking-[0.2em] mb-3 block">Todos
                                    los productos</span>
                                <h3 class="font-headline-lg text-headline-lg" id="section-title">Catálogo</h3>
                            </div>
                            <p id="product-count"
                                class="font-label-md text-[10px] text-on-surface-variant uppercase tracking-[0.15em]">
                            </p>
                        </div>
                    </section>

                    <!-- ══ PRODUCT GRID ══ -->
                    <section class="max-w-[1440px] mx-auto px-container-margin pb-section-gap">
                        <div id="product-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-gutter">

                            <!-- ═══ BELLEZA — Brochas ═══ -->
                            <div class="product-card group" data-cat="belleza" data-subcat="brochas" data-id="1">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Set de Brochas Profesional"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/productoM/brochas/brochasSet.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="1" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Brochas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Set Profesional</h4>
                                        <p class="font-body-md text-primary text-sm">$78.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(1)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="brochas" data-id="2">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Brocha Kabuki"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/productoM/brochas/KabukiPowder.jpg" />
                                    <button class="btn-fav" data-id="2" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Brochas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Kabuki Powder</h4>
                                        <p class="font-body-md text-primary text-sm">$32.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(2)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="brochas" data-id="3">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Brocha Contorno"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/productoM/brochas/contorno.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="3" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Brochas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Brocha Contorno</h4>
                                        <p class="font-body-md text-primary text-sm">$28.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(3)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ BELLEZA — Esponjas ═══ -->
                            <div class="product-card group" data-cat="belleza" data-subcat="esponjas" data-id="4">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Beauty Blender Botanical"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/productoM/esponjas/blender.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="4" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Esponjas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Botanical Blender
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$24.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(4)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="esponjas" data-id="5">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Set Esponjas Precision"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/productoM/esponjas/set.jpg" />
                                    <button class="btn-fav" data-id="5" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Esponjas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Set Precision</h4>
                                        <p class="font-body-md text-primary text-sm">$38.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(5)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ BELLEZA — Maquillaje ═══ -->
                            <div class="product-card group" data-cat="belleza" data-subcat="maquillaje" data-id="6">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Base Botánica SPF"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/makeUp/base/base.jpg" />
                                    <button class="btn-fav" data-id="6" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Maquillaje</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Base Botánica SPF
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$89.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(6)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="maquillaje" data-id="7">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Paleta Tierra"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/makeUp/sombras/paletaTierra1.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="7" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Maquillaje</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Paleta Tierra</h4>
                                        <p class="font-body-md text-primary text-sm">$112.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(7)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="maquillaje" data-id="8">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Labial Botanical Rouge"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/makeUp/labiales/rouge.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="8" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Maquillaje</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Botanical Rouge</h4>
                                        <p class="font-body-md text-primary text-sm">$54.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(8)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="belleza" data-subcat="maquillaje" data-id="9">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Iluminador Lunar Glow"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/belleza/makeUp/iluminador/lunar.jpg" />
                                    <button class="btn-fav" data-id="9" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Maquillaje</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Lunar Glow</h4>
                                        <p class="font-body-md text-primary text-sm">$67.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(9)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / FACIAL — Mascarillas ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="mascarillas" data-id="10">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Rose Clay Mask"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/pink1.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="10" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Mascarillas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Rose Clay Mask</h4>
                                        <p class="font-body-md text-primary text-sm">$64.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(10)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="mascarillas" data-id="11">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Vitamin C Glow Mask"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/VitaminC.jpg" />
                                    <button class="btn-fav" data-id="11" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Mascarillas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Vitamin C Glow</h4>
                                        <p class="font-body-md text-primary text-sm">$58.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(11)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="mascarillas" data-id="12">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Black Charcoal Detox Mask"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/mascarillas/charcoal.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="12" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Mascarillas</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Charcoal Detox</h4>
                                        <p class="font-body-md text-primary text-sm">$52.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(12)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / FACIAL — Serums ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="facial" data-subcat="serums"
                                data-id="13">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Radiance Elixir Serum"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/gold.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="13" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Serums</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Radiance Elixir</h4>
                                        <p class="font-body-md text-primary text-sm">$84.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(13)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial" data-subcat="serums"
                                data-id="14">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Midnight Recovery Oil"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/Midnight.jpg" />
                                    <button class="btn-fav" data-id="14" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Serums</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Midnight Recovery
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$95.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(14)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial" data-subcat="serums"
                                data-id="15">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Hyaluronic Serum"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/hyaluronic.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="15" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Serums</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Hyaluronic Boost
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$78.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(15)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / FACIAL — Hidratantes ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="hidratantes" data-id="16">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Velvet Cloud Cream"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/cream.jpg" />
                                    <button class="btn-fav" data-id="16" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Hidratantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Velvet Cloud Cream
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$62.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(16)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="hidratantes" data-id="17">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Night Repair Cream"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/night.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="17" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Hidratantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Night Repair Cream
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$74.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(17)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="hidratantes" data-id="18">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="SPF 50 Botanical Shield"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/hidratantes/spf50.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="18" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Hidratantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Botanical Shield
                                            SPF50</h4>
                                        <p class="font-body-md text-primary text-sm">$85.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(18)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / FACIAL — Tónicos ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="facial" data-subcat="tonicos"
                                data-id="19">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Agua Micelar Botánica"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/tonicos/micelar.jpg" />
                                    <button class="btn-fav" data-id="19" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Tónicos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Agua Micelar
                                            Botánica</h4>
                                        <p class="font-body-md text-primary text-sm">$42.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(19)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="facial" data-subcat="tonicos"
                                data-id="20">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Tónico de Rosa Mosqueta"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/tonicos/rosa.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="20" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Tónicos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Rosa Mosqueta Tónico
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$48.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(20)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / FACIAL — Exfoliantes ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="facial"
                                data-subcat="exfoliantes" data-id="21">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Exfoliante Enzimático"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/exfoliantes/enzimas.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="21" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Exfoliantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Enzyme Polish</h4>
                                        <p class="font-body-md text-primary text-sm">$68.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(21)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ PERFUMES — EDT ═══ -->
                            <div class="product-card group" data-cat="perfumes" data-subcat="edt" data-id="22">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Vetiver Blanc EDT"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/edt/vetiver.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="22" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">EDT
                                        </p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Vetiver Blanc</h4>
                                        <p class="font-body-md text-primary text-sm">$142.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(22)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="perfumes" data-subcat="edt" data-id="23">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Cedar & Tea EDT"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/edt/cedar.jpg" />
                                    <button class="btn-fav" data-id="23" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">EDT
                                        </p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Cedar & Tea</h4>
                                        <p class="font-body-md text-primary text-sm">$128.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(23)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ PERFUMES — EDP ═══ -->
                            <div class="product-card group" data-cat="perfumes" data-subcat="edp" data-id="24">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Bloom Noir EDP"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/edp/bloomNoir.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="24" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">EDP
                                        </p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Bloom Noir</h4>
                                        <p class="font-body-md text-primary text-sm">$185.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(24)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="perfumes" data-subcat="edp" data-id="25">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Rose Sauvage EDP"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/edp/roseSauvage.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="25" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">EDP
                                        </p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Rose Sauvage</h4>
                                        <p class="font-body-md text-primary text-sm">$168.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(25)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ PERFUMES — Sets Olfativos ═══ -->
                            <div class="product-card group" data-cat="perfumes" data-subcat="sets-olfativos"
                                data-id="26">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Set Olfativo Botánico"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/sets/setBotatnico.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="26" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Sets
                                            Olfativos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Discovery Set</h4>
                                        <p class="font-body-md text-primary text-sm">$98.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(26)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="perfumes" data-subcat="sets-olfativos"
                                data-id="27">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Trio Botanico Gift Set"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/perfumes/sets/trioGift.jpg" />
                                    <button class="btn-fav" data-id="27" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Sets
                                            Olfativos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Trío Botánico</h4>
                                        <p class="font-body-md text-primary text-sm">$124.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(27)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CABELLO — Shampoos ═══ -->
                            <div class="product-card group" data-cat="cabello" data-subcat="shampoos" data-id="28">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Botanical Shampoo sin sulfatos"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/shampoos/botanical.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="28" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Shampoos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Botanical Shampoo
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$48.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(28)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cabello" data-subcat="shampoos" data-id="29">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Acondicionador Botánico"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/shampoos/acondicionador.jpg" />
                                    <button class="btn-fav" data-id="29" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Shampoos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Botanical
                                            Conditioner</h4>
                                        <p class="font-body-md text-primary text-sm">$44.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(29)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CABELLO — Mascarillas Capilares ═══ -->
                            <div class="product-card group" data-cat="cabello" data-subcat="mascarillas-capilar"
                                data-id="30">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Mascarilla Keratina Rosa"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/mascarillas/keratina.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="30" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Mascarillas Capilares</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Keratina Rosa</h4>
                                        <p class="font-body-md text-primary text-sm">$65.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(30)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cabello" data-subcat="mascarillas-capilar"
                                data-id="31">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Deep Repair Mask"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/mascarillas/deepRepair.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="31" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Mascarillas Capilares</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Deep Repair Mask
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$58.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(31)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CABELLO — Aceites Capilares ═══ -->
                            <div class="product-card group" data-cat="cabello" data-subcat="aceites-capilares"
                                data-id="32">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Aceite de Argán Puro"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/aceites/argan.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="32" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Aceites Capilares</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Aceite de Argán</h4>
                                        <p class="font-body-md text-primary text-sm">$72.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(32)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cabello" data-subcat="aceites-capilares"
                                data-id="33">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Serum Capilar Reparador"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/cabello/aceites/serumCapilar.jpg" />
                                    <button class="btn-fav" data-id="33" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Aceites Capilares</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Serum Reparador</h4>
                                        <p class="font-body-md text-primary text-sm">$55.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(33)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / CORPORAL — Exfoliantes ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="exfoliantes-corp" data-id="34">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Exfoliante de Azúcar y Rosa"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/exfoliantes/sugar.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="34" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Exfoliantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Sugar & Rose Scrub
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$45.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(34)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="exfoliantes-corp" data-id="35">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Exfoliante de Café"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/exfoliantes/cafe.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="35" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Exfoliantes</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Coffee Awakening
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$42.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(35)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / CORPORAL — Lociones ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="lociones" data-id="36">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Loción Jazmín Botánico"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/lociones/jazmin.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="36" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Lociones</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Jasmine Silk Lotion
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$52.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(36)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="lociones" data-id="37">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Body Butter Coco"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/lociones/coco.jpg" />
                                    <button class="btn-fav" data-id="37" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Lociones</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Coconut Body Butter
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$58.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(37)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / CORPORAL — Aceites Corporales ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="aceites-corp" data-id="38">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Aceite Seco Corporal"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/aceites/seco.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Nuevo</span>
                                    <button class="btn-fav" data-id="38" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Aceites Corporales</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Dry Body Oil</h4>
                                        <p class="font-body-md text-primary text-sm">$68.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(38)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="aceites-corp" data-id="39">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Aceite Anticelulítico"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/aceites/anticelulitis.jpg" />
                                    <button class="btn-fav" data-id="39" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Aceites Corporales</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Firming Body Oil
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$74.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(39)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                            <!-- ═══ CUIDADO / CORPORAL — Tratamientos ═══ -->
                            <div class="product-card group" data-cat="cuidado" data-group="corporal"
                                data-subcat="tratamientos-corp" data-id="40">
                                <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                                    <img alt="Tratamiento Antimanchas Corporal"
                                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                                        src="<%= ctx %>/uploads/catalogo/corporales/tratamientos/antimanchas.jpg" />
                                    <span
                                        class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best
                                        Seller</span>
                                    <button class="btn-fav" data-id="40" onclick="toggleFav(this)"
                                        title="Añadir a favoritos">
                                        <span class="material-symbols-outlined">favorite</span>
                                    </button>
                                </div>
                                <div class="flex justify-between items-start">
                                    <div>
                                        <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">
                                            Tratamientos</p>
                                        <h4 class="font-headline-md text-[18px] leading-tight mb-2">Even Tone Treatment
                                        </h4>
                                        <p class="font-body-md text-primary text-sm">$82.000</p>
                                    </div>
                                    <button onclick="agregarAlCarrito(40)"
                                        class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all">
                                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                                    </button>
                                </div>
                            </div>

                        </div><!-- /product-grid -->
                    </section>

                </main>

                <!-- ══ FOOTER ══ -->
                <footer class="bg-white border-t border-on-surface/5 py-24 px-container-margin">
                    <div class="max-w-[1440px] mx-auto grid grid-cols-1 md:grid-cols-4 gap-gutter">
                        <div class="md:col-span-1">
                            <h2 class="font-display-lg text-headline-md text-primary tracking-[0.2em] uppercase mb-8">
                                Quiddity</h2>
                            <p class="text-body-md text-on-surface-variant max-w-[240px]">Redefining botanical skincare
                                through the lens of modern science and timeless purity.</p>
                        </div>
                        <div>
                            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                                Explore</h6>
                            <ul class="space-y-4">
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">All Collections</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Bestsellers</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Gift Sets</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Bundles</a></li>
                            </ul>
                        </div>
                        <div>
                            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                                Support</h6>
                            <ul class="space-y-4">
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Shipping &amp; Returns</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Track Order</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">Sustainability</a></li>
                                <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                                        href="#">FAQ</a></li>
                            </ul>
                        </div>
                        <div>
                            <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                                Follow</h6>
                            <div class="flex gap-4 mb-8">
                                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                                    href="#"><i class="text-sm font-bold not-italic">IN</i></a>
                                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                                    href="#"><i class="text-sm font-bold not-italic">FB</i></a>
                                <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                                    href="#"><i class="text-sm font-bold not-italic">PT</i></a>
                            </div>
                            <p class="text-xs text-on-surface-variant uppercase tracking-widest">Join our Newsletter</p>
                            <div class="mt-4 flex border-b border-on-surface pb-2">
                                <input
                                    class="bg-transparent border-none focus:ring-0 w-full text-sm uppercase tracking-widest placeholder:text-outline/40"
                                    placeholder="email address" type="email" />
                                <button class="material-symbols-outlined text-sm">east</button>
                            </div>
                        </div>
                    </div>
                    <div
                        class="max-w-[1440px] mx-auto mt-24 pt-8 border-t border-outline/10 flex flex-col md:flex-row justify-between items-center gap-4">
                        <p class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em]">©
                            2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.</p>
                        <div class="flex gap-8">
                            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary"
                                href="#">Privacy</a>
                            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary"
                                href="#">Terms</a>
                            <a class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em] hover:text-primary"
                                href="#">Accessibility</a>
                        </div>
                    </div>
                </footer>

                <script>
                    // ══════════════════════════════════════════════════════════
                    //  CONFIGURACIÓN: SUBCATS con jerarquía anidada para CUIDADO
                    //
                    //  Estructura:
                    //   - Si un ítem tiene la propiedad "subs" → es un GRUPO
                    //     (renderiza el nivel 2 y abre un nivel 3 al hacer click)
                    //   - Si no tiene "subs" → es una subcategoría directa
                    //     (solo dos niveles, como Belleza, Perfumes, Cabello)
                    // ══════════════════════════════════════════════════════════
                    var SUBCATS = {
                        'all': [],
                        'belleza': [
                            { key: 'brochas', label: 'Brochas' },
                            { key: 'esponjas', label: 'Esponjas' },
                            { key: 'maquillaje', label: 'Maquillaje' }
                        ],
                        'cuidado': [
                            {
                                key: 'facial', label: 'Facial',
                                subs: [
                                    { key: 'mascarillas', label: 'Mascarillas' },
                                    { key: 'serums', label: 'Serums' },
                                    { key: 'hidratantes', label: 'Hidratantes' },
                                    { key: 'tonicos', label: 'Tónicos' },
                                    { key: 'exfoliantes', label: 'Exfoliantes' }
                                ]
                            },
                            {
                                key: 'corporal', label: 'Corporal',
                                subs: [
                                    { key: 'exfoliantes-corp', label: 'Exfoliantes' },
                                    { key: 'lociones', label: 'Lociones & Mantecas' },
                                    { key: 'aceites-corp', label: 'Aceites Corporales' },
                                    { key: 'tratamientos-corp', label: 'Tratamientos' }
                                ]
                            }
                        ],
                        'perfumes': [
                            { key: 'edt', label: 'EDT' },
                            { key: 'edp', label: 'EDP' },
                            { key: 'sets-olfativos', label: 'Sets Olfativos' }
                        ],
                        'cabello': [
                            { key: 'shampoos', label: 'Shampoo & Acondicionador' },
                            { key: 'mascarillas-capilar', label: 'Mascarillas Capilares' },
                            { key: 'aceites-capilares', label: 'Aceites & Serums' }
                        ]
                    };

                    var SECTION_META = {
                        'all': { label: 'Todos los productos', title: 'Catálogo' },
                        'belleza': { label: 'Colección Belleza', title: 'Belleza & Maquillaje' },
                        'cuidado': { label: 'Ritual de Cuidado', title: 'Cuidado de la Piel' },
                        'perfumes': { label: 'Fragancias Botánicas', title: 'Perfumes & Fragancias' },
                        'cabello': { label: 'Cuidado Capilar', title: 'Cuidado del Cabello' }
                    };

                    // ── Estado activo ──
                    var activeCat = 'all';
                    var activeGroup = null;   // solo para categorías con grupos (ej. cuidado)
                    var activeSubcat = null;

                    // ══════════════════════════════════════════════════════════
                    //  FILTRADO DE PRODUCTOS
                    //
                    //  Lógica de 3 niveles:
                    //    1) activeCat  → filtra por data-cat
                    //    2) activeGroup → filtra por data-group (solo categorías anidadas)
                    //    3) activeSubcat → filtra por data-subcat
                    // ══════════════════════════════════════════════════════════
                    function filterProducts() {
                        var cards = document.querySelectorAll('.product-card');
                        var visible = 0;

                        cards.forEach(function (card) {
                            var cat = card.getAttribute('data-cat');
                            var group = card.getAttribute('data-group');   // puede ser null
                            var sub = card.getAttribute('data-subcat');
                            var show = false;

                            if (activeCat === 'all') {
                                show = true;
                            } else if (cat === activeCat) {
                                var catIsGrouped = isCatGrouped(activeCat);

                                if (catIsGrouped) {
                                    // Categoría con grupos (ej. cuidado → facial / corporal)
                                    if (!activeGroup) {
                                        show = true; // "Todos" en nivel 2: muestra toda la categoría
                                    } else {
                                        show = (group === activeGroup) &&
                                            (!activeSubcat || sub === activeSubcat);
                                    }
                                } else {
                                    // Categoría sin grupos (belleza, perfumes, cabello)
                                    show = !activeSubcat || sub === activeSubcat;
                                }
                            }

                            card.style.display = show ? '' : 'none';
                            if (show) visible++;
                        });

                        // ── Actualizar encabezado de sección ──
                        var meta = SECTION_META[activeCat];
                        var subs = SUBCATS[activeCat] || [];
                        var groupObj = activeGroup
                            ? subs.find(function (s) { return s.key === activeGroup; })
                            : null;
                        var subObj = null;
                        if (activeSubcat) {
                            var pool = (groupObj && groupObj.subs) ? groupObj.subs : subs;
                            subObj = pool.find(function (s) { return s.key === activeSubcat; }) || null;
                        }

                        var title = subObj ? subObj.label
                            : groupObj ? groupObj.label
                                : meta.title;

                        document.getElementById('section-label').textContent = meta.label;
                        document.getElementById('section-title').textContent = title;
                        document.getElementById('product-count').textContent =
                            visible + ' producto' + (visible !== 1 ? 's' : '');
                    }

                    // Devuelve true si la categoría usa grupos anidados
                    function isCatGrouped(cat) {
                        var subs = SUBCATS[cat] || [];
                        return subs.length > 0 && subs[0].subs !== undefined;
                    }

                    // ══════════════════════════════════════════════════════════
                    //  RENDERIZADO DE CHIPS — NIVEL 2
                    // ══════════════════════════════════════════════════════════
                    function renderSubcats(cat) {
                        var row = document.getElementById('subcat-row');
                        var divider = document.getElementById('subcat-divider');
                        var subs = SUBCATS[cat] || [];

                        // Siempre ocultar nivel 3 al cambiar categoría
                        hideSubsubcats();

                        if (subs.length === 0) {
                            row.style.display = 'none';
                            divider.style.display = 'none';
                            row.innerHTML = '';
                            return;
                        }

                        divider.style.display = 'block';
                        row.style.display = 'flex';

                        var grouped = isCatGrouped(cat);

                        row.innerHTML = '<button class="subcat-chip active" data-sub="all-sub">Todos</button>' +
                            subs.map(function (s) {
                                return '<button class="subcat-chip" data-sub="' + s.key + '">' + s.label + '</button>';
                            }).join('');

                        row.querySelectorAll('.subcat-chip').forEach(function (chip) {
                            chip.addEventListener('click', function () {
                                row.querySelectorAll('.subcat-chip').forEach(function (c) {
                                    c.classList.remove('active');
                                });
                                chip.classList.add('active');

                                var subKey = chip.getAttribute('data-sub');

                                if (subKey === 'all-sub') {
                                    // "Todos" → reset grupo y subcat, ocultar nivel 3
                                    activeGroup = null;
                                    activeSubcat = null;
                                    hideSubsubcats();
                                } else if (grouped) {
                                    // Chip de GRUPO → mostrar nivel 3 con sus sub-subcats
                                    activeGroup = subKey;
                                    activeSubcat = null;
                                    var groupObj = subs.find(function (s) { return s.key === subKey; });
                                    if (groupObj && groupObj.subs && groupObj.subs.length > 0) {
                                        renderSubsubcats(groupObj.subs);
                                    } else {
                                        hideSubsubcats();
                                    }
                                } else {
                                    // Chip de SUBCATEGORÍA directa (no hay nivel 3)
                                    activeGroup = null;
                                    activeSubcat = subKey;
                                    hideSubsubcats();
                                }

                                filterProducts();
                            });
                        });
                    }

                    // ══════════════════════════════════════════════════════════
                    //  RENDERIZADO DE CHIPS — NIVEL 3
                    // ══════════════════════════════════════════════════════════
                    function renderSubsubcats(subs) {
                        var subRow = document.getElementById('subsubcat-row');
                        var subDivider = document.getElementById('subsubcat-divider');

                        subDivider.style.display = 'block';
                        subRow.style.display = 'flex';

                        subRow.innerHTML = '<button class="subcat-chip active" data-subsub="all-subsub">Todos</button>' +
                            subs.map(function (s) {
                                return '<button class="subcat-chip" data-subsub="' + s.key + '">' + s.label + '</button>';
                            }).join('');

                        subRow.querySelectorAll('.subcat-chip').forEach(function (chip) {
                            chip.addEventListener('click', function () {
                                subRow.querySelectorAll('.subcat-chip').forEach(function (c) {
                                    c.classList.remove('active');
                                });
                                chip.classList.add('active');
                                var subsubKey = chip.getAttribute('data-subsub');
                                activeSubcat = subsubKey === 'all-subsub' ? null : subsubKey;
                                filterProducts();
                            });
                        });
                    }

                    function hideSubsubcats() {
                        var subRow = document.getElementById('subsubcat-row');
                        var subDivider = document.getElementById('subsubcat-divider');
                        subRow.style.display = 'none';
                        subDivider.style.display = 'none';
                        subRow.innerHTML = '';
                        activeSubcat = null;
                    }

                    // ══════════════════════════════════════════════════════════
                    //  EVENTOS — CHIPS DE CATEGORÍA PRINCIPAL (nivel 1)
                    // ══════════════════════════════════════════════════════════
                    document.querySelectorAll('.cat-chip').forEach(function (chip) {
                        chip.addEventListener('click', function () {
                            document.querySelectorAll('.cat-chip').forEach(function (c) {
                                c.classList.remove('active');
                            });
                            chip.classList.add('active');
                            activeCat = chip.getAttribute('data-cat');
                            activeGroup = null;    // siempre resetear grupo al cambiar cat
                            // activeSubcat se resetea dentro de renderSubcats/hideSubsubcats
                            updateHero(chip);
                            renderSubcats(activeCat);
                            filterProducts();
                        });
                    });

                    // ══════════════════════════════════════════════════════════
                    //  FAVORITOS (localStorage — migrar a servlet cuando esté listo)
                    // ══════════════════════════════════════════════════════════
                    var FAV_KEY = 'quiddity_favs';

                    function getFavs() { return JSON.parse(localStorage.getItem(FAV_KEY) || '[]'); }
                    function saveFavs(arr) { localStorage.setItem(FAV_KEY, JSON.stringify(arr)); }

                    function toggleFav(btn) {
                        var id = parseInt(btn.getAttribute('data-id'));
                        var favs = getFavs();
                        var idx = favs.indexOf(id);

                        if (idx === -1) {
                            favs.push(id);
                            btn.classList.add('active');
                            btn.classList.remove('pop');
                            void btn.offsetWidth;
                            btn.classList.add('pop');
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
                        if (count > 0) {
                            badge.textContent = count;
                            badge.style.display = 'flex';
                        } else {
                            badge.style.display = 'none';
                        }
                    }

                    // ── Restaurar favoritos al cargar ──
                    document.addEventListener('DOMContentLoaded', function () {
                        var favs = getFavs();
                        document.querySelectorAll('.btn-fav').forEach(function (btn) {
                            if (favs.includes(parseInt(btn.getAttribute('data-id')))) {
                                btn.classList.add('active');
                            }
                        });
                        updateFavBadge();
                        filterProducts();
                    });

                    // ══════════════════════════════════════════════════════════
                    //  HERO: actualizar video y texto al cambiar categoría
                    // ══════════════════════════════════════════════════════════
                    function updateHero(btn) {
                        var videoSrc = btn.getAttribute('data-hero-video');
                        var label = btn.getAttribute('data-hero-label');
                        var title = btn.getAttribute('data-hero-title');
                        var sub = btn.getAttribute('data-hero-sub');

                        if (videoSrc) {
                            var video = document.getElementById('hero-video');
                            var source = document.getElementById('hero-video-src');
                            source.setAttribute('src', videoSrc);
                            video.load();
                            video.play();
                        }
                        var wrapper = document.getElementById('hero-text-wrapper');
                        if (wrapper) {
                            wrapper.style.opacity = '0';
                            setTimeout(function () {
                                document.getElementById('hero-label').textContent = label || '';
                                document.getElementById('hero-title').textContent = title || '';
                                document.getElementById('hero-subtitle').textContent = sub || '';
                                wrapper.style.opacity = '1';
                            }, 280);
                        }
                    }

                    // ── Announcement bar ──
                    function closeAnnouncementBar() {
                        document.getElementById('announcement-bar').style.display = 'none';
                        document.getElementById('main-header').style.top = '0px';
                        document.querySelectorAll('.sticky').forEach(function (el) {
                            el.style.top = '72px';
                        });
                    }

                    // ── Scroll header compacto ──
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

                    // ── Agregar al carrito (demo — conectar con servlet /carrito/agregar) ──
                    function agregarAlCarrito(id) {
                        console.log('Producto ' + id + ' → carrito');
                    }
                </script>
            </body>

            </html>