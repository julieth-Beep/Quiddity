<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Página activa para resaltar en el sidebar
    request.setAttribute("activePage", "dashboard");

    // Datos de ejemplo para el dashboard (reemplazar con datos reales de BD)
    int totalUsuarios = 1248;
    int nuevosHoy = 23;
    int totalProductos = 456;
    int productosBajos = 12;
    int totalPedidos = 389;
    double ingresosMes = 28450.75;
    int citasHoy = 18;
    int citasPendientes = 7;

    // Simulación de usuario en sesión
    Object usuario = session.getAttribute("usuario");
    String nombreUsuario = "María García";
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
    <title>Dashboard | Belleza</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;600&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Material Symbols -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />

    <style>
        /* ═══════════════════════════════════════════════
           VARIABLES DEL TEMA
           ═══════════════════════════════════════════════ */
        :root {
            --primary: #9a3a5a;
            --primary-light: rgba(154, 58, 90, 0.08);
            --primary-medium: rgba(154, 58, 90, 0.15);
            --secondary: #516617;
            --tertiary: #88495a;
            --background: #ffffff;
            --surface: #ffffff;
            --on-surface: #1c1b1d;
            --on-surface-variant: #544246;
            --outline: #877276;
            --surface-container-low: #ffffff;
            --surface-container-lowest: #ffffff;
            --surface-variant: #f1ecef;
            --surface-variant-hover: #e8e3e6;
            --success: #516617;
            --warning: #c47e00;
            --error: #b3261e;
            --element-gap: 24px;
            --gutter: 32px;
            --section-gap: 120px;
            --radius: 0px;
            --radius-full: 9999px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Manrope', sans-serif;
            background: var(--background);
            color: var(--on-surface);
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        /* ═══════════════════════════════════════════════
           LAYOUT CON SIDEBAR
           ═══════════════════════════════════════════════ */
        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            min-height: 100vh;
            background: var(--background);
        }

        /* ── Toggle móvil ── */
        .sidebar-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 998;
            width: 44px;
            height: 44px;
            background: var(--surface);
            border: 1px solid var(--surface-variant);
            color: var(--on-surface);
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        /* ═══════════════════════════════════════════════
           HEADER DEL DASHBOARD
           ═══════════════════════════════════════════════ */
        .dashboard-header {
            padding: 40px var(--gutter) 0;
            max-width: 1400px;
            margin: 0 auto;
        }

        .header-breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--outline);
            letter-spacing: 0.02em;
            margin-bottom: 16px;
        }

        .header-breadcrumb .material-symbols-outlined {
            font-size: 16px;
        }

        .header-breadcrumb a {
            color: var(--outline);
            text-decoration: none;
            transition: color 0.2s;
        }

        .header-breadcrumb a:hover {
            color: var(--primary);
        }

        .header-title-row {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: var(--element-gap);
            flex-wrap: wrap;
            margin-bottom: 40px;
        }

        .header-title h1 {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 48px;
            font-weight: 400;
            line-height: 56px;
            color: var(--on-surface);
            margin-bottom: 8px;
        }

        .header-subtitle {
            font-size: 16px;
            color: var(--on-surface-variant);
            line-height: 24px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            line-height: 20px;
        }

        .btn-primary {
            background: var(--primary);
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #7a2e48;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(154, 58, 90, 0.25);
        }

        .btn-secondary {
            background: var(--surface-variant);
            color: var(--on-surface);
            border: 1px solid var(--outline);
        }

        .btn-secondary:hover {
            background: var(--surface-variant-hover);
        }

        .btn .material-symbols-outlined {
            font-size: 18px;
        }

        /* ═══════════════════════════════════════════════
           KPI CARDS
           ═══════════════════════════════════════════════ */
        .kpi-section {
            padding: 0 var(--gutter) 48px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: var(--element-gap);
        }

        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--surface-variant);
            padding: 28px;
            position: relative;
            overflow: hidden;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .kpi-card:hover {
            border-color: var(--outline);
            box-shadow: 0 4px 20px rgba(28, 27, 29, 0.06);
        }

        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 3px;
            height: 100%;
            background: var(--primary);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .kpi-card:hover::before {
            opacity: 1;
        }

        .kpi-card.success::before { background: var(--success); }
        .kpi-card.warning::before { background: var(--warning); }
        .kpi-card.info::before { background: var(--tertiary); }

        .kpi-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .kpi-label {
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--outline);
            line-height: 20px;
        }

        .kpi-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-light);
        }

        .kpi-icon .material-symbols-outlined {
            font-size: 22px;
            color: var(--primary);
        }

        .kpi-card.success .kpi-icon { background: rgba(81, 102, 23, 0.08); }
        .kpi-card.success .kpi-icon .material-symbols-outlined { color: var(--success); }
        .kpi-card.warning .kpi-icon { background: rgba(196, 126, 0, 0.08); }
        .kpi-card.warning .kpi-icon .material-symbols-outlined { color: var(--warning); }
        .kpi-card.info .kpi-icon { background: rgba(136, 73, 90, 0.08); }
        .kpi-card.info .kpi-icon .material-symbols-outlined { color: var(--tertiary); }

        .kpi-value {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 40px;
            font-weight: 400;
            line-height: 48px;
            color: var(--on-surface);
            margin-bottom: 12px;
        }

        .kpi-trend {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .kpi-trend.up {
            color: var(--success);
        }

        .kpi-trend.down {
            color: var(--error);
        }

        .kpi-trend .material-symbols-outlined {
            font-size: 16px;
        }

        /* ═══════════════════════════════════════════════
           SECCIONES DEL DASHBOARD
           ═══════════════════════════════════════════════ */
        .dashboard-section {
            padding: 0 var(--gutter) 48px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .section-title {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 32px;
            font-weight: 400;
            line-height: 40px;
            color: var(--on-surface);
        }

        .section-link {
            font-size: 14px;
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: gap 0.2s;
        }

        .section-link:hover {
            gap: 8px;
        }

        .section-link .material-symbols-outlined {
            font-size: 18px;
        }

        /* ═══════════════════════════════════════════════
           GRID DE CONTENIDO
           ═══════════════════════════════════════════════ */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--element-gap);
        }

        .content-grid.reverse {
            grid-template-columns: 1fr 2fr;
        }

        .content-grid.equal {
            grid-template-columns: 1fr 1fr;
        }

        /* ═══════════════════════════════════════════════
           CARDS / PANELES
           ═══════════════════════════════════════════════ */
        .panel {
            background: var(--surface);
            border: 1px solid var(--surface-variant);
            overflow: hidden;
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 24px 28px;
            border-bottom: 1px solid var(--surface-variant);
        }

        .panel-title {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 24px;
            font-weight: 400;
            line-height: 32px;
            color: var(--on-surface);
        }

        .panel-actions {
            display: flex;
            gap: 8px;
        }

        .panel-action-btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: none;
            border: 1px solid var(--surface-variant);
            color: var(--on-surface-variant);
            cursor: pointer;
            transition: all 0.2s;
        }

        .panel-action-btn:hover {
            background: var(--surface-variant);
            color: var(--on-surface);
        }

        .panel-action-btn .material-symbols-outlined {
            font-size: 18px;
        }

        .panel-body {
            padding: 24px 28px;
        }

        /* ═══════════════════════════════════════════════
           TABLA DE ACTIVIDAD
           ═══════════════════════════════════════════════ */
        .activity-table {
            width: 100%;
            border-collapse: collapse;
        }

        .activity-table th {
            text-align: left;
            padding: 12px 0;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--outline);
            border-bottom: 1px solid var(--surface-variant);
        }

        .activity-table td {
            padding: 16px 0;
            font-size: 14px;
            color: var(--on-surface);
            border-bottom: 1px solid var(--surface-variant);
            vertical-align: middle;
        }

        .activity-table tr:last-child td {
            border-bottom: none;
        }

        .activity-user {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .activity-avatar {
            width: 36px;
            height: 36px;
            border-radius: var(--radius-full);
            background: var(--surface-variant);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .activity-avatar .material-symbols-outlined {
            font-size: 18px;
            color: var(--primary);
        }

        .activity-user-info {
            min-width: 0;
        }

        .activity-user-name {
            font-weight: 600;
            color: var(--on-surface);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .activity-user-email {
            font-size: 12px;
            color: var(--outline);
        }

        .activity-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .badge-success {
            background: rgba(81, 102, 23, 0.08);
            color: var(--success);
        }

        .badge-warning {
            background: rgba(196, 126, 0, 0.08);
            color: var(--warning);
        }

        .badge-info {
            background: rgba(136, 73, 90, 0.08);
            color: var(--tertiary);
        }

        .badge-primary {
            background: var(--primary-light);
            color: var(--primary);
        }

        .activity-time {
            font-size: 13px;
            color: var(--outline);
        }

        /* ═══════════════════════════════════════════════
           LISTA DE TAREAS / CITAS
           ═══════════════════════════════════════════════ */
        .task-list {
            list-style: none;
        }

        .task-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid var(--surface-variant);
        }

        .task-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .task-item:first-child {
            padding-top: 0;
        }

        .task-checkbox {
            width: 20px;
            height: 20px;
            border: 2px solid var(--outline);
            flex-shrink: 0;
            margin-top: 2px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .task-checkbox:hover {
            border-color: var(--primary);
        }

        .task-checkbox.checked {
            background: var(--primary);
            border-color: var(--primary);
        }

        .task-checkbox.checked .material-symbols-outlined {
            font-size: 14px;
            color: #ffffff;
            display: block;
        }

        .task-checkbox .material-symbols-outlined {
            display: none;
        }

        .task-content {
            flex: 1;
            min-width: 0;
        }

        .task-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--on-surface);
            margin-bottom: 4px;
        }

        .task-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 12px;
            color: var(--outline);
        }

        .task-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .task-meta .material-symbols-outlined {
            font-size: 14px;
        }

        .task-priority {
            width: 8px;
            height: 8px;
            flex-shrink: 0;
            margin-top: 8px;
        }

        .priority-high { background: var(--error); }
        .priority-medium { background: var(--warning); }
        .priority-low { background: var(--success); }

        /* ═══════════════════════════════════════════════
           GRÁFICO DE BARRAS (CSS puro)
           ═══════════════════════════════════════════════ */
        .chart-container {
            padding: 20px 0;
        }

        .chart-bars {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 12px;
            height: 200px;
            padding-bottom: 40px;
            border-bottom: 1px solid var(--surface-variant);
            position: relative;
        }

        .chart-bar-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .chart-bar {
            width: 100%;
            max-width: 48px;
            background: var(--surface-variant);
            transition: background 0.3s, height 0.6s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
            cursor: pointer;
        }

        .chart-bar:hover {
            background: var(--primary);
        }

        .chart-bar::after {
            content: attr(data-value);
            position: absolute;
            top: -24px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 12px;
            font-weight: 600;
            color: var(--on-surface);
            opacity: 0;
            transition: opacity 0.2s;
        }

        .chart-bar:hover::after {
            opacity: 1;
        }

        .chart-label {
            font-size: 12px;
            color: var(--outline);
            font-weight: 500;
        }

        .chart-legend {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 24px;
            margin-top: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--on-surface-variant);
        }

        .legend-dot {
            width: 10px;
            height: 10px;
        }

        .legend-dot.primary { background: var(--primary); }
        .legend-dot.secondary { background: var(--secondary); }

        /* ═══════════════════════════════════════════════
           PRODUCTOS DESTACADOS
           ═══════════════════════════════════════════════ */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .product-card {
            border: 1px solid var(--surface-variant);
            overflow: hidden;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .product-card:hover {
            border-color: var(--outline);
            box-shadow: 0 4px 16px rgba(28, 27, 29, 0.06);
        }

        .product-image {
            width: 100%;
            height: 160px;
            background: var(--surface-variant);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-image .material-symbols-outlined {
            font-size: 48px;
            color: var(--outline);
        }

        .product-info {
            padding: 16px 20px 20px;
        }

        .product-category {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--primary);
            margin-bottom: 6px;
        }

        .product-name {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 18px;
            font-weight: 400;
            line-height: 24px;
            color: var(--on-surface);
            margin-bottom: 8px;
        }

        .product-price {
            font-size: 16px;
            font-weight: 700;
            color: var(--on-surface);
        }

        .product-stock {
            font-size: 12px;
            color: var(--outline);
            margin-top: 4px;
        }

        /* ═══════════════════════════════════════════════
           CALENDARIO MINI
           ═══════════════════════════════════════════════ */
        .mini-calendar {
            width: 100%;
        }

        .calendar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .calendar-month {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 20px;
            font-weight: 400;
            color: var(--on-surface);
        }

        .calendar-nav {
            display: flex;
            gap: 4px;
        }

        .calendar-nav-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: none;
            border: 1px solid var(--surface-variant);
            color: var(--on-surface-variant);
            cursor: pointer;
            transition: all 0.2s;
        }

        .calendar-nav-btn:hover {
            background: var(--surface-variant);
            color: var(--on-surface);
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
        }

        .calendar-day-header {
            text-align: center;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--outline);
            padding: 8px 0;
        }

        .calendar-day {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 500;
            color: var(--on-surface);
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }

        .calendar-day:hover {
            background: var(--surface-variant);
        }

        .calendar-day.today {
            background: var(--primary);
            color: #ffffff;
            font-weight: 600;
        }

        .calendar-day.has-event::after {
            content: '';
            position: absolute;
            bottom: 4px;
            width: 4px;
            height: 4px;
            border-radius: var(--radius-full);
            background: var(--primary);
        }

        .calendar-day.today.has-event::after {
            background: #ffffff;
        }

        .calendar-day.other-month {
            color: var(--outline);
        }

        /* ═══════════════════════════════════════════════
           NOTIFICACIONES
           ═══════════════════════════════════════════════ */
        .notification-list {
            list-style: none;
        }

        .notification-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 16px 0;
            border-bottom: 1px solid var(--surface-variant);
        }

        .notification-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .notification-item:first-child {
            padding-top: 0;
        }

        .notification-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .notification-icon .material-symbols-outlined {
            font-size: 20px;
        }

        .notification-icon.primary { background: var(--primary-light); }
        .notification-icon.primary .material-symbols-outlined { color: var(--primary); }
        .notification-icon.success { background: rgba(81, 102, 23, 0.08); }
        .notification-icon.success .material-symbols-outlined { color: var(--success); }
        .notification-icon.warning { background: rgba(196, 126, 0, 0.08); }
        .notification-icon.warning .material-symbols-outlined { color: var(--warning); }

        .notification-content {
            flex: 1;
        }

        .notification-text {
            font-size: 14px;
            color: var(--on-surface);
            line-height: 20px;
            margin-bottom: 4px;
        }

        .notification-text strong {
            font-weight: 600;
        }

        .notification-time {
            font-size: 12px;
            color: var(--outline);
        }

        /* ═══════════════════════════════════════════════
           FOOTER
           ═══════════════════════════════════════════════ */
        .dashboard-footer {
            padding: 32px var(--gutter);
            max-width: 1400px;
            margin: 0 auto;
            border-top: 1px solid var(--surface-variant);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
            color: var(--outline);
        }

        .footer-links {
            display: flex;
            gap: 24px;
        }

        .footer-links a {
            color: var(--outline);
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        /* ═══════════════════════════════════════════════
           ANIMACIONES
           ═══════════════════════════════════════════════ */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-in {
            animation: fadeInUp 0.6s cubic-bezier(0.22, 1, 0.36, 1) forwards;
            opacity: 0;
        }

        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        .delay-3 { animation-delay: 0.3s; }
        .delay-4 { animation-delay: 0.4s; }
        .delay-5 { animation-delay: 0.5s; }

        /* ═══════════════════════════════════════════════
           RESPONSIVE
           ═══════════════════════════════════════════════ */
        @media (max-width: 1200px) {
            .kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .content-grid,
            .content-grid.reverse,
            .content-grid.equal {
                grid-template-columns: 1fr;
            }
            .product-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
            .sidebar-toggle {
                display: flex;
            }
        }

        @media (max-width: 768px) {
            .kpi-grid {
                grid-template-columns: 1fr;
            }
            .header-title h1 {
                font-size: 32px;
                line-height: 40px;
            }
            .header-actions {
                width: 100%;
            }
            .btn {
                flex: 1;
                justify-content: center;
            }
            .product-grid {
                grid-template-columns: 1fr;
            }
            .dashboard-footer {
                flex-direction: column;
                gap: 12px;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .dashboard-header,
            .kpi-section,
            .dashboard-section,
            .dashboard-footer {
                padding-left: 20px;
                padding-right: 20px;
            }
        }
    </style>
</head>
<body>

    <!-- Botón hamburguesa para móvil -->
    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()">
        <span class="material-symbols-outlined">menu</span>
    </button>

    <div class="layout-wrapper">
        <!-- Sidebar -->
        <%@ include file="/includes/sidebar.jsp" %>

        <!-- Contenido Principal -->
        <main class="main-content">

            <!-- ═══════════════════════════════════════════════
                 HEADER
                 ═══════════════════════════════════════════════ -->
            <header class="dashboard-header animate-in">
                <nav class="header-breadcrumb">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp">Inicio</a>
                    <span class="material-symbols-outlined">chevron_right</span>
                    <span>Dashboard</span>
                </nav>

                <div class="header-title-row">
                    <div class="header-title">
                        <h1>Panel de Control</h1>
                        <p class="header-subtitle">
                            Bienvenida de vuelta, <strong><%= nombreUsuario %></strong>. 
                            Aquí tienes un resumen de la actividad de hoy.
                        </p>
                    </div>
                    <div class="header-actions">
                        <a href="${pageContext.request.contextPath}/admin/reportes.jsp" class="btn btn-secondary">
                            <span class="material-symbols-outlined">download</span>
                            Exportar
                        </a>
                        <a href="${pageContext.request.contextPath}/usuario/caracteristicas.jsp" class="btn btn-primary">
                            <span class="material-symbols-outlined">add</span>
                            Nueva Cita
                        </a>
                    </div>
                </div>
            </header>

            <!-- ═══════════════════════════════════════════════
                 KPI CARDS
                 ═══════════════════════════════════════════════ -->
            <section class="kpi-section">
                <div class="kpi-grid">
                    <!-- Usuarios -->
                    <article class="kpi-card animate-in delay-1">
                        <div class="kpi-header">
                            <span class="kpi-label">Total Usuarios</span>
                            <div class="kpi-icon">
                                <span class="material-symbols-outlined">group</span>
                            </div>
                        </div>
                        <div class="kpi-value"><%= String.format("%,d", totalUsuarios) %></div>
                        <div class="kpi-trend up">
                            <span class="material-symbols-outlined">trending_up</span>
                            +<%= nuevosHoy %> hoy
                        </div>
                    </article>

                    <!-- Productos -->
                    <article class="kpi-card success animate-in delay-2">
                        <div class="kpi-header">
                            <span class="kpi-label">Productos</span>
                            <div class="kpi-icon">
                                <span class="material-symbols-outlined">inventory_2</span>
                            </div>
                        </div>
                        <div class="kpi-value"><%= String.format("%,d", totalProductos) %></div>
                        <div class="kpi-trend down">
                            <span class="material-symbols-outlined">trending_down</span>
                            <%= productosBajos %> bajo stock
                        </div>
                    </article>

                    <!-- Pedidos -->
                    <article class="kpi-card warning animate-in delay-3">
                        <div class="kpi-header">
                            <span class="kpi-label">Pedidos del Mes</span>
                            <div class="kpi-icon">
                                <span class="material-symbols-outlined">shopping_bag</span>
                            </div>
                        </div>
                        <div class="kpi-value"><%= String.format("%,d", totalPedidos) %></div>
                        <div class="kpi-trend up">
                            <span class="material-symbols-outlined">trending_up</span>
                            +12% vs mes pasado
                        </div>
                    </article>

                    <!-- Ingresos -->
                    <article class="kpi-card info animate-in delay-4">
                        <div class="kpi-header">
                            <span class="kpi-label">Ingresos</span>
                            <div class="kpi-icon">
                                <span class="material-symbols-outlined">payments</span>
                            </div>
                        </div>
                        <div class="kpi-value">$<%= String.format("%,.0f", ingresosMes) %></div>
                        <div class="kpi-trend up">
                            <span class="material-symbols-outlined">trending_up</span>
                            +8.5% vs mes pasado
                        </div>
                    </article>
                </div>
            </section>

            <!-- ═══════════════════════════════════════════════
                 GRID PRINCIPAL: Actividad + Calendario
                 ═══════════════════════════════════════════════ -->
            <section class="dashboard-section">
                <div class="content-grid">
                    <!-- Panel de Actividad Reciente -->
                    <article class="panel animate-in delay-2">
                        <div class="panel-header">
                            <h2 class="panel-title">Actividad Reciente</h2>
                            <div class="panel-actions">
                                <button class="panel-action-btn" title="Filtrar">
                                    <span class="material-symbols-outlined">filter_list</span>
                                </button>
                                <button class="panel-action-btn" title="Ver todo">
                                    <span class="material-symbols-outlined">open_in_new</span>
                                </button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <table class="activity-table">
                                <thead>
                                    <tr>
                                        <th>Usuario</th>
                                        <th>Acción</th>
                                        <th>Estado</th>
                                        <th>Hora</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="activity-user">
                                                <div class="activity-avatar">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div class="activity-user-info">
                                                    <div class="activity-user-name">Laura Mendoza</div>
                                                    <div class="activity-user-email">laura@email.com</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Nueva cita agendada</td>
                                        <td><span class="activity-badge badge-success">Completado</span></td>
                                        <td class="activity-time">Hace 10 min</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="activity-user">
                                                <div class="activity-avatar">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div class="activity-user-info">
                                                    <div class="activity-user-name">Carlos Ruiz</div>
                                                    <div class="activity-user-email">carlos@email.com</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Compra de productos</td>
                                        <td><span class="activity-badge badge-primary">En proceso</span></td>
                                        <td class="activity-time">Hace 25 min</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="activity-user">
                                                <div class="activity-avatar">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div class="activity-user-info">
                                                    <div class="activity-user-name">Ana Torres</div>
                                                    <div class="activity-user-email">ana@email.com</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Registro de características</td>
                                        <td><span class="activity-badge badge-info">Nuevo</span></td>
                                        <td class="activity-time">Hace 1 hora</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="activity-user">
                                                <div class="activity-avatar">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div class="activity-user-info">
                                                    <div class="activity-user-name">Pedro Gómez</div>
                                                    <div class="activity-user-email">pedro@email.com</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Face Scan realizado</td>
                                        <td><span class="activity-badge badge-success">Completado</span></td>
                                        <td class="activity-time">Hace 2 horas</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="activity-user">
                                                <div class="activity-avatar">
                                                    <span class="material-symbols-outlined">person</span>
                                                </div>
                                                <div class="activity-user-info">
                                                    <div class="activity-user-name">Diana Flores</div>
                                                    <div class="activity-user-email">diana@email.com</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Estado de ánimo registrado</td>
                                        <td><span class="activity-badge badge-warning">Pendiente</span></td>
                                        <td class="activity-time">Hace 3 horas</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </article>

                    <!-- Panel de Calendario -->
                    <article class="panel animate-in delay-3">
                        <div class="panel-header">
                            <h2 class="panel-title">Calendario</h2>
                            <div class="panel-actions">
                                <button class="panel-action-btn" title="Agregar evento">
                                    <span class="material-symbols-outlined">add</span>
                                </button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="mini-calendar">
                                <div class="calendar-header">
                                    <span class="calendar-month">Junio 2026</span>
                                    <div class="calendar-nav">
                                        <button class="calendar-nav-btn">
                                            <span class="material-symbols-outlined">chevron_left</span>
                                        </button>
                                        <button class="calendar-nav-btn">
                                            <span class="material-symbols-outlined">chevron_right</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="calendar-grid">
                                    <div class="calendar-day-header">Dom</div>
                                    <div class="calendar-day-header">Lun</div>
                                    <div class="calendar-day-header">Mar</div>
                                    <div class="calendar-day-header">Mié</div>
                                    <div class="calendar-day-header">Jue</div>
                                    <div class="calendar-day-header">Vie</div>
                                    <div class="calendar-day-header">Sáb</div>

                                    <div class="calendar-day other-month">31</div>
                                    <div class="calendar-day">1</div>
                                    <div class="calendar-day">2</div>
                                    <div class="calendar-day has-event">3</div>
                                    <div class="calendar-day">4</div>
                                    <div class="calendar-day has-event">5</div>
                                    <div class="calendar-day">6</div>
                                    <div class="calendar-day">7</div>
                                    <div class="calendar-day has-event">8</div>
                                    <div class="calendar-day">9</div>
                                    <div class="calendar-day">10</div>
                                    <div class="calendar-day has-event">11</div>
                                    <div class="calendar-day">12</div>
                                    <div class="calendar-day">13</div>
                                    <div class="calendar-day">14</div>
                                    <div class="calendar-day has-event">15</div>
                                    <div class="calendar-day">16</div>
                                    <div class="calendar-day">17</div>
                                    <div class="calendar-day has-event">18</div>
                                    <div class="calendar-day">19</div>
                                    <div class="calendar-day">20</div>
                                    <div class="calendar-day">21</div>
                                    <div class="calendar-day has-event">22</div>
                                    <div class="calendar-day">23</div>
                                    <div class="calendar-day">24</div>
                                    <div class="calendar-day">25</div>
                                    <div class="calendar-day has-event">26</div>
                                    <div class="calendar-day">27</div>
                                    <div class="calendar-day">28</div>
                                    <div class="calendar-day">29</div>
                                    <div class="calendar-day has-event">30</div>
                                    <div class="calendar-day today has-event">2</div>
                                    <div class="calendar-day other-month">3</div>
                                    <div class="calendar-day other-month">4</div>
                                    <div class="calendar-day other-month">5</div>
                                    <div class="calendar-day other-month">6</div>
                                </div>
                            </div>

                            <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--surface-variant);">
                                <div style="font-size: 13px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--outline); margin-bottom: 12px;">
                                    Próximas Citas
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 12px;">
                                    <div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--surface-variant);">
                                        <div style="width: 40px; height: 40px; background: var(--primary); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 13px; font-weight: 600;">10:00</div>
                                        <div>
                                            <div style="font-weight: 600; font-size: 14px;">Facial Hidratante</div>
                                            <div style="font-size: 12px; color: var(--outline);">Laura Mendoza</div>
                                        </div>
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--surface-variant);">
                                        <div style="width: 40px; height: 40px; background: var(--tertiary); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 13px; font-weight: 600;">14:30</div>
                                        <div>
                                            <div style="font-weight: 600; font-size: 14px;">Masaje Relajante</div>
                                            <div style="font-size: 12px; color: var(--outline);">Carlos Ruiz</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>
                </div>
            </section>

            <!-- ═══════════════════════════════════════════════
                 GRID: Gráfico + Tareas
                 ═══════════════════════════════════════════════ -->
            <section class="dashboard-section">
                <div class="content-grid reverse">
                    <!-- Panel de Gráfico -->
                    <article class="panel animate-in delay-3">
                        <div class="panel-header">
                            <h2 class="panel-title">Ingresos Semanales</h2>
                            <div class="panel-actions">
                                <button class="panel-action-btn" title="Descargar">
                                    <span class="material-symbols-outlined">download</span>
                                </button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="chart-container">
                                <div class="chart-bars">
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 45%;" data-value="$3,240"></div>
                                        <span class="chart-label">Lun</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 62%;" data-value="$4,560"></div>
                                        <span class="chart-label">Mar</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 38%;" data-value="$2,890"></div>
                                        <span class="chart-label">Mié</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 75%;" data-value="$5,670"></div>
                                        <span class="chart-label">Jue</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 55%;" data-value="$4,120"></div>
                                        <span class="chart-label">Vie</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 88%;" data-value="$6,890"></div>
                                        <span class="chart-label">Sáb</span>
                                    </div>
                                    <div class="chart-bar-wrapper">
                                        <div class="chart-bar" style="height: 30%;" data-value="$2,100"></div>
                                        <span class="chart-label">Dom</span>
                                    </div>
                                </div>
                                <div class="chart-legend">
                                    <div class="legend-item">
                                        <div class="legend-dot primary"></div>
                                        <span>Ingresos</span>
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-dot secondary"></div>
                                        <span>Meta</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- Panel de Tareas -->
                    <article class="panel animate-in delay-4">
                        <div class="panel-header">
                            <h2 class="panel-title">Tareas Pendientes</h2>
                            <div class="panel-actions">
                                <button class="panel-action-btn" title="Nueva tarea">
                                    <span class="material-symbols-outlined">add</span>
                                </button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <ul class="task-list">
                                <li class="task-item">
                                    <div class="task-priority priority-high"></div>
                                    <div class="task-checkbox" onclick="this.classList.toggle('checked')">
                                        <span class="material-symbols-outlined">check</span>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title">Revisar inventario de productos</div>
                                        <div class="task-meta">
                                            <span><span class="material-symbols-outlined">schedule</span> Hoy, 16:00</span>
                                            <span><span class="material-symbols-outlined">inventory_2</span> Stock</span>
                                        </div>
                                    </div>
                                </li>
                                <li class="task-item">
                                    <div class="task-priority priority-medium"></div>
                                    <div class="task-checkbox" onclick="this.classList.toggle('checked')">
                                        <span class="material-symbols-outlined">check</span>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title">Confirmar citas de mañana</div>
                                        <div class="task-meta">
                                            <span><span class="material-symbols-outlined">schedule</span> Hoy, 18:00</span>
                                            <span><span class="material-symbols-outlined">event</span> Citas</span>
                                        </div>
                                    </div>
                                </li>
                                <li class="task-item">
                                    <div class="task-priority priority-low"></div>
                                    <div class="task-checkbox checked" onclick="this.classList.toggle('checked')">
                                        <span class="material-symbols-outlined">check</span>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title" style="text-decoration: line-through; color: var(--outline);">Actualizar catálogo de servicios</div>
                                        <div class="task-meta">
                                            <span><span class="material-symbols-outlined">schedule</span> Ayer</span>
                                            <span><span class="material-symbols-outlined">check_circle</span> Completado</span>
                                        </div>
                                    </div>
                                </li>
                                <li class="task-item">
                                    <div class="task-priority priority-high"></div>
                                    <div class="task-checkbox" onclick="this.classList.toggle('checked')">
                                        <span class="material-symbols-outlined">check</span>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title">Preparar reporte mensual</div>
                                        <div class="task-meta">
                                            <span><span class="material-symbols-outlined">schedule</span> Mañana, 09:00</span>
                                            <span><span class="material-symbols-outlined">description</span> Reportes</span>
                                        </div>
                                    </div>
                                </li>
                                <li class="task-item">
                                    <div class="task-priority priority-medium"></div>
                                    <div class="task-checkbox" onclick="this.classList.toggle('checked')">
                                        <span class="material-symbols-outlined">check</span>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title">Revisar feedback de clientes</div>
                                        <div class="task-meta">
                                            <span><span class="material-symbols-outlined">schedule</span> Viernes</span>
                                            <span><span class="material-symbols-outlined">reviews</span> Clientes</span>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </article>
                </div>
            </section>

            <!-- ═══════════════════════════════════════════════
                 GRID: Productos + Notificaciones
                 ═══════════════════════════════════════════════ -->
            <section class="dashboard-section">
                <div class="content-grid equal">
                    <!-- Panel de Productos Destacados -->
                    <article class="panel animate-in delay-4">
                        <div class="panel-header">
                            <h2 class="panel-title">Productos Destacados</h2>
                            <a href="${pageContext.request.contextPath}/catalogo/index.jsp" class="section-link">
                                Ver catálogo <span class="material-symbols-outlined">arrow_forward</span>
                            </a>
                        </div>
                        <div class="panel-body">
                            <div class="product-grid">
                                <div class="product-card">
                                    <div class="product-image">
                                        <span class="material-symbols-outlined">spa</span>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-category">Cuidado Facial</div>
                                        <div class="product-name">Serum Hidratante</div>
                                        <div class="product-price">$45.00</div>
                                        <div class="product-stock">Stock: 24 unidades</div>
                                    </div>
                                </div>
                                <div class="product-card">
                                    <div class="product-image">
                                        <span class="material-symbols-outlined">face</span>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-category">Maquillaje</div>
                                        <div class="product-name">Base Líquida Premium</div>
                                        <div class="product-price">$38.50</div>
                                        <div class="product-stock">Stock: 18 unidades</div>
                                    </div>
                                </div>
                                <div class="product-card">
                                    <div class="product-image">
                                        <span class="material-symbols-outlined">self_care</span>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-category">Corporal</div>
                                        <div class="product-name">Aceite Esencial</div>
                                        <div class="product-price">$28.00</div>
                                        <div class="product-stock">Stock: 32 unidades</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- Panel de Notificaciones -->
                    <article class="panel animate-in delay-5">
                        <div class="panel-header">
                            <h2 class="panel-title">Notificaciones</h2>
                            <div class="panel-actions">
                                <button class="panel-action-btn" title="Marcar todo como leído">
                                    <span class="material-symbols-outlined">done_all</span>
                                </button>
                            </div>
                        </div>
                        <div class="panel-body">
                            <ul class="notification-list">
                                <li class="notification-item">
                                    <div class="notification-icon primary">
                                        <span class="material-symbols-outlined">person_add</span>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-text">
                                            <strong>Nuevo usuario</strong> registrado: Sofía Herrera
                                        </div>
                                        <div class="notification-time">Hace 15 minutos</div>
                                    </div>
                                </li>
                                <li class="notification-item">
                                    <div class="notification-icon success">
                                        <span class="material-symbols-outlined">check_circle</span>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-text">
                                            Pedido <strong>#2847</strong> completado exitosamente
                                        </div>
                                        <div class="notification-time">Hace 45 minutos</div>
                                    </div>
                                </li>
                                <li class="notification-item">
                                    <div class="notification-icon warning">
                                        <span class="material-symbols-outlined">warning</span>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-text">
                                            Stock bajo: <strong>Crema Anti-edad</strong> (5 unidades)
                                        </div>
                                        <div class="notification-time">Hace 2 horas</div>
                                    </div>
                                </li>
                                <li class="notification-item">
                                    <div class="notification-icon primary">
                                        <span class="material-symbols-outlined">event</span>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-text">
                                            <strong>3 citas</strong> confirmadas para mañana
                                        </div>
                                        <div class="notification-time">Hace 3 horas</div>
                                    </div>
                                </li>
                                <li class="notification-item">
                                    <div class="notification-icon success">
                                        <span class="material-symbols-outlined">trending_up</span>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-text">
                                            Ingresos del día superaron la meta en <strong>12%</strong>
                                        </div>
                                        <div class="notification-time">Hace 5 horas</div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </article>
                </div>
            </section>

            <!-- ═══════════════════════════════════════════════
                 FOOTER
                 ═══════════════════════════════════════════════ -->
            <footer class="dashboard-footer">
                <span> 2026 Belleza. Todos los derechos reservados.</span>
                <div class="footer-links">
                    <a href="#">Ayuda</a>
                    <a href="#">Privacidad</a>
                    <a href="#">Términos</a>
                </div>
            </footer>

        </main>
    </div>

    <script>
        // Animación de entrada para las barras del gráfico
        document.addEventListener('DOMContentLoaded', function() {
            const bars = document.querySelectorAll('.chart-bar');
            bars.forEach((bar, index) => {
                const finalHeight = bar.style.height;
                bar.style.height = '0%';
                setTimeout(() => {
                    bar.style.height = finalHeight;
                }, 600 + (index * 100));
            });
        });
    </script>
<%@ include file="/includes/sidebar.jsp" %>
</body>
</html>