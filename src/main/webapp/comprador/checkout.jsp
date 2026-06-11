<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%@ page import="com.quiddity.model.Direccion" %>
<%@ page import="com.quiddity.model.Carrito" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    DecimalFormat df = new DecimalFormat("#,###");

    List<Direccion> direcciones = (List<Direccion>) request.getAttribute("direcciones");
    if (direcciones == null) direcciones = new ArrayList<Direccion>();

    List<Carrito> items = (List<Carrito>) request.getAttribute("itemsCarrito");
    if (items == null) items = new ArrayList<Carrito>();

    double total = 0;
    for (Carrito item : items) total += item.getSubtotal();

    String error = request.getParameter("error");
    String exito = request.getParameter("exito");
%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>QUIDDITY | Finalizar pedido</title>
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
                    "primary":                  "#9a3a5a",
                    "secondary":                "#516617",
                    "tertiary":                 "#88495a",
                    "background":               "#ffffff",
                    "surface":                  "#ffffff",
                    "on-surface":               "#1c1b1d",
                    "on-surface-variant":       "#544246",
                    "outline":                  "#877276",
                    "surface-container-low":    "#ffffff",
                    "surface-container-lowest": "#ffffff",
                    "surface-variant":          "#f1ecef"
                },
                borderRadius: { DEFAULT: "0px", lg: "0px", xl: "0px", full: "9999px" },
                spacing: {
                    "container-margin": "80px",
                    "element-gap":      "24px",
                    "gutter":           "32px",
                    "section-gap":      "120px"
                },
                fontFamily: {
                    "headline-md": ["EB Garamond"],
                    "display-lg":  ["EB Garamond"],
                    "body-lg":     ["Manrope"],
                    "headline-lg": ["EB Garamond"],
                    "body-md":     ["Manrope"],
                    "label-md":    ["Manrope"]
                },
                fontSize: {
                    "headline-md": ["32px", { lineHeight: "40px", fontWeight: "400" }],
                    "display-lg":  ["64px", { lineHeight: "72px", letterSpacing: "-0.01em", fontWeight: "400" }],
                    "body-lg":     ["20px", { lineHeight: "32px", fontWeight: "400" }],
                    "headline-lg": ["48px", { lineHeight: "56px", fontWeight: "400" }],
                    "body-md":     ["16px", { lineHeight: "24px", fontWeight: "400" }],
                    "label-md":    ["13px", { lineHeight: "20px", letterSpacing: "0.1em", fontWeight: "600" }]
                }
            }
        }
    }
