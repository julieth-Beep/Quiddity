<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.dao.UsuarioDAO" %>
<% 
    Usuario currentUser = (Usuario) session.getAttribute("usuario");
    boolean isLoggedIn = (currentUser != null);
    boolean isComprador = isLoggedIn && currentUser.getIdRol() == UsuarioDAO.ROL_COMPRADOR;
    boolean isUsuario   = isLoggedIn && currentUser.getIdRol() == UsuarioDAO.ROL_USUARIO;
    boolean isAdmin     = isLoggedIn && currentUser.getIdRol() == UsuarioDAO.ROL_ADMIN; 
%>
<% String ctx=request.getContextPath(); %>
<!DOCTYPE html>
<html class="light" lang="es">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>QUIDDITY | Botanical Essence for Your Soul</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
    <link
        href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&family=Manrope:wght@200..800&display=swap"
        rel="stylesheet" />
    <!-- Material Symbols -->
    <link
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />
    <!-- Tailwind CSS -->
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
                    borderRadius: {
                        DEFAULT: "0px",
                        lg: "0px",
                        xl: "0px",
                        full: "9999px"
                    },
                    spacing: {
                        "container-margin": "80px",
                        "element-gap": "24px",
                        "gutter": "32px",
                        "section-gap": "120px"
                    },
                    fontFamily: {
                        "headline-md": ["EB Garamond"],
                        "display-lg": ["EB Garamond"],
                        "headline-lg-mobile": ["EB Garamond"],
                        "body-lg": ["Manrope"],
                        "headline-lg": ["EB Garamond"],
                        "body-md": ["Manrope"],
                        "label-md": ["Manrope"]
                    },
                    fontSize: {
                        "headline-md": ["32px", { lineHeight: "40px", fontWeight: "400" }],
                        "display-lg": ["64px", { lineHeight: "72px", letterSpacing: "-0.01em", fontWeight: "400" }],
                        "headline-lg-mobile": ["32px", { lineHeight: "40px", fontWeight: "400" }],
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

        .glass-effect {
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
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

        /* ── Announcement bar ── */
        #announcement-bar {
            background-color: #c4a9a2;
            height: 42px;
        }

        #announcement-bar.hidden-bar {
            display: none;
        }

        /* ── Hero carousel ── */
        #hero-carousel {
            position: relative;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }

        .hero-slide {
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity 0.9s cubic-bezier(0.4, 0, 0.2, 1);
            pointer-events: none;
        }

        .hero-slide.active {
            opacity: 1;
            pointer-events: auto;
        }

        .hero-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        /* left-side tint so text is always readable */
        .hero-slide::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to right,
                    rgba(15, 10, 12, 0.52) 0%,
                    rgba(15, 10, 12, 0.18) 55%,
                    rgba(15, 10, 12, 0.00) 100%);
        }

        /* text content floats above overlay */
        .hero-content {
            position: absolute;
            inset: 0;
            z-index: 10;
            display: flex;
            align-items: center;
            padding-left: 80px;
            padding-right: 80px;
        }

        /* slide-in animation for text when slide becomes active */
        .hero-slide .slide-text {
            transform: translateY(22px);
            opacity: 0;
            transition: transform 0.85s cubic-bezier(0.22, 1, 0.36, 1) 0.25s,
                opacity 0.85s cubic-bezier(0.22, 1, 0.36, 1) 0.25s;
        }

        .hero-slide.active .slide-text {
            transform: translateY(0);
            opacity: 1;
        }

        /* ── Nav arrows ── */
        .hero-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 20;
            width: 52px;
            height: 52px;
            border: 1.5px solid rgba(255, 255, 255, 0.55);
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(8px);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.2s, border-color 0.2s;
            border-radius: 9999px;
        }

        .hero-arrow:hover {
            background: rgba(255, 255, 255, 0.22);
            border-color: rgba(255, 255, 255, 0.9);
        }

        #hero-prev {
            right: 76px;
        }

        #hero-next {
            right: 16px;
        }

        /* ── Progress dots ── */
        #hero-dots {
            position: absolute;
            bottom: 36px;
            left: 80px;
            z-index: 20;
            display: flex;
            gap: 8px;
        }

        .hero-dot {
            width: 28px;
            height: 2px;
            background: rgba(255, 255, 255, 0.35);
            cursor: pointer;
            transition: background 0.3s, width 0.3s;
        }

        .hero-dot.active {
            background: #ffffff;
            width: 52px;
        }

        /* ── Progress bar (auto-advance timer) ── */
        #hero-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 2px;
            background: #9a3a5a;
            z-index: 20;
            width: 0%;
            transition: none;
        }

        #hero-progress.animating {
            transition: width 6s linear;
            width: 100%;
        }
    </style>
