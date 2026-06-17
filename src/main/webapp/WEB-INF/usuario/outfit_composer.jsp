<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=DM+Sans:wght@300;400;500;700&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <title>Armar Outfit — Quiddity</title>
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

      /* Paleta unisex — Teal/Cyan como acento principal */
      --pastel-teal: #e0f2f1;
      --pastel-teal-dark: #b2dfdb;
      --pastel-teal-deep: #80cbc4;
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
      --pastel-sky: #e3f2fd;
      --pastel-sky-dark: #bbdefb;
      --pastel-rose: #fce4ec;
      --pastel-rose-dark: #f8bbd0;
      --pastel-stone: #f5f5f4;
      --pastel-stone-dark: #e7e5e4;

      --accent-teal: #00897b;
      --accent-teal-light: #26a69a;
      --accent-mint: #388e3c;
      --accent-lavender: #7b1fa2;
      --accent-cream: #f57c00;
      --accent-coral: #c2185b;
      --accent-sage: #689f38;
      --accent-sky: #1976d2;
      --accent-rose: #c2185b;
      --accent-stone: #78716c;

      /* Colores de énfasis unisex */
      --uni-teal: #0d9488;
      --uni-teal-light: #14b8a6;
      --uni-teal-pale: #ccfbf1;
      --uni-slate: #475569;
      --uni-slate-light: #64748b;
      --uni-warm: #a8a29e;

      --radius-sm: 10px;
      --radius-md: 12px;
      --radius-lg: 14px;
      --radius-xl: 20px;
      --radius-full: 999px;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
      --shadow: 0 2px 8px rgba(0,0,0,0.06);
      --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
      --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
      --shadow-teal: 0 4px 20px rgba(13,148,136,0.12);
      --transition-fast: 0.15s ease;
      --transition-base: 0.3s ease;
      --transition-spring: 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
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

    /* ═══════════════════════════════════════════════════════════════════
       LAYOUT — Full viewport
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
       WELCOME SECTION — Estilo Dashboard con acento teal
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

    .welcome-title span { color: var(--uni-teal); }

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
      background: linear-gradient(135deg, var(--pastel-teal), var(--pastel-teal-dark));
      border: 1px solid var(--pastel-teal-deep);
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

    /* ═══════════════════════════════════════════════════════════════════
       STATS BAR — Estilo Dashboard con acento teal
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
      border-color: var(--pastel-teal-dark);
    }

    .stat-item::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: var(--uni-teal);
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

    /* ═══════════════════════════════════════════════════════════════════
       DASHBOARD GRID — 2 columnas
       ═══════════════════════════════════════════════════════════════════ */
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 420px;
      gap: 20px;
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
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════
       DISEÑO ORIGINAL — Selecciona tus prendas, Prendas seleccionadas,
       Tu look, Modales. EXACTAMENTE IGUAL AL ARCHIVO ORIGINAL.
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════ */

    /* ── Panel izquierdo: selector ── */
    .panel {
      background: #fff;
      border-radius: 20px;
      padding: 22px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
    }

    .panel-title {
      font-size: 1rem;
      font-weight: 700;
      margin-bottom: 16px;
      color: #1a1a1a;
    }

    .tabs {
      display: flex;
      gap: 7px;
      flex-wrap: wrap;
      margin-bottom: 18px;
    }

    .tab {
      padding: 7px 16px;
      border-radius: 20px;
      border: 1.5px solid #e8e8e8;
      background: #fff;
      cursor: pointer;
      font-size: .8rem;
      font-weight: 500;
      transition: .18s;
      color: #555;
    }

    .tab.active {
      background: #1a1a1a;
      color: #fff;
      border-color: #1a1a1a;
    }

    .prendas-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
      gap: 12px;
      max-height: 560px;
      overflow-y: auto;
      padding-right: 4px;
    }

    .prendas-grid::-webkit-scrollbar { width: 4px; }
    .prendas-grid::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }

    .prenda-item {
      border-radius: 14px;
      overflow: hidden;
      cursor: pointer;
      border: 2.5px solid transparent;
      transition: .2s;
      background: #f8f8f8;
      position: relative;
    }

    .prenda-item.sel {
      border-color: #1a1a1a;
      box-shadow: 0 0 0 3px rgba(0,0,0,.08);
    }

    .prenda-item img {
      width: 100%;
      aspect-ratio: 1;
      object-fit: cover;
      display: block;
    }

    .prenda-check {
      position: absolute;
      top: 7px;
      right: 7px;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: #1a1a1a;
      color: #fff;
      font-size: .7rem;
      display: none;
      align-items: center;
      justify-content: center;
      font-weight: 700;
    }

    .prenda-item.sel .prenda-check { display: flex; }

    .prenda-label {
      padding: 6px 9px;
      font-size: .75rem;
      color: #666;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      text-transform: capitalize;
    }

    /* ── Panel derecho ── */
    .right-panel {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* Tira de seleccionadas */
    .strip-panel {
      background: #fff;
      border-radius: 20px;
      padding: 18px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
    }

    .strip-label {
      font-size: .82rem;
      font-weight: 600;
      color: #888;
      text-transform: uppercase;
      letter-spacing: .04em;
      margin-bottom: 12px;
    }

    .strip {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      min-height: 70px;
      align-items: flex-start;
    }

    .strip-item {
      position: relative;
      width: 62px;
      flex-shrink: 0;
    }

    .strip-item img {
      width: 62px;
      height: 62px;
      object-fit: cover;
      border-radius: 10px;
      border: 1.5px solid #eee;
      display: block;
    }

    .strip-del {
      position: absolute;
      top: -5px;
      right: -5px;
      width: 18px;
      height: 18px;
      border-radius: 50%;
      background: #1a1a1a;
      color: #fff;
      border: none;
      font-size: .6rem;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .strip-empty {
      color: #ccc;
      font-size: .85rem;
      padding: 16px 0;
      width: 100%;
      text-align: center;
    }

    /* Resultado */
    .result-panel {
      background: #fff;
      border-radius: 20px;
      padding: 18px;
      flex: 1;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
    }

    .result-label {
      font-size: .82rem;
      font-weight: 600;
      color: #888;
      text-transform: uppercase;
      letter-spacing: .04em;
      margin-bottom: 14px;
    }

    /* Canvas del flatlay */
    .flatlay-wrap {
      width: 100%;
      aspect-ratio: 4/5;
      border-radius: 14px;
      background: #f8f7f5;
      overflow: hidden;
      cursor: pointer;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .flatlay-wrap img {
      width: 100%;
      height: 100%;
      object-fit: contain;
      display: block;
    }

    .flatlay-placeholder {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 10px;
      color: #ccc;
      text-align: center;
      padding: 20px;
    }

    .flatlay-placeholder .ph-icon {
      font-size: 2.2rem;
    }

    .flatlay-placeholder p {
      font-size: .85rem;
    }

    .flatlay-loader {
      display: none;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 14px;
      width: 100%;
      aspect-ratio: 4/5;
    }

    .spinner {
      width: 36px;
      height: 36px;
      border: 3px solid #e8e8e8;
      border-top-color: #1a1a1a;
      border-radius: 50%;
      animation: spin .9s linear infinite;
    }

    .loader-text {
      font-size: .85rem;
      color: #888;
    }

    /* Acciones */
    .btn-generate {
      width: 100%;
      padding: 13px;
      background: #1a1a1a;
      color: #fff;
      border: none;
      border-radius: 14px;
      font-size: .95rem;
      font-weight: 600;
      cursor: pointer;
      margin-top: 14px;
      transition: .18s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .btn-generate:disabled {
      background: #ddd;
      cursor: not-allowed;
      color: #aaa;
    }

    .result-actions {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      margin-top: 10px;
    }

    .btn-action {
      padding: 10px;
      border-radius: 12px;
      border: 1.5px solid #e8e8e8;
      background: #fff;
      cursor: pointer;
      font-size: .82rem;
      font-weight: 500;
      transition: .18s;
      text-align: center;
    }

    .btn-action:hover {
      background: #f5f5f5;
    }

    .btn-action.primary {
      background: #1a1a1a;
      color: #fff;
      border-color: #1a1a1a;
    }

    .btn-action.primary:hover {
      background: #333;
    }

    /* ── Modales ── */
    .overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,.55);
      z-index: 200;
      align-items: center;
      justify-content: center;
    }

    .overlay.open {
      display: flex;
    }

    /* Modal detalle look */
    .modal-look {
      background: #fff;
      border-radius: 24px;
      width: 100%;
      max-width: 560px;
      overflow: hidden;
      box-shadow: 0 20px 60px rgba(0,0,0,.2);
    }

    .look-img-full {
      width: 100%;
      aspect-ratio: 4/5;
      object-fit: contain;
      background: #f8f7f5;
      display: block;
    }

    .look-footer {
      padding: 20px 22px;
    }

    .look-footer-title {
      font-size: 1rem;
      font-weight: 700;
      margin-bottom: 6px;
    }

    .look-prendas-strip {
      display: flex;
      gap: 8px;
      overflow-x: auto;
      padding-bottom: 6px;
      margin-bottom: 16px;
    }

    .look-prenda-mini {
      width: 52px;
      height: 52px;
      border-radius: 10px;
      object-fit: cover;
      flex-shrink: 0;
      border: 1.5px solid #eee;
      cursor: pointer;
      transition: .18s;
    }

    .look-prenda-mini:hover {
      border-color: #1a1a1a;
      transform: scale(1.06);
    }

    .look-actions {
      display: flex;
      gap: 10px;
    }

    /* Modal detalle prenda */
    .modal-prenda {
      background: #fff;
      border-radius: 24px;
      width: 100%;
      max-width: 440px;
      padding: 0;
      overflow: hidden;
    }

    .prenda-img-big {
      width: 100%;
      aspect-ratio: 1;
      object-fit: cover;
      background: #f5f5f5;
      display: block;
    }

    .prenda-body {
      padding: 20px 22px;
    }

    .prenda-body-tag {
      display: inline-block;
      background: #f0f0f0;
      border-radius: 12px;
      padding: 3px 12px;
      font-size: .78rem;
      color: #555;
      margin-bottom: 10px;
      text-transform: capitalize;
    }

    .prenda-body h3 {
      font-size: 1.05rem;
      font-weight: 700;
      margin-bottom: 4px;
      text-transform: capitalize;
    }

    .prenda-body p {
      font-size: .85rem;
      color: #888;
      margin-bottom: 16px;
    }

    .prenda-swap-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(68px, 1fr));
      gap: 8px;
      max-height: 200px;
      overflow-y: auto;
      margin-bottom: 16px;
      border: 1.5px solid #f0f0f0;
      border-radius: 12px;
      padding: 10px;
    }

    .swap-item {
      width: 100%;
      aspect-ratio: 1;
      object-fit: cover;
      border-radius: 10px;
      cursor: pointer;
      border: 2px solid transparent;
      transition: .18s;
    }

    .swap-item:hover {
      border-color: #1a1a1a;
    }

    .swap-item.sel {
      border-color: #1a1a1a;
      box-shadow: 0 0 0 2px rgba(0,0,0,.15);
    }

    .btn-swap {
      width: 100%;
      padding: 11px;
      background: #1a1a1a;
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: .9rem;
      font-weight: 600;
      cursor: pointer;
    }

    /* Modal calendario */
    .modal-cal {
      background: #fff;
      border-radius: 24px;
      padding: 28px;
      width: 100%;
      max-width: 380px;
    }

    .modal-cal h3 {
      font-size: 1.05rem;
      font-weight: 700;
      margin-bottom: 20px;
    }

    .field {
      margin-bottom: 14px;
    }

    .field label {
      display: block;
      font-size: .82rem;
      font-weight: 500;
      color: #555;
      margin-bottom: 5px;
    }

    .field input,
    .field select {
      width: 100%;
      padding: 10px 13px;
      border: 1.5px solid #e8e8e8;
      border-radius: 11px;
      font-size: .88rem;
      outline: none;
      transition: .18s;
    }

    .field input:focus,
    .field select:focus {
      border-color: #1a1a1a;
    }

    .modal-btns {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }

    .btn-cancel {
      flex: 1;
      padding: 11px;
      background: #f0f0f0;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-size: .9rem;
    }

    .btn-ok {
      flex: 1;
      padding: 11px;
      background: #1a1a1a;
      color: #fff;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-size: .9rem;
      font-weight: 600;
    }

    /* Toast */
    .toast {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%);
      background: #1a1a1a;
      color: #fff;
      padding: 11px 24px;
      border-radius: 24px;
      font-size: .88rem;
      opacity: 0;
      transition: .28s;
      pointer-events: none;
      z-index: 500;
      white-space: nowrap;
    }

    .toast.show {
      opacity: 1;
    }

    /* Empty state */
    .empty-closet {
      text-align: center;
      padding: 40px 20px;
      color: #bbb;
      grid-column: 1/-1;
    }

    .empty-closet a {
      color: #1a1a1a;
      font-weight: 600;
      text-decoration: none;
    }

    /* ═══════════════════════════════════════════════════════════════════
       ANIMACIONES
       ═══════════════════════════════════════════════════════════════════ */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(12px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .anim-fade-up {
      animation: fadeUp 0.5s ease forwards;
      opacity: 0;
    }

    .delay-1 { animation-delay: 0.06s; }
    .delay-2 { animation-delay: 0.12s; }
    .delay-3 { animation-delay: 0.18s; }

    /* ═══════════════════════════════════════════════════════════════════
       RESPONSIVE
       ═══════════════════════════════════════════════════════════════════ */
    @media (max-width: 1024px) {
      .dashboard-grid { grid-template-columns: 1fr; }
      .dashboard-right { flex-direction: row; }
      .strip-panel, .result-panel { flex: 1; }
    }

    @media (max-width: 768px) {
      .main-content { padding: 8px 12px; gap: 8px; }
      .welcome-section { flex-direction: column; gap: 8px; text-align: center; padding: 8px 12px; }
      .welcome-title { font-size: 16px; }
      .stats-bar { grid-template-columns: 1fr; gap: 8px; }
      .dashboard-right { flex-direction: column; }
      .prendas-grid { grid-template-columns: repeat(3, 1fr); gap: 6px; }
    }

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
  </style>
</head>
<body>

<!-- TOAST -->
<div class="toast" id="toast"></div>

<div class="layout-wrapper">
  <jsp:include page="/includes/sidebar.jsp"/>

  <main class="main-content">

    <!-- ═══════════════════════════════════════════════════════════════
         WELCOME SECTION — Estilo Dashboard con acento teal
         ═══════════════════════════════════════════════════════════════ -->
    <div class="welcome-section anim-fade-up">
      <div class="welcome-content">
        <h1 class="welcome-title">Armar <span>Outfit</span></h1>
        <p class="welcome-subtitle">Selecciona prendas de tu closet y genera combinaciones perfectas</p>
      </div>
      <div class="welcome-actions">
        <div class="step-badge">
          <span class="material-symbols-outlined">auto_awesome</span>
          Paso 2 de 5
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════
         STATS BAR — Estilo Dashboard con acento teal
         ═══════════════════════════════════════════════════════════════ -->
    <div class="stats-bar anim-fade-up delay-1">
      <div class="stat-item">
        <div class="stat-icon teal">
          <span class="material-symbols-outlined">checkroom</span>
        </div>
        <div class="stat-data">
          <h4 id="statPrendas">0</h4>
          <p>Prendas en closet</p>
        </div>
      </div>
      <div class="stat-item">
        <div class="stat-icon rose">
          <span class="material-symbols-outlined">favorite</span>
        </div>
        <div class="stat-data">
          <h4 id="statSeleccionadas">0</h4>
          <p>Seleccionadas</p>
        </div>
      </div>
      <div class="stat-item">
        <div class="stat-icon lavender">
          <span class="material-symbols-outlined">auto_awesome</span>
        </div>
        <div class="stat-data">
          <h4 id="statLooks">0</h4>
          <p>Looks generados</p>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════
         DASHBOARD GRID — 2 columnas
         ═══════════════════════════════════════════════════════════════ -->
    <div class="dashboard-grid">

      <!-- ═══════════════════════════════════════════════════════════
           LEFT COLUMN: Selecciona tus prendas — DISEÑO ORIGINAL
           ═══════════════════════════════════════════════════════════ -->
      <div class="dashboard-left">
        <div class="panel anim-fade-up delay-2" style="flex: 1;">
          <p class="panel-title">Selecciona tus prendas</p>
          <div class="tabs">
            <button class="tab active" onclick="filtrar('todos',this)">Todas</button>
            <button class="tab" onclick="filtrar('tops',this)">Tops</button>
            <button class="tab" onclick="filtrar('bottoms',this)">Bottoms</button>
            <button class="tab" onclick="filtrar('dresses',this)">Vestidos</button>
            <button class="tab" onclick="filtrar('outerwear',this)">Outerwear</button>
            <button class="tab" onclick="filtrar('shoes',this)">Zapatos</button>
            <button class="tab" onclick="filtrar('accessories',this)">Accesorios</button>
          </div>

          <div class="prendas-grid" id="prendasGrid">
            <c:choose>
              <c:when test="${empty prendas}">
                <div class="empty-closet">
                  <p style="font-size:1.1rem;margin-bottom:8px">Tu closet está vacío</p>
                  <a href="${ctx}/closet">Agregar prendas →</a>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="p" items="${prendas}">
                  <div class="prenda-item"
                       data-id="${p.id}"
                       data-tipo="${p.tipo}"
                       data-img="${ctx}/${p.imagen}"
                       data-color="${p.color}"
                       data-estilo="${p.estilo}"
                       onclick="togglePrenda(this)">
                    <img src="${ctx}/${p.imagen}" alt="${p.tipo}"
                         onerror="this.src='${ctx}/img/placeholder.png'"/>
                    <div class="prenda-check">✓</div>
                    <div class="prenda-label">${p.color} ${p.tipo}</div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- ═══════════════════════════════════════════════════════════
           RIGHT COLUMN: Prendas seleccionadas + Tu look — DISEÑO ORIGINAL
           ═══════════════════════════════════════════════════════════ -->
      <div class="dashboard-right">

        <!-- Prendas seleccionadas — DISEÑO ORIGINAL -->
        <div class="strip-panel anim-fade-up delay-3">
          <div class="strip-label">Prendas seleccionadas</div>
          <div class="strip" id="strip">
            <span class="strip-empty">Toca una prenda para agregarla</span>
          </div>
        </div>

        <!-- Tu look — DISEÑO ORIGINAL -->
        <div class="result-panel anim-fade-up delay-3" style="flex: 1;">
          <div class="result-label">Tu look</div>

          <div class="flatlay-wrap" id="flaywrap" onclick="lookIdActual && abrirLook()">
            <div class="flatlay-placeholder" id="placeholder">
              <span class="ph-icon">🪄</span>
              <p>Selecciona prendas y genera tu look</p>
            </div>
            <div class="flatlay-loader" id="loader">
              <div class="spinner"></div>
              <span class="loader-text">Armando tu outfit...</span>
            </div>
            <img id="imgResult" style="display:none" alt="Tu look"/>
          </div>

          <button class="btn-generate" id="btnGenerar" disabled onclick="generarFlatlay()">
            ✨ Generar look
          </button>

          <div class="result-actions" id="resultActions" style="display:none">
            <button class="btn-action" onclick="generarFlatlay()">🔄 Regenerar</button>
            <button class="btn-action primary" onclick="abrirModalCal()">📅 Al calendario</button>
          </div>
        </div>
      </div>
    </div>

  </main>
</div>

<%-- ═══════════════════════════════════════════════════════════════════
     MODAL: look completo — DISEÑO ORIGINAL
     ═══════════════════════════════════════════════════════════════════ --%>
<div class="overlay" id="overlayLook">
  <div class="modal-look">
    <img id="lookImgFull" class="look-img-full" alt="look"/>
    <div class="look-footer">
      <p class="look-footer-title">Tu outfit</p>
      <div class="look-prendas-strip" id="lookPrendasStrip"></div>
      <div class="look-actions">
        <button class="btn-action" style="flex:1" onclick="cerrarLook()">Cerrar</button>
        <button class="btn-action" style="flex:1" onclick="abrirModalCal()">📅 Al calendario</button>
        <button class="btn-action primary" style="flex:1" onclick="generarFlatlay()">🔄 Regenerar</button>
      </div>
    </div>
  </div>
</div>

<%-- ═══════════════════════════════════════════════════════════════════
     MODAL: detalle + swap de prenda — DISEÑO ORIGINAL
     ═══════════════════════════════════════════════════════════════════ --%>
<div class="overlay" id="overlayPrenda">
  <div class="modal-prenda">
    <img id="prendaImgBig" class="prenda-img-big" alt="prenda"/>
    <div class="prenda-body">
      <span class="prenda-body-tag" id="prendaTipo"></span>
      <h3 id="prendaDesc"></h3>
      <p id="prendaEstilo"></p>
      <p style="font-size:.8rem;color:#aaa;margin-bottom:10px">
        Cambia por otra prenda del mismo tipo:
      </p>
      <div class="prenda-swap-grid" id="swapGrid"></div>
      <div style="display:flex;gap:10px">
        <button class="btn-action" style="flex:1" onclick="cerrarPrenda()">Cancelar</button>
        <button class="btn-swap" id="btnSwap" disabled onclick="aplicarSwap()">
          Cambiar prenda
        </button>
      </div>
    </div>
  </div>
</div>

<%-- ═══════════════════════════════════════════════════════════════════
     MODAL: agregar al calendario — DISEÑO ORIGINAL
     ═══════════════════════════════════════════════════════════════════ --%>
<div class="overlay" id="overlayCal">
  <div class="modal-cal">
    <h3>📅 Agregar al calendario</h3>
    <div class="field">
      <label>Fecha</label>
      <input type="date" id="calFecha"/>
    </div>
    <div class="field">
      <label>Momento del día</label>
      <select id="calMomento">
        <option value="manana">Mañana</option>
        <option value="tarde">Tarde</option>
        <option value="noche">Noche</option>
      </select>
    </div>
    <div class="field">
      <label>Nota (opcional)</label>
      <input type="text" id="calNota" placeholder="ej: reunión, cita..."/>
    </div>
    <div class="modal-btns">
      <button class="btn-cancel" onclick="cerrarCal()">Cancelar</button>
      <button class="btn-ok" onclick="guardarEnCal()">Guardar</button>
    </div>
  </div>
</div>

<script>
var ctx = '${ctx}';
var seleccionadas  = [];   // [{id, img, tipo, color, estilo}]
var lookIdActual   = null;
var prendasLook    = [];   // prendas del look generado
var prendaEditando = null; // prenda que se está cambiando
var swapIdNuevo    = null; // nueva prenda seleccionada en el swap

// Actualizar stats bar
function updateStats() {
  var totalPrendas = document.querySelectorAll('.prenda-item').length;
  document.getElementById('statPrendas').textContent = totalPrendas;
  document.getElementById('statSeleccionadas').textContent = seleccionadas.length;
  // looks generados se mantiene en 0 hasta que se genere uno
}

// ── Filtros por tab ────────────────────────────────────────────
function filtrar(tipo, btn) {
  document.querySelectorAll('.tab').forEach(function(t){ t.classList.remove('active'); });
  btn.classList.add('active');
  document.querySelectorAll('.prenda-item').forEach(function(el) {
    el.style.display = (tipo === 'todos' || el.dataset.tipo === tipo) ? '' : 'none';
  });
}

// ── Toggle prenda ──────────────────────────────────────────────
function togglePrenda(el) {
  var id  = el.dataset.id;
  var idx = seleccionadas.findIndex(function(p){ return p.id === id; });
  if (idx === -1) {
    seleccionadas.push({
      id:     id,
      img:    el.dataset.img,
      tipo:   el.dataset.tipo,
      color:  el.dataset.color,
      estilo: el.dataset.estilo
    });
    el.classList.add('sel');
  } else {
    seleccionadas.splice(idx, 1);
    el.classList.remove('sel');
  }
  renderStrip();
  updateStats();
  document.getElementById('btnGenerar').disabled = seleccionadas.length === 0;
}

// ── Tira de seleccionadas ──────────────────────────────────────
function renderStrip() {
  var strip = document.getElementById('strip');
  strip.innerHTML = '';
  if (seleccionadas.length === 0) {
    var sp = document.createElement('span');
    sp.className = 'strip-empty';
    sp.textContent = 'Toca una prenda para agregarla';
    strip.appendChild(sp);
    return;
  }
  seleccionadas.forEach(function(p) {
    var item = document.createElement('div');
    item.className = 'strip-item';
    var img = document.createElement('img');
    img.src = p.img;
    img.alt = p.tipo;
    img.onerror = function(){ this.src = ctx + '/img/placeholder.png'; };
    var del = document.createElement('button');
    del.className = 'strip-del';
    del.textContent = '✕';
    (function(pid){ del.onclick = function(e){ e.stopPropagation(); quitarDeTira(pid); }; })(p.id);
    item.appendChild(img);
    item.appendChild(del);
    strip.appendChild(item);
  });
}

function quitarDeTira(id) {
  seleccionadas = seleccionadas.filter(function(p){ return p.id !== id; });
  var el = document.querySelector('.prenda-item[data-id="' + id + '"]');
  if (el) el.classList.remove('sel');
  renderStrip();
  updateStats();
  document.getElementById('btnGenerar').disabled = seleccionadas.length === 0;
}

// ── Generar flatlay ────────────────────────────────────────────
async function generarFlatlay() {
  if (seleccionadas.length === 0) { mostrarToast('Selecciona al menos una prenda'); return; }

  document.getElementById('placeholder').style.display  = 'none';
  document.getElementById('imgResult').style.display    = 'none';
  document.getElementById('resultActions').style.display = 'none';
  document.getElementById('loader').style.display       = 'flex';
  document.getElementById('btnGenerar').disabled = true;

  var params = seleccionadas.map(function(p){ return 'prendas=' + encodeURIComponent(p.id); }).join('&');

  try {
    var res  = await fetch(ctx + '/outfit/generar', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params
    });
    var data = await res.json();

    document.getElementById('loader').style.display = 'none';

    if (res.ok) {
      lookIdActual = data.id;
      prendasLook  = data.prendas || [];

      var img = document.getElementById('imgResult');
      img.src = ctx + '/' + data.imagen;
      img.style.display = 'block';
      img.onerror = function(){ this.src = ctx + '/img/placeholder.png'; };

      document.getElementById('resultActions').style.display = 'grid';
      document.getElementById('flaywrap').style.cursor = 'pointer';
      document.getElementById('statLooks').textContent = '1';
      mostrarToast('✨ Look generado');
    } else {
      document.getElementById('placeholder').style.display = 'flex';
      mostrarToast('❌ ' + (data.error || 'Error al generar'));
    }
  } catch(e) {
    document.getElementById('loader').style.display    = 'none';
    document.getElementById('placeholder').style.display = 'flex';
    mostrarToast('❌ Error de conexión');
  } finally {
    document.getElementById('btnGenerar').disabled = false;
  }
}

