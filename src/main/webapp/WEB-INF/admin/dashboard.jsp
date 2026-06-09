<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    request.setAttribute("activePage", "dashboard");

    Map<String, Object> kpis = (Map<String, Object>) request.getAttribute("kpis");
    List<Map<String, Object>> heatmap = (List<Map<String, Object>>) request.getAttribute("heatmap");
    List<Map<String, Object>> livefeed = (List<Map<String, Object>>) request.getAttribute("livefeed");
    List<Map<String, Object>> topProducts = (List<Map<String, Object>>) request.getAttribute("topProducts");
    List<Map<String, Object>> salesCalendar = (List<Map<String, Object>>) request.getAttribute("salesCalendar");
    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
    Map<String, Object> healthRadar = (Map<String, Object>) request.getAttribute("healthRadar");
    List<Map<String, Object>> actividadReciente = (List<Map<String, Object>>) request.getAttribute("actividadReciente");

    int totalUsuarios = kpis != null ? (Integer) kpis.get("totalUsuarios") : 0;
    int nuevosHoy = kpis != null ? (Integer) kpis.get("nuevosHoy") : 0;
    int totalProductos = kpis != null ? (Integer) kpis.get("totalProductos") : 0;
    int productosBajos = kpis != null ? (Integer) kpis.get("productosBajos") : 0;
    int totalPedidos = kpis != null ? (Integer) kpis.get("totalPedidos") : 0;
    double ingresosMes = kpis != null ? (Double) kpis.get("ingresosMes") : 0.0;
    double tendenciaPedidos = kpis != null ? (Double) kpis.get("tendenciaPedidos") : 0.0;
    double tendenciaIngresos = kpis != null ? (Double) kpis.get("tendenciaIngresos") : 0.0;

    Object usuario = session.getAttribute("usuario");
    String nombreUsuario = "Administrador";
    String rolUsuario = "admin";
    if (usuario != null) {
        try {
            nombreUsuario = (String) usuario.getClass().getMethod("getNombre").invoke(usuario);
            rolUsuario = (String) usuario.getClass().getMethod("getRol").invoke(usuario);
        } catch (Exception e) { }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Quiddity</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            /* ELEGANTE - Tonos neutros con acentos pastel suaves */
            --bg: #F8F9FA;
            --bg-soft: #FFFFFF;
            --surface: #FFFFFF;
            --text-primary: #1a1a2e;
            --text-secondary: #6c757d;
            --text-tertiary: #adb5bd;
            --border: #e9ecef;
            --border-light: #f1f3f5;

            /* Pasteles elegantes y sutiles */
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

            /* Acentos elegantes */
            --accent-sky: #1976d2;
            --accent-mint: #388e3c;
            --accent-lavender: #7b1fa2;
            --accent-cream: #f57c00;
            --accent-coral: #c2185b;
            --accent-sage: #689f38;

            --success: #388e3c;
            --warning: #f57c00;
            --error: #c2185b;

            --radius-sm: 12px;
            --radius-md: 14px;
            --radius-lg: 16px;

            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            line-height: 1.4;
            -webkit-font-smoothing: antialiased;
            font-size: 12px;
            overflow: hidden;
            height: 100vh;
        }

        .layout-wrapper {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* MAIN CONTENT */
        .main-content {
            flex: 1;
            padding: 16px 20px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
            overflow-x: hidden;
            transition: max-width 0.3s ease;
        }

        .main-content.sidebar-open {
            max-width: calc(100% - 320px);
        }

        .main-content.sidebar-closed {
            max-width: 100%;
        }



        /* RIGHT SIDEBAR */
        .right-sidebar {
            width: 320px;
            min-width: 320px;
            background: var(--surface);
            border-left: 1px solid var(--border);
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            height: 100vh;
            overflow-y: auto;
            z-index: 100;
            box-shadow: -2px 0 12px rgba(0,0,0,0.04);
            transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.35s ease;
        }

        .right-sidebar.hidden {
            transform: translateX(100%);
            opacity: 0;
            pointer-events: none;
            width: 0;
            min-width: 0;
            padding: 0;
            border: none;
            overflow: hidden;
        }

        .right-sidebar::-webkit-scrollbar { width: 3px; }
        .right-sidebar::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

        .sidebar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border-light);
        }

        .sidebar-title {
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .sidebar-close {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            border: none;
            background: var(--pastel-coral);
            color: var(--accent-coral);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .sidebar-close:hover {
            background: var(--pastel-coral-dark);
            transform: scale(1.1);
        }

        /* WELCOME - Elegante y sobrio */
        .welcome-section {
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
        }

        .welcome-content { flex: 1; }

        .welcome-title {
            font-family: 'DM Sans', sans-serif;
            font-size: 22px;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0 0 3px 0;
            letter-spacing: -0.3px;
        }

        .welcome-title span {
            color: var(--accent-sky);
        }

        .welcome-subtitle {
            font-size: 12px;
            color: var(--text-secondary);
            font-weight: 500;
            margin: 0;
        }

        .welcome-avatar {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .avatar-ring {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-lavender));
            padding: 2px;
        }

        .avatar-ring img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid white;
        }

        .avatar-info { text-align: right; }
        .avatar-name { font-weight: 700; font-size: 13px; color: var(--text-primary); }
        .avatar-role { font-size: 11px; color: var(--text-tertiary); font-weight: 600; }

        /* Toggle Orders Button en Welcome */
        .welcome-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .toggle-orders-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: var(--pastel-sky);
            border: 1px solid var(--pastel-sky-dark);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.25s ease;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 12px;
            font-weight: 600;
            color: var(--accent-sky);
        }

        .toggle-orders-btn:hover {
            background: var(--pastel-sky-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow);
        }

        .toggle-orders-btn .material-symbols-rounded {
            font-size: 18px;
        }

        .toggle-orders-btn .toggle-icon {
            transition: transform 0.3s ease;
        }

        .toggle-orders-btn.active .toggle-icon {
            transform: rotate(180deg);
        }

        .toggle-label {
            white-space: nowrap;
        }

        /* KPI GRID - Compacto */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 14px;
        }

        .kpi-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 14px 16px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .kpi-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
            border-color: var(--pastel-sky-dark);
        }

        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--pastel-sky-dark);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .kpi-card.sky::before { background: var(--accent-sky); }
        .kpi-card.mint::before { background: var(--accent-mint); }
        .kpi-card.lavender::before { background: var(--accent-lavender); }
        .kpi-card.cream::before { background: var(--accent-cream); }

        .kpi-card:hover::before { transform: scaleX(1); }

        .kpi-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .kpi-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .kpi-icon {
            width: 32px;
            height: 32px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .kpi-card:hover .kpi-icon {
            transform: scale(1.1);
        }

        .kpi-icon.sky { background: var(--pastel-sky); }
        .kpi-icon.sky .material-symbols-rounded { color: var(--accent-sky); }
        .kpi-icon.mint { background: var(--pastel-mint); }
        .kpi-icon.mint .material-symbols-rounded { color: var(--accent-mint); }
        .kpi-icon.lavender { background: var(--pastel-lavender); }
        .kpi-icon.lavender .material-symbols-rounded { color: var(--accent-lavender); }
        .kpi-icon.cream { background: var(--pastel-cream); }
        .kpi-icon.cream .material-symbols-rounded { color: var(--accent-cream); }

        .kpi-icon .material-symbols-rounded { font-size: 18px; }

        .kpi-value {
            font-family: 'DM Sans', sans-serif;
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
            letter-spacing: -0.5px;
            line-height: 1;
        }

        .kpi-trend {
            display: inline-flex;
            align-items: center;
            gap: 3px;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 8px;
            border-radius: 12px;
        }

        .kpi-trend.up { background: var(--pastel-mint); color: var(--accent-mint); }
        .kpi-trend.down { background: var(--pastel-coral); color: var(--accent-coral); }
        .kpi-trend .material-symbols-rounded { font-size: 13px; }

        /* DASHBOARD GRID */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            flex: 1;
            min-height: 0;
        }

        .dashboard-left {
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-height: 0;
        }

        .dashboard-right {
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-height: 0;
        }

        /* PANELS */
        .panel {
            background: var(--surface);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            overflow: hidden;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .panel:hover {
            box-shadow: var(--shadow);
            border-color: var(--border);
        }

        .panel-header {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .panel-title-group h3 {
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .panel-title-group h3::before {
            content: '';
            width: 3px;
            height: 14px;
            border-radius: 2px;
            background: var(--accent-sky);
        }

        .panel-title-group p {
            font-size: 11px;
            color: var(--text-tertiary);
            font-weight: 500;
            margin: 2px 0 0 11px;
        }

        .panel-actions { display: flex; gap: 6px; }

        .icon-btn {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            border: 1px solid var(--border-light);
            background: var(--surface);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            color: var(--text-tertiary);
        }

        .icon-btn:hover {
            background: var(--pastel-sky);
            border-color: var(--pastel-sky-dark);
            color: var(--accent-sky);
            transform: translateY(-1px);
        }

        .icon-btn .material-symbols-rounded { font-size: 15px; }

        .panel-body {
            padding: 12px 16px;
            flex: 1;
            overflow: auto;
            min-height: 0;
        }

        /* HEATMAP - Compacto */
        .heatmap-container { overflow-x: auto; }

        .heatmap-grid {
            display: grid;
            grid-template-columns: 28px repeat(24, 1fr);
            gap: 2px;
            min-width: 400px;
        }

        .heatmap-label {
            font-size: 9px;
            font-weight: 600;
            color: var(--text-tertiary);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 6px;
        }

        .heatmap-hour {
            font-size: 8px;
            color: var(--text-tertiary);
            text-align: center;
            padding-bottom: 3px;
            font-weight: 600;
        }

        .heatmap-cell {
            aspect-ratio: 1;
            border-radius: 3px;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            min-height: 14px;
        }

        .heatmap-cell:hover {
            transform: scale(1.4);
            z-index: 10;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        }

        .heatmap-cell::after {
            content: attr(data-tip);
            position: absolute;
            bottom: calc(100% + 6px);
            left: 50%;
            transform: translateX(-50%) scale(0);
            background: var(--text-primary);
            color: white;
            font-size: 10px;
            font-weight: 600;
            padding: 4px 8px;
            white-space: nowrap;
            border-radius: 6px;
            opacity: 0;
            pointer-events: none;
            transition: all 0.15s ease;
        }

        .heatmap-cell:hover::after {
            opacity: 1;
            transform: translateX(-50%) scale(1);
        }

        .hc-0 { background: #f1f3f5; }
        .hc-1 { background: #e3f2fd; }
        .hc-2 { background: #bbdefb; }
        .hc-3 { background: #90caf9; }
        .hc-4 { background: #64b5f6; }
        .hc-5 { background: #42a5f5; }

        .heatmap-legend {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 8px;
            justify-content: center;
        }

        .heatmap-legend span { font-size: 9px; color: var(--text-tertiary); font-weight: 600; }
        .legend-box { width: 12px; height: 12px; border-radius: 3px; }

        /* LIVE FEED */
        .feed-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .feed-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 10px 12px;
            background: var(--bg-soft);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-light);
            border-left: 3px solid transparent;
            transition: all 0.2s ease;
        }

        .feed-item:hover {
            background: var(--surface);
            box-shadow: var(--shadow-sm);
            transform: translateX(2px);
            border-color: var(--border);
        }

        .feed-item.alert {
            border-left-color: var(--accent-coral);
            background: var(--pastel-coral);
        }

        .feed-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            color: white;
            font-weight: 700;
            font-size: 11px;
        }

        .feed-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .feed-content { flex: 1; min-width: 0; }

        .feed-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2px;
        }

        .feed-name { font-size: 12px; font-weight: 700; color: var(--text-primary); }

        .feed-amount {
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--accent-coral);
        }

        .feed-product {
            font-size: 11px;
            color: var(--text-secondary);
            margin-bottom: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .feed-meta { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }

        .status-badge {
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            padding: 2px 8px;
            border-radius: 10px;
        }

        .status-pendiente { background: var(--pastel-cream); color: var(--accent-cream); }
        .status-confirmado { background: var(--pastel-sky); color: var(--accent-sky); }
        .status-en_preparacion { background: var(--pastel-lavender); color: var(--accent-lavender); }
        .status-enviado { background: var(--pastel-sky); color: var(--accent-sky); }
        .status-entregado { background: var(--pastel-mint); color: var(--accent-mint); }
        .status-cancelado { background: var(--pastel-coral); color: var(--accent-coral); }

        .feed-time { font-size: 10px; color: var(--text-tertiary); font-weight: 600; }

        .alert-badge {
            font-size: 9px;
            font-weight: 700;
            color: var(--accent-coral);
            background: white;
            padding: 2px 6px;
            border-radius: 10px;
        }

        /* TOP PRODUCTS */
        .product-list { display: flex; flex-direction: column; gap: 6px; }

        .product-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 10px;
            background: var(--bg-soft);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-light);
            transition: all 0.2s ease;
        }

        .product-item:hover {
            background: var(--surface);
            box-shadow: var(--shadow-sm);
            transform: translateX(2px);
        }

        .product-rank {
            width: 24px;
            height: 24px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'DM Sans', sans-serif;
            font-size: 11px;
            font-weight: 700;
            background: white;
            color: var(--text-tertiary);
            flex-shrink: 0;
            border: 1px solid var(--border-light);
        }

        .product-rank.gold { background: #fff8e1; color: #f9a825; border-color: #ffe082; }
        .product-rank.silver { background: #eceff1; color: #607d8b; border-color: #cfd8dc; }
        .product-rank.bronze { background: #fff3e0; color: #e65100; border-color: #ffcc80; }

        .product-info { flex: 1; min-width: 0; }

        .product-name {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .product-cat {
            font-size: 9px;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.03em;
            font-weight: 600;
        }

        .sparkline {
            display: flex;
            align-items: flex-end;
            gap: 2px;
            height: 18px;
            margin-right: 6px;
        }

        .spark-bar { width: 3px; border-radius: 1px; }
        .sparkline.up .spark-bar { background: var(--pastel-mint-dark); }
        .sparkline.down .spark-bar { background: var(--pastel-coral-dark); }

        .product-trend { font-size: 11px; font-weight: 700; }
        .product-trend.up { color: var(--accent-mint); }
        .product-trend.down { color: var(--accent-coral); }

        .product-sold { font-size: 11px; font-weight: 700; color: var(--text-secondary); }

        /* QUICK STATS */
        .quick-stats { display: flex; flex-direction: column; gap: 8px; }

        .quick-stat {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            background: var(--bg-soft);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-light);
            transition: all 0.2s ease;
        }

        .quick-stat:hover {
            background: var(--surface);
            box-shadow: var(--shadow-sm);
            transform: translateY(-2px);
        }

        .quick-stat-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .quick-stat-icon .material-symbols-rounded { font-size: 18px; }

        .quick-stat-info { flex: 1; }

        .quick-stat-label {
            font-size: 10px;
            color: var(--text-tertiary);
            font-weight: 600;
            margin-bottom: 2px;
        }

        .quick-stat-value {
            font-family: 'DM Sans', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1;
        }

        /* DATA TABLE */
        .data-table { width: 100%; border-collapse: separate; border-spacing: 0; }

        .data-table th {
            text-align: left;
            padding: 6px 0;
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-tertiary);
            border-bottom: 1.5px solid var(--border-light);
        }

        .data-table td {
            padding: 8px 0;
            font-size: 12px;
            color: var(--text-primary);
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
        }

        .data-table tr:last-child td { border-bottom: none; }
        .data-table tbody tr { transition: all 0.15s ease; }
        .data-table tbody tr:hover { background: var(--bg-soft); }

        .user-cell { display: flex; align-items: center; gap: 8px; }

        .user-avatar-sm {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 11px;
            flex-shrink: 0;
        }

        .user-avatar-sm img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .user-info { min-width: 0; }

        .user-name {
            font-weight: 700;
            color: var(--text-primary);
            font-size: 12px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .user-email { font-size: 10px; color: var(--text-tertiary); }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 3px;
            padding: 3px 10px;
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            border-radius: 10px;
        }

        .sp-success { background: var(--pastel-mint); color: var(--accent-mint); }
        .sp-warning { background: var(--pastel-cream); color: var(--accent-cream); }
        .sp-info { background: var(--pastel-sky); color: var(--accent-sky); }
        .sp-primary { background: var(--pastel-lavender); color: var(--accent-lavender); }
        .sp-error { background: var(--pastel-coral); color: var(--accent-coral); }

        /* ANIMATIONS */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .anim-fade-up {
            animation: fadeUp 0.5s ease forwards;
            opacity: 0;
        }

        .delay-1 { animation-delay: 0.04s; }
        .delay-2 { animation-delay: 0.08s; }
        .delay-3 { animation-delay: 0.12s; }
        .delay-4 { animation-delay: 0.16s; }

        .stagger-children > * {
            opacity: 0;
            animation: fadeUp 0.4s ease forwards;
        }

        .stagger-children > *:nth-child(1) { animation-delay: 0.03s; }
        .stagger-children > *:nth-child(2) { animation-delay: 0.06s; }
        .stagger-children > *:nth-child(3) { animation-delay: 0.09s; }
        .stagger-children > *:nth-child(4) { animation-delay: 0.12s; }
        .stagger-children > *:nth-child(5) { animation-delay: 0.15s; }

        /* RESPONSIVE */
        @media (max-width: 1280px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .dashboard-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .main-content { padding: 12px 16px; }
            .kpi-grid { grid-template-columns: 1fr; }
            .welcome-section { flex-direction: column; gap: 12px; text-align: center; }
            .avatar-info { text-align: center; }
            .right-sidebar { width: 280px; min-width: 280px; }
        }

        ::-webkit-scrollbar { width: 4px; height: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }
    </style>
</head>
<body>
<div class="layout-wrapper">
<%@ include file="/includes/sidebar.jsp" %>

    <!-- MAIN CONTENT -->
    <main class="main-content sidebar-open" id="mainContent">
        <!-- Welcome Section - Elegante -->
        <div class="welcome-section anim-fade-up">
            <div class="welcome-content">
                <h1 class="welcome-title">Welcome back, <span><%= nombreUsuario %></span>!</h1>
                <p class="welcome-subtitle">Here's what's happening in your dashboard today.</p>
            </div>
            <div class="welcome-actions">
                <button class="toggle-orders-btn" id="toggleOrdersBtn" onclick="toggleSidebar()">
                    <span class="material-symbols-rounded">notifications_active</span>
                    <span class="toggle-label">Live Orders</span>
                    <span class="material-symbols-rounded toggle-icon" id="toggleIcon">chevron_left</span>
                </button>
                <div class="welcome-avatar">
                    <div class="avatar-info">
                        <div class="avatar-name"><%= nombreUsuario %></div>
                        <div class="avatar-role"><%= rolUsuario %></div>
                    </div>
                    <div class="avatar-ring">
                        <img src="https://ui-avatars.com/api/?name=<%= nombreUsuario %>&background=random&color=fff&size=128" alt="<%= nombreUsuario %>">
                    </div>
                </div>
            </div>
        </div>

        <!-- KPIs -->
        <div class="kpi-grid">
            <div class="kpi-card sky anim-fade-up delay-1">
                <div class="kpi-header">
                    <span class="kpi-label">Total Usuarios</span>
                    <div class="kpi-icon sky">
                        <span class="material-symbols-rounded">group</span>
                    </div>
                </div>
                <div class="kpi-value"><%= String.format("%,d", totalUsuarios) %></div>
                <div class="kpi-trend up">
                    <span class="material-symbols-rounded">trending_up</span>
                    +<%= nuevosHoy %> hoy
                </div>
            </div>

            <div class="kpi-card mint anim-fade-up delay-2">
                <div class="kpi-header">
                    <span class="kpi-label">Productos</span>
                    <div class="kpi-icon mint">
                        <span class="material-symbols-rounded">inventory_2</span>
                    </div>
                </div>
                <div class="kpi-value"><%= String.format("%,d", totalProductos) %></div>
                <div class="kpi-trend <%= productosBajos > 0 ? "down" : "up" %>">
                    <span class="material-symbols-rounded"><%= productosBajos > 0 ? "trending_down" : "trending_up" %></span>
                    <%= productosBajos %> bajo stock
                </div>
            </div>

            <div class="kpi-card lavender anim-fade-up delay-3">
                <div class="kpi-header">
                    <span class="kpi-label">Pedidos del Mes</span>
                    <div class="kpi-icon lavender">
                        <span class="material-symbols-rounded">shopping_bag</span>
                    </div>
                </div>
                <div class="kpi-value"><%= String.format("%,d", totalPedidos) %></div>
                <div class="kpi-trend <%= tendenciaPedidos >= 0 ? "up" : "down" %>">
                    <span class="material-symbols-rounded"><%= tendenciaPedidos >= 0 ? "trending_up" : "trending_down" %></span>
                    <%= String.format("%.1f", Math.abs(tendenciaPedidos)) %>%
                </div>
            </div>

            <div class="kpi-card cream anim-fade-up delay-4">
                <div class="kpi-header">
                    <span class="kpi-label">Ingresos</span>
                    <div class="kpi-icon cream">
                        <span class="material-symbols-rounded">payments</span>
                    </div>
                </div>
                <div class="kpi-value">$<%= String.format("%,.0f", ingresosMes) %></div>
                <div class="kpi-trend <%= tendenciaIngresos >= 0 ? "up" : "down" %>">
                    <span class="material-symbols-rounded"><%= tendenciaIngresos >= 0 ? "trending_up" : "trending_down" %></span>
                    <%= String.format("%.1f", Math.abs(tendenciaIngresos)) %>%
                </div>
            </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            <!-- Left Column -->
            <div class="dashboard-left">
                <!-- Heatmap Compacto -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Activity Heatmap</h3>
                            <p>Traffic last 7 days</p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn"><span class="material-symbols-rounded">filter_list</span></button>
                            <button class="icon-btn"><span class="material-symbols-rounded">more_vert</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="heatmap-container">
                            <div class="heatmap-grid">
                                <div></div>
                                <% for (int h = 0; h < 24; h += 3) { %><div class="heatmap-hour" style="grid-column:<%= h + 2 %>"><%= h %>h</div><% } %>
                                <% String[] dias = {"Dom","Lun","Mar","Mié","Jue","Vie","Sáb"};
                                int[][] matriz = new int[7][24]; int heatMax = 1;
                                if (heatmap != null) { for (Map<String, Object> f : heatmap) { int d = (Integer)f.get("dia"); int h = (Integer)f.get("hora"); int t = (Integer)f.get("total"); if (d>=0&&d<7&&h>=0&&h<24){matriz[d][h]+=t; if(matriz[d][h]>heatMax)heatMax=matriz[d][h];} } }
                                for (int d = 0; d < 7; d++) { %>
                                    <div class="heatmap-label"><%= dias[d] %></div>
                                    <% for (int h = 0; h < 24; h++) { int v = matriz[d][h]; int inten = v==0?0:Math.min(5,(int)Math.ceil((double)v/heatMax*5)); %>
                                        <div class="heatmap-cell hc-<%= inten %>" data-tip="<%= dias[d] %> <%= h %>:00 — <%= v %> actividades"></div>
                                    <% } %>
                                <% } %>
                            </div>
                        </div>
                        <div class="heatmap-legend">
                            <span>Less</span>
                            <% for (int i=0;i<=5;i++){%><div class="legend-box hc-<%= i %>"></div><%}%>
                            <span>More</span>
                        </div>
                    </div>
                </div>

                <!-- Activity Table -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Recent Activity</h3>
                            <p>Latest movements</p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn"><span class="material-symbols-rounded">filter_list</span></button>
                            <button class="icon-btn"><span class="material-symbols-rounded">open_in_new</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Action</th>
                                    <th>Status</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody class="stagger-children">
                                <% if (actividadReciente != null && !actividadReciente.isEmpty()) { for (Map<String, Object> act : actividadReciente) { String avatar=(String)act.get("avatar"); String estado=(String)act.get("estado"); String bc="sp-info"; if("completado".equalsIgnoreCase(estado)||"entregado".equalsIgnoreCase(estado))bc="sp-success"; else if("pendiente".equalsIgnoreCase(estado))bc="sp-warning"; else if("cancelado".equalsIgnoreCase(estado))bc="sp-primary"; %>
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar-sm">
                                                <% if(avatar!=null&&!avatar.isEmpty()){%><img src="<%= avatar %>" alt=""><%}else{%><span><%= ((String)act.get("usuario")).substring(0,1).toUpperCase() %></span><%}%>
                                            </div>
                                            <div class="user-info">
                                                <div class="user-name"><%= act.get("usuario") %></div>
                                                <div class="user-email"><%= act.get("email") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%= act.get("accion") %></td>
                                    <td><span class="status-pill <%= bc %>"><%= estado %></span></td>
                                    <td style="color:var(--text-tertiary);font-weight:600;font-size:10px;"><%= act.get("tiempo") %></td>
                                </tr>
                                <% }} else { %><tr><td colspan="4" style="text-align:center;color:var(--text-tertiary);padding:20px;font-size:11px;">No recent activity</td></tr><% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="dashboard-right">
                <!-- Top Products -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Top Products</h3>
                            <p>Best sellers this week</p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn"><span class="material-symbols-rounded">trending_up</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="product-list stagger-children">
                            <% if (topProducts != null && !topProducts.isEmpty()) { int rk = 1; for (Map<String, Object> prod : topProducts) { List<Integer> tend = (List<Integer>)prod.get("tendencia"); String dir = (String)prod.get("tendenciaDireccion"); int maxT = 1; if (tend!=null) for (Integer v:tend) if (v>maxT) maxT=v; String rankClass = rk==1?"gold":(rk==2?"silver":(rk==3?"bronze":"")); %>
                            <div class="product-item">
                                <div class="product-rank <%= rankClass %>"><%= rk %></div>
                                <div class="product-info">
                                    <div class="product-name"><%= prod.get("nombre") %></div>
                                    <div class="product-cat"><%= prod.get("categoria")!=null?prod.get("categoria"):"Category" %></div>
                                </div>
                                <div class="sparkline <%= dir %>">
                                    <% if (tend!=null){for(Integer v:tend){int h=maxT>0?(int)((double)v/maxT*16)+2:2;%>
                                        <div class="spark-bar" style="height:<%= h %>px;"></div>
                                    <%}}%>
                                </div>
                                <span class="product-trend <%= dir %>">
                                    <span class="material-symbols-rounded" style="font-size:13px;"><%= "up".equals(dir)?"trending_up":"trending_down" %></span>
                                </span>
                                <span class="product-sold"><%= prod.get("totalVendido") %></span>
                            </div>
                            <% rk++; }} else { %><div style="text-align:center;padding:20px;color:var(--text-tertiary);font-size:11px;">No sales data</div><% } %>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Quick Stats</h3>
                            <p>Key metrics</p>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="quick-stats stagger-children">
                            <div class="quick-stat">
                                <div class="quick-stat-icon" style="background:var(--pastel-sky);">
                                    <span class="material-symbols-rounded" style="color:var(--accent-sky);">trending_up</span>
                                </div>
                                <div class="quick-stat-info">
                                    <div class="quick-stat-label">Sales Today</div>
                                    <div class="quick-stat-value">$<%= String.format("%,.0f", ingresosMes/30) %></div>
                                </div>
                            </div>
                            <div class="quick-stat">
                                <div class="quick-stat-icon" style="background:var(--pastel-mint);">
                                    <span class="material-symbols-rounded" style="color:var(--accent-mint);">group</span>
                                </div>
                                <div class="quick-stat-info">
                                    <div class="quick-stat-label">New Users</div>
                                    <div class="quick-stat-value">+<%= nuevosHoy %> today</div>
                                </div>
                            </div>
                            <div class="quick-stat">
                                <div class="quick-stat-icon" style="background:var(--pastel-cream);">
                                    <span class="material-symbols-rounded" style="color:var(--accent-cream);">inventory_2</span>
                                </div>
                                <div class="quick-stat-info">
                                    <div class="quick-stat-label">Low Stock</div>
                                    <div class="quick-stat-value"><%= productosBajos %> products</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- RIGHT SIDEBAR FIJO - Toggleable -->
    <aside class="right-sidebar" id="rightSidebar">
        <div class="sidebar-header">
            <div class="sidebar-title">
                <span class="material-symbols-rounded" style="color:var(--accent-sky);font-size:20px;">notifications_active</span>
                Live Orders
            </div>
            <button class="sidebar-close" onclick="toggleSidebar()">
                <span class="material-symbols-rounded" style="font-size:16px;">close</span>
            </button>
        </div>

        <div class="feed-list stagger-children">
            <% if (livefeed != null && !livefeed.isEmpty()) { for (Map<String, Object> p : livefeed) { boolean alerta = p.get("alerta")!=null?(Boolean)p.get("alerta"):false; String av=(String)p.get("usuarioAvatar"); %>
            <div class="feed-item <%= alerta?"alert":"" %>">
                <div class="feed-avatar">
                    <% if (av!=null&&!av.isEmpty()){%><img src="<%= av %>" alt=""><%}else{%><span><%= ((String)p.get("usuarioNombre")).substring(0,1).toUpperCase() %></span><%}%>
                </div>
                <div class="feed-content">
                    <div class="feed-header">
                        <span class="feed-name"><%= p.get("usuarioNombre") %></span>
                        <span class="feed-amount">$<%= String.format("%,.0f",(Double)p.get("total")) %></span>
                    </div>
                    <div class="feed-product"><%= p.get("productoPrincipal")!=null?p.get("productoPrincipal"):"Producto" %></div>
                    <div class="feed-meta">
                        <span class="status-badge status-<%= ((String)p.get("estado")).toLowerCase() %>"><%= p.get("estado") %></span>
                        <span class="feed-time"><%= p.get("tiempoLegible") %></span>
                        <% if (alerta) {%><span class="alert-badge">+2h</span><%}%>
                    </div>
                </div>
            </div>
            <% }} else { %><div style="text-align:center;padding:30px 16px;color:var(--text-tertiary);font-size:12px;background:var(--bg-soft);border-radius:12px;border:1px dashed var(--border);">
                <span class="material-symbols-rounded" style="font-size:32px;color:var(--text-tertiary);margin-bottom:8px;display:block;">inbox</span>
                No recent orders
            </div><% } %>
        </div>
        
    </aside>


</div>
    <script>
        let sidebarOpen = true;

        function toggleSidebar() {
            const sidebar = document.getElementById('rightSidebar');
            const mainContent = document.getElementById('mainContent');
            const toggleBtn = document.getElementById('sidebarToggle');
            const ordersBtn = document.getElementById('toggleOrdersBtn');
            const toggleIcon = document.getElementById('toggleIcon');

            sidebarOpen = !sidebarOpen;

            if (sidebarOpen) {
                sidebar.classList.remove('hidden');
                mainContent.classList.remove('sidebar-closed');
                mainContent.classList.add('sidebar-open');
                if (toggleBtn) toggleBtn.classList.add('active');
                if (toggleBtn) toggleBtn.querySelector('.material-symbols-rounded').textContent = 'chevron_left';
                if (ordersBtn) ordersBtn.classList.add('active');
                if (toggleIcon) toggleIcon.textContent = 'chevron_left';
            } else {
                sidebar.classList.add('hidden');
                mainContent.classList.remove('sidebar-open');
                mainContent.classList.add('sidebar-closed');
                if (toggleBtn) toggleBtn.classList.remove('active');
                if (toggleBtn) toggleBtn.querySelector('.material-symbols-rounded').textContent = 'chevron_right';
                if (ordersBtn) ordersBtn.classList.remove('active');
                if (toggleIcon) toggleIcon.textContent = 'chevron_right';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -20px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.anim-fade-up').forEach(el => {
                observer.observe(el);
            });

            const kpiValues = document.querySelectorAll('.kpi-value');
            kpiValues.forEach(el => {
                const finalValue = el.textContent;
                const isMoney = finalValue.includes('$');
                const numericValue = parseFloat(finalValue.replace(/[^0-9.]/g, ''));

                if (!isNaN(numericValue)) {
                    let current = 0;
                    const increment = numericValue / 40;
                    const timer = setInterval(() => {
                        current += increment;
                        if (current >= numericValue) {
                            current = numericValue;
                            clearInterval(timer);
                        }
                        if (isMoney) {
                            el.textContent = '$' + Math.floor(current).toLocaleString();
                        } else {
                            el.textContent = Math.floor(current).toLocaleString();
                        }
                    }, 25);
                }
            });
        });
    </script>
</body>
</html>