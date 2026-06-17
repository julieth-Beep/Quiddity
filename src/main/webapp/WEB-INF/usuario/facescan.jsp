<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Face Scan — Quiddity</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=DM+Sans:wght@300;400;500;700&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
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
            --pastel-rose: #fce4ec;
            --pastel-rose-dark: #f8bbd0;
            --pastel-gold: #fff8e1;
            --pastel-gold-dark: #ffe082;
            --accent-sky: #1976d2;
            --accent-mint: #388e3c;
            --accent-lavender: #7b1fa2;
            --accent-cream: #f57c00;
            --accent-coral: #c2185b;
            --accent-sage: #689f38;
            --accent-rose: #c2185b;
            --accent-gold: #f9a825;
            --beauty-gold: #C9A96E;
            --beauty-rose: #C4796A;
            --beauty-blush: #E8C4B8;
            --beauty-plum: #3D2B35;
            --radius-sm: 10px;
            --radius-md: 12px;
            --radius-lg: 14px;
            --radius-xl: 20px;
            --radius-full: 999px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
            --shadow-lg: 0 12px 32px rgba(0,0,0,0.12);
            --shadow-gold: 0 4px 20px rgba(201,169,110,0.15);
            --transition-fast: 0.15s ease;
            --transition-base: 0.3s ease;
            --transition-spring: 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        * { margin:0; padding:0; box-sizing:border-box; }

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

        /* ═══════════════════════════════════════════════════════════════════
           LAYOUT — Full viewport, ancho completo
           ═══════════════════════════════════════════════════════════════════ */
        .layout-wrapper {
            display: flex;
            height: 100vh;
            flex-direction: row;
            overflow: hidden;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 12px 20px;
            gap: 10px;
            width: 100%;
            height: 100vh;
            overflow: hidden;
            max-width: none;
            margin: 0;
        }

        /* ═══════════════════════════════════════════════════════════════════
           WELCOME SECTION
           ═══════════════════════════════════════════════════════════════════ */
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

        .welcome-title span { color: var(--beauty-gold); }

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
        }

        .step-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            background: linear-gradient(135deg, var(--pastel-gold), var(--pastel-cream));
            border: 1px solid var(--pastel-gold-dark);
            border-radius: var(--radius-md);
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--accent-gold);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .step-badge .material-symbols-outlined {
            font-size: 14px;
            color: var(--accent-gold);
        }

        /* ═══════════════════════════════════════════════════════════════════
           STATS BAR
           ═══════════════════════════════════════════════════════════════════ */
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
            transition: all var(--transition-base);
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
            border-color: var(--pastel-gold-dark);
        }

        .stat-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--beauty-gold);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform var(--transition-base);
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
            transition: all var(--transition-base);
        }

        .stat-item:hover .stat-icon { transform: scale(1.1); }

        .stat-icon.gold {
            background: var(--pastel-gold);
            color: var(--accent-gold);
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

        /* ═══════════════════════════════════════════════════════════════════
           DASHBOARD GRID — 2 columnas como el dashboard real
           ═══════════════════════════════════════════════════════════════════ */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 600px 1fr;
            gap: 12px;
            flex: 1;
            min-height: 0;
        }

        .dashboard-left, .dashboard-right {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 0;
        }

        /* ═══════════════════════════════════════════════════════════════════
           PANEL
           ═══════════════════════════════════════════════════════════════════ */
        .panel {
            background: var(--surface);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            overflow: hidden;
            transition: all var(--transition-base);
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
        }

        .panel:hover {
            box-shadow: var(--shadow);
            border-color: var(--border);
        }

        .panel-header {
            padding: 10px 14px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .panel-title-group h3 {
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .panel-title-group h3::before {
            content: '';
            width: 3px;
            height: 12px;
            border-radius: 2px;
            background: var(--beauty-gold);
        }

        .panel-title-group h3.rose::before { background: var(--beauty-rose); }
        .panel-title-group h3.lavender::before { background: var(--accent-lavender); }

        .panel-title-group p {
            font-size: 10px;
            color: var(--text-tertiary);
            font-weight: 500;
            margin: 2px 0 0 9px;
        }

        .panel-body {
            padding: 12px;
            flex: 1;
            overflow: hidden;
            min-height: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ═══════════════════════════════════════════════════════════════════
           CÁMARA STAGE — Grande, ocupa toda la columna izquierda
           ═══════════════════════════════════════════════════════════════════ */
        .camera-container {
            position: relative;
            width: 100%;
            height: 100%;
            min-height: 0;
            border-radius: var(--radius-lg);
            overflow: hidden;
            background: linear-gradient(160deg, #2a1f27 0%, #1a1118 100%);
            box-shadow: var(--shadow-md);
        }

        #video {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transform: scaleX(-1);
        }

        #overlayCanvas {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 10;
        }

        .face-guide-overlay {
            position: absolute;
            inset: 0;
            z-index: 5;
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .face-oval-guide {
            width: 50%;
            height: 60%;
            border: 2px dashed rgba(201,169,110,0.30);
            border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
            position: relative;
        }

        .face-oval-guide::before {
            content: '';
            position: absolute;
            inset: -10px;
            border: 1.5px dashed rgba(201,169,110,0.15);
            border-radius: inherit;
        }

        .guide-corners {
            position: absolute;
            inset: 20px;
        }

        .guide-corner {
            position: absolute;
            width: 24px;
            height: 24px;
            border-color: var(--beauty-gold);
            border-style: solid;
            opacity: 0.4;
            transition: opacity var(--transition-base);
        }

        .guide-corner.tl { top:0; left:0; border-width: 2px 0 0 2px; border-radius: 4px 0 0 0; }
        .guide-corner.tr { top:0; right:0; border-width: 2px 2px 0 0; border-radius: 0 4px 0 0; }
        .guide-corner.bl { bottom:0; left:0; border-width: 0 0 2px 2px; border-radius: 0 0 0 4px; }
        .guide-corner.br { bottom:0; right:0; border-width: 0 2px 2px 0; border-radius: 0 0 4px 0; }

        .camera-container:hover .guide-corner { opacity: 0.7; }

        .no-camera {
            position: absolute;
            inset: 0;
            background: linear-gradient(160deg, #2a1f27 0%, #1a1118 100%);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 24px;
            text-align: center;
            z-index: 15;
        }

        .no-camera-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            background: var(--pastel-gold);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .no-camera-icon .material-symbols-outlined {
            font-size: 24px;
            color: var(--accent-gold);
        }

        .no-camera h4 {
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--pastel-gold-dark);
            margin-bottom: 3px;
        }

        .no-camera p {
            font-size: 10px;
            color: rgba(245,240,234,0.50);
            max-width: 180px;
            line-height: 1.5;
        }

        .btn-retry {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 8px 16px;
            background: linear-gradient(135deg, var(--pastel-gold), var(--pastel-cream));
            border: 1px solid var(--pastel-gold-dark);
            border-radius: var(--radius-sm);
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--accent-gold);
            cursor: pointer;
            transition: all var(--transition-spring);
            text-decoration: none;
        }

        .btn-retry:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-gold);
        }

        .shape-detected-label {
            position: absolute;
            bottom: 12px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-full);
            padding: 5px 14px;
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--accent-gold);
            white-space: nowrap;
            z-index: 20;
            display: none;
            box-shadow: var(--shadow-sm);
        }

        .shape-detected-label.visible { display: flex; align-items: center; gap: 5px; }

        .shape-detected-label .dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: var(--accent-gold);
        }

        /* ═══════════════════════════════════════════════════════════════════
           CHIPS / GRID DE FORMAS
           ═══════════════════════════════════════════════════════════════════ */
        .shapes-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
            width: 100%;
        }

        @media (max-width: 480px) {
            .shapes-grid { grid-template-columns: repeat(3, 1fr); }
        }

        .shape-chip {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            padding: 10px 6px 8px;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: all var(--transition-spring);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .shape-chip:hover {
            border-color: var(--beauty-gold);
            color: var(--beauty-gold);
            background: var(--pastel-gold);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .shape-chip.active {
            background: linear-gradient(135deg, var(--pastel-gold), var(--pastel-cream));
            border-color: transparent;
            color: var(--accent-gold);
            box-shadow: 0 3px 10px rgba(201,169,110,0.15);
            transform: translateY(-2px);
        }

        .shape-chip .icon-wrap {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: var(--bg);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition-base);
        }

        .shape-chip:hover .icon-wrap,
        .shape-chip.active .icon-wrap {
            background: rgba(255,255,255,0.5);
        }

        .shape-chip .material-symbols-outlined {
            font-size: 16px;
            color: var(--text-tertiary);
            transition: all var(--transition-base);
        }

        .shape-chip:hover .material-symbols-outlined,
        .shape-chip.active .material-symbols-outlined {
            color: var(--accent-gold);
        }

        .shape-chip span.label {
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--text-secondary);
            transition: all var(--transition-base);
        }

        .shape-chip:hover span.label,
        .shape-chip.active span.label {
            color: var(--accent-gold);
            font-weight: 700;
        }

        /* ═══════════════════════════════════════════════════════════════════
           SKIN TONES
           ═══════════════════════════════════════════════════════════════════ */
        .skin-grid {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
            width: 100%;
        }

        .skin-chip {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            padding: 10px 12px;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: all var(--transition-spring);
            min-width: 56px;
            flex: 1;
            max-width: 80px;
        }

        .skin-chip:hover {
            border-color: var(--beauty-gold);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .skin-chip.active {
            border-color: var(--beauty-gold);
            background: var(--pastel-gold);
            box-shadow: 0 3px 10px rgba(201,169,110,0.15);
            transform: translateY(-2px);
        }

        .skin-swatch {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: 2px solid var(--border);
            transition: all var(--transition-spring);
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }

        .skin-chip:hover .skin-swatch {
            border-color: var(--beauty-gold);
            transform: scale(1.1);
        }

        .skin-chip.active .skin-swatch {
            border-color: var(--beauty-gold);
            box-shadow: 0 0 0 2px var(--pastel-gold-dark), inset 0 2px 4px rgba(0,0,0,0.1);
            transform: scale(1.15);
        }

        .skin-chip span.label {
            font-size: 8px;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--text-tertiary);
            transition: all var(--transition-base);
        }

        .skin-chip:hover span.label,
        .skin-chip.active span.label {
            color: var(--accent-gold);
            font-weight: 700;
        }

        /* ═══════════════════════════════════════════════════════════════════
           CONFIRM AREA
           ═══════════════════════════════════════════════════════════════════ */
        .confirm-panel {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex-shrink: 0;
        }

        .confirm-panel:hover {
            box-shadow: var(--shadow);
            border-color: var(--border);
        }

        .selection-summary {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .summary-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            background: var(--bg);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-full);
            font-size: 10px;
            font-weight: 700;
            color: var(--text-secondary);
            transition: all var(--transition-base);
        }

        .summary-pill.visible {
            background: var(--pastel-gold);
            border-color: var(--pastel-gold-dark);
            color: var(--accent-gold);
        }

        .summary-pill .dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: var(--text-tertiary);
        }

        .summary-pill.visible .dot {
            background: var(--accent-gold);
        }

        .hint-text {
            text-align: center;
            font-size: 10px;
            color: var(--text-tertiary);
            font-weight: 600;
            min-height: 1.3em;
            transition: all var(--transition-base);
            margin: 0;
        }

        .hint-text.ready {
            color: var(--accent-gold);
            font-weight: 700;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 10px 24px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: all var(--transition-spring);
            text-decoration: none;
            font-family: 'Plus Jakarta Sans', sans-serif;
            align-self: center;
        }

        .btn-action.primary {
            background: linear-gradient(135deg, var(--pastel-gold), var(--pastel-cream));
            color: var(--accent-gold);
            box-shadow: 0 3px 10px rgba(201,169,110,0.15);
            border: 1px solid var(--pastel-gold-dark);
        }

        .btn-action.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(201,169,110,0.25);
        }

        .btn-action:disabled {
            opacity: 0.35;
            pointer-events: none;
            filter: grayscale(0.5);
        }

        /* ═══════════════════════════════════════════════════════════════════
           TOAST
           ═══════════════════════════════════════════════════════════════════ */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 8px;
            pointer-events: none;
        }

        .toast-item {
            background: var(--surface);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: var(--shadow-lg);
            animation: slideInToast 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            font-size: 11px;
            font-weight: 600;
            min-width: 260px;
            border-left: 3px solid var(--accent-gold);
            font-family: 'Plus Jakarta Sans', sans-serif;
            pointer-events: auto;
        }

        .toast-item.error { border-left-color: var(--accent-coral); }

        @keyframes slideInToast {
            from { transform: translateX(120%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* ═══════════════════════════════════════════════════════════════════
           ANIMACIONES
           ═══════════════════════════════════════════════════════════════════ */
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
        .delay-4 { animation-delay: 0.24s; }
        .delay-5 { animation-delay: 0.30s; }

        /* ═══════════════════════════════════════════════════════════════════
           RESPONSIVE
           ═══════════════════════════════════════════════════════════════════ */
        @media (max-width: 1024px) {
            .dashboard-grid { grid-template-columns: 1fr; }
            .camera-container { min-height: 200px; }
        }

        @media (max-width: 640px) {
            .main-content { padding: 8px 12px; gap: 8px; }
            .welcome-section { flex-direction: column; gap: 8px; text-align: center; padding: 8px 12px; }
            .welcome-title { font-size: 16px; }
            .stats-bar { grid-template-columns: 1fr; gap: 8px; }
            .shapes-grid { grid-template-columns: repeat(3, 1fr); gap: 6px; }
            .shape-chip { padding: 8px 4px 6px; }
            .skin-grid { gap: 6px; }
            .skin-chip { padding: 8px 8px; min-width: 50px; }
            .panel-header { padding: 8px 12px; }
            .panel-body { padding: 8px; }
            .confirm-panel { padding: 10px 12px; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }

    </style>
</head>
<body>

    <!-- TOASTS -->
    <div class="toast-container" id="toastContainer">
        <c:if test="${not empty error}">
            <div class="toast-item error">
                <span class="material-symbols-outlined" style="color:var(--accent-coral);">error</span>
                <span>${error}</span>
            </div>
        </c:if>
    </div>

    <div class="layout-wrapper">
            <%@ include file="/includes/sidebar.jsp" %>
        <main class="main-content">

            <!-- Welcome Section -->
            <div class="welcome-section anim-fade-up">
                <div class="welcome-content">
                    <h1 class="welcome-title">Face Scan <span>Beauty</span></h1>
                    <p class="welcome-subtitle">Descubre la forma de tu rostro y tu tono de piel ideal</p>
                </div>
                <div class="welcome-actions">
                    <div class="step-badge">
                        <span class="material-symbols-outlined">face_retouching_natural</span>
                        Paso 1 de 5
                    </div>
                </div>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar anim-fade-up delay-1">
                <div class="stat-item">
                    <div class="stat-icon gold">
                        <span class="material-symbols-outlined">face</span>
                    </div>
                    <div class="stat-data">
                        <h4>7</h4>
                        <p>Formas de rostro</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon rose">
                        <span class="material-symbols-outlined">palette</span>
                    </div>
                    <div class="stat-data">
                        <h4>6</h4>
                        <p>Tonos de piel</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon lavender">
                        <span class="material-symbols-outlined">auto_awesome</span>
                    </div>
                    <div class="stat-data">
                        <h4>42</h4>
                        <p>Combinaciones</p>
                    </div>
                </div>
            </div>

            <!-- Dashboard Grid: 2 columnas -->
            <div class="dashboard-grid">

                <!-- Left Column: Cámara -->
                <div class="dashboard-left">
                    <div class="panel anim-fade-up delay-2" style="flex: 1;">
                        <div class="panel-header">
                            <div class="panel-title-group">
                                <h3><span class="material-symbols-outlined" style="font-size:14px;color:var(--accent-gold);">videocam</span> Escáner Facial</h3>
                                <p>Centra tu rostro en el encuadre</p>
                            </div>
                        </div>
                        <div class="panel-body" style="padding: 0;">
                            <div class="camera-container" id="cameraStage">
                                <video id="video" autoplay playsinline muted></video>
                                <canvas id="overlayCanvas"></canvas>

                                <!-- Guía facial -->
                                <div class="face-guide-overlay">
                                    <div class="face-oval-guide"></div>
                                    <div class="guide-corners">
                                        <div class="guide-corner tl"></div>
                                        <div class="guide-corner tr"></div>
                                        <div class="guide-corner bl"></div>
                                        <div class="guide-corner br"></div>
                                    </div>
                                </div>

                                <!-- Sin cámara -->
                                <div class="no-camera" id="noCamMsg">
                                    <div class="no-camera-icon">
                                        <span class="material-symbols-outlined">videocam_off</span>
                                    </div>
                                    <div>
                                        <h4>Cámara no disponible</h4>
                                        <p>Permite el acceso a la cámara o selecciona manualmente</p>
                                    </div>
                                    <button class="btn-retry" onclick="requestCamera()">
                                        <span class="material-symbols-outlined" style="font-size:12px;">videocam</span>
                                        Intentar
                                    </button>
                                </div>

                                <!-- Label de forma detectada -->
                                <div class="shape-detected-label" id="shapeLabel">
                                    <span class="dot"></span>
                                    <span id="shapeLabelText">—</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Formas + Tonos + Confirmar -->
                <div class="dashboard-right">

                    <!-- Shapes Section -->
                    <div class="panel anim-fade-up delay-3" style="flex: 1.2;">
                        <div class="panel-header">
                            <div class="panel-title-group">
                                <h3 class="rose"><span class="material-symbols-outlined" style="font-size:14px;color:var(--accent-coral);">face</span> Forma de Rostro</h3>
                                <p>Selecciona la que mejor te defina</p>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="shapes-grid" id="shapesGrid"></div>
                        </div>
                    </div>

                    <!-- Skin Section -->
                    <div class="panel anim-fade-up delay-4" style="flex: 1;">
                        <div class="panel-header">
                            <div class="panel-title-group">
                                <h3 class="lavender"><span class="material-symbols-outlined" style="font-size:14px;color:var(--accent-lavender);">palette</span> Tono de Piel</h3>
                                <p>Elige tu tono natural</p>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="skin-grid" id="skinGrid"></div>
                        </div>
                    </div>

                    <!-- Confirm Panel -->
                    <div class="confirm-panel anim-fade-up delay-5">
                        <c:if test="${not empty error}">
                            <div class="alert-error" style="display:flex;align-items:center;gap:6px;padding:8px 12px;background:var(--pastel-coral);border-radius:var(--radius-sm);color:var(--accent-coral);font-size:10px;font-weight:600;">
                                <span class="material-symbols-outlined" style="font-size:14px;">error</span>
                                ${error}
                            </div>
                        </c:if>

                        <div class="selection-summary">
                            <div class="summary-pill" id="summaryShape">
                                <span class="dot"></span>
                                <span id="summaryShapeValue">—</span>
                            </div>
                            <span class="material-symbols-outlined" style="font-size:12px;color:var(--text-tertiary);">add</span>
                            <div class="summary-pill" id="summarySkin">
                                <span class="dot"></span>
                                <span id="summarySkinValue">—</span>
                            </div>
                        </div>

                        <p class="hint-text" id="hintText">Elige la forma que mejor describa tu rostro</p>

                        <form id="faceScanForm" action="${pageContext.request.contextPath}/facefull" method="post" style="display:flex;justify-content:center;">
                            <input type="hidden" name="formaCara" id="hiddenFormaCara">
                            <input type="hidden" name="tonoPiel" id="hiddenTonoPiel">
                            <button type="submit" id="btnConfirmar" class="btn-action primary" disabled>
                                <span class="material-symbols-outlined" style="font-size:14px;">sparkle</span>
                                Confirmar y continuar
                            </button>
                        </form>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script>

        // ═══════════════════════════════════════════════════════════════════
        // DATOS — EXACTAMENTE IGUAL que tu archivo original
        // ═══════════════════════════════════════════════════════════════════
        var SHAPES = [
            {
                id:"corazon", label:"Corazon",
                path:"M190,85 C195,78 210,72 230,76 C260,82 285,105 298,140 C310,175 305,215 290,255 C275,295 250,335 235,365 C225,382 215,390 190,390 C165,390 155,382 145,365 C130,335 105,295 90,255 C75,215 70,175 82,140 C95,105 120,82 150,76 C170,72 185,78 190,85 Z"
            },
            {
                id:"triangular_inv", 
                label:"Invertida",
                path:"M135,100 C160,88 220,88 245,100 C270,115 295,140 295,170 C295,215 270,265 250,305 C240,325 215,345 190,355 C165,345 140,325 130,305 C110,265 85,215 85,170 C85,140 110,115 135,100 Z"
            }, 
            {
                id:"triangular", 
                label:"Triangular",
                path:"M145,85 C168,77 212,77 235,85 C260,95 280,120 290,155 C300,190 303,235 300,275 C297,305 285,325 265,340 C245,355 215,365 190,368 C165,365 135,355 115,340 C95,325 83,305 80,275 C77,235 80,190 90,155 C100,120 120,95 145,85 Z"
            },
            {
                id:"ovalada", label:"Ovalada",
                path:"M190,75 C245,75 295,155 295,253 C295,351 245,430 190,430 C135,430 85,351 85,253 C85,155 135,75 190,75 Z"
            },
            {
                id:"cuadrada", label:"Cuadrada",
                path:"M115,100 C130,75 250,75 265,100 C278,105 285,115 288,135 C290,155 290,320 288,340 C285,360 278,370 265,380 C240,400 220,415 190,420 C160,415 140,400 115,380 C102,370 95,360 92,340 C90,320 90,155 92,135 C95,115 102,105 115,100 Z"
            },
            {
                id:"redonda", label:"Redonda",
                path:"M190,90 C255,90 308,160 308,253 C308,346 255,415 190,415 C125,415 72,346 72,253 C72,160 125,90 190,90 Z"
            },
            {
                id:"diamante", label:"Diamante",
                path:"M190,75 C210,75 240,95 265,130 C295,172 305,215 298,255 C290,300 260,350 220,385 C210,393 200,398 190,400 C180,398 170,393 160,385 C120,350 90,300 82,255 C75,215 85,172 115,130 C140,95 170,75 190,75 Z"
            }
        ];

        var ICONS = {
            corazon:       "<path d=\"M16,10 C16,10 10,6 6,9 C2,12 2,17 6,21 C10,25 16,30 16,30 C16,30 22,25 26,21 C30,17 30,12 26,9 C22,6 16,10 16,10Z\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            triangular_inv:"<polygon points=\"4,8 28,8 16,36\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            triangular:    "<polygon points=\"16,6 28,36 4,36\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            ovalada:       "<ellipse cx=\"16\" cy=\"20\" rx=\"8\" ry=\"12\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            cuadrada:      "<rect x=\"5\" y=\"8\" width=\"22\" height=\"24\" rx=\"3\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            redonda:       "<circle cx=\"16\" cy=\"20\" r=\"11\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
            diamante:      "<polygon points=\"16,4 28,20 16,36 4,20\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>"
        };

        var SKIN_TONES = [
            { id:"muy_claro",  label:"Muy claro",  color:"#FDDBB4", r:253, g:219, b:180 },
            { id:"claro",      label:"Claro",      color:"#F0C08A", r:240, g:192, b:138 },
            { id:"medio",      label:"Medio",      color:"#D4956A", r:212, g:149, b:106 },
            { id:"bronceado",  label:"Bronceado",  color:"#B97048", r:185, g:112, b:72  },
            { id:"oscuro",     label:"Oscuro",     color:"#7D4A2A", r:125, g:74,  b:42  },
            { id:"muy_oscuro", label:"Muy oscuro", color:"#3B1F0E", r:59,  g:31,  b:14  }
        ];

        var selectedShapeId = null;
        var selectedSkinId  = null;
        var VB_W = 380;
        var VB_H = 506;

        // ═══════════════════════════════════════════════════════════════════
        // CANVAS — LOGICA DEL SEGUNDO ARCHIVO (destination-out, relleno FUERA)
        // ═══════════════════════════════════════════════════════════════════
        var canvas = document.getElementById("overlayCanvas");
        var ctx    = canvas.getContext("2d");

        function resizeCanvas() {
            var stage = canvas.parentElement;
            canvas.width  = stage.clientWidth;
            canvas.height = stage.clientHeight;
            redrawOverlay();
        }

        function redrawOverlay() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            if (!selectedShapeId) return;

            var shape = null;
            for (var i = 0; i < SHAPES.length; i++) {
                if (SHAPES[i].id === selectedShapeId) { shape = SHAPES[i]; break; }
            }
            if (!shape) return;

            var scaleX = canvas.width  / VB_W;
            var scaleY = canvas.height / VB_H;

            ctx.save();
            ctx.scale(scaleX, scaleY);

            var facePath = new Path2D(shape.path);

            // 1. Si hay tono de piel: pintar el area FUERA de la cara con color solido
            if (selectedSkinId) {
                var tone = null;
                for (var j = 0; j < SKIN_TONES.length; j++) {
                    if (SKIN_TONES[j].id === selectedSkinId) { tone = SKIN_TONES[j]; break; }
                }
                if (tone) {
                    // Rellenar todo el canvas con el color de piel
                    ctx.fillStyle = "rgb(" + tone.r + "," + tone.g + "," + tone.b + ")";
                    ctx.fillRect(0, 0, VB_W, VB_H);
                    // Recortar la cara (dejar transparente dentro)
                    ctx.globalCompositeOperation = "destination-out";
                    ctx.fill(facePath);
                    ctx.globalCompositeOperation = "source-over";
                }
            }

            // 2. Contorno blanco grueso alrededor de la cara
            ctx.strokeStyle = "rgba(255,255,255,0.95)";
            ctx.lineWidth   = 5;
            ctx.lineJoin    = "round";
            ctx.stroke(facePath);

            // 3. Sombra negra fina interior para definicion
            ctx.strokeStyle = "rgba(0,0,0,0.35)";
            ctx.lineWidth   = 1.5;
            ctx.stroke(facePath);

            ctx.restore();
        }

        // ═══════════════════════════════════════════════════════════════════
        // RENDER — Estructura del primer archivo, iconos del segundo
        // ═══════════════════════════════════════════════════════════════════
        function renderShapes() {
            var grid = document.getElementById("shapesGrid");
            SHAPES.forEach(function(shape, idx) {
                var chip = document.createElement("button");
                chip.type = "button";
                chip.className = "shape-chip";
                chip.setAttribute("data-id", shape.id);
                chip.innerHTML =
                    '<div class="icon-wrap">' +
                        '<svg viewBox="0 0 32 40" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="1.5" style="width:18px;height:22px;">' + ICONS[shape.id] + '</svg>' +
                    '</div>' +
                    '<span class="label">' + shape.label + '</span>';
                chip.addEventListener("click", function() { selectShape(shape.id); });
                grid.appendChild(chip);
            });
        }

        function renderSkins() {
            var grid = document.getElementById("skinGrid");
            SKIN_TONES.forEach(function(tone, idx) {
                var chip = document.createElement("button");
                chip.type = "button";
                chip.className = "skin-chip";
                chip.setAttribute("data-id", tone.id);
                chip.innerHTML =
                    '<div class="skin-swatch" style="background:' + tone.color + ';"></div>' +
                    '<span class="label">' + tone.label + '</span>';
                chip.addEventListener("click", function() { selectSkin(tone.id); });
                grid.appendChild(chip);
            });
        }

        // ═══════════════════════════════════════════════════════════════════
        // SELECCION — LOGICA DEL SEGUNDO ARCHIVO
        // ═══════════════════════════════════════════════════════════════════
        function selectShape(id) {
            selectedShapeId = id;
            document.querySelectorAll(".shape-chip").forEach(function(c) {
                c.classList.toggle("active", c.getAttribute("data-id") === id);
            });

            var shape = null;
            for (var i = 0; i < SHAPES.length; i++) {
                if (SHAPES[i].id === id) { shape = SHAPES[i]; break; }
            }

            var label = document.getElementById("shapeLabel");
            var labelText = document.getElementById("shapeLabelText");
            if (shape) {
                labelText.textContent = shape.label;
                label.classList.add("visible");
            }

            document.getElementById("hiddenFormaCara").value = id;
            
            // Boton se habilita SOLO con forma (logica original)
            document.getElementById("btnConfirmar").disabled = false;
            
            actualizarHint();
            updateSummary();
            redrawOverlay();
        }

        function selectSkin(id) {
            selectedSkinId = id;
            document.querySelectorAll(".skin-chip").forEach(function(c) {
                c.classList.toggle("active", c.getAttribute("data-id") === id);
            });

            document.getElementById("hiddenTonoPiel").value = id;
            actualizarHint();
            updateSummary();
            redrawOverlay();
        }

        function updateSummary() {
            var shapePill = document.getElementById("summaryShape");
            var skinPill = document.getElementById("summarySkin");

            if (selectedShapeId) {
                var shape = null;
                for (var i = 0; i < SHAPES.length; i++) {
                    if (SHAPES[i].id === selectedShapeId) { shape = SHAPES[i]; break; }
                }
                document.getElementById("summaryShapeValue").textContent = shape ? shape.label : "—";
                shapePill.classList.add("visible");
            } else {
                shapePill.classList.remove("visible");
            }

            if (selectedSkinId) {
                var tone = null;
                for (var j = 0; j < SKIN_TONES.length; j++) {
                    if (SKIN_TONES[j].id === selectedSkinId) { tone = SKIN_TONES[j]; break; }
                }
                document.getElementById("summarySkinValue").textContent = tone ? tone.label : "—";
                skinPill.classList.add("visible");
            } else {
                skinPill.classList.remove("visible");
            }
        }

        // Hint con logica del segundo archivo
        function actualizarHint() {
            var hint = document.getElementById("hintText");
            if (selectedShapeId && selectedSkinId) {
                var sLabel = "", tLabel = "";
                for (var i = 0; i < SHAPES.length; i++) { if (SHAPES[i].id === selectedShapeId) { sLabel = SHAPES[i].label; break; } }
                for (var j = 0; j < SKIN_TONES.length; j++) { if (SKIN_TONES[j].id === selectedSkinId) { tLabel = SKIN_TONES[j].label; break; } }
                hint.textContent = "Forma: " + sLabel + " - Tono: " + tLabel;
                hint.classList.add("ready");
            } else if (selectedShapeId) {
                for (var k = 0; k < SHAPES.length; k++) { if (SHAPES[k].id === selectedShapeId) { hint.textContent = "Forma: " + SHAPES[k].label; break; } }
                hint.classList.remove("ready");
            } else {
                hint.textContent = "Elige la forma que mejor describa tu rostro";
                hint.classList.remove("ready");
            }
        }

        // ═══════════════════════════════════════════════════════════════════
        // CÁMARA — EXACTAMENTE IGUAL que la version original
        // ═══════════════════════════════════════════════════════════════════
        function initCamera() {
            var video = document.getElementById("video");
            var noCam = document.getElementById("noCamMsg");

            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                video.style.display = "none";
                noCam.style.display = "flex";
                resizeCanvas();
                return;
            }

            navigator.mediaDevices.getUserMedia({
                video: { facingMode: { ideal: "user" }, width: { ideal: 640 }, height: { ideal: 853 } },
                audio: false
            })
            .then(function(stream) {
                video.srcObject = stream;
                video.addEventListener("loadedmetadata", function() {
                    resizeCanvas();
                });
            })
            .catch(function(err) {
                console.warn("Cámara no disponible:", err);
                video.style.display = "none";
                noCam.style.display = "flex";
                resizeCanvas();
            });
        }

        function requestCamera() {
            initCamera();
        }

        // ═══════════════════════════════════════════════════════════════════
        // INIT — EXACTAMENTE IGUAL
        // ═══════════════════════════════════════════════════════════════════
        document.addEventListener("DOMContentLoaded", function() {
            renderShapes();
            renderSkins();
            initCamera();
            window.addEventListener("resize", resizeCanvas);
        });

        // Toast auto-hide — Exacto como tus archivos
        setTimeout(function() {
            document.querySelectorAll(".toast-item").forEach(function(t) {
                t.style.transition = "all 0.4s ease";
                t.style.opacity = "0";
                t.style.transform = "translateX(120%)";
                setTimeout(function() { if(t.parentNode) t.parentNode.removeChild(t); }, 400);
            });
        }, 4000);
    
    </script>
</body>
</html>