</head>

<body class="bg-white font-body-md text-on-surface selection:bg-primary/10">

    <!-- ═══════════════════════════════════════════
     ANNOUNCEMENT BAR
═══════════════════════════════════════════ -->
    <div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
        <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
            NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
        </p>
        <button onclick="closeAnnouncementBar()"
            class="absolute right-6 text-white/60 hover:text-white transition-colors">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
    </div>

    <!-- ═══════════════════════════════════════════
     TOP APP BAR
═══════════════════════════════════════════ -->
    <header id="main-header"
        class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300"
        style="top: 42px;">
        <div class="flex items-center gap-12">
            <a href="<%= ctx %>/index.jsp">
                <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">
                    Quiddity</h1>
            </a>
            <nav class="hidden md:flex gap-8">
                <%-- Si está logueado como comprador o usuario, el enlace "Shop" va al catálogo completo
                    --%>
                    <% String shopLink=(isComprador || isUsuario) ? ctx + "/catalogo" :
                        ctx + "/catalogo.jsp" ; %>
                            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                href="<%= shopLink %>">Shop</a>
                            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                href="#nuestra-historia">Nuestra historia</a>
                            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                href="#apothecary">Apothecary</a>
                            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors"
                                href="#offerings">Blog</a>
            </nav>
        </div>
        <div class="flex items-center gap-6">
            <% if (!isLoggedIn) { %>
                <!-- Usuario no logueado: muestra Login y Registro -->
                <div class="w-px h-5 bg-outline/20"></div>
                <a href="<%= ctx %>/login.jsp"
                    class="font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary transition-colors">Login</a>
                <a href="<%= ctx %>/registro.jsp"
                    class="font-label-md text-label-md uppercase tracking-widest px-6 py-2.5 bg-primary text-white hover:bg-tertiary transition-all duration-300 active:scale-95">Registro</a>
            <% } else { %>
                <!-- Usuario logueado: menú de cuenta con click -->
                <div class="w-px h-5 bg-outline/20"></div>
                <div class="relative" id="user-menu-container">
                    <button id="user-menu-btn"
                        class="flex items-center gap-2 font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary transition-colors">
                        <%= currentUser.getNombre() %>
                        <span id="user-menu-icon" class="material-symbols-outlined text-sm transition-transform duration-200">expand_more</span>
                    </button>
                    <div id="user-menu-dropdown"
                        class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden z-50 rounded-md">
                        <% if (isAdmin) { %>
                            <a href="<%= ctx %>/admin/dashboard"
                                class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                        <% } else if (isUsuario) { %>
                            <a href="<%= ctx %>/usuario/dashboard"
                                class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                        <% } else { %>
                            <a href="<%= ctx %>/comprador/perfil.jsp"
                                class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                        <% } %>
                        <a href="<%= ctx %>/pedidos"
                            class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Pedidos</a>
                        <a href="<%= ctx %>/carrito"
                            class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Carrito</a>
                        <div class="border-t my-1"></div>
                        <a href="<%= ctx %>/logout"
                            class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
                    </div>
                </div>
            <% } %>
        </div>
    </header>

    <main>

        <!-- ═══════════════════════════════════════════
     HERO — DYNAMIC CAROUSEL
     Imágenes en: webapp/uploads/catalogo/
     Cambia los nombres de archivo según los tuyos.