// ── Modal: look completo ───────────────────────────────────────
function abrirLook() {
  if (!lookIdActual) return;
  var imgSrc = document.getElementById('imgResult').src;
  document.getElementById('lookImgFull').src = imgSrc;

  // Strip de prendas del look con click para editar
  var strip = document.getElementById('lookPrendasStrip');
  strip.innerHTML = '';
  prendasLook.forEach(function(p) {
    var img = document.createElement('img');
    img.className = 'look-prenda-mini';
    img.src = ctx + '/' + p.imagen;
    img.alt = p.tipo;
    img.title = p.color + ' ' + p.tipo;
    img.onerror = function(){ this.src = ctx + '/img/placeholder.png'; };
    (function(prenda){ img.onclick = function(){ cerrarLook(); abrirSwap(prenda); }; })(p);
    strip.appendChild(img);
  });

  document.getElementById('overlayLook').classList.add('open');
}
function cerrarLook() { document.getElementById('overlayLook').classList.remove('open'); }
document.getElementById('overlayLook').addEventListener('click', function(e){
  if (e.target === this) cerrarLook();
});

// ── Modal: detalle + swap de prenda ───────────────────────────
function abrirSwap(prenda) {
  prendaEditando = prenda;
  swapIdNuevo    = null;
  document.getElementById('btnSwap').disabled = true;

  document.getElementById('prendaImgBig').src    = ctx + '/' + prenda.imagen;
  document.getElementById('prendaTipo').textContent  = prenda.tipo;
  document.getElementById('prendaDesc').textContent  = prenda.color + ' ' + prenda.tipo;
  document.getElementById('prendaEstilo').textContent = prenda.estilo || '';

  // Cargar prendas del mismo tipo para el swap
  var grid = document.getElementById('swapGrid');
  grid.innerHTML = '<span style="color:#bbb;font-size:.82rem">Cargando...</span>';

  fetch(ctx + '/closet/prenda?tipo=' + encodeURIComponent(prenda.tipo))
    .then(function(r){ return r.json(); })
    .then(function(lista) {
      grid.innerHTML = '';
      var mismoTipo = lista.filter(function(p){ return p.id !== prenda.id; });
      if (mismoTipo.length === 0) {
        grid.innerHTML = '<span style="color:#bbb;font-size:.82rem">No hay otras prendas de este tipo</span>';
        return;
      }
      mismoTipo.forEach(function(p) {
        var img = document.createElement('img');
        img.className = 'swap-item';
        img.src = ctx + '/' + p.imagen;
        img.alt = p.tipo;
        img.title = p.color + ' ' + p.tipo;
        img.onerror = function(){ this.src = ctx + '/img/placeholder.png'; };
        (function(pid, el){
          el.onclick = function() {
            document.querySelectorAll('.swap-item').forEach(function(i){ i.classList.remove('sel'); });
            el.classList.add('sel');
            swapIdNuevo = pid;
            document.getElementById('btnSwap').disabled = false;
          };
        })(p.id, img);
        grid.appendChild(img);
      });
    })
    .catch(function(){ grid.innerHTML = '<span style="color:#bbb">Error al cargar</span>'; });

  document.getElementById('overlayPrenda').classList.add('open');
}
function cerrarPrenda() {
  document.getElementById('overlayPrenda').classList.remove('open');
  prendaEditando = null; swapIdNuevo = null;
}
document.getElementById('overlayPrenda').addEventListener('click', function(e){
  if (e.target === this) cerrarPrenda();
});

