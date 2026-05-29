<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html class="light" lang="es">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>QUIDDITY | Catálogo — Explorar</title>
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
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

        /* ── Mini Hero ── */
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

        #hero-video.fade-out { opacity: 0; }
        #hero-video.fade-in  { opacity: 1; }

        #hero-text-wrapper {
            transition: opacity 0.3s ease;
        }

        /* ── Category chips ── */
        .cat-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 22px;
            border: 1.5px solid rgba(154,58,90,0.25);
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
        .cat-chip:hover  { border-color: #9a3a5a; color: #9a3a5a; }
        .cat-chip.active { background: #9a3a5a; border-color: #9a3a5a; color: white; }

        /* ── Subcat chips ── */
        .subcat-chip {
            display: inline-flex;
            align-items: center;
            padding: 7px 16px;
            border: 1px solid rgba(135,114,118,0.25);
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
        .subcat-chip:hover  { border-color: #9a3a5a; color: #9a3a5a; }
        .subcat-chip.active { background: #f1ecef; border-color: #9a3a5a; color: #9a3a5a; }

        .chips-scroll { display: flex; gap: 10px; overflow-x: auto; scrollbar-width: none; padding-bottom: 4px; }
        .chips-scroll::-webkit-scrollbar { display: none; }

        /* ── Product cards ── */
        .product-card { opacity: 1; }

        /* ── CTA Banner ── */
        #guest-cta { background: linear-gradient(135deg, #9a3a5a 0%, #88495a 60%, #516617 100%); }
    </style>
</head>

<body class="bg-white font-body-md text-on-surface selection:bg-primary/10">

    <!-- ANNOUNCEMENT BAR -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
            NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
        </p>
        <button onclick="closeAnnouncementBar()" class="absolute right-6 text-white/60 hover:text-white transition-colors">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
    </div>

    <!-- TOP APP BAR -->
    <header id="main-header"
        class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
        style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp">
                <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1>
            </a>
            <nav class="hidden md:flex gap-8">
                <a class="font-label-md text-label-md uppercase text-primary border-b border-primary pb-0.5" href="<%= ctx %>/catalogo.jsp">Shop</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Our Story</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Apothecary</a>
                <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Journal</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <button class="text-on-surface hover:text-primary transition-colors">
                <span class="material-symbols-outlined">search</span>
            </button>
            <button class="text-on-surface hover:text-primary transition-colors">
                <span class="material-symbols-outlined">favorite</span>
            </button>
            <div class="w-px h-5 bg-outline/20"></div>
            <a href="<%= ctx %>/login.jsp" class="font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary transition-colors">Login</a>
            <a href="<%= ctx %>/registro.jsp" class="font-label-md text-label-md uppercase tracking-widest px-6 py-2.5 bg-primary text-white hover:bg-tertiary transition-all duration-300 active:scale-95">Registro</a>
        </div>
    </header>

    <main style="padding-top: 42px;">

        <!-- MINI HERO CON VIDEO -->
        <section id="catalog-hero" aria-label="Catálogo hero">
            <video id="hero-video" autoplay muted loop playsinline class="fade-in">
                <source id="hero-video-src" src="<%= ctx %>/uploads/videos/mixed/4.mp4" type="video/mp4">
            </video>
            <div class="absolute inset-0" style="background: linear-gradient(to right, rgba(15,10,12,0.60) 0%, rgba(15,10,12,0.25) 55%, rgba(15,10,12,0.05) 100%);"></div>
            <div class="relative z-10 h-full flex flex-col justify-end pb-14 px-container-margin">
                <div id="hero-text-wrapper">
                    <span id="hero-label" class="block font-label-md text-[10px] tracking-[0.35em] text-white/70 uppercase mb-4">
                        Explora nuestra selección
                    </span>
                    <h2 id="hero-title" class="font-display-lg text-white italic mb-3 leading-tight" style="font-size:clamp(32px,4vw,56px);">
                        Todo el Catálogo
                    </h2>
                    <p id="hero-subtitle" class="font-body-md text-white/60 text-sm max-w-sm tracking-wide">
                        Descubre nuestra gama completa de productos botánicos para tu cuidado.
                    </p>
                </div>
            </div>
        </section>

        <!-- CATEGORY CHIPS -->
        <div class="sticky z-40 bg-white border-b border-on-surface/5 shadow-sm" style="top: calc(42px + 72px);">
            <div class="max-w-[1440px] mx-auto px-container-margin">
                <div class="chips-scroll py-5 gap-3">

                    <button class="cat-chip active" data-cat="all"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/4.mp4"
                        data-hero-label="Explora nuestra selección"
                        data-hero-title="Todo el Catálogo"
                        data-hero-sub="Descubre nuestra gama completa de productos botánicos para tu cuidado.">
                        <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span>
                        Todo
                    </button>

                    <button class="cat-chip" data-cat="belleza"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/3.mp4"
                        data-hero-label="Colección Belleza"
                        data-hero-title="Belleza & Maquillaje"
                        data-hero-sub="Herramientas y cosméticos que realzan tu belleza natural con formulaciones puras.">
                        <span class="material-symbols-outlined" style="font-size:14px;">face_retouching_natural</span>
                        Belleza
                    </button>

                    <button class="cat-chip" data-cat="cuidado"
                        data-hero-video="<%= ctx %>/uploads/videos/mixed/2.mp4"
                        data-hero-label="Ritual de Cuidado"
                        data-hero-title="Cuidado de la Piel"
                        data-hero-sub="Skincare botánico clínicamente comprobado para una piel radiante y saludable.">
                        <span class="material-symbols-outlined" style="font-size:14px;">spa</span>
                        Cuidado de la Piel
                    </button>

                </div>
                <div id="subcat-row" class="chips-scroll pb-4 gap-2" style="display:none;"></div>
            </div>
        </div>

        <!-- SECTION HEADER -->
        <section class="max-w-[1440px] mx-auto px-container-margin pt-16 pb-6">
            <div class="flex justify-between items-end">
                <div>
                    <span id="section-label" class="font-label-md text-label-md text-primary uppercase tracking-[0.2em] mb-3 block">Todos los productos</span>
                    <h3 class="font-headline-lg text-headline-lg" id="section-title">Catálogo</h3>
                </div>
                <div class="hidden md:flex items-center gap-3 border border-outline/20 px-5 py-3 bg-surface-variant/50">
                    <span class="material-symbols-outlined text-primary" style="font-size:18px;">lock</span>
                    <p class="font-label-md text-[11px] text-on-surface-variant uppercase tracking-widest">Inicia sesión para ver todo &amp; comprar</p>
                    <a href="<%= ctx %>/login.jsp" class="font-label-md text-[11px] uppercase tracking-widest text-primary hover:underline ml-2">Login →</a>
                </div>
            </div>
        </section>

        <!-- PRODUCT GRID -->
        <section class="max-w-[1440px] mx-auto px-container-margin pb-section-gap">
            <div id="product-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-gutter">

                <!-- BELLEZA — Brochas -->
                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="brochas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Set de Brochas Profesional" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/productoM/brochas/brochasSet.jpg" />
                        <span class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1 text-on-surface">Nuevo</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Brochas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Set Profesional</h4>
                            <p class="font-body-md text-primary text-sm">$78.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="brochas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Brocha Kabuki" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/productoM/brochas/KabukiPowder.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Brochas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Kabuki Powder</h4>
                            <p class="font-body-md text-primary text-sm">$32.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <!-- BELLEZA — Esponjas -->
                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="esponjas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Beauty Blender Botanical" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/productoM/esponjas/blender.jpg" />
                        <span class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best Seller</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Esponjas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Botanical Blender</h4>
                            <p class="font-body-md text-primary text-sm">$24.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="esponjas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Set Esponjas" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/productoM/esponjas/set.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Esponjas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Set Precision</h4>
                            <p class="font-body-md text-primary text-sm">$38.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <!-- BELLEZA — Maquillaje -->
                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="maquillaje">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Base Botánica" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/makeUp/base/base.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Maquillaje</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Base Botánica SPF</h4>
                            <p class="font-body-md text-primary text-sm">$89.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="belleza" data-subcat="maquillaje">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Paleta Tierra" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/belleza/makeUp/sombras/paletaTierra1.jpg" />
                        <span class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1 text-on-surface">Nuevo</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Maquillaje</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Paleta Tierra</h4>
                            <p class="font-body-md text-primary text-sm">$112.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <!-- CUIDADO — Mascarillas -->
                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="mascarillas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Mascarilla de Arcilla Rosa" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/pink1.jpg" />
                        <span class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best Seller</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Mascarillas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Rose Clay Mask</h4>
                            <p class="font-body-md text-primary text-sm">$64.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="mascarillas">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Mascarilla Vitamina C" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/VitaminC.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Mascarillas</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Vitamin C Glow</h4>
                            <p class="font-body-md text-primary text-sm">$58.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <!-- CUIDADO — Serums -->
                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="serums">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Radiance Elixir Serum" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/gold.jpg" />
                        <span class="absolute top-3 left-3 bg-primary text-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1">Best Seller</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Serums</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Radiance Elixir</h4>
                            <p class="font-body-md text-primary text-sm">$84.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="serums">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Midnight Recovery Oil" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/Midnight.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Serums</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Midnight Recovery</h4>
                            <p class="font-body-md text-primary text-sm">$95.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <!-- CUIDADO — Hidratantes -->
                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="hidratantes">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Velvet Cloud Cream" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/cream.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Hidratantes</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Velvet Cloud Cream</h4>
                            <p class="font-body-md text-primary text-sm">$62.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

                <div class="product-card group cursor-pointer" data-cat="cuidado" data-subcat="hidratantes">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-5 relative">
                        <img alt="Crema Regeneradora Nocturna" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/cremas/night.jpg" />
                        <span class="absolute top-3 left-3 bg-white font-label-md text-[9px] tracking-[0.2em] uppercase px-3 py-1 text-on-surface">Nuevo</span>
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-1">Hidratantes</p>
                            <h4 class="font-headline-md text-[18px] leading-tight mb-2 group-hover:text-primary transition-colors">Night Repair Cream</h4>
                            <p class="font-body-md text-primary text-sm">$74.000</p>
                        </div>
                        <button onclick="openLoginPrompt()" class="w-9 h-9 rounded-full border border-outline/20 flex items-center justify-center hover:bg-primary hover:text-white transition-all mt-1">
                            <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        </button>
                    </div>
                </div>

            </div><!-- /product-grid -->

            <!-- LOCKED overlay -->
            <div id="lock-cta" class="relative overflow-hidden" style="height: 220px; margin-top: -120px;">
                <div class="absolute inset-0" style="background: linear-gradient(to top, rgba(255,255,255,1) 0%, rgba(255,255,255,0.85) 55%, rgba(255,255,255,0) 100%);"></div>
                <div class="absolute bottom-0 inset-x-0 flex flex-col items-center pb-8 gap-4">
                    <div class="flex items-center gap-2 text-on-surface-variant">
                        <span class="material-symbols-outlined text-primary">lock</span>
                        <p class="font-label-md text-[11px] uppercase tracking-[0.2em]">Inicia sesión para ver el catálogo completo</p>
                    </div>
                    <div class="flex gap-4">
                        <a href="<%= ctx %>/login.jsp" class="bg-primary text-white font-label-md text-label-md px-10 py-4 uppercase tracking-widest hover:bg-tertiary transition-all active:scale-95">Iniciar Sesión</a>
                        <a href="<%= ctx %>/registro.jsp" class="border border-on-surface text-on-surface font-label-md text-label-md px-10 py-4 uppercase tracking-widest hover:border-primary hover:text-primary transition-all active:scale-95">Registrarse</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- GUEST CTA BANNER -->
        <section id="guest-cta" class="py-20 px-container-margin text-center">
            <span class="font-label-md text-[10px] tracking-[0.4em] text-white/60 uppercase mb-6 block">Únete a Quiddity</span>
            <h2 class="font-display-lg text-white italic mb-6 leading-tight" style="font-size: clamp(28px,4vw,52px);">Accede a beneficios exclusivos</h2>
            <p class="font-body-md text-white/60 max-w-lg mx-auto mb-10 text-sm">Miembros registrados disfrutan de descuentos personalizados, acceso anticipado a nuevas colecciones, consultas con expertos y mucho más.</p>
            <div class="flex flex-wrap justify-center gap-4 mb-14">
                <div class="flex items-center gap-2 text-white/80"><span class="material-symbols-outlined" style="font-size:16px;">discount</span><span class="font-label-md text-[11px] uppercase tracking-widest">Descuentos exclusivos</span></div>
                <div class="w-px h-4 bg-white/20 self-center hidden md:block"></div>
                <div class="flex items-center gap-2 text-white/80"><span class="material-symbols-outlined" style="font-size:16px;">new_releases</span><span class="font-label-md text-[11px] uppercase tracking-widest">Acceso anticipado</span></div>
                <div class="w-px h-4 bg-white/20 self-center hidden md:block"></div>
                <div class="flex items-center gap-2 text-white/80"><span class="material-symbols-outlined" style="font-size:16px;">spa</span><span class="font-label-md text-[11px] uppercase tracking-widest">Consultas personalizadas</span></div>
                <div class="w-px h-4 bg-white/20 self-center hidden md:block"></div>
                <div class="flex items-center gap-2 text-white/80"><span class="material-symbols-outlined" style="font-size:16px;">local_shipping</span><span class="font-label-md text-[11px] uppercase tracking-widest">Envío gratis prioritario</span></div>
            </div>
            <div class="flex flex-wrap justify-center gap-4">
                <a href="<%= ctx %>/registro.jsp" class="bg-white text-primary font-label-md text-label-md px-12 py-5 uppercase tracking-widest hover:bg-surface-variant transition-all active:scale-95">Crear cuenta gratis</a>
                <a href="<%= ctx %>/login.jsp" class="border border-white/50 text-white font-label-md text-label-md px-12 py-5 uppercase tracking-widest hover:border-white hover:bg-white/10 transition-all active:scale-95">Ya tengo cuenta</a>
            </div>
        </section>

    </main>

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
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">IN</i></a>
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">FB</i></a>
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all" href="#"><i class="text-sm font-bold not-italic">PT</i></a>
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

    <!-- LOGIN MODAL -->
    <div id="login-modal" class="fixed inset-0 z-[100] hidden items-center justify-center" style="background: rgba(28,27,29,0.55); backdrop-filter: blur(4px);">
        <div class="bg-white max-w-md w-full mx-4 p-12 relative">
            <button onclick="closeLoginPrompt()" class="absolute top-5 right-5 text-on-surface-variant hover:text-on-surface transition-colors">
                <span class="material-symbols-outlined">close</span>
            </button>
            <span class="block font-label-md text-[10px] tracking-[0.35em] text-primary uppercase mb-6">Acceso requerido</span>
            <h3 class="font-display-lg text-headline-md italic text-on-surface mb-4 leading-tight">Crea tu cuenta para comprar</h3>
            <p class="font-body-md text-sm text-on-surface-variant mb-8 leading-relaxed">Los invitados pueden explorar nuestro catálogo, pero para añadir productos al carrito, guardar favoritos y disfrutar de ofertas exclusivas, necesitas una cuenta gratuita.</p>
            <div class="flex flex-col gap-3">
                <a href="<%= ctx %>/registro.jsp" class="w-full bg-primary text-white font-label-md text-label-md py-4 uppercase tracking-widest hover:bg-tertiary transition-all text-center active:scale-95">Crear cuenta gratis</a>
                <a href="<%= ctx %>/login.jsp" class="w-full border border-on-surface text-on-surface font-label-md text-label-md py-4 uppercase tracking-widest hover:border-primary hover:text-primary transition-all text-center active:scale-95">Ya tengo cuenta — Login</a>
            </div>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script>
        /* ── Announcement bar ── */
        function closeAnnouncementBar() {
            document.getElementById('announcement-bar').style.display = 'none';
            document.getElementById('main-header').style.top = '0px';
            document.querySelectorAll('.sticky').forEach(function(el) { el.style.top = '72px'; });
        }

        /* ── Shrink header on scroll ── */
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

        /* ── Modal ── */
        function openLoginPrompt() {
            document.getElementById('login-modal').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
        function closeLoginPrompt() {
            document.getElementById('login-modal').style.display = 'none';
            document.body.style.overflow = '';
        }
        document.getElementById('login-modal').addEventListener('click', function(e) {
            if (e.target === this) closeLoginPrompt();
        });

        /* ── State ── */
        var activeCat    = 'all';
        var activeSubcat = null;

        var SUBCATS = {
            'all':     [],
            'belleza': [
                { key: 'brochas',    label: 'Brochas' },
                { key: 'esponjas',   label: 'Esponjas' },
                { key: 'maquillaje', label: 'Maquillaje' }
            ],
            'cuidado': [
                { key: 'mascarillas', label: 'Mascarillas' },
                { key: 'serums',      label: 'Serums' },
                { key: 'hidratantes', label: 'Hidratantes' }
            ]
        };

        var SECTION_META = {
            'all':     { label: 'Todos los productos', title: 'Catálogo' },
            'belleza': { label: 'Colección Belleza',   title: 'Belleza & Maquillaje' },
            'cuidado': { label: 'Ritual de Cuidado',   title: 'Cuidado de la Piel' }
        };

        /* ── Filter ── */
        function filterProducts() {
            document.querySelectorAll('.product-card').forEach(function(card) {
                var cat = card.getAttribute('data-cat');
                var sub = card.getAttribute('data-subcat');
                var show = false;
                if (activeCat === 'all') {
                    show = true;
                } else if (cat === activeCat) {
                    show = !activeSubcat || sub === activeSubcat;
                }
                card.style.display = show ? '' : 'none';
            });
            var meta = SECTION_META[activeCat];
            document.getElementById('section-label').textContent = meta.label;
            var subObj = activeSubcat && SUBCATS[activeCat]
                ? SUBCATS[activeCat].find(function(s) { return s.key === activeSubcat; })
                : null;
            document.getElementById('section-title').textContent = subObj ? subObj.label : meta.title;
        }

        /* ── Hero video + texto ── */
        function updateHero(btn) {
            var videoSrc = btn.getAttribute('data-hero-video');
            var label    = btn.getAttribute('data-hero-label');
            var title    = btn.getAttribute('data-hero-title');
            var sub      = btn.getAttribute('data-hero-sub');

            /* cambiar video */
            if (videoSrc) {
                var video  = document.getElementById('hero-video');
                var source = document.getElementById('hero-video-src');
                source.setAttribute('src', videoSrc);
                video.load();
                video.play();
            }

            /* fade texto */
            var wrapper = document.getElementById('hero-text-wrapper');
            if (!wrapper) return;
            wrapper.style.opacity = '0';
            setTimeout(function() {
                var el1 = document.getElementById('hero-label');
                var el2 = document.getElementById('hero-title');
                var el3 = document.getElementById('hero-subtitle');
                if (el1) el1.textContent = label || '';
                if (el2) el2.textContent = title || '';
                if (el3) el3.textContent = sub   || '';
                wrapper.style.opacity = '1';
            }, 280);
        }

        /* ── Subcategorías ── */
        function renderSubcats(cat) {
            var row  = document.getElementById('subcat-row');
            var subs = SUBCATS[cat] || [];
            if (subs.length === 0) {
                row.style.display = 'none';
                row.innerHTML = '';
                return;
            }
            row.style.display = 'flex';
            row.innerHTML = '<button class="subcat-chip active" data-sub="all-sub">Todos</button>'
                + subs.map(function(s) {
                    return '<button class="subcat-chip" data-sub="' + s.key + '">' + s.label + '</button>';
                }).join('');
            row.querySelectorAll('.subcat-chip').forEach(function(chip) {
                chip.addEventListener('click', function() {
                    row.querySelectorAll('.subcat-chip').forEach(function(c) { c.classList.remove('active'); });
                    chip.classList.add('active');
                    activeSubcat = chip.getAttribute('data-sub') === 'all-sub' ? null : chip.getAttribute('data-sub');
                    filterProducts();
                });
            });
        }

        /* ── Chips principales ── */
        document.querySelectorAll('.cat-chip').forEach(function(chip) {
            chip.addEventListener('click', function() {
                document.querySelectorAll('.cat-chip').forEach(function(c) { c.classList.remove('active'); });
                chip.classList.add('active');
                activeCat    = chip.getAttribute('data-cat');
                activeSubcat = null;
                updateHero(chip);
                renderSubcats(activeCat);
                filterProducts();
            });
        });
    </script>

</body>
</html>
