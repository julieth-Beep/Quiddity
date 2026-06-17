<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // ── Datos del servlet ─────────────────────────────────────────────
    com.quiddity.model.Usuario usuario = (com.quiddity.model.Usuario) session.getAttribute("usuario");
    com.quiddity.model.Caracteristicas caract = (com.quiddity.model.Caracteristicas) request.getAttribute("caract");
    java.util.List<com.quiddity.model.Prenda> prendasRecientes = (java.util.List<com.quiddity.model.Prenda>) request.getAttribute("prendasRecientes");
    com.quiddity.model.Pedido ultimoPedido = (com.quiddity.model.Pedido) request.getAttribute("ultimoPedido");
    com.quiddity.model.Rutina rutinaDelDia = (com.quiddity.model.Rutina) request.getAttribute("rutinaDelDia");
    java.util.List<com.quiddity.model.LookGenerado> favoritosPreview = (java.util.List<com.quiddity.model.LookGenerado>) request.getAttribute("favoritosPreview");
    com.quiddity.model.Frase fraseActual = (com.quiddity.model.Frase) session.getAttribute("fraseActual");

    int totalPrendas = request.getAttribute("totalPrendas") != null ? (Integer) request.getAttribute("totalPrendas") : 0;
    int totalPedidos = request.getAttribute("totalPedidos") != null ? (Integer) request.getAttribute("totalPedidos") : 0;
    int totalRutinas = request.getAttribute("totalRutinas") != null ? (Integer) request.getAttribute("totalRutinas") : 0;
    int totalFavoritos = request.getAttribute("totalFavoritos") != null ? (Integer) request.getAttribute("totalFavoritos") : 0;

    String nombreUsuario = usuario != null ? usuario.getNombre() : "Usuario";
    String fotoPerfil = usuario != null && usuario.getFotoPerfil() != null ? usuario.getFotoPerfil() : "";
    String tipoPiel = (caract != null && caract.getTipoPiel() != null) ? caract.getTipoPiel() : null;

    // FIX: getEstado() devuelve enum -> convertir a String
    String estadoUltimoPedido = "";
    if (ultimoPedido != null && ultimoPedido.getEstado() != null) {
        estadoUltimoPedido = ultimoPedido.getEstado().toString();
    }

    // Tracker de pedido
    String[] estadosPedido = {"Confirmado", "En preparacion", "Enviado", "Entregado"};
    int pasoActual = -1;
    if (!estadoUltimoPedido.isEmpty()) {
        for (int i = 0; i < estadosPedido.length; i++) {
            if (estadoUltimoPedido.equalsIgnoreCase(estadosPedido[i])) {
                pasoActual = i;
                break;
            }
        }
    }

    // Clima
    String ciudad = "Bogota";
    String temp = "18C";
    String condicion = "Parcialmente nublado";

    // FIX: Frase getter generico
    String fraseTexto = null;
    if (fraseActual != null) {
        try {
            fraseTexto = (String) fraseActual.getClass().getMethod("getTexto").invoke(fraseActual);
        } catch (Exception e1) {
            try {
                fraseTexto = (String) fraseActual.getClass().getMethod("getFrase").invoke(fraseActual);
            } catch (Exception e2) {
                try {
                    fraseTexto = (String) fraseActual.getClass().getMethod("getContenido").invoke(fraseActual);
                } catch (Exception e3) {
                    fraseTexto = fraseActual.toString();
                }
            }
        }
    }

    request.setAttribute("activePage", "dashboard");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Espacio - Quiddity</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    
    <style>
        :root {
            /* MISMA PALETA DEL ADMIN - pasteles elegantes y frios */
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

            --success: #388e3c;
            --warning: #f57c00;
            --error: #c2185b;

            --radius-sm: 12px;
            --radius-md: 14px;
            --radius-lg: 16px;
            --radius-xl: 20px;

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

        .main-content.sidebar-open { max-width: calc(100% - 320px); }
        .main-content.sidebar-closed { max-width: 100%; }

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

        /* WELCOME - Elegante y sobrio (igual admin) */
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

        /* Skin badge */
        .skin-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            background: var(--pastel-lavender);
            color: var(--accent-lavender);
            margin-top: 8px;
        }

        .skin-badge .material-symbols-rounded { font-size: 14px; }

        /* CTA escaneo */
        .scan-cta {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: var(--pastel-sky);
            border: 1px solid var(--pastel-sky-dark);
            border-radius: var(--radius-md);
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--accent-sky);
            text-decoration: none;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 8px;
        }

        .scan-cta:hover {
            background: var(--pastel-sky-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow);
            color: var(--accent-sky);
        }

        .scan-cta .material-symbols-rounded { font-size: 16px; }

        /* Toggle Closet Button */
        .welcome-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .toggle-closet-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: var(--pastel-mint);
            border: 1px solid var(--pastel-mint-dark);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.25s ease;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 12px;
            font-weight: 600;
            color: var(--accent-mint);
        }

        .toggle-closet-btn:hover {
            background: var(--pastel-mint-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow);
        }

        .toggle-closet-btn .material-symbols-rounded { font-size: 18px; }
        .toggle-closet-btn .toggle-icon { transition: transform 0.3s ease; }
        .toggle-closet-btn.active .toggle-icon { transform: rotate(180deg); }

        /* Weather widget */
        .weather-widget {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: var(--pastel-sky);
            border-radius: var(--radius-md);
            border: 1px solid var(--pastel-sky-dark);
        }

        .weather-icon {
            font-size: 20px;
            color: var(--accent-sky);
        }

        .weather-info { text-align: left; }
        .weather-temp {
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1;
        }
        .weather-city {
            font-size: 9px;
            font-weight: 700;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* KPI GRID - Compacto (igual admin) */
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

        .kpi-card:hover .kpi-icon { transform: scale(1.1); }

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

        .dashboard-left, .dashboard-right {
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-height: 0;
        }

        /* PANELS (igual admin) */
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

        .panel:hover { box-shadow: var(--shadow); border-color: var(--border); }

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

        /* OUTFIT DEL DIA */
        .outfit-visual {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: linear-gradient(135deg, var(--pastel-sky) 0%, var(--pastel-lavender) 100%);
            border-radius: var(--radius-sm);
            min-height: 200px;
            position: relative;
        }

        .outfit-image {
            max-width: 100%;
            max-height: 180px;
            border-radius: var(--radius-sm);
            box-shadow: var(--shadow-md);
            object-fit: cover;
        }

        .outfit-tags {
            display: flex;
            gap: 8px;
            margin: 12px 0;
            flex-wrap: wrap;
        }

        .outfit-tag {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            background: var(--bg);
            border: 1px solid var(--border);
            color: var(--text-secondary);
        }

        .outfit-tag .material-symbols-rounded { font-size: 14px; }

        .outfit-actions {
            display: flex;
            gap: 8px;
        }

        .outfit-btn {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            padding: 8px;
            border-radius: var(--radius-sm);
            border: none;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .outfit-btn.like { background: var(--pastel-mint); color: var(--accent-mint); }
        .outfit-btn.like:hover { background: var(--pastel-mint-dark); }
        .outfit-btn.change { background: var(--pastel-cream); color: var(--accent-cream); }
        .outfit-btn.change:hover { background: var(--pastel-cream-dark); }
        .outfit-btn.view { background: var(--pastel-lavender); color: var(--accent-lavender); }
        .outfit-btn.view:hover { background: var(--pastel-lavender-dark); }

        /* TRACKER PEDIDO */
        .tracker {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 0;
            position: relative;
        }

        .tracker::before {
            content: '';
            position: absolute;
            top: 24px;
            left: 30px;
            right: 30px;
            height: 3px;
            background: var(--border);
            border-radius: 2px;
            z-index: 0;
        }

        .tracker-line {
            position: absolute;
            top: 24px;
            left: 30px;
            height: 3px;
            background: var(--accent-sky);
            border-radius: 2px;
            z-index: 0;
            transition: width 0.6s ease;
        }

        .tracker-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            position: relative;
            z-index: 1;
            flex: 1;
        }

        .step-dot {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: white;
            border: 3px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.4s ease;
        }

        .step-dot .material-symbols-rounded {
            font-size: 14px;
            color: var(--text-tertiary);
            transition: all 0.4s ease;
        }

        .tracker-step.active .step-dot {
            border-color: var(--accent-sky);
            background: var(--pastel-sky);
            box-shadow: 0 0 0 4px rgba(25,118,210,0.15);
        }

        .tracker-step.active .step-dot .material-symbols-rounded { color: var(--accent-sky); }

        .tracker-step.completed .step-dot {
            border-color: var(--accent-mint);
            background: var(--pastel-mint);
        }

        .tracker-step.completed .step-dot .material-symbols-rounded { color: var(--accent-mint); }

        .step-label {
            font-size: 9px;
            font-weight: 700;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.03em;
            text-align: center;
            transition: color 0.3s ease;
        }

        .tracker-step.active .step-label { color: var(--accent-sky); }
        .tracker-step.completed .step-label { color: var(--accent-mint); }

        /* RUTINA */
        .routine-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .routine-step {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            background: var(--bg);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-light);
            transition: all 0.2s ease;
        }

        .routine-step:hover {
            background: var(--pastel-sage);
            transform: translateX(2px);
        }

        .step-number {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--accent-sky);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .step-info { flex: 1; min-width: 0; }

        .step-name {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1px;
        }

        .step-product {
            font-size: 10px;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .step-time {
            font-size: 10px;
            font-weight: 700;
            color: var(--accent-cream);
            background: var(--pastel-cream);
            padding: 3px 8px;
            border-radius: 10px;
            white-space: nowrap;
        }

        /* ACCESOS RAPIDOS */
        .quick-access {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }

        .access-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            padding: 20px 12px;
            background: var(--bg);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-light);
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .access-btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
            border-color: var(--border);
        }

        .access-btn:hover .access-icon { transform: scale(1.1); }

        .access-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .access-icon .material-symbols-rounded { font-size: 20px; }

        .access-btn.scan .access-icon { background: var(--pastel-sky); }
        .access-btn.scan .access-icon .material-symbols-rounded { color: var(--accent-sky); }
        .access-btn.avatar .access-icon { background: var(--pastel-lavender); }
        .access-btn.avatar .access-icon .material-symbols-rounded { color: var(--accent-lavender); }
        .access-btn.closet .access-icon { background: var(--pastel-mint); }
        .access-btn.closet .access-icon .material-symbols-rounded { color: var(--accent-mint); }
        .access-btn.catalog .access-icon { background: var(--pastel-cream); }
        .access-btn.catalog .access-icon .material-symbols-rounded { color: var(--accent-cream); }

        .access-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* SIDEBAR - Mi Closet reciente */
        .closet-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
        }

        .closet-item {
            position: relative;
            border-radius: var(--radius-sm);
            overflow: hidden;
            aspect-ratio: 1;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .closet-item:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .closet-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .closet-item:hover img { transform: scale(1.05); }

        .closet-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(26,26,46,0.7) 0%, transparent 60%);
            opacity: 0;
            transition: opacity 0.3s ease;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding: 8px;
        }

        .closet-item:hover .closet-overlay { opacity: 1; }

        .closet-action {
            font-size: 9px;
            font-weight: 700;
            color: white;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(8px);
            padding: 4px 10px;
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.3);
            text-decoration: none;
        }

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
                <h1 class="welcome-title">Hola, <span><%= nombreUsuario %></span></h1>
                <p class="welcome-subtitle">
                    <% if (fraseTexto != null) { %>
                        <%= fraseTexto %>
                    <% } else { %>
                        Descubre tu look perfecto para hoy y manten tu rutina de skincare al dia.
                    <% } %>
                </p>
                <% if (tipoPiel != null) { %>
                    <div class="skin-badge">
                        <span class="material-symbols-rounded">auto_awesome</span>
                        Piel <%= tipoPiel %>
                    </div>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/facefull" class="scan-cta">
                        <span class="material-symbols-rounded">face_retouching_natural</span>
                        Completa tu analisis facial
                    </a>
                <% } %>
            </div>
            <div class="welcome-actions">
                <div class="weather-widget">
                    <span class="material-symbols-rounded weather-icon">partly_cloudy_day</span>
                    <div class="weather-info">
                        <div class="weather-temp"><%= temp %></div>
                        <div class="weather-city"><%= ciudad %></div>
                    </div>
                </div>
                <button class="toggle-closet-btn" id="toggleClosetBtn" onclick="toggleSidebar()">
                    <span class="material-symbols-rounded">checkroom</span>
                    <span class="toggle-label">Mi Closet</span>
                    <span class="material-symbols-rounded toggle-icon" id="toggleIcon">chevron_left</span>
                </button>
                <div class="welcome-avatar">
                    <div class="avatar-info">
                        <div class="avatar-name"><%= nombreUsuario %></div>
                        <div class="avatar-role">Usuario</div>
                    </div>
                    <div class="avatar-ring">
                        <% if (!fotoPerfil.isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/uploads/perfiles/<%= fotoPerfil %>" 
                                alt="<%= nombreUsuario %>"
                                onerror="this.style.display='none'; this.parentElement.innerHTML='<span style=\"display:flex;align-items:center;justify-content:center;width:100%;height:100%;background:var(--accent-sky);color:white;font-weight:700;font-size:16px;border-radius:50%;\"><%= nombreUsuario.substring(0,1).toUpperCase() %></span>';">
                        <% } else { %>
                            <img src="https://ui-avatars.com/api/?name=<%= nombreUsuario %>&background=random&color=fff&size=128" 
                                alt="<%= nombreUsuario %>">
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPIs -->
        <div class="kpi-grid">
            <div class="kpi-card sky anim-fade-up delay-1">
                <div class="kpi-header">
                    <span class="kpi-label">Mis Pedidos</span>
                    <div class="kpi-icon sky">
                        <span class="material-symbols-rounded">shopping_bag</span>
                    </div>
                </div>
                <div class="kpi-value"><%= totalPedidos %></div>
                <div class="kpi-trend <%= !estadoUltimoPedido.isEmpty() ? "up" : "down" %>">
                    <span class="material-symbols-rounded"><%= !estadoUltimoPedido.isEmpty() ? "check_circle" : "info" %></span>
                    <%= !estadoUltimoPedido.isEmpty() ? estadoUltimoPedido : "Sin pedidos" %>
                </div>
            </div>

            <div class="kpi-card mint anim-fade-up delay-2">
                <div class="kpi-header">
                    <span class="kpi-label">En mi Closet</span>
                    <div class="kpi-icon mint">
                        <span class="material-symbols-rounded">checkroom</span>
                    </div>
                </div>
                <div class="kpi-value"><%= totalPrendas %></div>
                <div class="kpi-trend up">
                    <span class="material-symbols-rounded">add_circle</span>
                    <%= totalPrendas %> prendas
                </div>
            </div>

            <div class="kpi-card lavender anim-fade-up delay-3">
                <div class="kpi-header">
                    <span class="kpi-label">Rutinas Activas</span>
                    <div class="kpi-icon lavender">
                        <span class="material-symbols-rounded">spa</span>
                    </div>
                </div>
                <div class="kpi-value"><%= totalRutinas %></div>
                <div class="kpi-trend up">
                    <span class="material-symbols-rounded">favorite</span>
                    <%= tipoPiel != null ? "Piel " + tipoPiel : "Sin definir" %>
                </div>
            </div>

            <div class="kpi-card cream anim-fade-up delay-4">
                <div class="kpi-header">
                    <span class="kpi-label">Outfits Favoritos</span>
                    <div class="kpi-icon cream">
                        <span class="material-symbols-rounded">favorite</span>
                    </div>
                </div>
                <div class="kpi-value"><%= totalFavoritos %></div>
                <div class="kpi-trend up">
                    <span class="material-symbols-rounded">auto_awesome</span>
                    looks guardados
                </div>
            </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            <!-- Left Column -->
            <div class="dashboard-left">
                <!-- Outfit del Dia -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Outfit del Dia</h3>
                            <p>Sugerencia segun el clima en <%= ciudad %></p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn" title="Regenerar"><span class="material-symbols-rounded">refresh</span></button>
                            <button class="icon-btn" title="Mas opciones"><span class="material-symbols-rounded">more_vert</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="outfit-visual">
                            <% if (favoritosPreview != null && !favoritosPreview.isEmpty() && favoritosPreview.get(0).getImagenGenerada() != null) { %>
                                <img src="<%= request.getContextPath() %>/<%= favoritosPreview.get(0).getImagenGenerada() %>" 
                                     alt="Outfit del dia" class="outfit-image">
                            <% } else { %>
                                <div style="text-align: center; color: var(--text-tertiary);">
                                    <span class="material-symbols-rounded" style="font-size: 48px; display: block; margin-bottom: 8px;">auto_awesome</span>
                                    <p style="font-size: 13px; font-weight: 600;">Genera tu primer look</p>
                                </div>
                            <% } %>
                        </div>
                        <div class="outfit-tags">
                            <span class="outfit-tag">
                                <span class="material-symbols-rounded">thermostat</span>
                                <%= temp %>
                            </span>
                            <span class="outfit-tag">
                                <span class="material-symbols-rounded">wb_sunny</span>
                                <%= condicion %>
                            </span>
                            <span class="outfit-tag">
                                <span class="material-symbols-rounded">event</span>
                                Casual
                            </span>
                        </div>
                        <div class="outfit-actions">
                            <button class="outfit-btn like" onclick="alert('Me gusta!')">
                                <span class="material-symbols-rounded">thumb_up</span>
                                Me gusta
                            </button>
                            <button class="outfit-btn change" onclick="alert('Cambiando outfit...')">
                                <span class="material-symbols-rounded">sync</span>
                                Cambiar
                            </button>
                            <button class="outfit-btn view" onclick="alert('Ver en avatar')">
                                <span class="material-symbols-rounded">visibility</span>
                                Ver en avatar
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Ultimo Pedido -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Mi Ultimo Pedido</h3>
                            <p><%= ultimoPedido != null ? "Pedido #" + ultimoPedido.getId() : "Sin pedidos" %></p>
                        </div>
                        <div class="panel-actions">
                            <a href="<%= request.getContextPath() %>/pedidos" class="icon-btn" title="Ver todos">
                                <span class="material-symbols-rounded">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                    <div class="panel-body">
                        <% if (ultimoPedido != null) { %>
                            <div class="tracker">
                                <div class="tracker-line" style="width: <%= pasoActual >= 0 ? (pasoActual * 33.33) + "%" : "0%" %>;"></div>
                                <% 
                                String[] icons = {"receipt_long", "inventory_2", "local_shipping", "check_circle"};
                                for (int i = 0; i < estadosPedido.length; i++) { 
                                    boolean isActive = i == pasoActual;
                                    boolean isCompleted = i < pasoActual;
                                %>
                                    <div class="tracker-step <%= isActive ? "active" : "" %> <%= isCompleted ? "completed" : "" %>">
                                        <div class="step-dot">
                                            <span class="material-symbols-rounded"><%= icons[i] %></span>
                                        </div>
                                        <span class="step-label"><%= estadosPedido[i] %></span>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div style="text-align: center; padding: 24px; color: var(--text-tertiary);">
                                <span class="material-symbols-rounded" style="font-size: 36px; display: block; margin-bottom: 8px;">shopping_bag</span>
                                <p style="font-size: 12px; font-weight: 600;">Aun no tienes pedidos</p>
                                <a href="<%= request.getContextPath() %>/catalogo" style="color: var(--accent-sky); font-weight: 700; text-decoration: none; margin-top: 6px; display: inline-block;">
                                    Explorar catalogo
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="dashboard-right">
                <!-- Rutina de Hoy -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Rutina de Hoy</h3>
                            <p><%= tipoPiel != null ? "Personalizada para piel " + tipoPiel : "Completa tu perfil" %></p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn" title="Ver todas"><span class="material-symbols-rounded">spa</span></button>
                            <button class="icon-btn" title="Mas opciones"><span class="material-symbols-rounded">more_vert</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <% if (rutinaDelDia != null) { %>
                            <div class="routine-list stagger-children">
                                <div class="routine-step">
                                    <div class="step-number">1</div>
                                    <div class="step-info">
                                        <div class="step-name">Limpieza facial</div>
                                        <div class="step-product">Gel limpiador suave</div>
                                    </div>
                                    <span class="step-time">2 min</span>
                                </div>
                                <div class="routine-step">
                                    <div class="step-number">2</div>
                                    <div class="step-info">
                                        <div class="step-name">Tonico equilibrante</div>
                                        <div class="step-product">Tonico de rosas</div>
                                    </div>
                                    <span class="step-time">1 min</span>
                                </div>
                                <div class="routine-step">
                                    <div class="step-number">3</div>
                                    <div class="step-info">
                                        <div class="step-name">Serum hidratante</div>
                                        <div class="step-product">Acido hialuronico 2%</div>
                                    </div>
                                    <span class="step-time">1 min</span>
                                </div>
                                <div class="routine-step">
                                    <div class="step-number">4</div>
                                    <div class="step-info">
                                        <div class="step-name">Crema hidratante</div>
                                        <div class="step-product">Moisturizer SPF 30</div>
                                    </div>
                                    <span class="step-time">2 min</span>
                                </div>
                                <div class="routine-step">
                                    <div class="step-number">5</div>
                                    <div class="step-info">
                                        <div class="step-name">Protector solar</div>
                                        <div class="step-product">Sunscreen SPF 50</div>
                                    </div>
                                    <span class="step-time">1 min</span>
                                </div>
                            </div>
                            <div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border-light); display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 11px; color: var(--text-tertiary); font-weight: 600;">
                                    <span class="material-symbols-rounded" style="font-size: 13px; vertical-align: middle; margin-right: 4px;">schedule</span>
                                    ~7 min total
                                </span>
                                <button class="scan-cta" style="padding: 6px 14px; font-size: 11px; margin-top: 0;">
                                    <span class="material-symbols-rounded" style="font-size: 14px;">play_arrow</span>
                                    Iniciar
                                </button>
                            </div>
                        <% } else { %>
                            <div style="text-align: center; padding: 24px; color: var(--text-tertiary);">
                                <span class="material-symbols-rounded" style="font-size: 36px; display: block; margin-bottom: 8px;">spa</span>
                                <p style="font-size: 12px; font-weight: 600;">No tienes rutinas activas</p>
                                <a href="<%= request.getContextPath() %>/rutinas" style="color: var(--accent-sky); font-weight: 700; text-decoration: none; margin-top: 6px; display: inline-block;">
                                    Descubrir rutinas
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Accesos Rapidos -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <div class="panel-title-group">
                            <h3>Accesos Rapidos</h3>
                            <p>Todo a un clic</p>
                        </div>
                        <div class="panel-actions">
                            <button class="icon-btn" title="Configurar"><span class="material-symbols-rounded">settings</span></button>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="quick-access stagger-children">
                            <a href="<%= request.getContextPath() %>/facefull" class="access-btn scan">
                                <div class="access-icon">
                                    <span class="material-symbols-rounded">face_retouching_natural</span>
                                </div>
                                <span class="access-label">Escaneo Facial</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/avatar" class="access-btn avatar">
                                <div class="access-icon">
                                    <span class="material-symbols-rounded">person</span>
                                </div>
                                <span class="access-label">Mi Avatar</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/closet" class="access-btn closet">
                                <div class="access-icon">
                                    <span class="material-symbols-rounded">checkroom</span>
                                </div>
                                <span class="access-label">Mi Closet</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/catalogo" class="access-btn catalog">
                                <div class="access-icon">
                                    <span class="material-symbols-rounded">storefront</span>
                                </div>
                                <span class="access-label">Catalogo</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- RIGHT SIDEBAR - Mi Closet Reciente -->
    <aside class="right-sidebar" id="rightSidebar">
        <div class="sidebar-header">
            <div class="sidebar-title">
                <span class="material-symbols-rounded" style="color:var(--accent-mint);font-size:20px;">checkroom</span>
                Mi Closet Reciente
            </div>
            <button class="sidebar-close" onclick="toggleSidebar()">
                <span class="material-symbols-rounded" style="font-size:16px;">close</span>
            </button>
        </div>

        <div class="closet-grid stagger-children">
            <% if (prendasRecientes != null && !prendasRecientes.isEmpty()) { 
                for (com.quiddity.model.Prenda p : prendasRecientes) { %>
                <div class="closet-item">
                    <img src="<%= request.getContextPath() %>/<%= p.getImagen() != null ? p.getImagen() : "assets/img/placeholder.png" %>" 
                         alt="<%= p.getTipo() %>">
                    <div class="closet-overlay">
                        <a href="<%= request.getContextPath() %>/avatar?prenda=<%= p.getId() %>" class="closet-action">
                            Ver en avatar
                        </a>
                    </div>
                </div>
            <% } 
            } else { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 24px; color: var(--text-tertiary); background: var(--bg); border-radius: var(--radius-sm); border: 1px dashed var(--border);">
                    <span class="material-symbols-rounded" style="font-size: 28px; display: block; margin-bottom: 6px;">add_photo_alternate</span>
                    <p style="font-size: 11px; font-weight: 600;">Sube tu primera prenda</p>
                </div>
            <% } %>
        </div>

        <a href="<%= request.getContextPath() %>/closet" style="display: flex; align-items: center; justify-content: center; gap: 6px; margin-top: 8px; padding: 10px; background: var(--bg); border-radius: var(--radius-sm); text-decoration: none; color: var(--text-secondary); font-size: 11px; font-weight: 700; transition: all 0.2s ease;">
            <span class="material-symbols-rounded" style="font-size: 14px;">arrow_forward</span>
            Ver todo mi closet
        </a>
    </aside>

</div>

<script>
    var sidebarOpen = true;

    function toggleSidebar() {
        var sidebar = document.getElementById('rightSidebar');
        var mainContent = document.getElementById('mainContent');
        var toggleBtn = document.getElementById('toggleClosetBtn');
        var toggleIcon = document.getElementById('toggleIcon');

        sidebarOpen = !sidebarOpen;

        if (sidebarOpen) {
            sidebar.classList.remove('hidden');
            mainContent.classList.remove('sidebar-closed');
            mainContent.classList.add('sidebar-open');
            if (toggleBtn) toggleBtn.classList.add('active');
            if (toggleIcon) toggleIcon.textContent = 'chevron_left';
        } else {
            sidebar.classList.add('hidden');
            mainContent.classList.remove('sidebar-open');
            mainContent.classList.add('sidebar-closed');
            if (toggleBtn) toggleBtn.classList.remove('active');
            if (toggleIcon) toggleIcon.textContent = 'chevron_right';
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        var kpiValues = document.querySelectorAll('.kpi-value');
        for (var i = 0; i < kpiValues.length; i++) {
            var el = kpiValues[i];
            var finalValue = parseInt(el.textContent.replace(/[^0-9]/g, '')) || 0;
            if (finalValue > 0) {
                var current = 0;
                var increment = finalValue / 40;
                var timer = setInterval((function(element, target) {
                    return function() {
                        current += increment;
                        if (current >= target) {
                            current = target;
                            clearInterval(timer);
                        }
                        element.textContent = Math.floor(current);
                    };
                })(el, finalValue), 25);
            }
        }
    });
</script>

</body>
</html>