═══════════════════════════════════════════ -->
        <section id="hero-carousel" aria-label="Hero carousel">

            <!-- ── SLIDE 1 ── -->
            <div class="hero-slide active" data-index="0">
                <img src="<%= ctx %>/uploads/catalogo/heroSection/card1.png"
                    alt="Nueva Colección Quiddity" />
                <div class="hero-content">
                    <div class="slide-text max-w-xl">
                        <span class="block font-label-md text-[11px] tracking-[0.35em] text-white/80 uppercase mb-5
                             border border-white/30 inline-flex px-4 py-1.5 backdrop-blur-sm bg-white/10">
                            NUEVA COLECCIÓN
                        </span>
                        <h2 class="font-display-lg text-white mb-5 leading-[1.08] italic"
                            style="font-size:clamp(40px,5vw,68px);">
                            Botanical Essence<br />for Your Soul
                        </h2>
                        <p class="font-body-md text-white/70 mb-8 text-sm tracking-wide max-w-sm">
                            Fórmulas botánicas puras para una piel radiante.<br />
                            <em class="text-white/50 text-xs">*Resultados clínicamente comprobados en 4
                                semanas</em>
                        </p>
                        <button class="border border-white text-white font-label-md text-label-md px-10 py-4
                               uppercase tracking-widest hover:bg-white hover:text-on-surface
                               transition-all duration-300 active:scale-95">
                            Shop Now
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── SLIDE 2 ── -->
            <div class="hero-slide" data-index="1">
                <img src="<%= ctx %>/uploads/catalogo/heroSection/card2.jpg" alt="Velvet Cloud Cream" />
                <div class="hero-content">
                    <div class="slide-text max-w-xl">
                        <span class="block font-label-md text-[11px] tracking-[0.35em] text-white/80 uppercase mb-5
                             border border-white/30 inline-flex px-4 py-1.5 backdrop-blur-sm bg-white/10">
                            TRENDING
                        </span>
                        <h2 class="font-display-lg text-white mb-5 leading-[1.08] italic"
                            style="font-size:clamp(40px,5vw,68px);">
                            Velvet Cloud<br />Cream
                        </h2>
                        <p class="font-body-md text-white/70 mb-8 text-sm tracking-wide max-w-sm">
                            Hidratación profunda con extractos de rosas silvestres.<br />
                            <em class="text-white/50 text-xs">*100% mejora en textura después de 2
                                semanas</em>
                        </p>
                        <button class="border border-white text-white font-label-md text-label-md px-10 py-4
                               uppercase tracking-widest hover:bg-white hover:text-on-surface
                               transition-all duration-300 active:scale-95">
                            Shop Now
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── SLIDE 3 ── -->
            <div class="hero-slide" data-index="2">
                <img src="<%= ctx %>/uploads/catalogo/heroSection/card3.png"
                    alt="Midnight Recovery Oil" />
                <div class="hero-content">
                    <div class="slide-text max-w-xl">
                        <span class="block font-label-md text-[11px] tracking-[0.35em] text-white/80 uppercase mb-5
                             border border-white/30 inline-flex px-4 py-1.5 backdrop-blur-sm bg-white/10">
                            BEST SELLER
                        </span>
                        <h2 class="font-display-lg text-white mb-5 leading-[1.08] italic"
                            style="font-size:clamp(40px,5vw,68px);">
                            Midnight<br />Recovery Oil
                        </h2>
                        <p class="font-body-md text-white/70 mb-8 text-sm tracking-wide max-w-sm">
                            Regeneración nocturna con aceites esenciales certificados.<br />
                            <em class="text-white/50 text-xs">*Visible glow desde la primera
                                aplicación</em>
                        </p>
                        <button class="border border-white text-white font-label-md text-label-md px-10 py-4
                               uppercase tracking-widest hover:bg-white hover:text-on-surface
                               transition-all duration-300 active:scale-95">
                            Shop Now
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── Navigation arrows ── -->
            <button id="hero-prev" class="hero-arrow" aria-label="Slide anterior">
                <span class="material-symbols-outlined" style="font-size:20px;">arrow_back</span>
            </button>
            <button id="hero-next" class="hero-arrow" aria-label="Siguiente slide">
                <span class="material-symbols-outlined" style="font-size:20px;">arrow_forward</span>
            </button>

            <!-- ── Dots ── -->
            <div id="hero-dots" aria-hidden="true">
                <div class="hero-dot active" data-dot="0"></div>
                <div class="hero-dot" data-dot="1"></div>
                <div class="hero-dot" data-dot="2"></div>
            </div>

            <!-- ── Progress bar ── -->
            <div id="hero-progress"></div>
        </section>


        <!-- ═══════════════════════════════════════════
     MOST POPULAR CATALOG
