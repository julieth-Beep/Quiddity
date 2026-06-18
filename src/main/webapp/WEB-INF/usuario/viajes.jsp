<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%-- Cálculo de fechas y próximo viaje en scriptlet (compatible con Java 6) --%>
<%
    // Obtener la lista de viajes desde el request
    List<?> viajes = (List<?>) request.getAttribute("viajes");
    if (viajes == null) viajes = new ArrayList<Object>();  // ← CORREGIDO: sin diamante

    // Fecha actual
    java.util.Date hoy = new java.util.Date();
    pageContext.setAttribute("hoy", hoy);

    // Calcular el próximo viaje (el que tenga fecha fin >= hoy)
    Object proximoViaje = null;
    for (Object v : viajes) {
        try {
            java.lang.reflect.Method m = v.getClass().getMethod("getFechaFin");
            String fechaFinStr = (String) m.invoke(v);
            if (fechaFinStr != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date fechaFin = sdf.parse(fechaFinStr);
                if (!fechaFin.before(hoy)) {
                    proximoViaje = v;
                    break;
                }
            }
        } catch (Exception e) { /* ignorar */ }
    }
    pageContext.setAttribute("proximoViaje", proximoViaje);

    // Calcular total de días y outfits
    int totalDias = 0;
    int totalOutfits = 0;
    for (Object v : viajes) {
        try {
            java.lang.reflect.Method mDias = v.getClass().getMethod("getDuracionDias");
            Integer dias = (Integer) mDias.invoke(v);
            if (dias != null) totalDias += dias;

            java.lang.reflect.Method mOutfits = v.getClass().getMethod("getOutfitsCount");
            Integer outfits = (Integer) mOutfits.invoke(v);
            if (outfits != null) totalOutfits += outfits;
        } catch (Exception e) { /* ignorar */ }
    }
    pageContext.setAttribute("totalDias", totalDias);
    pageContext.setAttribute("totalOutfits", totalOutfits);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=DM+Sans:wght@300;400;500;700&display=swap" rel="stylesheet">
    <title>Viajes — Quiddity</title>
    <style>
        /* ── Variables (igual que en el resto del panel) ── */
        :root {
            --bg: #F8F9FA;
            --bg-soft: #FFFFFF;
            --surface: #FFFFFF;
            --text-primary: #1a1a2e;
            --text-secondary: #6c757d;
            --text-tertiary: #adb5bd;
            --border: #e9ecef;
            --border-light: #f1f3f5;

            --pastel-sky: #e3f2fd;
            --pastel-sky-dark: #bbdefb;
            --pastel-mint: #e8f5e9;
            --pastel-mint-dark: #c8e6c9;
            --pastel-lavender: #f3e5f5;
            --pastel-lavender-dark: #e1bee7;
            --pastel-cream: #fff3e0;
            --pastel-cream-dark: #ffe0b2;
            --pastel-coral: #fce4ec;
            --pastel-coral-dark: #f8bbd0;
            --pastel-sage: #f1f8e9;
            --pastel-sage-dark: #dcedc8;

            --accent-sky: #1976d2;
            --accent-mint: #388e3c;
            --accent-lavender: #7b1fa2;
            --accent-cream: #f57c00;
            --accent-coral: #c2185b;
            --accent-sage: #689f38;

            --accent-teal: #00897b;
            --pastel-teal: #e0f2f1;
            --pastel-teal-dark: #b2dfdb;

            --radius-sm: 10px;
            --radius-md: 12px;
            --radius-lg: 14px;
            --radius-xl: 20px;
            --radius-full: 999px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
            --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        html, body {
            height: 100vh;
            overflow: hidden;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            font-size: 12px;
            line-height: 1.4;
            -webkit-font-smoothing: antialiased;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* ── Layout (exactamente igual que en el original) ── */
        .layout-with-sidebar {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .main-content {
            flex: 1;
            padding: 12px 20px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .page {
            max-width: 100%;
            margin: 0 auto;
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        /* ── NUEVO: Welcome Section ── */
        .welcome-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 10px 16px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
            animation: fadeUp 0.4s ease forwards;
            opacity: 0;
            flex-shrink: 0;
        }

        .welcome-content { flex: 1; }

        .welcome-title {
            font-family: 'DM Sans', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0 0 2px 0;
            letter-spacing: -0.2px;
        }

        .welcome-title span { color: var(--accent-teal); }

        .welcome-subtitle {
            font-size: 11px;
            color: var(--text-secondary);
            font-weight: 500;
            margin: 0;
        }

        .welcome-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .step-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            background: linear-gradient(135deg, var(--pastel-teal), var(--pastel-teal-dark));
            border: 1px solid var(--pastel-teal-dark);
            border-radius: var(--radius-md);
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--accent-teal);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .step-badge .material-symbols-outlined {
            font-size: 14px;
            color: var(--accent-teal);
        }

        .btn-add {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--pastel-teal), var(--pastel-teal-dark));
            border: 1px solid var(--pastel-teal-dark);
            border-radius: var(--radius-md);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            color: var(--accent-teal);
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,137,123,0.15);
        }

        .btn-add .material-symbols-outlined { font-size: 14px; }

        /* ── NUEVO: Stats Bar ── */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            animation: fadeUp 0.4s ease 0.05s forwards;
            opacity: 0;
            flex-shrink: 0;
        }

        .stat-item {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 10px 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            transition: all 0.25s ease;
            position: relative;
            overflow: hidden;
            cursor: default;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
            border-color: var(--pastel-teal-dark);
        }

        .stat-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--accent-teal);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .stat-item:hover::before { transform: scaleX(1); }

        .stat-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
            transition: all 0.25s ease;
        }

        .stat-item:hover .stat-icon { transform: scale(1.1); }

        .stat-icon.teal {
            background: var(--pastel-teal);
            color: var(--accent-teal);
        }
        .stat-icon.rose {
            background: var(--pastel-coral);
            color: var(--accent-coral);
        }
        .stat-icon.lavender {
            background: var(--pastel-lavender);
            color: var(--accent-lavender);
        }

        .stat-data h4 {
            font-family: 'DM Sans', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1;
            margin-bottom: 2px;
            letter-spacing: -0.5px;
        }

        .stat-data p {
            font-size: 8px;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        /* ── NUEVO: Chips de filtro (igual que en closet) ── */
        .chips-section {
            background: var(--surface);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            flex-shrink: 0;
        }

        .chips-container { padding: 10px 14px; }

        .chips-row {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            scrollbar-width: none;
        }

        .chips-row::-webkit-scrollbar { display: none; }

        .cat-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.22s;
            background: var(--surface);
            white-space: nowrap;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: none;
        }

        .cat-chip:hover {
            border-color: var(--accent-teal);
            color: var(--accent-teal);
            background: var(--pastel-teal);
        }

        .cat-chip.active {
            background: linear-gradient(135deg, var(--pastel-teal), var(--pastel-teal-dark));
            border-color: transparent;
            color: var(--accent-teal);
            box-shadow: 0 4px 12px rgba(0,137,123,0.15);
        }

        .cat-chip .material-symbols-outlined { font-size: 14px; }

        /* ── NUEVO: Badge de próximo viaje (extra) ── */
        .next-trip-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 14px 6px 10px;
            background: var(--pastel-cream);
            border: 1px solid var(--pastel-cream-dark);
            border-radius: var(--radius-full);
            font-size: 11px;
            font-weight: 600;
            color: var(--accent-cream);
            white-space: nowrap;
        }

        .next-trip-badge .material-symbols-outlined {
            font-size: 16px;
            color: var(--accent-cream);
        }

        .next-trip-badge strong {
            font-weight: 700;
            color: var(--text-primary);
        }

        /* ── Grid de viajes y tarjetas (SIN CAMBIOS, exactamente igual que el original) ── */
        .viajes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding-top: 4px;
        }

        .viaje-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,.06);
            cursor: pointer;
            transition: .2s;
        }
        .viaje-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 28px rgba(0,0,0,.1);
        }
        .viaje-header {
            padding: 20px 20px 12px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .viaje-destino { font-size: 1.2rem; font-weight: 700; }
        .viaje-fechas { font-size: .8rem; color: #888; margin-top: 3px; }
        .viaje-clima-badge {
            padding: 4px 12px;
            border-radius: 12px;
            background: #f0f0f0;
            font-size: .78rem;
            font-weight: 500;
            white-space: nowrap;
        }
        .viaje-body { padding: 0 20px 16px; }
        .viaje-stats { display: flex; gap: 16px; }
        .stat { text-align: center; }
        .stat-num { font-size: 1.3rem; font-weight: 700; }
        .stat-label { font-size: .75rem; color: #888; }
        .viaje-outfits-strip {
            display: flex;
            gap: 6px;
            padding: 12px 20px;
            background: #f8f8f8;
            overflow-x: auto;
        }
        .outfit-mini {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
            border: 2px solid #fff;
            box-shadow: 0 1px 4px rgba(0,0,0,.1);
        }
        .outfit-mini-add {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            background: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
            cursor: pointer;
            color: #aaa;
            text-decoration: none;
        }
        .viaje-footer {
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn-ver {
            padding: 8px 18px;
            border-radius: 16px;
            background: #1a1a1a;
            color: #fff;
            border: none;
            cursor: pointer;
            font-size: .82rem;
            font-weight: 500;
        }
        .btn-del {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            font-size: .9rem;
        }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #bbb;
            grid-column: 1/-1;
        }
        .empty-state .empty-icon { font-size: 3rem; margin-bottom: 14px; }

        /* ── Modales (SIN CAMBIOS) ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.5);
            z-index: 200;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: #fff;
            border-radius: 24px;
            padding: 32px;
            width: 100%;
            max-width: 480px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-title { font-size: 1.2rem; font-weight: 700; margin-bottom: 8px; }
        .modal-sub { color: #888; font-size: .85rem; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            font-size: .85rem;
            font-weight: 500;
            margin-bottom: 6px;
            color: #555;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 12px;
            font-size: .9rem;
            outline: none;
            transition: .2s;
        }
        .form-group input:focus { border-color: var(--accent-teal); }
        .clima-detect {
            background: #f0f7f0;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: .85rem;
            color: #2d6a2d;
            margin-top: 8px;
            display: none;
        }
        .modal-actions {
            display: flex;
            gap: 10px;
            margin-top: 24px;
        }
        .btn-primary {
            flex: 1;
            padding: 12px;
            background: var(--accent-teal);
            color: #fff;
            border: none;
            border-radius: 16px;
            font-size: .95rem;
            font-weight: 600;
            cursor: pointer;
            transition: .2s;
        }
        .btn-primary:hover { background: #00796b; }
        .btn-secondary {
            flex: 1;
            padding: 12px;
            background: #f0f0f0;
            color: #1a1a1a;
            border: none;
            border-radius: 16px;
            font-size: .95rem;
            cursor: pointer;
        }

        .modal-detalle {
            background: #fff;
            border-radius: 24px;
            padding: 28px;
            width: 100%;
            max-width: 680px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .detalle-header { margin-bottom: 20px; }
        .detalle-destino { font-size: 1.4rem; font-weight: 700; }
        .detalle-meta { color: #888; font-size: .85rem; margin-top: 4px; }
        .outfits-dias {
            display: flex;
            gap: 14px;
            overflow-x: auto;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }
        .dia-col { flex-shrink: 0; text-align: center; }
        .dia-label {
            font-size: .78rem;
            font-weight: 600;
            color: #888;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        .dia-look {
            width: 100px;
            aspect-ratio: 2/3;
            border-radius: 14px;
            object-fit: cover;
            background: #f5f5f5;
            display: block;
        }
        .dia-look-add {
            width: 100px;
            aspect-ratio: 2/3;
            border-radius: 14px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            color: #ccc;
            cursor: pointer;
            border: 2px dashed #ddd;
        }
        .btn-gen-look {
            width: 100%;
            padding: 12px;
            background: #1a1a1a;
            color: #fff;
            border: none;
            border-radius: 14px;
            font-size: .9rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
        }
        .spinner-small {
            width: 18px;
            height: 18px;
            border: 2px solid rgba(255,255,255,.4);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            display: inline-block;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .toast {
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            background: #1a1a1a;
            color: #fff;
            padding: 12px 24px;
            border-radius: 24px;
            font-size: .9rem;
            opacity: 0;
            transition: .3s;
            pointer-events: none;
            z-index: 400;
        }
        .toast.show { opacity: 1; }

        /* ── Animaciones ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .anim-fade-up {
            animation: fadeUp 0.5s ease forwards;
            opacity: 0;
        }

        .delay-1 { animation-delay: 0.06s; }
        .delay-2 { animation-delay: 0.12s; }
        .delay-3 { animation-delay: 0.18s; }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }

        ::-webkit-scrollbar { width: 4px; height: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

        @media (max-width: 768px) {
            .main-content { padding: 8px 12px; }
            .welcome-section { flex-direction: column; gap: 8px; text-align: center; padding: 8px 12px; }
            .welcome-title { font-size: 16px; }
            .stats-bar { grid-template-columns: 1fr; gap: 8px; }
            .viajes-grid { grid-template-columns: 1fr; }
            .welcome-actions { justify-content: center; }
        }
    </style>
</head>
<body>
<div class="layout-with-sidebar">
    <%@ include file="/includes/sidebar.jsp" %>
    <div class="main-content">
        <div class="page">

            <!-- ═══════════════════════════════════════════════════════════════
                 NUEVO: WELCOME SECTION + STATS + FILTROS
                 ═══════════════════════════════════════════════════════════════ -->

            <!-- Welcome Section -->
            <div class="welcome-section anim-fade-up">
                <div class="welcome-content">
                    <h1 class="welcome-title">Mis <span>Viajes</span></h1>
                    <p class="welcome-subtitle">Organiza tu maleta con outfits perfectos para cada destino</p>
                </div>
                <div class="welcome-actions">


                    <!-- Badge de próximo viaje (extra) usando la variable calculada en scriptlet -->
                    <c:if test="${proximoViaje != null}">
                        <div class="next-trip-badge">
                            <span class="material-symbols-outlined">flight_takeoff</span>
                            Próximo: <strong>${proximoViaje.destino}</strong>
                            <span style="color:var(--text-tertiary);font-weight:400;margin-left:2px;">
                                (${proximoViaje.fechaInicio})
                            </span>
                        </div>
                    </c:if>

                    <button class="btn-add" onclick="abrirModalNuevo()">
                        <span class="material-symbols-outlined">add</span>
                        Nuevo viaje
                    </button>
                </div>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar anim-fade-up delay-1">
                <div class="stat-item">
                    <div class="stat-icon teal">
                        <span class="material-symbols-outlined">flight</span>
                    </div>
                    <div class="stat-data">
                        <h4>${fn:length(viajes)}</h4>
                        <p>Viajes totales</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon rose">
                        <span class="material-symbols-outlined">calendar_today</span>
                    </div>
                    <div class="stat-data">
                        <h4>${totalDias}</h4>
                        <p>Días de viaje</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon lavender">
                        <span class="material-symbols-outlined">checkroom</span>
                    </div>
                    <div class="stat-data">
                        <h4>${totalOutfits}</h4>
                        <p>Outfits generados</p>
                    </div>
                </div>
            </div>

            <!-- Chips de filtro -->
            <div class="chips-section anim-fade-up delay-2">
                <div class="chips-container">
                    <div class="chips-row" id="catRow">
                        <button class="cat-chip active" data-filtro="todos" onclick="filtrarViajes('todos', this)">
                            <span class="material-symbols-outlined">auto_awesome</span> Todos
                        </button>
                        <button class="cat-chip" data-filtro="proximos" onclick="filtrarViajes('proximos', this)">
                            <span class="material-symbols-outlined">flight_takeoff</span> Próximos
                        </button>
                        <button class="cat-chip" data-filtro="curso" onclick="filtrarViajes('curso', this)">
                            <span class="material-symbols-outlined">play_arrow</span> En curso
                        </button>
                        <button class="cat-chip" data-filtro="pasados" onclick="filtrarViajes('pasados', this)">
                            <span class="material-symbols-outlined">history</span> Pasados
                        </button>
                    </div>
                </div>
            </div>

            <!-- ═══════════════════════════════════════════════════════════════
                 GRID DE VIAJES (SIN NINGÚN CAMBIO)
                 ═══════════════════════════════════════════════════════════════ -->
            <div class="viajes-grid" id="viajesGrid">
                <c:choose>
                    <c:when test="${empty viajes}">
                        <div class="empty-state">
                            <div class="empty-icon">✈️</div>
                            <p style="font-size:1.1rem;font-weight:600;margin-bottom:8px">¡Planea tu próximo viaje!</p>
                            <p style="margin-bottom:20px">La app detectará el clima y te recomendará qué llevar</p>
                            <button class="btn-add" onclick="abrirModalNuevo()">Crear viaje</button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="v" items="${viajes}">
                            <div class="viaje-card" data-id="${v.id}"
                                 data-inicio="${v.fechaInicio}"
                                 data-fin="${v.fechaFin}">
                                <div class="viaje-header">
                                    <div>
                                        <div class="viaje-destino">✈️ ${v.destino}</div>
                                        <div class="viaje-fechas">${v.fechaInicio} → ${v.fechaFin} · ${v.duracionDias} días</div>
                                    </div>
                                    <span class="viaje-clima-badge">🌤 ${v.climaEsperado}</span>
                                </div>
                                <div class="viaje-outfits-strip" id="strip-${v.id}">
                                    <span style="color:#bbb;font-size:.8rem;padding:14px 0">Cargando outfits...</span>
                                </div>
                                <div class="viaje-footer">
                                    <button class="btn-ver"
                                            data-id="${v.id}"
                                            data-destino="${v.destino}"
                                            data-ini="${v.fechaInicio}"
                                            data-fin="${v.fechaFin}"
                                            data-clima="${v.climaEsperado}"
                                            onclick="abrirDetalleBtn(this)">
                                        Ver outfits →
                                    </button>
                                    <button class="btn-del" data-vid="${v.id}" onclick="eliminarViajeBtn(this,event)">🗑️</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </div> <!-- /.page -->
    </div> <!-- /.main-content -->
</div> <!-- /.layout-with-sidebar -->

<!-- ── Modales (SIN CAMBIOS) ── -->

<!-- Modal nuevo viaje -->
<div class="modal-overlay" id="modalNuevo">
    <div class="modal">
        <h2 class="modal-title">✈️ Tu próximo viaje</h2>
        <p class="modal-sub">Elige tu destino y las fechas — detectamos el clima automáticamente</p>
        <div class="form-group">
            <label>Destino *</label>
            <input type="text" id="inputDestino" placeholder="ej: Milan, Paris, Tokio" oninput="limpiarClima()"/>
        </div>
        <div class="form-group">
            <label>Fecha de inicio *</label>
            <input type="date" id="inputFechaIni"/>
        </div>
        <div class="form-group">
            <label>Fecha de regreso *</label>
            <input type="date" id="inputFechaFin"/>
        </div>
        <div class="form-group">
            <label>Notas (opcional)</label>
            <input type="text" id="inputNotas" placeholder="ej: viaje de negocios, luna de miel..."/>
        </div>
        <div class="clima-detect" id="climaDetect">
            🌤 Clima detectado: <strong id="climaTexto"></strong>
        </div>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="cerrarModalNuevo()">Cancelar</button>
            <button class="btn-primary" id="btnCrearViaje" onclick="crearViaje()">Crear viaje</button>
        </div>
    </div>
</div>

<!-- Modal detalle viaje -->
<div class="modal-overlay" id="modalDetalle">
    <div class="modal-detalle">
        <div class="detalle-header">
            <div class="detalle-destino" id="detDestino"></div>
            <div class="detalle-meta" id="detMeta"></div>
        </div>
        <p style="font-size:.9rem;font-weight:600;margin-bottom:12px">Outfits por día</p>
        <div class="outfits-dias" id="detalleOutfits"></div>
        <button class="btn-gen-look" id="btnGenLook" onclick="generarLookViaje()">
            ✨ Generar look IA para el viaje
        </button>
        <div style="margin-top:12px">
            <button onclick="cerrarDetalle()" style="width:100%;padding:11px;background:#f0f0f0;border:none;border-radius:14px;cursor:pointer;font-size:.9rem">Cerrar</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>

<script>
    const ctx = '${ctx}';
    let viajeDetalleId = null;
    let viajeDetalleFin = null;

    // ── Cargar strips de outfits para cada viaje ──
    document.querySelectorAll('.viaje-card[data-id]').forEach(async card => {
        const id = card.dataset.id;
        try {
            const res     = await fetch(ctx + '/viajes/' + id + '/outfits');
            const outfits = await res.json();
            const strip   = document.getElementById('strip-' + id);
            if (!outfits || outfits.length === 0) {
                strip.innerHTML = '<span style="color:#bbb;font-size:.8rem;padding:14px 0">Sin outfits asignados</span>';
                return;
            }
            strip.innerHTML = '';
            outfits.slice(0, 5).forEach(function(o) {
                var img = document.createElement('img');
                img.className = 'outfit-mini';
                img.src = ctx + '/' + o.imagenGenerada;
                img.alt = 'outfit';
                img.onerror = function() { this.style.display = 'none'; };
                strip.appendChild(img);
            });
            var addLink = document.createElement('a');
            addLink.className = 'outfit-mini-add';
            addLink.href = ctx + '/look';
            addLink.textContent = '+';
            strip.appendChild(addLink);
        } catch(e) {}
    });

    // ── Filtros (igual que en closet) ──
    function filtrarViajes(filtro, btn) {
        document.querySelectorAll('.cat-chip').forEach(function(c) { c.classList.remove('active'); });
        btn.classList.add('active');

        const hoy = new Date();
        hoy.setHours(0,0,0,0);

        document.querySelectorAll('.viaje-card').forEach(function(card) {
            const ini = card.dataset.inicio;
            const fin = card.dataset.fin;
            if (!ini || !fin) { card.style.display = ''; return; }

            const fechaIni = new Date(ini + 'T00:00:00');
            const fechaFin = new Date(fin + 'T00:00:00');
            let mostrar = false;

            switch (filtro) {
                case 'todos':
                    mostrar = true;
                    break;
                case 'proximos':
                    mostrar = fechaIni > hoy;
                    break;
                case 'curso':
                    mostrar = fechaIni <= hoy && fechaFin >= hoy;
                    break;
                case 'pasados':
                    mostrar = fechaFin < hoy;
                    break;
                default:
                    mostrar = true;
            }
            card.style.display = mostrar ? '' : 'none';
        });
    }

    // ── Modal nuevo viaje ──
    function abrirModalNuevo() {
        document.getElementById('modalNuevo').classList.add('open');
        var hoyD = new Date();
        var mm = String(hoyD.getMonth()+1).padStart(2,'0');
        var dd = String(hoyD.getDate()).padStart(2,'0');
        var hoy = hoyD.getFullYear() + '-' + mm + '-' + dd;
        document.getElementById('inputFechaIni').min = hoy;
        document.getElementById('inputFechaFin').min = hoy;
    }
    function cerrarModalNuevo() { document.getElementById('modalNuevo').classList.remove('open'); }
    function limpiarClima() { document.getElementById('climaDetect').style.display = 'none'; }

    async function crearViaje() {
        const destino  = document.getElementById('inputDestino').value.trim();
        const fechaIni = document.getElementById('inputFechaIni').value;
        const fechaFin = document.getElementById('inputFechaFin').value;
        const notas    = document.getElementById('inputNotas').value;

        if (!destino || !fechaIni || !fechaFin) {
            mostrarToast('Completa destino y fechas'); return;
        }
        if (fechaFin < fechaIni) { mostrarToast('La fecha de regreso debe ser posterior'); return; }

        const btn = document.getElementById('btnCrearViaje');
        btn.innerHTML = '<span class="spinner-small"></span> Detectando clima...';
        btn.disabled = true;

        try {
            const res  = await fetch(ctx + '/viajes', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'destino=' + encodeURIComponent(destino)
                    + '&fechaInicio=' + encodeURIComponent(fechaIni)
                    + '&fechaFin='    + encodeURIComponent(fechaFin)
                    + '&notas='       + encodeURIComponent(notas)
            });
            const data = await res.json();
            if (res.ok) {
                document.getElementById('climaTexto').textContent = data.climaEsperado;
                document.getElementById('climaDetect').style.display = 'block';
                mostrarToast('✈️ Viaje creado — ' + data.climaEsperado);
                setTimeout(() => { cerrarModalNuevo(); location.reload(); }, 1500);
            } else {
                mostrarToast('❌ ' + data.error);
            }
        } catch(e) { mostrarToast('❌ Error al crear el viaje'); }
        finally {
            btn.textContent = 'Crear viaje'; btn.disabled = false;
        }
    }

    // ── Modal detalle viaje ──
    function abrirDetalleBtn(btn) {
        var id      = btn.getAttribute('data-id');
        var destino = btn.getAttribute('data-destino');
        var ini     = btn.getAttribute('data-ini');
        var fin     = btn.getAttribute('data-fin');
        var clima   = btn.getAttribute('data-clima');
        abrirDetalle(id, destino, ini, fin, clima);
    }

    function eliminarViajeBtn(btn, e) {
        e.stopPropagation();
        var id = btn.getAttribute('data-vid');
        eliminarViaje(id, e);
    }

    async function abrirDetalle(id, destino, ini, fin, clima) {
        viajeDetalleId  = id;
        viajeDetalleFin = fin;
        document.getElementById('detDestino').textContent = '✈️ ' + destino;
        document.getElementById('detMeta').textContent    = ini + ' → ' + fin + ' · ' + clima;
        document.getElementById('detalleOutfits').innerHTML =
            '<div style="color:#bbb;padding:20px">Cargando...</div>';
        document.getElementById('modalDetalle').classList.add('open');

        try {
            const res     = await fetch(ctx + '/viajes/' + id + '/outfits');
            const outfits = await res.json();
            renderDetalleOutfits(outfits, ini, fin);
        } catch(e) {
            document.getElementById('detalleOutfits').innerHTML =
                '<div style="color:#bbb">Error al cargar</div>';
        }
    }
    function cerrarDetalle() { document.getElementById('modalDetalle').classList.remove('open'); }

    function renderDetalleOutfits(outfits, ini, fin) {
        var contenedor = document.getElementById('detalleOutfits');
        var fechaIni = new Date(ini + 'T00:00:00');
        var fechaFin = new Date(fin + 'T00:00:00');

        if (isNaN(fechaIni) || isNaN(fechaFin)) {
            contenedor.innerHTML = '<p style="color:#bbb">Fechas no disponibles</p>';
            return;
        }

        contenedor.innerHTML = '';

        for (var d = new Date(fechaIni); d <= fechaFin; d.setDate(d.getDate() + 1)) {
            var mm  = String(d.getMonth()+1).padStart(2,'0');
            var dd  = String(d.getDate()).padStart(2,'0');
            var dStr = d.getFullYear() + '-' + mm + '-' + dd;
            var num  = d.getDate();
            var look = outfits.find(function(o) { return o.dia === dStr; });

            var col = document.createElement('div');
            col.className = 'dia-col';

            var label = document.createElement('div');
            label.className = 'dia-label';
            label.textContent = 'Día ' + num;
            col.appendChild(label);

            if (look && look.imagenGenerada) {
                var img = document.createElement('img');
                img.className = 'dia-look';
                img.src = ctx + '/' + look.imagenGenerada;
                img.alt = 'look';
                img.onerror = function() { this.src = ctx + '/img/placeholder.png'; };
                col.appendChild(img);
            } else {
                var addDiv = document.createElement('div');
                addDiv.className = 'dia-look-add';
                addDiv.textContent = '+';
                (function(fecha) {
                    addDiv.onclick = function() { generarParaDia(fecha); };
                })(dStr);
                col.appendChild(addDiv);
            }

            contenedor.appendChild(col);
        }

        if (contenedor.children.length === 0) {
            contenedor.innerHTML = '<p style="color:#bbb">Sin días configurados</p>';
        }
    }

    async function generarParaDia(dia) {
        mostrarToast('✨ Generando look...');
        const fd = new FormData();
        fd.append('dia', dia); fd.append('motivo', 'Outfit del día');
        const res  = await fetch(ctx + '/viajes/' + viajeDetalleId + '/generar', { method:'POST', body:fd });
        const data = await res.json();
        if (res.ok) { mostrarToast('✨ Look generado'); abrirDetalle(viajeDetalleId, '', '', viajeDetalleFin, ''); }
        else         mostrarToast('❌ ' + data.error);
    }

    async function generarLookViaje() {
        const hoy = new Date().toISOString().split('T')[0];
        generarParaDia(hoy);
    }

    async function eliminarViaje(id, e) {
        if (e) e.stopPropagation();
        if (!confirm('¿Eliminar este viaje?')) return;
        var res = await fetch(ctx + '/viajes/' + id, { method:'DELETE' });
        if (res.ok) {
            var card = document.querySelector('.viaje-card[data-id="' + id + '"]');
            if (card) card.remove();
            mostrarToast('Viaje eliminado');
            setTimeout(() => location.reload(), 800);
        }
    }

    function mostrarToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg; t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 3000);
    }
</script>
</body>
</html>