function aplicarSwap() {
  if (!swapIdNuevo || !prendaEditando) return;
  // Reemplazar en seleccionadas
  var idx = seleccionadas.findIndex(function(p){ return p.id == prendaEditando.id; });
  if (idx !== -1) seleccionadas.splice(idx, 1);
  // Quitar mark visual de la prenda vieja
  var elVieja = document.querySelector('.prenda-item[data-id="' + prendaEditando.id + '"]');
  if (elVieja) elVieja.classList.remove('sel');
  // Agregar nueva
  var elNueva = document.querySelector('.prenda-item[data-id="' + swapIdNuevo + '"]');
  if (elNueva) {
    seleccionadas.push({
      id:     String(swapIdNuevo),
      img:    elNueva.dataset.img,
      tipo:   elNueva.dataset.tipo,
      color:  elNueva.dataset.color,
      estilo: elNueva.dataset.estilo
    });
    elNueva.classList.add('sel');
  }
  cerrarPrenda();
  renderStrip();
  updateStats();
  mostrarToast('Prenda cambiada — regenera para ver el cambio');
}

// ── Modal calendario ───────────────────────────────────────────
function abrirModalCal() {
  if (!lookIdActual) { mostrarToast('Genera un look primero'); return; }
  var hoy = new Date();
  var mm  = String(hoy.getMonth()+1).padStart(2,'0');
  var dd  = String(hoy.getDate()).padStart(2,'0');
  document.getElementById('calFecha').value = hoy.getFullYear() + '-' + mm + '-' + dd;
  document.getElementById('overlayCal').classList.add('open');
}
function cerrarCal() { document.getElementById('overlayCal').classList.remove('open'); }
document.getElementById('overlayCal').addEventListener('click', function(e){
  if (e.target === this) cerrarCal();
});

async function guardarEnCal() {
  var fecha   = document.getElementById('calFecha').value;
  var momento = document.getElementById('calMomento').value;
  var nota    = document.getElementById('calNota').value;
  if (!fecha) { mostrarToast('Selecciona una fecha'); return; }

  var res = await fetch(ctx + '/calendario', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'fecha='    + encodeURIComponent(fecha)
        + '&idLook='  + encodeURIComponent(lookIdActual)
        + '&momento=' + encodeURIComponent(momento)
        + '&nota='    + encodeURIComponent(nota || '')
  });
  var data = await res.json();
  cerrarCal();
  mostrarToast(res.ok ? '📅 Guardado en el calendario' : '❌ ' + (data.error || 'Error'));
}

// ── Toast ──────────────────────────────────────────────────────
function mostrarToast(msg) {
  var t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(function(){ t.classList.remove('show'); }, 3000);
}

// ── Init ───────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {
  updateStats();
});
</script>
</body>
</html>