</script>
<style>
    .material-symbols-outlined {
        font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
    }
    ::-webkit-scrollbar { width: 4px; }
    ::-webkit-scrollbar-track { background: #ffffff; }
    ::-webkit-scrollbar-thumb { background: #e6e1e4; }

    #announcement-bar { background-color: #c4a9a2; height: 42px; }

    /* ── Pasos del checkout ── */
    .step-item { display: flex; align-items: center; gap: 10px; }
    .step-num {
        width: 28px; height: 28px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-family: 'Manrope', sans-serif; font-size: 11px; font-weight: 700;
        letter-spacing: 0.05em; border: 1.5px solid rgba(135,114,118,0.35);
        color: #877276; flex-shrink: 0; transition: all 0.25s;
    }
    .step-item.active .step-num   { background: #9a3a5a; border-color: #9a3a5a; color: #fff; }
    .step-item.done   .step-num   { background: #f1ecef; border-color: #9a3a5a; color: #9a3a5a; }
    .step-label {
        font-family: 'Manrope', sans-serif; font-size: 11px; font-weight: 600;
        letter-spacing: 0.12em; text-transform: uppercase; color: #877276;
        transition: color 0.25s;
    }
    .step-item.active .step-label { color: #9a3a5a; }
    .step-item.done   .step-label { color: #544246; }
    .step-line { flex: 1; height: 1px; background: rgba(135,114,118,0.20); margin: 0 6px; }

    /* ── Tarjetas de sección ── */
    .section-card {
        border: 1px solid rgba(135,114,118,0.18);
        padding: 36px 40px;
        margin-bottom: 24px;
        background: #fff;
    }
    .section-eyebrow {
        font-family: 'Manrope', sans-serif; font-size: 10px; font-weight: 700;
        letter-spacing: 0.22em; text-transform: uppercase; color: #9a3a5a;
        margin-bottom: 6px; display: block;
    }
    .section-title {
        font-family: 'EB Garamond', serif; font-size: 24px; font-weight: 400;
        color: #1c1b1d; margin-bottom: 28px; line-height: 1.3;
    }

    /* ── Tarjetas de dirección ── */
    .address-card {
        position: relative; padding: 20px 24px; border: 1.5px solid rgba(135,114,118,0.22);
        cursor: pointer; transition: all 0.22s ease; background: #fff;
    }
    .address-card:hover { border-color: rgba(154,58,90,0.45); }
    .address-card.selected {
        border-color: #9a3a5a;
        background: #fdf8fa;
    }
    .address-card input[type="radio"] { position: absolute; opacity: 0; pointer-events: none; }
    .address-radio-dot {
        width: 18px; height: 18px; border-radius: 50%;
        border: 1.5px solid rgba(135,114,118,0.4);
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0; transition: all 0.2s; margin-top: 2px;
    }
    .address-card.selected .address-radio-dot {
        border-color: #9a3a5a;
        background: #9a3a5a;
    }
    .address-radio-dot::after {
        content: ''; width: 7px; height: 7px; border-radius: 50%;
        background: #fff; opacity: 0; transition: opacity 0.2s;
    }
    .address-card.selected .address-radio-dot::after { opacity: 1; }
    .address-tag {
        display: inline-block; padding: 2px 10px;
        background: #f1ecef; font-family: 'Manrope', sans-serif;
        font-size: 9px; font-weight: 700; letter-spacing: 0.15em;
        text-transform: uppercase; color: #877276; margin-left: 8px;
    }
    .address-tag.default { background: #f7edf1; color: #9a3a5a; }

    /* ── Métodos de pago ── */
    .pago-card {
        display: flex; align-items: center; gap: 16px;
        padding: 18px 22px; border: 1.5px solid rgba(135,114,118,0.22);
        cursor: pointer; transition: all 0.22s; background: #fff;
    }
    .pago-card:hover { border-color: rgba(154,58,90,0.45); }
    .pago-card.selected { border-color: #9a3a5a; background: #fdf8fa; }
    .pago-card input[type="radio"] { display: none; }
    .pago-icon {
        width: 42px; height: 42px; background: #f1ecef;
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
    }
    .pago-icon .material-symbols-outlined { font-size: 20px; color: #9a3a5a; }

    /* ── Campo de notas ── */
    .quiddity-textarea {
        width: 100%; border: 1px solid rgba(135,114,118,0.30); padding: 14px 16px;
        font-family: 'Manrope', sans-serif; font-size: 13px; color: #1c1b1d;
        resize: vertical; min-height: 88px; outline: none; transition: border-color 0.2s;
        background: #fff;
    }
    .quiddity-textarea:focus { border-color: #9a3a5a; }
    .quiddity-textarea::placeholder { color: #b8aeb1; }

    /* ── Resumen lateral ── */
    .summary-panel {
        border: 1px solid rgba(135,114,118,0.18);
        background: #fff;
        position: sticky; top: calc(42px + 72px + 24px);
    }
    .summary-header {
        padding: 28px 32px 20px;
        border-bottom: 1px solid rgba(135,114,118,0.12);
    }
    .summary-items { padding: 20px 32px; border-bottom: 1px solid rgba(135,114,118,0.12); }
    .summary-item { display: flex; justify-content: space-between; align-items: start; gap: 12px; margin-bottom: 14px; }
    .summary-item:last-child { margin-bottom: 0; }
    .summary-item-img {
        width: 52px; height: 52px; object-fit: cover;
        background: #f1ecef; flex-shrink: 0;
    }
    .summary-item-img-placeholder {
        width: 52px; height: 52px; background: #f1ecef;
        display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .summary-totals { padding: 20px 32px; border-bottom: 1px solid rgba(135,114,118,0.12); }
    .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
    .summary-row:last-child { margin-bottom: 0; }
    .summary-actions { padding: 24px 32px; }

    /* ── Botón principal ── */
    .btn-primary {
        width: 100%; padding: 16px;
        background: #9a3a5a; color: #fff;
        font-family: 'Manrope', sans-serif; font-size: 11px;
        font-weight: 700; letter-spacing: 0.22em; text-transform: uppercase;
        border: none; cursor: pointer; transition: background 0.2s, opacity 0.2s;
        display: flex; align-items: center; justify-content: center; gap: 10px;
    }
    .btn-primary:hover { background: #7d2e48; }
    .btn-primary:disabled { opacity: 0.45; cursor: not-allowed; }

    /* ── Botón secundario ── */
    .btn-ghost {
        width: 100%; padding: 13px;
        background: transparent; color: #544246;
        font-family: 'Manrope', sans-serif; font-size: 11px;
        font-weight: 600; letter-spacing: 0.18em; text-transform: uppercase;
        border: 1px solid rgba(135,114,118,0.30); cursor: pointer;
        transition: all 0.2s; margin-top: 10px;
        display: flex; align-items: center; justify-content: center; gap: 8px;
        text-decoration: none;
    }
    .btn-ghost:hover { border-color: #9a3a5a; color: #9a3a5a; }

    /* ── Alerta de error ── */
    .alert-error {
        display: flex; align-items: start; gap: 12px;
        padding: 16px 20px;
        border-left: 3px solid #c0392b;
        background: #fdf4f4;
        margin-bottom: 24px;
        font-family: 'Manrope', sans-serif; font-size: 13px; color: #7b2020;
    }
    .alert-ok {
        display: flex; align-items: start; gap: 12px;
        padding: 16px 20px;
        border-left: 3px solid #166534;
        background: #f0fdf4;
        margin-bottom: 24px;
        font-family: 'Manrope', sans-serif; font-size: 13px; color: #166534;
    }

    /* ── Botón "nueva dirección" ── */
    .btn-add-address {
        display: flex; align-items: center; gap: 10px;
        padding: 16px 20px; border: 1.5px dashed rgba(154,58,90,0.30);
        background: transparent; color: #9a3a5a; width: 100%; cursor: pointer;
        font-family: 'Manrope', sans-serif; font-size: 11px;
        font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase;
        transition: all 0.2s;
    }
    .btn-add-address:hover { border-color: #9a3a5a; background: #fdf8fa; }

    /* ── Divider con texto ── */
    .divider-text {
        display: flex; align-items: center; gap: 16px; margin: 28px 0;
    }
    .divider-text::before, .divider-text::after {
        content: ''; flex: 1; height: 1px; background: rgba(135,114,118,0.15);
    }
    .divider-text span {
        font-family: 'Manrope', sans-serif; font-size: 10px;
        font-weight: 600; letter-spacing: 0.18em; text-transform: uppercase;
        color: #b8aeb1; white-space: nowrap;
    }

    /* ── Formulario inline de nueva dirección ── */
    #form-nueva-direccion {
        display: none;
        animation: slideDown 0.3s ease;
    }
    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
    @media (max-width: 640px) { .form-row { grid-template-columns: 1fr; } }

    .q-input {
        width: 100%; padding: 12px 14px;
        border: 1px solid rgba(135,114,118,0.30);
        font-family: 'Manrope', sans-serif; font-size: 13px; color: #1c1b1d;
        outline: none; transition: border-color 0.2s; background: #fff;
    }
    .q-input:focus { border-color: #9a3a5a; }
    .q-input::placeholder { color: #b8aeb1; }
    .q-label {
        display: block; font-family: 'Manrope', sans-serif; font-size: 10px;
        font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase;
        color: #877276; margin-bottom: 6px;
    }
    .q-checkbox {
        display: flex; align-items: center; gap: 8px;
        font-family: 'Manrope', sans-serif; font-size: 12px; color: #544246;
        cursor: pointer;
    }
    .q-checkbox input { width: 16px; height: 16px; accent-color: #9a3a5a; }

    /* ── Mensaje AJAX ── */
    .ajax-msg {
        padding: 12px 16px; font-family: 'Manrope', sans-serif; font-size: 12px;
        margin-bottom: 16px; display: none; align-items: center; gap: 8px;
    }
    .ajax-msg.ok  { display: flex; background: #f0fdf4; color: #166534; border-left: 3px solid #166534; }
    .ajax-msg.err { display: flex; background: #fff1f2; color: #9a3a5a; border-left: 3px solid #9a3a5a; }
    .ajax-msg .spinner {
        width: 14px; height: 14px; border: 2px solid rgba(135,114,118,0.3);
        border-top-color: #9a3a5a; border-radius: 50%;
        animation: spin 0.8s linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
</style>
</head>
<body class="bg-white font-body-md text-on-surface">

<!-- ANNOUNCEMENT BAR -->
<div id="announcement-bar" class="fixed top-0 w-full z-[60] flex items-center justify-center px-8">
    <p class="font-label-md text-[11px] tracking-[0.3em] text-white uppercase">
        NUEVOS ARRIVALES — ENVÍO GRATIS EN PEDIDOS MAYORES A $150.000
    </p>
    <button onclick="this.closest('#announcement-bar').style.display='none'"
            class="absolute right-6 text-white/60 hover:text-white transition-colors">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<!-- HEADER -->
<header class="fixed w-full z-50 bg-white/90 backdrop-blur-md flex justify-between items-center px-container-margin py-4 border-b border-on-surface/5 transition-all duration-300" style="top: 42px;">
    <div class="flex items-center gap-12">
        <a href="<%= ctx %>/index.jsp">
            <h1 class="font-display-lg text-headline-md tracking-[0.2em] text-primary uppercase">Quiddity</h1>
        </a>
        <nav class="hidden md:flex gap-8">
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="<%= ctx %>/catalogo">Shop</a>
            <a class="font-label-md text-label-md uppercase hover:text-primary transition-colors" href="#">Nuestra historia</a>
        </nav>
    </div>
    <div class="flex items-center gap-6">
        <a href="<%= ctx %>/carrito" class="text-on-surface hover:text-primary transition-colors relative">
            <span class="material-symbols-outlined">shopping_bag</span>
            <% if (items.size() > 0) { %>
            <span class="absolute -top-1 -right-1 bg-primary text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center"><%= items.size() %></span>
            <% } %>
        </a>
        <div class="relative group">
            <button class="flex items-center gap-2 font-label-md text-label-md uppercase tracking-widest text-on-surface hover:text-primary">
                <%= user.getNombre() %>
                <span class="material-symbols-outlined text-sm">expand_more</span>
            </button>
            <div class="absolute right-0 mt-2 w-48 bg-white shadow-lg border border-outline/10 hidden group-hover:block z-50">
                <a href="<%= ctx %>/comprador/perfil.jsp"  class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mi Perfil</a>
                <a href="<%= ctx %>/comprador/compras.jsp" class="block px-4 py-2 text-sm text-on-surface hover:bg-surface-variant">Mis Compras</a>
                <div class="border-t my-1"></div>
                <a href="<%= ctx %>/logout" class="block px-4 py-2 text-sm text-primary hover:bg-surface-variant">Cerrar sesión</a>
            </div>
        </div>
    </div>
</header>

<!-- MAIN -->
<main style="padding-top: calc(42px + 72px);">
    <div class="max-w-[1440px] mx-auto px-container-margin py-14">

        <!-- Breadcrumb + título -->
        <div class="mb-10">
            <span class="font-label-md text-[10px] tracking-[0.25em] text-on-surface-variant uppercase">
                <a href="<%= ctx %>/carrito" class="hover:text-primary transition-colors">Carrito</a>
                <span class="mx-2 opacity-40">/</span>
                <span class="text-primary">Finalizar pedido</span>
            </span>
            <h2 class="font-headline-lg text-headline-lg mt-3 italic">Finalizar pedido</h2>
        </div>

        <!-- Barra de pasos -->
        <div class="flex items-center mb-12 max-w-sm">
            <div class="step-item done">
                <div class="step-num">
                    <span class="material-symbols-outlined" style="font-size:13px;font-variation-settings:'FILL' 1,'wght' 500,'GRAD' 0,'opsz' 20;">check</span>
                </div>
                <span class="step-label">Carrito</span>
            </div>
            <div class="step-line"></div>
            <div class="step-item active">
                <div class="step-num">2</div>
                <span class="step-label">Envío</span>
            </div>
            <div class="step-line"></div>
            <div class="step-item">
                <div class="step-num">3</div>
                <span class="step-label">Confirmación</span>
            </div>
        </div>

        <!-- Mensajes flash -->
        <% if (exito != null && !exito.isEmpty()) { %>
        <div class="alert-ok mb-6">
            <span class="material-symbols-outlined" style="font-size:18px;flex-shrink:0;color:#166534;">check_circle</span>
            <span><%= java.net.URLDecoder.decode(exito, "UTF-8") %></span>
        </div>
        <% } %>
        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert-error mb-6">
            <span class="material-symbols-outlined" style="font-size:18px;flex-shrink:0;color:#c0392b;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">error_outline</span>
            <span><%= java.net.URLDecoder.decode(error, "UTF-8") %></span>
        </div>
        <% } %>

        <!-- Layout: formulario + panel lateral -->
        <div class="grid grid-cols-1 lg:grid-cols-[1fr_400px] gap-10 items-start">

            <!-- ═══════════════════ COLUMNA IZQUIERDA ═══════════════════ -->
            <div>

                <!-- ── Sección 1: Dirección de envío ── -->
                <div class="section-card">
                    <span class="section-eyebrow">01 — Envío</span>
                    <h3 class="section-title">Dirección de entrega</h3>

                    <% if (direcciones.isEmpty()) { %>
                    <!-- Sin direcciones guardadas -->
                    <div class="flex flex-col items-center justify-center py-10 text-center mb-4">
                        <span class="material-symbols-outlined mb-4" style="font-size:40px;color:#c4a9a2;">location_off</span>
                        <p class="font-body-md text-sm text-on-surface-variant mb-2">Aún no tienes direcciones guardadas.</p>
                        <p class="font-body-md text-[11px] text-outline">Agrega una dirección para poder continuar con tu pedido.</p>
                    </div>
                    <% } else { %>
                    <!-- Lista de direcciones existentes -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-4" id="address-list">
                        <% for (Direccion d : direcciones) { %>
                        <label class="address-card <%= d.isPredeterminada() ? "selected" : "" %>"
                               onclick="selectAddress(this, '<%= d.getId() %>')">
                            <input type="radio" name="direccionId" value="<%= d.getId() %>"
                                   <%= d.isPredeterminada() ? "checked" : "" %> form="checkout-form" required>
                            <div class="flex items-start gap-3">
                                <div class="address-radio-dot"></div>
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center flex-wrap gap-1 mb-1">
                                        <span class="font-label-md text-[11px] tracking-[0.08em] text-on-surface uppercase">
                                            <%= d.getCiudad() %>
                                        </span>
                                        <% if (d.isPredeterminada()) { %>
                                        <span class="address-tag default">Predeterminada</span>
                                        <% } %>
                                    </div>
                                    <p class="font-body-md text-[12px] text-on-surface-variant leading-relaxed">
                                        <%= d.getDireccion() %>
                                        <% if (d.getBarrio() != null && !d.getBarrio().trim().isEmpty()) { %>, <%= d.getBarrio() %><% } %>
                                    </p>
                                    <p class="font-body-md text-[11px] text-outline mt-0.5">
                                        <%= d.getDepartamento() %>
                                        <% if (d.isEsRural() && d.getDescripcionRural() != null && !d.getDescripcionRural().trim().isEmpty()) { %>
                                        · <span class="italic">Zona rural: <%= d.getDescripcionRural() %></span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                        </label>
                        <% } %>
                    </div>
                    <% } %>

                    <!-- Mensaje AJAX -->
                    <div id="ajax-msg" class="ajax-msg"></div>

                    <!-- Botón mostrar/ocultar formulario de nueva dirección -->
                    <button type="button" onclick="toggleNuevaDireccion()" class="btn-add-address mt-2" id="btn-toggle-direccion">
                        <span class="material-symbols-outlined" style="font-size:16px;">add</span>
                        <span id="txt-toggle-direccion">Agregar nueva dirección</span>
                    </button>

                    <!-- ═══════ FORMULARIO INLINE DE NUEVA DIRECCIÓN ═══════ -->
                    <div id="form-nueva-direccion" class="mt-6 pt-6 border-t border-outline/10">
                        <p class="font-label-md text-[10px] tracking-[0.2em] text-primary uppercase mb-5">Nueva dirección</p>

                        <form id="form-direccion-inline" onsubmit="guardarDireccion(event)">

                            <div class="form-row">
                                <div>
                                    <label class="q-label">Departamento *</label>
                                    <input type="text" name="departamento" class="q-input" placeholder="Ej: Boyacá" required maxlength="100">
                                </div>
                                <div>
                                    <label class="q-label">Ciudad *</label>
                                    <input type="text" name="ciudad" class="q-input" placeholder="Ej: Tunja" required maxlength="100">
                                </div>
                            </div>

                            <div class="form-row">
                                <div>
                                    <label class="q-label">Dirección *</label>
                                    <input type="text" name="direccion" class="q-input" placeholder="Ej: Calle 10 # 15-30, Apto 201" required maxlength="200">
                                </div>
                                <div>
                                    <label class="q-label">Barrio</label>
                                    <input type="text" name="barrio" class="q-input" placeholder="Ej: Centro" maxlength="100">
                                </div>
                            </div>

                            <div class="form-row">
                                <div>
                                    <label class="q-label">Código postal</label>
                                    <input type="text" name="codigoPostal" class="q-input" placeholder="Ej: 150001" maxlength="20">
                                </div>
                                <div>
                                    <label class="q-label">Teléfono de contacto</label>
                                    <input type="text" name="telefono" class="q-input" placeholder="Ej: 310 123 4567" maxlength="30">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="q-checkbox">
                                    <input type="checkbox" name="esRural" value="true" id="chk-rural" onchange="toggleRural()">
                                    <span>Esta dirección es zona rural</span>
                                </label>
                            </div>

                            <div class="mb-4" id="campo-rural" style="display:none;">
                                <label class="q-label">Descripción de zona rural</label>
                                <input type="text" name="descripcionRural" class="q-input" placeholder="Ej: Vereda El Carmen, 2 km después del puente" maxlength="200">
                            </div>

                            <div class="mb-5">
                                <label class="q-checkbox">
                                    <input type="checkbox" name="predeterminada" value="true" checked>
                                    <span>Establecer como dirección predeterminada</span>
                                </label>
                            </div>

                            <div class="flex gap-3">
                                <button type="submit" class="btn-primary" style="width:auto; padding: 12px 28px;">
                                    <span class="material-symbols-outlined" style="font-size:16px;">save</span>
                                    Guardar dirección
                                </button>
                                <button type="button" onclick="toggleNuevaDireccion()" class="btn-ghost" style="width:auto; padding: 12px 24px; margin-top:0;">
                                    Cancelar
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ── Sección 2: Método de pago ── -->
                <div class="section-card">
                    <span class="section-eyebrow">02 — Pago</span>
                    <h3 class="section-title">Método de pago</h3>

                    <div class="flex flex-col gap-3" id="pago-list">

                        <label class="pago-card selected" onclick="selectPago(this, 'EFECTIVO')">
                            <input type="radio" name="metodoPago" value="EFECTIVO" checked required form="checkout-form">
                            <div class="pago-icon">
                                <span class="material-symbols-outlined">payments</span>
                            </div>
                            <div>
                                <p class="font-label-md text-[12px] tracking-[0.08em] text-on-surface uppercase mb-0.5">Efectivo contra entrega</p>
                                <p class="font-body-md text-[12px] text-on-surface-variant">Paga en el momento de recibir tu pedido.</p>
                            </div>
                            <div class="ml-auto address-radio-dot" style="flex-shrink:0;margin-top:0;"></div>
                        </label>

                        <label class="pago-card" onclick="selectPago(this, 'TRANSFERENCIA')">
                            <input type="radio" name="metodoPago" value="TRANSFERENCIA" required form="checkout-form">
                            <div class="pago-icon">
                                <span class="material-symbols-outlined">account_balance</span>
                            </div>
                            <div>
                                <p class="font-label-md text-[12px] tracking-[0.08em] text-on-surface uppercase mb-0.5">Transferencia bancaria</p>
                                <p class="font-body-md text-[12px] text-on-surface-variant">Te enviamos los datos al confirmar.</p>
                            </div>
                            <div class="ml-auto address-radio-dot" style="flex-shrink:0;margin-top:0;"></div>
                        </label>

                        <label class="pago-card" onclick="selectPago(this, 'TARJETA')">
                            <input type="radio" name="metodoPago" value="TARJETA" required form="checkout-form">
                            <div class="pago-icon">
                                <span class="material-symbols-outlined">credit_card</span>
                            </div>
                            <div>
                                <p class="font-label-md text-[12px] tracking-[0.08em] text-on-surface uppercase mb-0.5">Tarjeta crédito / débito</p>
                                <p class="font-body-md text-[12px] text-on-surface-variant">Pago seguro procesado en checkout.</p>
                            </div>
                            <div class="ml-auto address-radio-dot" style="flex-shrink:0;margin-top:0;"></div>
                        </label>

                    </div>
                </div>

                <!-- ── Sección 3: Notas ── -->
                <div class="section-card">
                    <span class="section-eyebrow">03 — Opcional</span>
                    <h3 class="section-title">Instrucciones de entrega</h3>
                    <textarea name="notas" class="quiddity-textarea" form="checkout-form"
                              placeholder="Ej: Dejar con el portero, llamar antes de entregar, no doblar empaques…"
                              maxlength="400"></textarea>
                    <p class="font-body-md text-[11px] text-outline mt-2">Máximo 400 caracteres. Campo opcional.</p>
                </div>

                <!-- Formulario principal del checkout (fuera de las secciones para no anidar forms) -->
                <form action="<%= ctx %>/pedido" method="post" id="checkout-form" class="hidden"></form>

                <!-- ── Botón visible en móvil ── -->
                <div class="lg:hidden mt-2">
                    <button type="submit" form="checkout-form" class="btn-primary" id="submit-btn-mobile">
                        <span class="material-symbols-outlined" style="font-size:16px;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">lock</span>
                        Confirmar pedido
                    </button>
                    <a href="<%= ctx %>/carrito" class="btn-ghost" style="display:flex;">
                        <span class="material-symbols-outlined" style="font-size:15px;">arrow_back</span>
                        Volver al carrito
                    </a>
                </div>

            </div>

            <!-- ═══════════════════ PANEL LATERAL ═══════════════════ -->
            <aside>
                <div class="summary-panel">
                    <div class="summary-header">
                        <span class="section-eyebrow" style="margin-bottom:4px;">Resumen del pedido</span>
                        <p class="font-body-md text-[12px] text-on-surface-variant">
                            <%= items.size() %> producto<%= items.size() != 1 ? "s" : "" %>
                        </p>
                    </div>

                    <!-- Ítems con TODA la información -->
<div class="summary-items">
    <% for (Carrito item : items) { %>
    <div class="summary-item">
        <div class="summary-item-img-placeholder">
            <span class="material-symbols-outlined" style="font-size:20px;color:#c4a9a2;">inventory_2</span>
        </div>
        <div class="flex-1 min-w-0">
            <p class="font-label-md text-[11px] tracking-[0.06em] text-on-surface uppercase leading-tight">
                <%= item.getProducto().getNombre() %>
            </p>
            <p class="font-body-md text-[11px] text-outline mt-0.5">
                Cant: <%= item.getCantidad() %>
            </p>
        </div>
        <span class="font-label-md text-[12px] text-on-surface whitespace-nowrap">
            $<%= df.format(item.getSubtotal()) %>
        </span>
    </div>
    <% } %>
</div>

<!-- Totales -->
<div class="summary-totals">
    <div class="summary-row">
        <span class="font-body-md text-[13px] text-on-surface-variant">Subtotal</span>
        <span class="font-body-md text-[13px] text-on-surface">$<%= df.format(total) %></span>
    </div>
    <div class="summary-row">
        <span class="font-body-md text-[13px] text-on-surface-variant">Envío</span>
        <span class="font-body-md text-[13px] text-outline italic">Calculado en checkout</span>
    </div>
    <div class="summary-row mt-3">
        <span class="font-label-md text-[13px] tracking-[0.08em] uppercase text-on-surface">Total</span>
        <span class="font-label-md text-[15px] text-primary">$<%= df.format(total) %></span>
    </div>
</div>

                    <!-- Acciones -->
                    <div class="summary-actions">
                        <button type="submit" form="checkout-form" class="btn-primary hidden lg:flex" id="submit-btn-desktop">
                            <span class="material-symbols-outlined" style="font-size:16px;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">lock</span>
                            Confirmar pedido
                        </button>
                        <a href="<%= ctx %>/carrito" class="btn-ghost hidden lg:flex">
                            <span class="material-symbols-outlined" style="font-size:15px;">arrow_back</span>
                            Volver al carrito
                        </a>

                        <!-- Sellos de confianza -->
                        <div class="divider-text"><span>Compra segura</span></div>
                        <div class="flex flex-col gap-2">
                            <div class="flex items-center gap-3">
                                <span class="material-symbols-outlined" style="font-size:16px;color:#9a3a5a;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">verified_user</span>
                                <span class="font-body-md text-[11px] text-on-surface-variant">Datos protegidos con cifración SSL</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <span class="material-symbols-outlined" style="font-size:16px;color:#9a3a5a;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">local_shipping</span>
                                <span class="font-body-md text-[11px] text-on-surface-variant">Envío gratis desde $150.000</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <span class="material-symbols-outlined" style="font-size:16px;color:#9a3a5a;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24;">autorenew</span>
                                <span class="font-body-md text-[11px] text-on-surface-variant">Devoluciones dentro de 30 días</span>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>

        </div><!-- /grid -->
    </div>
</main>

<!-- FOOTER -->
<footer class="border-t border-on-surface/5 py-8 px-container-margin">
    <p class="font-label-md text-[10px] tracking-[0.2em] text-outline uppercase text-center">
        © 2026 Quiddity Skincare. All rights reserved.
    </p>
</footer>

<script>
    var ctxPath = '<%= ctx %>';

    // ── Selección de dirección ──────────────────────────────────
    function selectAddress(label, id) {
        document.querySelectorAll('#address-list .address-card').forEach(c => c.classList.remove('selected'));
        label.classList.add('selected');
        label.querySelector('input[type="radio"]').checked = true;
    }

    // ── Selección de método de pago ────────────────────────────
    function selectPago(label, val) {
        document.querySelectorAll('#pago-list .pago-card').forEach(c => {
            c.classList.remove('selected');
            c.querySelectorAll('.address-radio-dot').forEach(d => {
                d.style.borderColor = '';
                d.style.background  = '';
            });
        });
        label.classList.add('selected');
        label.querySelector('input[type="radio"]').checked = true;
        label.querySelectorAll('.address-radio-dot').forEach(d => {
            d.style.borderColor = '#9a3a5a';
            d.style.background  = '#9a3a5a';
        });
    }

    // Aplicar estilo inicial al dot de "Efectivo"
    document.querySelectorAll('#pago-list .pago-card.selected .address-radio-dot').forEach(d => {
        d.style.borderColor = '#9a3a5a';
        d.style.background  = '#9a3a5a';
    });

    // ── Mostrar / ocultar formulario de nueva dirección ───────
    function toggleNuevaDireccion() {
        var form = document.getElementById('form-nueva-direccion');
        var txt = document.getElementById('txt-toggle-direccion');
        var btn = document.getElementById('btn-toggle-direccion');
        if (form.style.display === 'block') {
            form.style.display = 'none';
            txt.textContent = 'Agregar nueva dirección';
            btn.querySelector('.material-symbols-outlined').textContent = 'add';
        } else {
            form.style.display = 'block';
            txt.textContent = 'Ocultar formulario';
            btn.querySelector('.material-symbols-outlined').textContent = 'remove';
            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    // ── Toggle zona rural ──────────────────────────────────────
    function toggleRural() {
        var chk = document.getElementById('chk-rural');
        var campo = document.getElementById('campo-rural');
        campo.style.display = chk.checked ? 'block' : 'none';
    }

    // ═══════════════════════════════════════════════════════════
    // ── GUARDAR DIRECCIÓN VIA AJAX (sin salir del checkout) ────
    // ═══════════════════════════════════════════════════════════
    function guardarDireccion(event) {
        event.preventDefault();
        var form = document.getElementById('form-direccion-inline');
        var btn = form.querySelector('button[type="submit"]');
        var msg = document.getElementById('ajax-msg');
        var formData = new FormData(form);

        // Deshabilitar botón y mostrar spinner
        btn.disabled = true;
        var oldHtml = btn.innerHTML;
        btn.innerHTML = '<div class="spinner"></div> Guardando…';
        msg.className = 'ajax-msg';
        msg.style.display = 'flex';
        msg.innerHTML = '<div class="spinner"></div> Guardando dirección…';

        function guardarDireccion(event) {
    event.preventDefault();
    var form = document.getElementById('form-direccion-inline');
    var btn = form.querySelector('button[type="submit"]');
    var msg = document.getElementById('ajax-msg');

    // ── CAMBIO: usar URLSearchParams en vez de FormData ──
    var params = new URLSearchParams(new FormData(form));
    params.append('accion', 'guardarAjax');

    btn.disabled = true;
    var oldHtml = btn.innerHTML;
    btn.innerHTML = '<div class="spinner"></div> Guardando…';
    msg.className = 'ajax-msg';
    msg.style.display = 'flex';
    msg.innerHTML = '<div class="spinner"></div> Guardando dirección…';

    fetch(ctxPath + '/direccion', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    })
    .then(function(response) {
        if (!response.ok) throw new Error('Error ' + response.status);
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            msg.className = 'ajax-msg ok';
            msg.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">check_circle</span> ' +
                            (data.message || 'Dirección guardada correctamente.');
            setTimeout(function() { window.location.reload(); }, 600);
        } else {
            throw new Error(data.message || 'No se pudo guardar la dirección.');
        }
    })
    .catch(function(err) {
        msg.className = 'ajax-msg err';
        msg.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;">error</span> ' + err.message;
        btn.disabled = false;
        btn.innerHTML = oldHtml;
    });
}
    }

    // ── Validación + estado de carga del checkout ─────────────
    document.getElementById('checkout-form').addEventListener('submit', function(e) {
        var direccionSel = document.querySelector('input[name="direccionId"]:checked');
        if (!direccionSel) {
            e.preventDefault();
            alert('Selecciona una dirección de entrega para continuar. Si no tienes direcciones, agrega una nueva.');
            var form = document.getElementById('form-nueva-direccion');
            if (form.style.display !== 'block') {
                toggleNuevaDireccion();
            }
            return;
        }
        ['submit-btn-desktop', 'submit-btn-mobile'].forEach(function(id) {
            var btn = document.getElementById(id);
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px;animation:spin 1s linear infinite;">progress_activity</span> Procesando…';
            }
        });
    });
</script>
</body>
</html>