═══════════════════════════════════════════ -->
        <section class="py-section-gap bg-white max-w-[1440px] mx-auto px-container-margin">
            <div class="mb-16 flex justify-between items-end">
                <div>
                    <span
                        class="font-label-md text-label-md text-primary uppercase tracking-[0.2em] mb-4 block">Curation</span>
                    <h3 class="font-headline-lg text-headline-lg">Most Popular</h3>
                </div>
                <button
                    class="group flex items-center gap-2 font-label-md text-label-md text-on-surface uppercase hover:text-primary transition-colors">
                    View All Products
                    <span
                        class="material-symbols-outlined text-sm group-hover:translate-x-1 transition-transform">arrow_forward</span>
                </button>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-gutter">

                <!-- Product Card 1 -->
                <div class="group cursor-pointer">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-6">
                        <img alt="Radiance Elixir"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                            src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/gold.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-2">
                                Serum
                            </p>
                            <h4
                                class="font-headline-md text-headline-md mb-2 group-hover:text-primary transition-colors">
                                Radiance Elixir</h4>
                            <p class="font-body-md text-primary">$84.00</p>
                        </div>
                        <button
                            class="w-10 h-10 rounded-full border border-outline/20 flex items-center justify-center hover:bg-on-surface hover:text-white transition-all">
                            <span class="material-symbols-outlined text-xl">add</span>
                        </button>
                    </div>
                </div>

                <!-- Product Card 2 -->
                <div class="group cursor-pointer">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-6">
                        <img alt="Velvet Cloud Cream"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuC4E25gmKmSsT4fgqf4blKyXp5mQi7rv2NBthU8AZ3RIgxp7wQiMBbVEF2y1CI3k5jRMhnNkxHC6osV7nO9LQnUSoZTFYGbqPwvmSm6TSiIMDV6gwZqdrIDRU-yV2GKWh2M-Pisrd_e6dOpZK6AUdgbZXUtLAS68xIYJHC9z54K5McGoa7ZIhQ0qlwjMfFPAgVsAIBV1rGy1yZQbdX2c-OW48dJrbvt06xShkez3HAChWvGCgHQlo2CoLwR6MKA_QHbClNNh-84tJMZ" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-2">
                                Moisturizer</p>
                            <h4
                                class="font-headline-md text-headline-md mb-2 group-hover:text-primary transition-colors">
                                Velvet Cloud Cream</h4>
                            <p class="font-body-md text-primary">$62.00</p>
                        </div>
                        <button
                            class="w-10 h-10 rounded-full border border-outline/20 flex items-center justify-center hover:bg-on-surface hover:text-white transition-all">
                            <span class="material-symbols-outlined text-xl">add</span>
                        </button>
                    </div>
                </div>

                <!-- Product Card 3 -->
                <div class="group cursor-pointer">
                    <div class="aspect-[4/5] overflow-hidden bg-surface-variant mb-6">
                        <img alt="Midnight Recovery"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000"
                            src="<%= ctx %>/uploads/catalogo/cuidado/skinCare/serum/Midnight.jpg" />
                    </div>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="font-label-md text-[10px] text-on-surface-variant uppercase mb-2">
                                Oil</p>
                            <h4
                                class="font-headline-md text-headline-md mb-2 group-hover:text-primary transition-colors">
                                Midnight Recovery</h4>
                            <p class="font-body-md text-primary">$95.00</p>
                        </div>
                        <button
                            class="w-10 h-10 rounded-full border border-outline/20 flex items-center justify-center hover:bg-on-surface hover:text-white transition-all">
                            <span class="material-symbols-outlined text-xl">add</span>
                        </button>
                    </div>
                </div>

            </div>
        </section>


        <!-- ═══════════════════════════════════════════
     ABOUT US - NUESTRA HISTORIA
