<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
  <title>Armar Outfit — Quiddity</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Segoe UI',sans-serif;background:#f5f4f2;color:#1a1a1a;min-height:100vh}
    /* ── Layout ── */
    .page{display:grid;grid-template-columns:1fr 420px;gap:20px;
      max-width:1160px;margin:0 auto;padding:24px 20px}
    /* ── Panel izquierdo: selector ── */
    .panel{background:#fff;border-radius:20px;padding:22px}
    .panel-title{font-size:1rem;font-weight:700;margin-bottom:16px;color:#1a1a1a}
    .tabs{display:flex;gap:7px;flex-wrap:wrap;margin-bottom:18px}
    .tab{padding:7px 16px;border-radius:20px;border:1.5px solid #e8e8e8;
      background:#fff;cursor:pointer;font-size:.8rem;font-weight:500;transition:.18s;color:#555}
    .tab.active{background:#1a1a1a;color:#fff;border-color:#1a1a1a}
    .prendas-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(130px,1fr));
      gap:12px;max-height:560px;overflow-y:auto;padding-right:4px}
    .prendas-grid::-webkit-scrollbar{width:4px}
    .prendas-grid::-webkit-scrollbar-thumb{background:#ddd;border-radius:4px}
    .prenda-item{border-radius:14px;overflow:hidden;cursor:pointer;
      border:2.5px solid transparent;transition:.2s;background:#f8f8f8;position:relative}
    .prenda-item.sel{border-color:#1a1a1a;box-shadow:0 0 0 3px rgba(0,0,0,.08)}
    .prenda-item img{width:100%;aspect-ratio:1;object-fit:cover;display:block}
    .prenda-check{position:absolute;top:7px;right:7px;width:22px;height:22px;
      border-radius:50%;background:#1a1a1a;color:#fff;font-size:.7rem;
      display:none;align-items:center;justify-content:center;font-weight:700}
    .prenda-item.sel .prenda-check{display:flex}
    .prenda-label{padding:6px 9px;font-size:.75rem;color:#666;
      white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-transform:capitalize}
    /* ── Panel derecho ── */
    .right-panel{display:flex;flex-direction:column;gap:16px}
    /* Tira de seleccionadas */
    .strip-panel{background:#fff;border-radius:20px;padding:18px}
    .strip-label{font-size:.82rem;font-weight:600;color:#888;
      text-transform:uppercase;letter-spacing:.04em;margin-bottom:12px}
    .strip{display:flex;gap:10px;flex-wrap:wrap;min-height:70px;align-items:flex-start}
    .strip-item{position:relative;width:62px;flex-shrink:0}
    .strip-item img{width:62px;height:62px;object-fit:cover;border-radius:10px;
      border:1.5px solid #eee;display:block}
    .strip-del{position:absolute;top:-5px;right:-5px;width:18px;height:18px;
      border-radius:50%;background:#1a1a1a;color:#fff;border:none;
      font-size:.6rem;cursor:pointer;display:flex;align-items:center;justify-content:center}
    .strip-empty{color:#ccc;font-size:.85rem;padding:16px 0;width:100%;text-align:center}
    /* Resultado */
    .result-panel{background:#fff;border-radius:20px;padding:18px;flex:1}
    .result-label{font-size:.82rem;font-weight:600;color:#888;
      text-transform:uppercase;letter-spacing:.04em;margin-bottom:14px}
    /* Canvas del flatlay */
    .flatlay-wrap{width:100%;aspect-ratio:4/5;border-radius:14px;
      background:#f8f7f5;overflow:hidden;cursor:pointer;position:relative;
      display:flex;align-items:center;justify-content:center}
    .flatlay-wrap img{width:100%;height:100%;object-fit:contain;display:block}
    .flatlay-placeholder{display:flex;flex-direction:column;align-items:center;
      justify-content:center;gap:10px;color:#ccc;text-align:center;padding:20px}
    .flatlay-placeholder .ph-icon{font-size:2.2rem}
    .flatlay-placeholder p{font-size:.85rem}
    .flatlay-loader{display:none;flex-direction:column;align-items:center;
      justify-content:center;gap:14px;width:100%;aspect-ratio:4/5}
    .spinner{width:36px;height:36px;border:3px solid #e8e8e8;border-top-color:#1a1a1a;
      border-radius:50%;animation:spin .9s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
    .loader-text{font-size:.85rem;color:#888}
    /* Acciones */
    .btn-generate{width:100%;padding:13px;background:#1a1a1a;color:#fff;
      border:none;border-radius:14px;font-size:.95rem;font-weight:600;
      cursor:pointer;margin-top:14px;transition:.18s;display:flex;
      align-items:center;justify-content:center;gap:8px}
    .btn-generate:disabled{background:#ddd;cursor:not-allowed;color:#aaa}
    .result-actions{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:10px}
    .btn-action{padding:10px;border-radius:12px;border:1.5px solid #e8e8e8;
      background:#fff;cursor:pointer;font-size:.82rem;font-weight:500;
      transition:.18s;text-align:center}
    .btn-action:hover{background:#f5f5f5}
    .btn-action.primary{background:#1a1a1a;color:#fff;border-color:#1a1a1a}
    .btn-action.primary:hover{background:#333}
    /* ── Modales ── */
    .overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.55);
      z-index:200;align-items:center;justify-content:center}
    .overlay.open{display:flex}
    /* Modal detalle look */
    .modal-look{background:#fff;border-radius:24px;width:100%;max-width:560px;
      overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,.2)}
    .look-img-full{width:100%;aspect-ratio:4/5;object-fit:contain;background:#f8f7f5;display:block}
    .look-footer{padding:20px 22px}
    .look-footer-title{font-size:1rem;font-weight:700;margin-bottom:6px}
    .look-prendas-strip{display:flex;gap:8px;overflow-x:auto;padding-bottom:6px;margin-bottom:16px}
    .look-prenda-mini{width:52px;height:52px;border-radius:10px;object-fit:cover;
      flex-shrink:0;border:1.5px solid #eee;cursor:pointer;transition:.18s}
    .look-prenda-mini:hover{border-color:#1a1a1a;transform:scale(1.06)}
    .look-actions{display:flex;gap:10px}
    /* Modal detalle prenda */
    .modal-prenda{background:#fff;border-radius:24px;width:100%;max-width:440px;padding:0;overflow:hidden}
    .prenda-img-big{width:100%;aspect-ratio:1;object-fit:cover;background:#f5f5f5;display:block}
    .prenda-body{padding:20px 22px}
    .prenda-body-tag{display:inline-block;background:#f0f0f0;border-radius:12px;
      padding:3px 12px;font-size:.78rem;color:#555;margin-bottom:10px;text-transform:capitalize}
    .prenda-body h3{font-size:1.05rem;font-weight:700;margin-bottom:4px;text-transform:capitalize}
    .prenda-body p{font-size:.85rem;color:#888;margin-bottom:16px}
    .prenda-swap-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(68px,1fr));
      gap:8px;max-height:200px;overflow-y:auto;margin-bottom:16px;
      border:1.5px solid #f0f0f0;border-radius:12px;padding:10px}
    .swap-item{width:100%;aspect-ratio:1;object-fit:cover;border-radius:10px;
      cursor:pointer;border:2px solid transparent;transition:.18s}
    .swap-item:hover{border-color:#1a1a1a}
    .swap-item.sel{border-color:#1a1a1a;box-shadow:0 0 0 2px rgba(0,0,0,.15)}
    .btn-swap{width:100%;padding:11px;background:#1a1a1a;color:#fff;border:none;
      border-radius:12px;font-size:.9rem;font-weight:600;cursor:pointer}
    /* Modal calendario */
    .modal-cal{background:#fff;border-radius:24px;padding:28px;width:100%;max-width:380px}
    .modal-cal h3{font-size:1.05rem;font-weight:700;margin-bottom:20px}
    .field{margin-bottom:14px}
    .field label{display:block;font-size:.82rem;font-weight:500;
      color:#555;margin-bottom:5px}
    .field input,.field select{width:100%;padding:10px 13px;
      border:1.5px solid #e8e8e8;border-radius:11px;font-size:.88rem;outline:none;transition:.18s}
    .field input:focus,.field select:focus{border-color:#1a1a1a}
    .modal-btns{display:flex;gap:10px;margin-top:20px}
    .btn-cancel{flex:1;padding:11px;background:#f0f0f0;border:none;
      border-radius:12px;cursor:pointer;font-size:.9rem}
    .btn-ok{flex:1;padding:11px;background:#1a1a1a;color:#fff;border:none;
      border-radius:12px;cursor:pointer;font-size:.9rem;font-weight:600}
    /* Toast */
    .toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
      background:#1a1a1a;color:#fff;padding:11px 24px;border-radius:24px;
      font-size:.88rem;opacity:0;transition:.28s;pointer-events:none;z-index:500;
      white-space:nowrap}
    .toast.show{opacity:1}
    /* Empty state */
    .empty-closet{text-align:center;padding:40px 20px;color:#bbb;
      grid-column:1/-1}
    .empty-closet a{color:#1a1a1a;font-weight:600;text-decoration:none}
  </style>
</head>
<body>
<div class="layout-with-sidebar">
<jsp:include page="/includes/sidebar.jsp"/>
  <div class="main-content">
<div class="page">

  <%-- Panel izquierdo: selector de prendas --%>
  <div class="panel">
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

  <%-- Panel derecho --%>
  <div class="right-panel">

    <%-- Tira de seleccionadas --%>
    <div class="strip-panel">
      <div class="strip-label">Prendas seleccionadas</div>
      <div class="strip" id="strip">
        <span class="strip-empty">Toca una prenda para agregarla</span>
      </div>
    </div>

    <%-- Resultado del flatlay --%>
    <div class="result-panel">
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

<%-- ── MODAL: look completo ──────────────────────────────────── --%>
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

<%-- ── MODAL: detalle + swap de prenda ───────────────────────── --%>
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

<%-- ── MODAL: agregar al calendario ──────────────────────────── --%>
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

<div class="toast" id="toast"></div>

<script>
var ctx = '${ctx}';
var seleccionadas  = [];   // [{id, img, tipo, color, estilo}]
var lookIdActual   = null;
var prendasLook    = [];   // prendas del look generado
var prendaEditando = null; // prenda que se está cambiando
var swapIdNuevo    = null; // nueva prenda seleccionada en el swap

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
</script>
  </div>
</div>
</body>
</html>
