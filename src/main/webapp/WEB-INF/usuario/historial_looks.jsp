<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=DM+Sans:wght@300;400;500;700&display=swap" rel="stylesheet">
  <title>Mis Looks — Quiddity</title>
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

      /* Paleta unisex — Indigo/Sapphire */
      --pastel-indigo: #e8eaf6;
      --pastel-indigo-dark: #c5cae9;
      --pastel-indigo-deep: #9fa8da;
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

      --accent-indigo: #3949ab;
      --accent-indigo-light: #5c6bc0;
      --accent-mint: #388e3c;
      --accent-lavender: #7b1fa2;
      --accent-cream: #f57c00;
      --accent-coral: #c2185b;
      --accent-sage: #689f38;
      --accent-sky: #1976d2;

      --uni-indigo: #4338ca;
      --uni-indigo-light: #6366f1;
      --uni-indigo-pale: #e0e7ff;
      --uni-slate: #475569;

      --radius-sm: 10px;
      --radius-md: 12px;
      --radius-lg: 14px;
      --radius-xl: 20px;
      --radius-full: 999px;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
      --shadow: 0 2px 8px rgba(0,0,0,0.06);
      --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
      --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
      --shadow-indigo: 0 4px 20px rgba(67,56,202,0.12);
      --transition-fast: 0.15s ease;
      --transition-base: 0.3s ease;
      --transition-spring: 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    *{box-sizing:border-box;margin:0;padding:0}

    html, body { height: 100vh; overflow: hidden; }

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
      padding: 12px 0 0 0;
      gap: 10px;
      width: 100%;
      height: 100vh;
      overflow: hidden;
      max-width: none;
      margin: 0;
    }

    /* ═══════════════════════════════════════════════════════════════════
       WELCOME SECTION — Estilo Dashboard con acento indigo
       ═══════════════════════════════════════════════════════════════════ */
    .welcome-section {
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: var(--surface);
      border-radius: var(--radius-lg);
      padding: 10px 20px;
      margin: 0 20px;
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

    .welcome-title span { color: var(--uni-indigo); }

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
      background: linear-gradient(135deg, var(--pastel-indigo), var(--pastel-indigo-dark));
      border: 1px solid var(--pastel-indigo-deep);
      border-radius: var(--radius-md);
      font-size: 9px;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--accent-indigo);
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .step-badge .material-symbols-outlined {
      font-size: 14px;
      color: var(--accent-indigo);
    }

    .btn-create {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: linear-gradient(135deg, var(--pastel-indigo), var(--pastel-indigo-dark));
      border: 1px solid var(--pastel-indigo-deep);
      border-radius: var(--radius-md);
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      color: var(--accent-indigo);
      text-decoration: none;
      transition: all var(--transition-spring);
      font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .btn-create:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-indigo);
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
      margin: 0 20px;
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
      border-color: var(--pastel-indigo-dark);
    }

    .stat-item::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: var(--uni-indigo);
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

    .stat-icon.indigo {
      background: var(--pastel-indigo);
      color: var(--accent-indigo);
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
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════
       DISEÑO ORIGINAL — Filtros, Grid, Cards, Modales, Toast.
       EXACTAMENTE IGUAL AL ARCHIVO ORIGINAL.
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════
       ═══════════════════════════════════════════════════════════════════ */

    .page{max-width:none;margin:0;padding:0}
    .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}
    .page-title{font-size:1.6rem;font-weight:700}
    /* ── Chips de filtro ── */
    .chips-section {
      background: var(--surface);
      border: 1px solid var(--border-light);
      border-radius: var(--radius-md);
      box-shadow: var(--shadow-sm);
      margin-bottom: 16px;
      margin: 0 20px 16px 20px;
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
    }

    .cat-chip:hover {
      border-color: var(--uni-indigo);
      color: var(--uni-indigo);
      background: var(--pastel-indigo);
    }

    .cat-chip.active {
      background: linear-gradient(135deg, var(--pastel-indigo), var(--pastel-indigo-dark));
      border-color: transparent;
      color: var(--accent-indigo);
      box-shadow: 0 4px 12px rgba(67, 56, 202, 0.15);
    }
    /* ── Grid tipo Pinterest 2 columnas ── */
    .looks-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 16px;
      margin: 0 20px;
    }
    /* ── Card estilo Closet ── */
    .look-card {
      background: var(--surface);
      border-radius: var(--radius-lg);
      overflow: hidden;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
      cursor: pointer;
      transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      animation: fadeUp 0.4s ease forwards;
      opacity: 0;
    }

    .look-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--pastel-sky-dark);
    }

    .look-card img {
      width: 100%;
      aspect-ratio: 1;          /* Imagen cuadrada como en closet */
      object-fit: cover;
      transition: transform 0.5s ease;
    }

    .look-card:hover img {
      transform: scale(1.05);
    }
    .look-broken{width:100%;aspect-ratio:3/4;display:flex;flex-direction:column;
      align-items:center;justify-content:center;background:#f0f0ee;color:#bbb;
      font-size:.78rem;text-align:center;gap:6px;padding:10px}
    .look-overlay{position:absolute;inset:0;background:linear-gradient(transparent 50%,rgba(0,0,0,.6));
      opacity:0;transition:.2s;display:flex;flex-direction:column;justify-content:flex-end;padding:14px}
    .look-card:hover .look-overlay{opacity:1}
    .look-actions{display:flex;gap:8px;justify-content:flex-end;margin-bottom:8px}
    .btn-round{width:34px;height:34px;border-radius:50%;border:none;background:rgba(255,255,255,.9);
      cursor:pointer;font-size:1rem;display:flex;align-items:center;justify-content:center;transition:.2s}
    .btn-round:hover{background:#fff;transform:scale(1.1)}
    .look-date{color:#ddd;font-size:.75rem}
    .fav-badge{position:absolute;top:10px;right:10px;font-size:1.2rem}
    .look-tipo{position:absolute;top:10px;left:10px;background:rgba(255,255,255,.9);
      padding:3px 10px;border-radius:12px;font-size:.72rem;font-weight:600;color:#1a1a1a}
    .empty-state{text-align:center;padding:80px 20px;color:#bbb;margin:0 20px}
    .empty-icon{font-size:3.5rem;margin-bottom:14px}
    /* ── Modal detalle ── */
    .modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.7);
      z-index:200;align-items:center;justify-content:center}
    .modal-overlay.open{display:flex}
    .modal-detail{background:#fff;border-radius:24px;overflow:hidden;
      width:100%;max-width:480px;max-height:90vh;display:flex;flex-direction:column}
    .modal-img{width:100%;aspect-ratio:4/5;object-fit:contain;background:#f8f7f5;padding:16px;display:block;box-sizing:border-box}
    .modal-body{padding:20px;overflow-y:auto}
    .modal-actions-row{display:flex;gap:10px;margin-top:16px}
    .btn-modal{flex:1;padding:10px;border-radius:12px;border:1.5px solid #e0e0e0;
      background:#fff;cursor:pointer;font-size:.85rem;font-weight:500}
    .btn-modal.primary{background:#1a1a1a;color:#fff;border-color:#1a1a1a}
    .toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
      background:#1a1a1a;color:#fff;padding:12px 24px;border-radius:24px;
      font-size:.9rem;opacity:0;transition:.3s;pointer-events:none;z-index:400}
    .toast.show{opacity:1}

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
<div class="layout-wrapper">
  <jsp:include page="/includes/sidebar.jsp"/>

  <main class="main-content">

    <!-- ═══════════════════════════════════════════════════════════════
         WELCOME SECTION — Estilo Dashboard con acento indigo
         ═══════════════════════════════════════════════════════════════ -->
    <div class="welcome-section anim-fade-up">
      <div class="welcome-content">
        <h1 class="welcome-title">Mis <span>Looks</span></h1>
        <p class="welcome-subtitle">Explora y gestiona todos tus outfits generados</p>
      </div>
      <div class="welcome-actions">
        <div class="step-badge">
          <span class="material-symbols-outlined">auto_awesome</span>
          Paso 3 de 5
        </div>
        <a href="${ctx}/outfit" class="btn-create">
          <span class="material-symbols-outlined" style="font-size:14px;">add</span>
          Crear look
        </a>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════
         STATS BAR
         ═══════════════════════════════════════════════════════════════ -->
    <div class="stats-bar anim-fade-up delay-1">
      <div class="stat-item">
        <div class="stat-icon indigo">
          <span class="material-symbols-outlined">checkroom</span>
        </div>
        <div class="stat-data">
          <h4>${looks.size()}</h4>
          <p>Looks totales</p>
        </div>
      </div>
      <div class="stat-item">
        <div class="stat-icon rose">
          <span class="material-symbols-outlined">favorite</span>
        </div>
        <div class="stat-data">
          <h4 id="statFavs">0</h4>
          <p>Favoritos</p>
        </div>
      </div>
      <div class="stat-item">
        <div class="stat-icon lavender">
          <span class="material-symbols-outlined">auto_awesome</span>
        </div>
        <div class="stat-data">
          <h4 id="statIA">0</h4>
          <p>Generados por IA</p>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════════════
         DISEÑO ORIGINAL — Filtros, Grid, Cards, Modales
         ═══════════════════════════════════════════════════════════════ -->
    <div style="flex:1;overflow-y:auto;min-height:0;padding:0 0 20px 0;">

        <div class="chips-section">
          <div class="chips-container">
            <div class="chips-row" id="catRow">
              <button class="cat-chip active" data-cat="todos" onclick="filtrar('todos', this)">
                <span class="material-symbols-outlined" style="font-size:14px;">auto_awesome</span> Todos
              </button>
              <button class="cat-chip" data-cat="manual" onclick="filtrar('manual', this)">
                <span class="material-symbols-outlined" style="font-size:14px;">checkroom</span> Manuales
              </button>
              <button class="cat-chip" data-cat="ia" onclick="filtrar('ia', this)">
                <span class="material-symbols-outlined" style="font-size:14px;">auto_fix_high</span> Chat IA
              </button>
              <button class="cat-chip" data-cat="favorito" onclick="filtrar('favorito', this)">
                <span class="material-symbols-outlined" style="font-size:14px;">favorite</span> Favoritos
              </button>
            </div>
          </div>
        </div>

        <c:choose>
          <c:when test="${empty looks}">
            <div class="empty-state">
              <div class="empty-icon">🪄</div>
              <p style="font-size:1.1rem;font-weight:600;margin-bottom:8px">Aún no tienes looks</p>
              <p style="margin-bottom:20px">Crea tu primer look armando un outfit</p>
              <a href="${ctx}/outfit" style="padding:12px 28px;background:#1a1a1a;color:#fff;
                border-radius:24px;text-decoration:none;font-weight:600">Crear look</a>
            </div>
          </c:when>
          <c:otherwise>
            <div class="looks-grid" id="looksGrid">
              <c:forEach var="look" items="${looks}">
                <div class="look-card"
                     data-tipo="${look.esManual ? 'manual' : 'ia'}"
                     data-fav="${look.favorito}"
                     data-id="${look.id}"
                     onclick="abrirDetalle(${look.id},'${ctx}/${look.imagenGenerada}',${look.favorito},'${look.esManual ? 'Manual' : 'Chat IA'}')">
                  <img src="${ctx}/${look.imagenGenerada}" alt="Look"
                       onerror="this.style.display='none'; this.insertAdjacentHTML('afterend',
                       '&lt;div class=\"look-broken\"&gt;&#9888;&lt;br&gt;Imagen no disponible&lt;/div&gt;');
                       this.onerror=null;"/>
                  <span class="look-tipo">${look.esManual ? 'Manual' : 'Chat IA'}</span>
                  <c:if test="${look.favorito}">
                    <span class="fav-badge">❤️</span>
                  </c:if>
                  <div class="look-overlay">
                    <div class="look-actions">
                      <button class="btn-round" onclick="toggleFav(${look.id},event)" title="Favorito">
                        ${look.favorito ? '❤️' : '🤍'}
                      </button>
                      <button class="btn-round" onclick="eliminar(${look.id},event)" title="Eliminar">🗑️</button>
                    </div>
                    <span class="look-date">${look.creadoEn}</span>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
    </div>

  </main>
</div>

<%-- Modal detalle look --%>
<div class="modal-overlay" id="modalOverlay">
  <div class="modal-detail">
    <img id="modalImg" class="modal-img" alt="Look"/>
    <div class="modal-body">
      <div style="display:flex;justify-content:space-between;align-items:center">
        <span id="modalTipo" style="font-size:.85rem;background:#f0f0f0;
          padding:4px 12px;border-radius:12px;font-weight:500"></span>
        <button id="modalFavBtn" onclick="toggleFavModal()" style="background:none;border:none;
          font-size:1.4rem;cursor:pointer"></button>
      </div>
      <div class="modal-actions-row">
        <button class="btn-modal" onclick="cerrarModal()">Cerrar</button>
        <button class="btn-modal" onclick="abrirCalDesdeModal()">📅 Al calendario</button>
        <button class="btn-modal primary" onclick="eliminarDesdeModal()">🗑️ Eliminar</button>
      </div>
    </div>
  </div>
</div>

<%-- Modal calendario rápido --%>
<div id="modalCal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);
  z-index:300;align-items:center;justify-content:center">
  <div style="background:#fff;border-radius:24px;padding:28px;width:100%;max-width:380px">
    <h3 style="margin-bottom:18px;font-weight:700">Agregar al calendario</h3>
    <input type="date" id="calFecha" style="width:100%;padding:10px 14px;
      border:1.5px solid #e0e0e0;border-radius:12px;font-size:.9rem;margin-bottom:12px"/>
    <select id="calMomento" style="width:100%;padding:10px 14px;
      border:1.5px solid #e0e0e0;border-radius:12px;font-size:.9rem;margin-bottom:18px">
      <option value="manana">Mañana</option>
      <option value="tarde">Tarde</option>
      <option value="noche">Noche</option>
    </select>
    <div style="display:flex;gap:10px">
      <button onclick="cerrarModalCal()" style="flex:1;padding:11px;background:#f0f0f0;
        border:none;border-radius:12px;cursor:pointer">Cancelar</button>
      <button onclick="guardarEnCal()" style="flex:1;padding:11px;background:#1a1a1a;
        color:#fff;border:none;border-radius:12px;cursor:pointer;font-weight:600">Guardar</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
const ctx = '${ctx}';
let lookActualId  = null;
let lookActualFav = false;

// Contar favoritos e IA para stats bar
(function(){
  var favs = 0, ia = 0;
  document.querySelectorAll('.look-card').forEach(function(c){
    if (c.dataset.fav === 'true') favs++;
    if (c.dataset.tipo === 'ia') ia++;
  });
  var sf = document.getElementById('statFavs');
  var si = document.getElementById('statIA');
  if (sf) sf.textContent = favs;
  if (si) si.textContent = ia;
})();

function filtrar(tipo, btn) {
  document.querySelectorAll('.cat-chip').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('.look-card').forEach(card => {
    if (tipo === 'todos') { card.style.display = ''; return; }
    if (tipo === 'favorito') { card.style.display = card.dataset.fav === 'true' ? '' : 'none'; return; }
    card.style.display = card.dataset.tipo === tipo ? '' : 'none';
  });
}

function abrirDetalle(id, img, fav, tipo) {
  lookActualId  = id;
  lookActualFav = fav;
  document.getElementById('modalImg').src = img;
  document.getElementById('modalTipo').textContent = tipo;
  document.getElementById('modalFavBtn').textContent = fav ? '❤️' : '🤍';
  document.getElementById('modalOverlay').classList.add('open');
}
function cerrarModal() {
  document.getElementById('modalOverlay').classList.remove('open');
  lookActualId = null;
}
document.getElementById('modalOverlay').addEventListener('click', e => {
  if (e.target === e.currentTarget) cerrarModal();
});

async function toggleFav(id, e) {
  e.stopPropagation();
  const res  = await fetch(ctx + '/look/' + id + '/fav', { method:'PUT' });
  if (res.ok) { location.reload(); }
}
async function toggleFavModal() {
  if (!lookActualId) return;
  const res = await fetch(ctx + '/look/' + lookActualId + '/fav', { method:'PUT' });
  if (res.ok) { mostrarToast('Favorito actualizado'); cerrarModal(); setTimeout(() => location.reload(), 800); }
}

async function eliminar(id, e) {
  e.stopPropagation();
  if (!confirm('¿Eliminar este look?')) return;
  const res = await fetch(ctx + '/look/' + id, { method:'DELETE' });
  if (res.ok) { document.querySelector('[data-id="'+id+'"]').remove(); mostrarToast('Look eliminado'); }
}
async function eliminarDesdeModal() {
  if (!lookActualId) return;
  if (!confirm('¿Eliminar este look?')) return;
  const res = await fetch(ctx + '/look/' + lookActualId, { method:'DELETE' });
  if (res.ok) { cerrarModal(); mostrarToast('Look eliminado'); setTimeout(() => location.reload(), 800); }
}

function abrirCalDesdeModal() {
  if (!lookActualId) return;
  document.getElementById('calFecha').valueAsDate = new Date();
  document.getElementById('modalCal').style.display = 'flex';
}
function cerrarModalCal() { document.getElementById('modalCal').style.display = 'none'; }
async function guardarEnCal() {
  const fecha   = document.getElementById('calFecha').value;
  const momento = document.getElementById('calMomento').value;
  if (!fecha) { mostrarToast('Selecciona una fecha'); return; }
  const fd = new FormData();
  fd.append('fecha', fecha); fd.append('idLook', lookActualId); fd.append('momento', momento);
  const res = await fetch(ctx + '/calendario', { method:'POST', body:fd });
  cerrarModalCal(); cerrarModal();
  mostrarToast((await res.json()).mensaje || 'Guardado');
}

function mostrarToast(msg) {
  const t = document.getElementById('toast');
  t.textContent = msg; t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 3000);
}
</script>
</body>
</html>