═══════════════════════════════════════════ -->
        <section id="nuestra-historia" class="py-section-gap bg-white">
            <div
                class="max-w-[1440px] mx-auto px-container-margin grid grid-cols-1 md:grid-cols-2 gap-gutter items-center">
                <div class="pr-12">
                    <span
                        class="font-label-md text-label-md text-secondary uppercase tracking-[0.3em] mb-8 block">Our
                        Philosophy</span>
                    <h2
                        class="font-display-lg text-headline-lg md:text-display-lg text-on-surface mb-10 leading-tight italic">
                        Donde la naturaleza se encuentra con la <br class="hidden md:block" /> ciencia
                        rigurosa.
                    </h2>
                    <p
                        class="font-body-lg text-body-lg text-on-surface-variant max-w-xl mb-12 leading-relaxed">
                        En Quiddity, creemos que el verdadero bienestar se encuentra en el equilibrio
                        entre el potencial puro de la tierra y la claridad de la dermatología moderna.
                        Cada fórmula es un testimonio de pureza.
                    </p>
                    <a class="inline-flex items-center gap-4 font-label-md text-label-md text-on-surface uppercase tracking-widest group border-b-2 border-primary pb-2 hover:text-primary transition-all"
                        href="#">
                        Descubre nuestra historia
                        <span
                            class="material-symbols-outlined text-sm group-hover:translate-x-2 transition-transform">east</span>
                    </a>
                </div>
                <div class="relative aspect-[4/5] bg-surface-variant overflow-hidden">
                    <img alt="The Laboratory" class="w-full h-full object-cover "
                        src="<%= ctx %>/uploads/catalogo/heroSection/Philosophy.jpg" />
                </div>
            </div>
        </section>


        <!-- ═══════════════════════════════════════════
     OFFERINGS & SERVICES - BLOG
═══════════════════════════════════════════ -->
        <section id="offerings" class="py-section-gap bg-white">
            <div class="max-w-[1440px] mx-auto px-container-margin">
                <div class="grid grid-cols-2 md:grid-cols-4 gap-gutter">

                    <div class="text-center group">
                        <div
                            class="w-20 h-20 mx-auto border border-outline/10 flex items-center justify-center text-secondary mb-8 group-hover:bg-primary/5 transition-colors">
                            <span class="material-symbols-outlined text-3xl">eco</span>
                        </div>
                        <h5 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-4">100%
                            Organic0
                        </h5>
                        <p
                            class="text-xs text-on-surface-variant uppercase tracking-widest max-w-[160px] mx-auto leading-relaxed">
                            Ingredientes botánicos puros provenientes de granjas éticas</p>
                    </div>

                    <div class="text-center group">
                        <div
                            class="w-20 h-20 mx-auto border border-outline/10 flex items-center justify-center text-secondary mb-8 group-hover:bg-primary/5 transition-colors">
                            <span class="material-symbols-outlined text-3xl">pets</span>
                        </div>
                        <h5 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-4">Libre de
                            crueldad animal
                        </h5>
                        <p
                            class="text-xs text-on-surface-variant uppercase tracking-widest max-w-[160px] mx-auto leading-relaxed">
                            Prácticas éticas certificadas por Leaping Bunny</p>
                    </div>

                    <div class="text-center group">
                        <div
                            class="w-20 h-20 mx-auto border border-outline/10 flex items-center justify-center text-secondary mb-8 group-hover:bg-primary/5 transition-colors">
                            <span class="material-symbols-outlined text-3xl">science</span>
                        </div>
                        <h5 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-4">Mezclas
                            personalizadas
                        </h5>
                        <p
                            class="text-xs text-on-surface-variant uppercase tracking-widest max-w-[160px] mx-auto leading-relaxed">
                            Fórmulas adaptadas a tu ADN cutáneo único</p>
                    </div>

                    <div class="text-center group">
                        <div
                            class="w-20 h-20 mx-auto border border-outline/10 flex items-center justify-center text-secondary mb-8 group-hover:bg-primary/5 transition-colors">
                            <span
                                class="material-symbols-outlined text-3xl">face_retouching_natural</span>
                        </div>
                        <h5 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-4">Cuidado
                            especializado</h5>
                        <p
                            class="text-xs text-on-surface-variant uppercase tracking-widest max-w-[160px] mx-auto leading-relaxed">
                            Consultas con dermatólogos de primer nivel</p>
                    </div>

                </div>
            </div>
        </section>


        <!-- ═══════════════════════════════════════════
     LOCATION - APOTHECARY
