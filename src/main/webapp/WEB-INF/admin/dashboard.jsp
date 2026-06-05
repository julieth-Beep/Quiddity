<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    request.setAttribute("activePage", "dashboard");
    String nombreUsuario = "Admin";
    if (session.getAttribute("usuario") != null) {
        try {
            nombreUsuario = (String) session.getAttribute("usuario").getClass()
                .getMethod("getNombre").invoke(session.getAttribute("usuario"));
        } catch (Exception e) {
            // Ignorar, usar valor por defecto
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | QUIDDITY Command Center</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;600&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />

    <!-- Chart.js para gráficas avanzadas -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --primary: #4A5D3A;
            --primary-light: rgba(74, 93, 58, 0.1);
            --accent: #B8956A;
            --dark: #2A2623;
            --bg: #FAF8F5;
            --surface: #FFFFFF;
            --text: #1F1D1B;
            --text-muted: #8B8882;
            --border: #E8E4DE;
            --success: #2D5A3D;
            --warning: #D4A574;
            --danger: #C45C4E;
            --sidebar-width: 280px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Manrope', sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.5;
        }

        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 40px;
        }

        /* ═════ HEADER ════ */
        .dashboard-header {
            margin-bottom: 40px;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .welcome-text h1 {
            font-family: 'EB Garamond', serif;
            font-size: 42px;
            font-weight: 400;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .welcome-text p {
            color: var(--text-muted);
            font-size: 15px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: #3D4D30;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            border: 1px solid var(--border);
            color: var(--text);
        }

        .btn-secondary:hover {
            background: var(--bg);
        }

        /* ═════ KPI GRID ════ */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 40px;
        }

        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            transition: all 0.3s;
        }

        .kpi-card:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
            transform: translateY(-2px);
        }

        .kpi-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .kpi-label {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--text-muted);
        }

        .kpi-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-light);
        }

        .kpi-icon .material-symbols-outlined {
            color: var(--primary);
            font-size: 22px;
        }

        .kpi-value {
            font-family: 'EB Garamond', serif;
            font-size: 36px;
            font-weight: 400;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .kpi-trend {
            font-size: 13px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .kpi-trend.up {
            color: var(--success);
        }

        .kpi-trend.down {
            color: var(--danger);
        }

        /* ═════ SECCIONES ════ */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .dashboard-grid.wide {
            grid-template-columns: 2fr 1fr;
        }

        .panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
        }

        .panel-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .panel-title {
            font-family: 'EB Garamond', serif;
            font-size: 20px;
            font-weight: 400;
            color: var(--dark);
        }

        .panel-body {
            padding: 24px;
        }

        /* ═════ HEATMAP 7x24 ════ */
        .heatmap-container {
            overflow-x: auto;
        }

        .heatmap-grid {
            display: grid;
            grid-template-columns: 50px repeat(24, 1fr);
            gap: 2px;
            min-width: 800px;
        }

        .heatmap-label {
            font-size: 10px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4px;
        }

        .heatmap-cell {
            aspect-ratio: 1;
            border-radius: 2px;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }

        .heatmap-cell:hover {
            transform: scale(1.3);
            z-index: 10;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .heatmap-cell.level-0 { background: #f0f0f0; }
        .heatmap-cell.level-1 { background: #d4edda; }
        .heatmap-cell.level-2 { background: #a8d5ba; }
        .heatmap-cell.level-3 { background: #7fbf9a; }
        .heatmap-cell.level-4 { background: var(--success); }

        .heatmap-cell::after {
            content: attr(data-value);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: var(--dark);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.2s;
        }

        .heatmap-cell:hover::after {
            opacity: 1;
        }

        /* ═════ COMMAND CENTER (Feed) ════ */
        .command-feed {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .feed-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: var(--bg);
            border-radius: 10px;
            border-left: 4px solid transparent;
            transition: all 0.2s;
            position: relative;
        }

        .feed-item:hover {
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .feed-item.alert {
            border-left-color: var(--warning);
            background: rgba(212, 165, 116, 0.08);
        }

        .feed-item.alert::before {
            content: '';
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 8px;
            height: 8px;
            background: var(--warning);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        .feed-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 16px;
            flex-shrink: 0;
        }

        .feed-content {
            flex: 1;
            min-width: 0;
        }

        .feed-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 6px;
        }

        .feed-user {
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        .feed-product {
            color: var(--text-muted);
            font-size: 13px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .feed-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 12px;
        }

        .feed-time {
            color: var(--text-muted);
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-pending {
            background: rgba(212, 165, 116, 0.2);
            color: var(--warning);
        }

        .status-processing {
            background: rgba(74, 93, 58, 0.15);
            color: var(--primary);
        }

        .status-completed {
            background: rgba(45, 90, 61, 0.15);
            color: var(--success);
        }

        /* ═════ TOP PRODUCTS con Sparklines ════ */
        .product-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .product-item {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .product-rank {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            background: var(--bg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 12px;
            color: var(--text-muted);
        }

        .product-rank.top-1 { background: var(--accent); color: white; }
        .product-rank.top-2 { background: #C0C0C0; color: var(--dark); }
        .product-rank.top-3 { background: #CD7F32; color: white; }

        .product-info {
            flex: 1;
            min-width: 0;
        }

        .product-name {
            font-weight: 600;
            font-size: 14px;
            color: var(--dark);
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .product-sales {
            font-size: 12px;
            color: var(--text-muted);
        }

        .sparkline-container {
            width: 100px;
            height: 40px;
        }

        .trend-indicator {
            width: 40px;
            text-align: right;
            font-weight: 600;
            font-size: 13px;
        }

        .trend-indicator.up { color: var(--success); }
        .trend-indicator.down { color: var(--danger); }

        /* ═════ GITHUB-STYLE CALENDAR ════ */
        .contributions-calendar {
            padding: 20px 0;
        }

        .calendar-legend {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 6px;
            margin-bottom: 12px;
            font-size: 11px;
            color: var(--text-muted);
        }

        .legend-box {
            width: 12px;
            height: 12px;
            border-radius: 2px;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
        }

        .calendar-day {
            aspect-ratio: 1;
            border-radius: 4px;
            cursor: pointer;
            position: relative;
            transition: transform 0.2s;
        }

        .calendar-day:hover {
            transform: scale(1.2);
            z-index: 10;
        }

        .calendar-day.level-0 { background: #ebedf0; }
        .calendar-day.level-1 { background: #9be9a8; }
        .calendar-day.level-2 { background: #40c463; }
        .calendar-day.level-3 { background: #30a14e; }
        .calendar-day.level-4 { background: #216e39; }

        .calendar-day.best-day {
            box-shadow: 0 0 0 2px var(--accent);
        }

        .calendar-day::after {
            content: attr(data-date) ' - $' attr(data-sales);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: var(--dark);
            color: white;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 11px;
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.2s;
            margin-bottom: 6px;
        }

        .calendar-day:hover::after {
            opacity: 1;
        }

        /* ═════ BUBBLE HEATMAP ════ */
        .bubble-container {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            justify-content: center;
            align-items: center;
            min-height: 300px;
            padding: 20px;
        }

        .category-bubble {
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            animation: float 6s ease-in-out infinite;
        }

        .category-bubble:hover {
            transform: scale(1.1);
            z-index: 10;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .category-bubble:nth-child(1) { animation-delay: 0s; }
        .category-bubble:nth-child(2) { animation-delay: 0.5s; }
        .category-bubble:nth-child(3) { animation-delay: 1s; }
        .category-bubble:nth-child(4) { animation-delay: 1.5s; }
        .category-bubble:nth-child(5) { animation-delay: 2s; }

        .bubble-label {
            font-size: 12px;
            text-align: center;
            padding: 8px;
        }

        .bubble-value {
            font-size: 14px;
            font-weight: 700;
        }

        .bubble-trend {
            font-size: 10px;
            opacity: 0.9;
        }

        /* ═════ RADAR CHART ════ */
        .radar-container {
            position: relative;
            height: 320px;
        }

        /* ═════ RESPONSIVE ════ */
        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .dashboard-grid { grid-template-columns: 1fr; }
            .dashboard-grid.wide { grid-template-columns: 1fr; }
        }

        @media (max-width: 1024px) {
            .main-content { margin-left: 0; }
        }

        @media (max-width: 768px) {
            .kpi-grid { grid-template-columns: 1fr; }
            .header-top {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .welcome-text h1 { font-size: 28px; }
        }
    </style>
</head>

<body>

    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

        <main class="main-content">

            <!-- ═════ HEADER ════ -->
            <header class="dashboard-header">
                <div class="header-top">
                    <div class="welcome-text">
                        <h1>Command Center</h1>
                        <p>Bienvenido de vuelta, <%= nombreUsuario %>. Aquí está lo que está pasando hoy.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn btn-secondary">
                            <span class="material-symbols-outlined">download</span>
                            Exportar Reporte
                        </button>
                        <button class="btn btn-primary">
                            <span class="material-symbols-outlined">refresh</span>
                            Actualizar
                        </button>
                    </div>
                </div>
            </header>

            <!-- ═════ KPI CARDS ════ -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Ventas Hoy</span>
                        <div class="kpi-icon">
                            <span class="material-symbols-outlined">trending_up</span>
                        </div>
                    </div>
                    <div class="kpi-value">$12,450</div>
                    <div class="kpi-trend up">
                        <span class="material-symbols-outlined">arrow_upward</span>
                        +18% vs ayer
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Pedidos</span>
                        <div class="kpi-icon">
                            <span class="material-symbols-outlined">shopping_cart</span>
                        </div>
                    </div>
                    <div class="kpi-value">47</div>
                    <div class="kpi-trend up">
                        <span class="material-symbols-outlined">arrow_upward</span>
                        +12 nuevos
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Escaneos Faciales</span>
                        <div class="kpi-icon">
                            <span class="material-symbols-outlined">face</span>
                        </div>
                    </div>
                    <div class="kpi-value">23</div>
                    <div class="kpi-trend down">
                        <span class="material-symbols-outlined">arrow_downward</span>
                        -3 vs ayer
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Usuarios Activos</span>
                        <div class="kpi-icon">
                            <span class="material-symbols-outlined">people</span>
                        </div>
                    </div>
                    <div class="kpi-value">342</div>
                    <div class="kpi-trend up">
                        <span class="material-symbols-outlined">arrow_upward</span>
                        +28 hoy
                    </div>
                </div>
            </div>

            <!-- ═════ HEATMAP 7x24 ════ -->
            <div class="panel" style="margin-bottom: 24px;">
                <div class="panel-header">
                    <h2 class="panel-title">Mapa de Calor de Actividad — Últimos 7 Días</h2>
                    <button class="btn btn-secondary" style="padding: 8px 16px; font-size: 12px;">
                        <span class="material-symbols-outlined" style="font-size: 16px;">filter_list</span>
                        Filtrar
                    </button>
                </div>
                <div class="panel-body">
                    <div class="heatmap-container">
                        <div class="heatmap-grid" id="activityHeatmap"></div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px; margin-top: 16px; font-size: 12px; color: var(--text-muted);">
                        <span>Menos activo</span>
                        <div style="display: flex; gap: 2px;">
                            <div style="width: 16px; height: 16px; background: #f0f0f0; border-radius: 2px;"></div>
                            <div style="width: 16px; height: 16px; background: #d4edda; border-radius: 2px;"></div>
                            <div style="width: 16px; height: 16px; background: #a8d5ba; border-radius: 2px;"></div>
                            <div style="width: 16px; height: 16px; background: #7fbf9a; border-radius: 2px;"></div>
                            <div style="width: 16px; height: 16px; background: var(--success); border-radius: 2px;"></div>
                        </div>
                        <span>Más activo</span>
                    </div>
                </div>
            </div>

            <!-- ═════ GRID: Command Center + Top Products ════ -->
            <div class="dashboard-grid wide">

                <!-- Command Center Feed -->
                <div class="panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Centro de Comando — Pedidos en Tiempo Real</h2>
                        <span class="status-badge status-processing" style="animation: pulse 2s infinite;">
                            ● En Vivo
                        </span>
                    </div>
                    <div class="panel-body">
                        <div class="command-feed" id="commandFeed"></div>
                    </div>
                </div>

                <!-- Top Products con Sparklines -->
                <div class="panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Top 5 Productos</h2>
                        <button class="btn btn-secondary" style="padding: 6px 12px; font-size: 12px;">
                            Ver Todo
                        </button>
                    </div>
                    <div class="panel-body">
                        <div class="product-list" id="topProducts"></div>
                    </div>
                </div>
            </div>

            <!-- ═════ GRID: Calendar + Radar ════ -->
            <div class="dashboard-grid wide">

                <!-- GitHub-style Calendar -->
                <div class="panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Calendario de Ventas — Junio 2026</h2>
                    </div>
                    <div class="panel-body">
                        <div class="contributions-calendar">
                            <div class="calendar-legend">
                                <span>Menos</span>
                                <div class="legend-box" style="background: #ebedf0;"></div>
                                <div class="legend-box" style="background: #9be9a8;"></div>
                                <div class="legend-box" style="background: #40c463;"></div>
                                <div class="legend-box" style="background: #30a14e;"></div>
                                <div class="legend-box" style="background: #216e39;"></div>
                                <span>Más</span>
                            </div>
                            <div class="calendar-grid" id="salesCalendar"></div>
                        </div>
                    </div>
                </div>

                <!-- Platform Health Radar -->
                <div class="panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Salud de la Plataforma</h2>
                    </div>
                    <div class="panel-body">
                        <div class="radar-container">
                            <canvas id="radarChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ═════ Category Bubble Map ════ -->
            <div class="panel">
                <div class="panel-header">
                    <h2 class="panel-title">¿Qué Está Caliente? — Mapa de Categorías</h2>
                </div>
                <div class="panel-body">
                    <div class="bubble-container" id="categoryBubbles"></div>
                </div>
            </div>

        </main>
    </div>

    <script>
        // ═════ GENERAR HEATMAP 7x24 ════
        function generateHeatmap() {
            const grid = document.getElementById('activityHeatmap');
            const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

            grid.innerHTML = '<div class="heatmap-label">Hora</div>';
            for (let h = 0; h < 24; h++) {
                grid.innerHTML += `<div class="heatmap-label">${h}:00</div>`;
            }

            days.forEach((day, dayIndex) => {
                grid.innerHTML += `<div class="heatmap-label" style="font-weight: 600;">${day}</div>`;
                for (let h = 0; h < 24; h++) {
                    let activity = 0;
                    if (h >= 12 && h <= 14) activity = 3;
                    else if (h >= 18 && h <= 21) activity = 4;
                    else if (h >= 9 && h <= 11) activity = 2;
                    else if (h >= 22 || h <= 6) activity = 0;
                    else activity = 1;

                    if (dayIndex === 4 && h === 20) activity = 4;
                    if (Math.random() > 0.7) activity = Math.min(4, activity + 1);

                    const value = activity * Math.floor(Math.random() * 20 + 10);
                    grid.innerHTML += `<div class="heatmap-cell level-${activity}" data-value="${value} actividades"></div>`;
                }
            });
        }

        // ═════ COMMAND CENTER FEED ════
        function generateCommandFeed() {
            const feed = document.getElementById('commandFeed');
            const orders = [
                { user: 'María García', product: 'Serum Radiance Elixir - $84', status: 'processing', time: '2h 15m', alert: true },
                { user: 'Carlos Ruiz', product: 'Set Brochas Profesional - $78', status: 'completed', time: '45m', alert: false },
                { user: 'Ana Torres', product: 'Perfume Bloom Noir EDP - $185', status: 'pending', time: '15m', alert: false },
                { user: 'Pedro Gómez', product: 'Crema Velvet Cloud - $62', status: 'processing', time: '1h 30m', alert: false },
                { user: 'Laura Mendoza', product: 'Aceite Argán Capilar - $72', status: 'completed', time: '3h 10m', alert: false },
            ];

            orders.forEach(order => {
                const initials = order.user.split(' ').map(n => n[0]).join('');
                const alertClass = order.alert ? 'alert' : '';

                feed.innerHTML += `
                    <div class="feed-item ${alertClass}">
                        <div class="feed-avatar">${initials}</div>
                        <div class="feed-content">
                            <div class="feed-header">
                                <span class="feed-user">${order.user}</span>
                                <span class="feed-product">${order.product}</span>
                            </div>
                            <div class="feed-meta">
                                <span class="feed-time">Hace ${order.time}</span>
                                <span class="status-badge status-${order.status}">${order.status}</span>
                            </div>
                        </div>
                    </div>
                `;
            });
        }

        // ═════ TOP PRODUCTS CON SPARKLINES ════
        function generateTopProducts() {
            const container = document.getElementById('topProducts');
            const products = [
                { name: 'Serum Radiance Elixir', sales: 234, trend: [12, 15, 18, 22, 28, 35, 42], change: '+18%' },
                { name: 'Perfume Bloom Noir', sales: 189, trend: [20, 22, 25, 24, 28, 30, 32], change: '+12%' },
                { name: 'Crema Velvet Cloud', sales: 167, trend: [15, 18, 16, 19, 22, 25, 28], change: '+8%' },
                { name: 'Set Brochas Pro', sales: 145, trend: [25, 23, 20, 18, 16, 14, 12], change: '-5%' },
                { name: 'Aceite Midnight Recovery', sales: 132, trend: [10, 12, 15, 18, 22, 26, 30], change: '+22%' },
            ];

            products.forEach((product, index) => {
                const rank = index + 1;
                const rankClass = rank <= 3 ? `top-${rank}` : '';
                const trendClass = product.change.startsWith('+') ? 'up' : 'down';

                container.innerHTML += `
                    <div class="product-item">
                        <div class="product-rank ${rankClass}">${rank}</div>
                        <div class="product-info">
                            <div class="product-name">${product.name}</div>
                            <div class="product-sales">${product.sales} ventas esta semana</div>
                        </div>
                        <div class="sparkline-container">
                            <svg width="100" height="40" viewBox="0 0 100 40">
                                <polyline 
                                    fill="none" 
                                    stroke="${trendClass === 'up' ? 'var(--success)' : 'var(--danger)'}" 
                                    stroke-width="2"
                                    points="${product.trend.map((v, i) => `${i * 16.67},${40 - v}`).join(' ')}"
                                />
                            </svg>
                        </div>
                        <div class="trend-indicator ${trendClass}">${product.change}</div>
                    </div>
                `;
            });
        }

        // ═════ GITHUB-STYLE CALENDAR ════
        function generateSalesCalendar() {
            const grid = document.getElementById('salesCalendar');
            const daysInMonth = 30;
            const bestDay = 15;

            for (let i = 1; i <= daysInMonth; i++) {
                let level = Math.floor(Math.random() * 5);
                if (i === bestDay) level = 4;

                const sales = level * 500 + Math.floor(Math.random() * 500);
                const bestClass = i === bestDay ? 'best-day' : '';

                grid.innerHTML += `
                    <div class="calendar-day level-${level} ${bestClass}" 
                         data-date="${i} Junio" 
                         data-sales="${sales}">
                    </div>
                `;
            }
        }

        // ═════ RADAR CHART ════
        function initRadarChart() {
            const ctx = document.getElementById('radarChart').getContext('2d');
            new Chart(ctx, {
                type: 'radar',
                data: {
                    labels: ['Ventas', 'Stock', 'Usuarios Nuevos', 'Escaneos', 'Pedidos', 'Reseñas'],
                    datasets: [{
                        label: 'Hoy',
                        data: [85, 70, 90, 65, 80, 75],
                        backgroundColor: 'rgba(74, 93, 58, 0.2)',
                        borderColor: 'var(--primary)',
                        borderWidth: 2,
                        pointBackgroundColor: 'var(--primary)',
                    }, {
                        label: 'Ayer',
                        data: [75, 75, 80, 70, 70, 80],
                        backgroundColor: 'rgba(184, 149, 106, 0.2)',
                        borderColor: 'var(--accent)',
                        borderWidth: 2,
                        pointBackgroundColor: 'var(--accent)',
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        r: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                stepSize: 20,
                                color: 'var(--text-muted)',
                                font: { size: 10 }
                            },
                            grid: {
                                color: 'var(--border)'
                            },
                            pointLabels: {
                                color: 'var(--text)',
                                font: { size: 11, weight: '600' }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 16,
                                font: { size: 11 }
                            }
                        }
                    }
                }
            });
        }

        // ═════ CATEGORY BUBBLES ════
        function generateCategoryBubbles() {
            const container = document.getElementById('categoryBubbles');
            const categories = [
                { name: 'Cuidado Facial', sales: 1240, trend: '+15%', size: 140, color: '#4A5D3A' },
                { name: 'Perfumes', sales: 890, trend: '+8%', size: 110, color: '#B8956A' },
                { name: 'Maquillaje', sales: 756, trend: '-3%', size: 95, color: '#88495A' },
                { name: 'Cabello', sales: 623, trend: '+12%', size: 85, color: '#516617' },
                { name: 'Corporal', sales: 445, trend: '+5%', size: 70, color: '#9a3a5a' },
            ];

            categories.forEach(cat => {
                const trendClass = cat.trend.startsWith('+') ? '↑' : '↓';
                container.innerHTML += `
                    <div class="category-bubble" 
                         style="width: ${cat.size}px; height: ${cat.size}px; background: ${cat.color};">
                        <div class="bubble-label">${cat.name}</div>
                        <div class="bubble-value">${cat.sales}</div>
                        <div class="bubble-trend">${trendClass} ${cat.trend}</div>
                    </div>
                `;
            });
        }

        // ═════ INIT ════
        document.addEventListener('DOMContentLoaded', function () {
            generateHeatmap();
            generateCommandFeed();
            generateTopProducts();
            generateSalesCalendar();
            initRadarChart();
            generateCategoryBubbles();
        });
    </script>

</body>

</html>