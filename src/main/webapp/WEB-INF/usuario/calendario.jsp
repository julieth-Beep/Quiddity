<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
  <head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
  <title>Calendario — Quiddity</title>
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
      --accent: #4338ca;
      --accent-light: #e0e7ff;
      --accent-hover: #3730a3;
      --radius-sm: 10px;
      --radius-md: 14px;
      --radius-lg: 16px;
      --radius-xl: 20px;
      --radius-full: 999px;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
      --shadow: 0 2px 8px rgba(0,0,0,0.06);
      --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
      --transition-fast: 0.15s ease;
      --transition-base: 0.3s ease;
    }

    * { box-sizing: border-box; margin: 0; padding: 0 }

    html, body { height: 100vh; overflow: hidden; }

    body {
      font-family: 'Plus Jakarta Sans', 'Segoe UI', sans-serif;
      background: var(--bg);
      color: var(--text-primary);
      font-size: 13px;
      line-height: 1.5;
      -webkit-font-smoothing: antialiased;
    }

    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
      vertical-align: middle;
    }

    /* ═══════════════════════════════════════════════════════════════════
       LAYOUT
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
      height: 100vh;
      overflow: hidden;
      background: var(--bg);
      transition: max-width 0.35s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .main-content.sidebar-open { max-width: calc(100% - 320px); }
    .main-content.sidebar-closed { max-width: 100%; }

    .page {
      max-width: 1000px;
      margin: 0 auto;
      padding: 0 20px 28px 20px;
      width: 100%;
      overflow-y: auto;
      flex: 1;
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
      padding: 14px 20px;
      border: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
      margin: 16px 20px 16px 20px;
      flex-shrink: 0;
      animation: fadeUp 0.4s ease forwards;
    }

    .welcome-content { flex: 1; }

    .welcome-title {
      font-family: 'DM Sans', sans-serif;
      font-size: 20px;
      font-weight: 700;
      color: var(--text-primary);
      margin: 0 0 3px 0;
      letter-spacing: -0.3px;
    }

    .welcome-title span { color: var(--accent); }

    .welcome-subtitle {
      font-size: 12px;
      color: var(--text-secondary);
      font-weight: 500;
      margin: 0;
    }

    .welcome-actions {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .step-badge {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      padding: 6px 12px;
      background: var(--accent-light);
      border: 1px solid var(--accent-light);
      border-radius: var(--radius-md);
      font-size: 9px;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--accent);
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .step-badge .material-symbols-outlined {
      font-size: 14px;
      color: var(--accent);
    }

    /* Toggle Outfits Button */
    .toggle-outfits-btn {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      background: var(--accent-light);
      border: 1px solid var(--accent-light);
      border-radius: var(--radius-md);
      cursor: pointer;
      transition: all 0.25s ease;
      font-family: 'Plus Jakarta Sans', sans-serif;
      font-size: 12px;
      font-weight: 600;
      color: var(--accent);
    }

    .toggle-outfits-btn:hover {
      background: #c7d2fe;
      transform: translateY(-1px);
      box-shadow: var(--shadow);
    }

    .toggle-outfits-btn .material-symbols-outlined { font-size: 18px; }
    .toggle-outfits-btn .toggle-icon { transition: transform 0.3s ease; }
    .toggle-outfits-btn.active .toggle-icon { transform: rotate(180deg); }

    /* ═══════════════════════════════════════════════════════════════════
       RIGHT SIDEBAR - OUTFITS PROGRAMADOS
       ═══════════════════════════════════════════════════════════════════ */
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
      flex-shrink: 0;
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

    .sidebar-title .material-symbols-outlined {
      font-size: 20px;
      color: var(--accent);
    }

    .sidebar-close {
      width: 28px;
      height: 28px;
      border-radius: 8px;
      border: none;
      background: var(--accent-light);
      color: var(--accent);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
    }

    .sidebar-close:hover {
      background: #c7d2fe;
      transform: scale(1.1);
    }

    .sidebar-close .material-symbols-outlined { font-size: 16px; }

    /* Outfit list items */
    .outfit-list {
      display: flex;
      flex-direction: column;
      gap: 8px;
      flex: 1;
      overflow-y: auto;
      min-height: 0;
    }

    .outfit-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 12px;
      background: var(--bg);
      border-radius: var(--radius-md);
      border: 1px solid var(--border-light);
      cursor: pointer;
      transition: all 0.25s ease;
      position: relative;
    }

    .outfit-item:hover {
      background: var(--accent-light);
      transform: translateX(4px);
      border-color: var(--accent-light);
    }

    .outfit-thumb {
      width: 60px;
      height: 60px;
      border-radius: var(--radius-sm);
      object-fit: cover;
      flex-shrink: 0;
      border: 1px solid var(--border-light);
    }

    .outfit-info { flex: 1; min-width: 0; }

    .outfit-fecha {
      font-family: 'DM Sans', sans-serif;
      font-size: 12px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 2px;
    }

    .outfit-meta {
      display: flex;
      align-items: center;
      gap: 6px;
      flex-wrap: wrap;
    }

    .outfit-tag {
      display: inline-flex;
      align-items: center;
      gap: 3px;
      padding: 2px 8px;
      border-radius: 10px;
      font-size: 10px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .outfit-tag.tipo-manual {
      background: #e8f5e9;
      color: #388e3c;
    }

    .outfit-tag.tipo-ia {
      background: #f3e5f5;
      color: #7b1fa2;
    }

    .outfit-tag.momento {
      background: #fff3e0;
      color: #f57c00;
    }

    .outfit-tag .material-symbols-outlined { font-size: 11px; }

    .outfit-del {
      width: 24px;
      height: 24px;
      border-radius: 50%;
      border: none;
      background: transparent;
      color: var(--text-tertiary);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: all 0.2s ease;
      flex-shrink: 0;
    }

    .outfit-item:hover .outfit-del {
      opacity: 1;
    }

    .outfit-del:hover {
      background: var(--pastel-coral, #fce4ec);
      color: var(--accent-coral, #c2185b);
    }

    .outfit-del .material-symbols-outlined { font-size: 14px; }

    /* Empty state */
    .sidebar-empty {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 32px 16px;
      text-align: center;
      color: var(--text-tertiary);
    }

    .sidebar-empty .material-symbols-outlined {
      font-size: 36px;
      color: var(--text-tertiary);
      margin-bottom: 8px;
    }

    .sidebar-empty p {
      font-size: 12px;
      font-weight: 600;
    }

    /* Sidebar footer */
    .sidebar-footer {
      flex-shrink: 0;
      padding-top: 8px;
      border-top: 1px solid var(--border-light);
    }

    .sidebar-footer a {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      padding: 10px;
      background: var(--bg);
      border-radius: var(--radius-sm);
      text-decoration: none;
      color: var(--text-secondary);
      font-size: 11px;
      font-weight: 700;
      transition: all 0.2s ease;
      border: 1px solid var(--border-light);
    }

    .sidebar-footer a:hover {
      background: var(--accent-light);
      color: var(--accent);
      border-color: var(--accent-light);
    }

    .sidebar-footer a .material-symbols-outlined { font-size: 14px; }

    /* ═══════════════════════════════════════════════════════════════════
       CALENDARIO - DISEÑO ORIGINAL PRESERVADO
       ═══════════════════════════════════════════════════════════════════ */
    .cal-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
    }

    .cal-title {
      font-family: 'DM Sans', sans-serif;
      font-size: 22px;
      font-weight: 700;
      text-transform: capitalize;
      color: var(--text-primary);
      letter-spacing: -0.3px;
    }

    .cal-nav {
      display: flex;
      gap: 8px;
      align-items: center;
    }

    .btn-nav {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      border: 1.5px solid var(--border);
      background: var(--surface);
      cursor: pointer;
      font-size: 1rem;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text-secondary);
      transition: all var(--transition-fast);
    }

    .btn-nav:hover {
      background: var(--accent-light);
      border-color: var(--accent);
      color: var(--accent);
    }

    /* ── Grid del calendario ── */
    .cal-grid {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      gap: 8px;
    }

    .cal-day-name {
      text-align: center;
      font-size: 0.78rem;
      font-weight: 600;
      color: var(--text-tertiary);
      padding: 8px 0;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .cal-cell {
      background: var(--surface);
      border-radius: var(--radius-lg);
      padding: 8px;
      min-height: 100px;
      border: 1.5px solid transparent;
      transition: all var(--transition-fast);
      cursor: pointer;
      position: relative;
      box-shadow: var(--shadow-sm);
    }

    .cal-cell:hover {
      border-color: var(--border);
      background: var(--bg-soft);
      box-shadow: var(--shadow);
    }

    .cal-cell.today {
      border-color: var(--accent);
      box-shadow: 0 0 0 2px rgba(67,56,202,0.1), var(--shadow-sm);
    }

    .cal-cell.otro-mes {
      background: var(--bg);
      opacity: 0.5;
    }

    .day-num {
      font-size: 0.82rem;
      font-weight: 600;
      color: var(--text-tertiary);
      margin-bottom: 6px;
    }

    .cal-cell.today .day-num {
      color: var(--accent);
      background: var(--accent);
      color: #fff;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.75rem;
    }

    .look-thumb {
      width: 100%;
      aspect-ratio: 1;
      object-fit: cover;
      border-radius: 8px;
      display: block;
      margin-bottom: 4px;
      border: 1px solid var(--border-light);
    }

    .look-thumb-more {
      text-align: center;
      font-size: 0.72rem;
      color: var(--text-tertiary);
      font-weight: 600;
    }

    .add-btn {
      position: absolute;
      bottom: 6px;
      right: 6px;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: var(--accent-light);
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: all var(--transition-fast);
      color: var(--accent);
    }

    .cal-cell:hover .add-btn {
      opacity: 1;
    }

    .add-btn:hover {
      background: var(--accent);
      color: #fff;
    }

    /* ── Modal detalle día ── */
    .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(26,26,46,0.5);
      backdrop-filter: blur(4px);
      z-index: 200;
      align-items: flex-end;
      justify-content: center;
    }

    .modal-overlay.open {
      display: flex;
    }

    .modal-sheet {
      background: var(--surface);
      border-radius: 24px 24px 0 0;
      width: 100%;
      max-width: 600px;
      padding: 28px;
      max-height: 80vh;
      overflow-y: auto;
      box-shadow: var(--shadow-lg);
    }

    .modal-date {
      font-family: 'DM Sans', sans-serif;
      font-size: 18px;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 16px;
      letter-spacing: -0.3px;
    }

    .looks-del-dia {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 20px;
    }

    .look-dia-item {
      width: 100px;
      border-radius: var(--radius-lg);
      overflow: hidden;
      position: relative;
      cursor: pointer;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
    }

    .look-dia-item img {
      width: 100%;
      aspect-ratio: 3/4;
      object-fit: cover;
      display: block;
    }

    .look-dia-del {
      position: absolute;
      top: 4px;
      right: 4px;
      width: 22px;
      height: 22px;
      border-radius: 50%;
      background: rgba(26,26,46,0.6);
      color: #fff;
      border: none;
      font-size: 0.65rem;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all var(--transition-fast);
    }

    .look-dia-del:hover {
      background: var(--accent-coral);
    }

    .modal-actions {
      display: flex;
      gap: 10px;
    }

    .btn-modal-action {
      flex: 1;
      padding: 11px;
      border-radius: var(--radius-md);
      border: 1.5px solid var(--border);
      background: var(--surface);
      cursor: pointer;
      font-size: 0.88rem;
      font-weight: 600;
      font-family: 'Plus Jakarta Sans', sans-serif;
      color: var(--text-secondary);
      transition: all var(--transition-fast);
    }

    .btn-modal-action:hover {
      background: var(--bg);
      border-color: var(--accent);
      color: var(--accent);
    }

    .btn-modal-action.primary {
      background: var(--accent);
      color: #fff;
      border-color: var(--accent);
    }

    .btn-modal-action.primary:hover {
      background: var(--accent-hover);
      border-color: var(--accent-hover);
    }

    .loading-cal {
      text-align: center;
      padding: 40px;
      color: var(--text-tertiary);
      font-size: 14px;
      font-weight: 500;
    }

    /* ── Toast ── */
    .toast {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(100px);
      background: var(--text-primary);
      color: #fff;
      padding: 12px 24px;
      border-radius: var(--radius-full);
      font-size: 13px;
      font-weight: 600;
      opacity: 0;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      pointer-events: none;
      z-index: 400;
      display: flex;
      align-items: center;
      gap: 8px;
      box-shadow: var(--shadow-md);
    }

    .toast.show {
      opacity: 1;
      transform: translateX(-50%) translateY(0);
    }

    /* ── Animations ── */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(8px); }
      to { opacity: 1; transform: translateY(0); }
    }

    ::-webkit-scrollbar { width: 4px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

  </style>
</head>
<body>
<div class="layout-wrapper">
  <jsp:include page="/includes/sidebar.jsp"/>

  <main class="main-content sidebar-open" id="mainContent">
    <!-- Welcome Section -->
    <div class="welcome-section">
      <div class="welcome-content">
        <h1 class="welcome-title">Mi <span>Calendario</span></h1>
        <p class="welcome-subtitle">Organiza tus outfits por fecha y planifica tu estilo</p>
      </div>
      <div class="welcome-actions">
        <div class="step-badge">
          <span class="material-symbols-outlined">event</span>
          Paso 4 de 5
        </div>
        <button class="toggle-outfits-btn" id="toggleOutfitsBtn" onclick="toggleSidebar()">
          <span class="material-symbols-outlined">event_available</span>
          <span class="toggle-label">Outfits</span>
          <span class="material-symbols-outlined toggle-icon" id="toggleIcon">chevron_left</span>
        </button>
      </div>
    </div>

    <div class="page">
      <div class="cal-header">
        <h1 class="cal-title" id="calTitulo"></h1>
        <div class="cal-nav">
          <button class="btn-nav" onclick="cambiarMes(-1)">
            <span class="material-symbols-outlined" style="font-size:16px;">chevron_left</span>
          </button>
          <button class="btn-nav" onclick="irHoy()" style="width:auto;padding:0 14px;font-size:12px;font-weight:600;">Hoy</button>
          <button class="btn-nav" onclick="cambiarMes(1)">
            <span class="material-symbols-outlined" style="font-size:16px;">chevron_right</span>
          </button>
        </div>
      </div>

      <div class="cal-grid" id="calGrid">
        <div class="cal-day-name">Dom</div>
        <div class="cal-day-name">Lun</div>
        <div class="cal-day-name">Mar</div>
        <div class="cal-day-name">Mié</div>
        <div class="cal-day-name">Jue</div>
        <div class="cal-day-name">Vie</div>
        <div class="cal-day-name">Sáb</div>
      </div>
    </div>

    <%-- Modal día --%>
    <div class="modal-overlay" id="modalOverlay">
      <div class="modal-sheet">
        <p class="modal-date" id="modalFecha"></p>
        <div class="looks-del-dia" id="looksDelDia"></div>
        <div class="modal-actions">
          <button class="btn-modal-action" onclick="cerrarModal()">
            Cerrar
          </button>
          <button class="btn-modal-action primary" onclick="irALooks()">
            + Agregar look
          </button>
        </div>
      </div>
    </div>

    <div class="toast" id="toast"></div>
  </main>

  <!-- RIGHT SIDEBAR - Outfits Programados -->
  <aside class="right-sidebar" id="rightSidebar">
    <div class="sidebar-header">
      <div class="sidebar-title">
        <span class="material-symbols-outlined">event_available</span>
        Outfits Programados
      </div>
      <button class="sidebar-close" onclick="toggleSidebar()">
        <span class="material-symbols-outlined">close</span>
      </button>
    </div>

    <div class="outfit-list" id="outfitList">
      <!-- Rendered by JS -->
    </div>

    <div class="sidebar-footer">
      <a href="${ctx}/look">
        <span class="material-symbols-outlined">add</span>
        Agregar outfit al calendario
      </a>
    </div>
  </aside>
</div>

<script>

  const ctx = "${ctx}";
  const MESES = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  ];
  const HOY = new Date();

  let mesActual = HOY.getMonth();
  let anioActual = HOY.getFullYear();
  let looksMes = [];
  let fechaSeleccionada = null;
  let sidebarOpen = true;

  async function cargarMes() {
    const mes = String(mesActual + 1).padStart(2, "0");
    const mesStr = anioActual + "-" + mes;
    document.getElementById("calTitulo").textContent =
      MESES[mesActual] + " " + anioActual;

    try {
      const res = await fetch(ctx + "/calendario/mes?mes=" + mesStr);
      looksMes = await res.json();
    } catch (e) {
      looksMes = [];
    }

    renderCalendario();
    renderSidebarOutfits();
  }

  function renderSidebarOutfits() {
    const contenedor = document.getElementById("outfitList");
    contenedor.innerHTML = "";

    if (!looksMes || looksMes.length === 0) {
      contenedor.innerHTML =
        '<div class="sidebar-empty">' +
        '<span class="material-symbols-outlined">event_available</span>' +
        '<p>No tienes outfits programados</p>' +
        '</div>';
      return;
    }

    // Ordenar por fecha ascendente
    var ordenados = looksMes.slice().sort(function (a, b) {
      var fa = normalizarFecha(a.fecha);
      var fb = normalizarFecha(b.fecha);
      if (fa < fb) return -1;
      if (fa > fb) return 1;
      return 0;
    });

    ordenados.forEach(function (l) {
      var fechaNorm = normalizarFecha(l.fecha);
      var partes = fechaNorm.split("-");
      var fechaLabel = partes[2] + " " + MESES[parseInt(partes[1]) - 1].substring(0, 3) + ", " + partes[0];

      var tipo = (l.tipo || "Manual").toLowerCase();
      var tipoClass = tipo === "ia" || tipo === "chat ia" ? "tipo-ia" : "tipo-manual";
      var tipoLabel = tipo === "ia" || tipo === "chat ia" ? "Chat IA" : "Manual";
      var momento = l.momento || "Mañana";

      var item = document.createElement("div");
      item.className = "outfit-item";
      item.onclick = function () {
        abrirDia(fechaNorm, looksMes.filter(function (lk) {
          return normalizarFecha(lk.fecha) === fechaNorm;
        }));
      };

      var thumb = document.createElement("img");
      thumb.className = "outfit-thumb";
      thumb.src = ctx + "/" + l.imagenGenerada;
      thumb.onerror = function () {
        this.style.display = "none";
      };

      var info = document.createElement("div");
      info.className = "outfit-info";

      var fechaDiv = document.createElement("div");
      fechaDiv.className = "outfit-fecha";
      fechaDiv.textContent = fechaLabel;

      var meta = document.createElement("div");
      meta.className = "outfit-meta";

      var tagTipo = document.createElement("span");
      tagTipo.className = "outfit-tag " + tipoClass;
      tagTipo.innerHTML = '<span class="material-symbols-outlined" style="font-size:11px;">' +
        (tipoClass === "tipo-ia" ? "smart_toy" : "handyman") + '</span>' + tipoLabel;

      var tagMomento = document.createElement("span");
      tagMomento.className = "outfit-tag momento";
      tagMomento.innerHTML = '<span class="material-symbols-outlined" style="font-size:11px;">schedule</span>' + momento;

      meta.appendChild(tagTipo);
      meta.appendChild(tagMomento);
      info.appendChild(fechaDiv);
      info.appendChild(meta);

      var btnDel = document.createElement("button");
      btnDel.className = "outfit-del";
      btnDel.innerHTML = '<span class="material-symbols-outlined">close</span>';
      btnDel.onclick = function (e) {
        e.stopPropagation();
        quitarDelDia(l.id);
      };

      item.appendChild(thumb);
      item.appendChild(info);
      item.appendChild(btnDel);
      contenedor.appendChild(item);
    });
  }

  function normalizarFecha(fechaRaw) {
    if (!fechaRaw) return "";
    if (typeof fechaRaw === "string") {
      if (fechaRaw.match(/^\d{4}-\d{2}-\d{2}/)) {
        return fechaRaw.substring(0, 10);
      } else {
        var d = new Date(fechaRaw);
        if (!isNaN(d)) {
          var mm = String(d.getMonth() + 1).padStart(2, "0");
          var dd = String(d.getDate()).padStart(2, "0");
          return d.getFullYear() + "-" + mm + "-" + dd;
        }
      }
    } else if (typeof fechaRaw === "number") {
      var d = new Date(fechaRaw);
      var mm = String(d.getMonth() + 1).padStart(2, "0");
      var dd = String(d.getDate()).padStart(2, "0");
      return d.getFullYear() + "-" + mm + "-" + dd;
    }
    return "";
  }

  function renderCalendario() {
    const grid = document.getElementById("calGrid");
    // Quitar celdas anteriores (mantener los 7 headers)
    while (grid.children.length > 7) grid.removeChild(grid.lastChild);

    const primerDia = new Date(anioActual, mesActual, 1).getDay();
    const diasEnMes = new Date(anioActual, mesActual + 1, 0).getDate();
    const diasAnteriores = new Date(anioActual, mesActual, 0).getDate();

    // Celdas del mes anterior
    for (let i = primerDia - 1; i >= 0; i--) {
      const cell = crearCelda(diasAnteriores - i, true);
      grid.appendChild(cell);
    }

    // Celdas del mes actual
    for (let d = 1; d <= diasEnMes; d++) {
      const mes = String(mesActual + 1).padStart(2, "0");
      const dia = String(d).padStart(2, "0");
      const fechaStr = anioActual + "-" + mes + "-" + dia;
      const esHoy =
        d === HOY.getDate() &&
        mesActual === HOY.getMonth() &&
        anioActual === HOY.getFullYear();

      const looksDelDia = looksMes.filter(function (l) {
        if (!l.fecha) return false;
        // Normalizar: puede venir como "2026-06-08", "Jun 8, 2026", timestamp, etc.
        var fechaNorm = "";
        if (typeof l.fecha === "string") {
          // Si ya tiene formato YYYY-MM-DD
          if (l.fecha.match(/^\d{4}-\d{2}-\d{2}/)) {
            fechaNorm = l.fecha.substring(0, 10);
          } else {
            // Intentar parsear cualquier otro formato
            var d = new Date(l.fecha);
            if (!isNaN(d)) {
              var mm = String(d.getMonth() + 1).padStart(2, "0");
              var dd = String(d.getDate()).padStart(2, "0");
              fechaNorm = d.getFullYear() + "-" + mm + "-" + dd;
            }
          }
        } else if (typeof l.fecha === "number") {
          var d = new Date(l.fecha);
          var mm = String(d.getMonth() + 1).padStart(2, "0");
          var dd = String(d.getDate()).padStart(2, "0");
          fechaNorm = d.getFullYear() + "-" + mm + "-" + dd;
        }
        return fechaNorm === fechaStr;
      });
      const cell = crearCelda(d, false, esHoy, fechaStr, looksDelDia);
      grid.appendChild(cell);
    }

    // Completar con días del mes siguiente
    const totalCeldas = grid.children.length - 7;
    const restantes = totalCeldas % 7 === 0 ? 0 : 7 - (totalCeldas % 7);
    for (let i = 1; i <= restantes; i++) {
      grid.appendChild(crearCelda(i, true));
    }
  }

  function crearCelda(num, otroMes, esHoy, fechaStr, looks) {
    const cell = document.createElement("div");
    cell.className =
      "cal-cell" + (otroMes ? " otro-mes" : "") + (esHoy ? " today" : "");

    const dayNum = document.createElement("div");
    dayNum.className = "day-num";
    dayNum.textContent = num;
    cell.appendChild(dayNum);

    if (looks && looks.length > 0) {
      const maxShow = Math.min(looks.length, 2);
      for (let i = 0; i < maxShow; i++) {
        const img = document.createElement("img");
        img.className = "look-thumb";
        img.src = ctx + "/" + looks[i].imagenGenerada;
        img.onerror = () => (img.style.display = "none");
        cell.appendChild(img);
      }
      if (looks.length > 2) {
        const more = document.createElement("div");
        more.className = "look-thumb-more";
        more.textContent = "+" + (looks.length - 2) + " más";
        cell.appendChild(more);
      }
    }

    if (!otroMes && fechaStr) {
      const addBtn = document.createElement("button");
      addBtn.className = "add-btn";
      addBtn.textContent = "+";
      addBtn.onclick = (e) => {
        e.stopPropagation();
        irALooks();
      };
      cell.appendChild(addBtn);

      cell.onclick = () => abrirDia(fechaStr, looks || []);
    }

    return cell;
  }

  function abrirDia(fechaStr, looks) {
    fechaSeleccionada = fechaStr;
    const [y, m, d] = fechaStr.split("-");
    document.getElementById("modalFecha").textContent =
      d + " de " + MESES[parseInt(m) - 1] + " de " + y;

    const contenedor = document.getElementById("looksDelDia");
    contenedor.innerHTML = "";
    if (looks.length === 0) {
      contenedor.innerHTML =
        '<p style="color:#bbb;font-size:.9rem">Sin outfits asignados</p>';
    } else {
      looks.forEach(function (l) {
        var item = document.createElement("div");
        item.className = "look-dia-item";
        var img = document.createElement("img");
        img.src = ctx + "/" + l.imagenGenerada;
        img.alt = "look";
        img.onerror = function () {
          this.src = ctx + "/img/placeholder.png";
        };
        var btn = document.createElement("button");
        btn.className = "look-dia-del";
        btn.textContent = "✕";
        (function (lid) {
          btn.onclick = function () {
            quitarDelDia(lid);
          };
        })(l.id);
        item.appendChild(img);
        item.appendChild(btn);
        contenedor.appendChild(item);
      });
    }

    document.getElementById("modalOverlay").classList.add("open");
  }

  async function quitarDelDia(id) {
    if (!confirm("¿Quitar este look del día?")) return;
    const res = await fetch(ctx + "/calendario/" + id, {
      method: "DELETE",
    });
    if (res.ok) {
      mostrarToast("Look quitado");
      cerrarModal();
      cargarMes();
    }
  }

  function cerrarModal() {
    document.getElementById("modalOverlay").classList.remove("open");
  }
  function irALooks() {
    window.location.href = ctx + "/look";
  }
  function cambiarMes(d) {
    mesActual += d;
    if (mesActual > 11) {
      mesActual = 0;
      anioActual++;
    } else if (mesActual < 0) {
      mesActual = 11;
      anioActual--;
    }
    cargarMes();
  }
  function irHoy() {
    mesActual = HOY.getMonth();
    anioActual = HOY.getFullYear();
    cargarMes();
  }

  function mostrarToast(msg) {
    const t = document.getElementById("toast");
    t.textContent = msg;
    t.classList.add("show");
    setTimeout(() => t.classList.remove("show"), 3000);
  }

  function toggleSidebar() {
    var sidebar = document.getElementById('rightSidebar');
    var mainContent = document.getElementById('mainContent');
    var toggleBtn = document.getElementById('toggleOutfitsBtn');
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

  cargarMes();

</script>
</body>
</html>