═══════════════════════════════════════════ -->
        <section id="apothecary" class="py-section-gap bg-white border-t border-on-surface/5">
            <div
                class="max-w-[1440px] mx-auto px-container-margin grid grid-cols-1 md:grid-cols-2 gap-section-gap items-center">
                <div>
                    <span
                        class="font-label-md text-label-md text-primary uppercase tracking-[0.3em] mb-8 block">
                        Visítanos</span>
                    <h2 class="font-display-lg text-headline-lg mb-8 italic">The Apothecary</h2>
                    <address class="not-italic font-body-lg text-on-surface space-y-4 mb-12">
                        <p class="text-on-surface-variant">1248 Botanical Way, Distrito Jardín<br />
                            San Francisco, CA 94110</p>
                        <div class="pt-4 border-t border-outline/10 space-y-2">
                            <p class="text-sm uppercase tracking-widest flex justify-between">
                                <span>Lun – Sab:</span><span>10am – 7pm</span>
                            </p>
                            <p class="text-sm uppercase tracking-widest flex justify-between">
                                <span>Dom:</span><span>11am – 5pm</span>
                            </p>
                        </div>
                    </address>
                    <button
                        class="w-full md:w-auto bg-on-surface text-white font-label-md text-label-md px-12 py-5 uppercase tracking-widest hover:bg-primary transition-all active:scale-95">
                        Get Directions
                    </button>
                </div>
                <div
                    class="aspect-square bg-surface-variant relative overflow-hidden flex items-center justify-center group">
                    <div class="absolute inset-0 opacity-10"
                        style="background-image: radial-gradient(circle, #000 1px, transparent 1px); background-size: 30px 30px;">
                    </div>
                    <div
                        class="z-10 text-center group-hover:scale-110 transition-transform duration-700">
                        <span
                            class="material-symbols-outlined text-primary text-6xl mb-4">location_on</span>
                        <p
                            class="font-label-md text-label-md uppercase tracking-[0.4em] text-on-surface">
                            Quiddity Flagship</p>
                    </div>
                </div>
            </div>
        </section>

    </main>


    <!-- ═══════════════════════════════════════════
     FOOTER
═══════════════════════════════════════════ -->
    <footer class="bg-white border-t border-on-surface/5 py-24 px-container-margin">
        <div class="max-w-[1440px] mx-auto grid grid-cols-1 md:grid-cols-4 gap-gutter">

            <div class="md:col-span-1">
                <h2
                    class="font-display-lg text-headline-md text-primary tracking-[0.2em] uppercase mb-8">
                    Quiddity</h2>
                <p class="text-body-md text-on-surface-variant max-w-[240px]">
                    Redefiniendo el cuidado botánico de la piel a través de la lente de la ciencia
                    moderna y la pureza atemporal.
                </p>
            </div>

            <div>
                <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                    Explorar
                </h6>
                <ul class="space-y-4">
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Todas las Colecciones</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Lo más Vendido</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Sets de regalo</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Bundles</a></li>
                </ul>
            </div>

            <div>
                <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                    Soporte
                </h6>
                <ul class="space-y-4">
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Envíos &amp; Devoluciones</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Seguir mi pedido</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">Sostenibilidad</a></li>
                    <li><a class="text-body-md text-on-surface-variant hover:text-primary transition-colors"
                            href="#">FAQ</a></li>
                </ul>
            </div>

            <div>
                <h6 class="font-label-md text-label-md uppercase tracking-[0.2em] mb-8 text-on-surface">
                    Follow
                </h6>
                <div class="flex gap-4 mb-8">
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                        href="#">
                        <i class="text-sm font-bold not-italic">IN</i>
                    </a>
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                        href="#">
                        <i class="text-sm font-bold not-italic">FB</i>
                    </a>
                    <a class="w-10 h-10 border border-outline/20 flex items-center justify-center rounded-full hover:bg-primary hover:text-white transition-all"
                        href="#">
                        <i class="text-sm font-bold not-italic">PT</i>
                    </a>
                </div>
                <p class="text-xs text-on-surface-variant uppercase tracking-widest">Join our Newsletter
                </p>
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
            <p class="text-[10px] font-label-md text-on-surface-variant/60 uppercase tracking-[0.2em]">
                © 2026 QUIDDITY SKINCARE. ALL RIGHTS RESERVED.
            </p>
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


    <!-- ═══════════════════════════════════════════
     SCRIPTS
═══════════════════════════════════════════ -->
    <script>
        /* ── Announcement bar ── */
        function closeAnnouncementBar() {
            const bar = document.getElementById('announcement-bar');
            const header = document.getElementById('main-header');
            bar.style.display = 'none';
            header.style.top = '0px';
        }

        /* ── Shrink header on scroll ── */
        window.addEventListener('scroll', () => {
            const header = document.getElementById('main-header');
            const barShown = document.getElementById('announcement-bar').style.display !== 'none';
            if (window.scrollY > 10) {
                header.classList.add('py-2');
                header.classList.remove('py-4');
            } else {
                header.classList.remove('py-2');
                header.classList.add('py-4');
            }
        });

        /* ══════════════════════════════════════
           HERO CAROUSEL
        ══════════════════════════════════════ */
        (function () {
            const slides = Array.from(document.querySelectorAll('.hero-slide'));
            const dots = Array.from(document.querySelectorAll('.hero-dot'));
            const progressBar = document.getElementById('hero-progress');
            const INTERVAL = 6000;   // ms between auto-advance
            let current = 0;
            let timer = null;

            function goTo(index) {
                slides[current].classList.remove('active');
                dots[current].classList.remove('active');

                current = (index + slides.length) % slides.length;

                slides[current].classList.add('active');
                dots[current].classList.add('active');

                /* restart progress bar */
                progressBar.classList.remove('animating');
                progressBar.style.transition = 'none';
                progressBar.style.width = '0%';
                /* force reflow */
                void progressBar.offsetWidth;
                progressBar.classList.add('animating');
            }

            function startTimer() {
                clearInterval(timer);
                timer = setInterval(() => goTo(current + 1), INTERVAL);
            }

            /* arrows */
            document.getElementById('hero-next').addEventListener('click', () => {
                goTo(current + 1);
                startTimer();
            });
            document.getElementById('hero-prev').addEventListener('click', () => {
                goTo(current - 1);
                startTimer();
            });

            /* dots */
            dots.forEach(dot => {
                dot.addEventListener('click', () => {
                    goTo(parseInt(dot.dataset.dot, 10));
                    startTimer();
                });
            });

            /* keyboard */
            document.addEventListener('keydown', e => {
                if (e.key === 'ArrowRight') { goTo(current + 1); startTimer(); }
                if (e.key === 'ArrowLeft') { goTo(current - 1); startTimer(); }
            });

            /* touch / swipe */
            let touchStartX = 0;
            const carousel = document.getElementById('hero-carousel');
            carousel.addEventListener('touchstart', e => { touchStartX = e.touches[0].clientX; }, { passive: true });
            carousel.addEventListener('touchend', e => {
                const diff = touchStartX - e.changedTouches[0].clientX;
                if (Math.abs(diff) > 50) {
                    diff > 0 ? goTo(current + 1) : goTo(current - 1);
                    startTimer();
                }
            });

            /* kick off */
            goTo(0);
            startTimer();
        })();

        /* ── Smooth scroll for anchor links ── */
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href !== '#') {
                    e.preventDefault();
                    const target = document.querySelector(href);
                    if (target) {
                        const headerOffset = 100;
                        const elementPosition = target.getBoundingClientRect().top;
                        const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                        window.scrollTo({
                            top: offsetPosition,
                            behavior: 'smooth'
                        });
                    }
                }
            });
        });
    </script>
    <script>
        // ── Menú de usuario con click (no hover) ──
        document.addEventListener('DOMContentLoaded', function() {
            var container = document.getElementById('user-menu-container');
            if (!container) return;

            var btn = document.getElementById('user-menu-btn');
            var dropdown = document.getElementById('user-menu-dropdown');
            var icon = document.getElementById('user-menu-icon');

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

            // Cerrar con tecla Escape
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