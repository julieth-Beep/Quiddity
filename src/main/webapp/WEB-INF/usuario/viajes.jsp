<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
  <title>Viajes — Quiddity</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Segoe UI',sans-serif;background:#f8f7f5;color:#1a1a1a}
    .navbar{display:flex;align-items:center;justify-content:space-between;
      background:#fff;padding:14px 28px;border-bottom:1px solid #eee;position:sticky;top:0;z-index:100}
    .logo-text{font-size:1.4rem;font-weight:700;color:#1a1a1a;text-decoration:none}
    .nav-links{list-style:none;display:flex;gap:8px}
    .nav-links li a{display:flex;flex-direction:column;align-items:center;gap:2px;
      padding:8px 14px;border-radius:12px;text-decoration:none;color:#666;font-size:.75rem;transition:.2s}
    .nav-links li a:hover,.nav-links li.active a{background:#f0f0f0;color:#1a1a1a}
    .btn-logout{padding:6px 14px;border-radius:20px;background:#1a1a1a;color:#fff;text-decoration:none;font-size:.8rem}
    .page{max-width:1000px;margin:0 auto;padding:28px 20px}
    .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:28px}
    .page-title{font-size:1.6rem;font-weight:700}
    .btn-add{padding:10px 22px;background:#1a1a1a;color:#fff;border:none;
      border-radius:24px;cursor:pointer;font-size:.9rem;font-weight:500}
    /* ── Tarjetas de viaje ── */
    .viajes-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px}
    .viaje-card{background:#fff;border-radius:20px;overflow:hidden;
      box-shadow:0 2px 12px rgba(0,0,0,.06);cursor:pointer;transition:.2s}
    .viaje-card:hover{transform:translateY(-4px);box-shadow:0 8px 28px rgba(0,0,0,.1)}
    .viaje-header{padding:20px 20px 12px;display:flex;justify-content:space-between;align-items:flex-start}
    .viaje-destino{font-size:1.2rem;font-weight:700}
    .viaje-fechas{font-size:.8rem;color:#888;margin-top:3px}
    .viaje-clima-badge{padding:4px 12px;border-radius:12px;background:#f0f0f0;
      font-size:.78rem;font-weight:500;white-space:nowrap}
    .viaje-body{padding:0 20px 16px}
    .viaje-stats{display:flex;gap:16px}
    .stat{text-align:center}
    .stat-num{font-size:1.3rem;font-weight:700}
    .stat-label{font-size:.75rem;color:#888}
    .viaje-outfits-strip{display:flex;gap:6px;padding:12px 20px;
      background:#f8f8f8;overflow-x:auto}
    .outfit-mini{width:52px;height:52px;border-radius:10px;object-fit:cover;
      flex-shrink:0;border:2px solid #fff;box-shadow:0 1px 4px rgba(0,0,0,.1)}
    .outfit-mini-add{width:52px;height:52px;border-radius:10px;background:#eee;
      display:flex;align-items:center;justify-content:center;font-size:1.2rem;
      flex-shrink:0;cursor:pointer;color:#aaa;text-decoration:none}
    .viaje-footer{padding:12px 20px;display:flex;justify-content:space-between;align-items:center}
    .btn-ver{padding:8px 18px;border-radius:16px;background:#1a1a1a;color:#fff;
      border:none;cursor:pointer;font-size:.82rem;font-weight:500}
    .btn-del{width:32px;height:32px;border-radius:50%;background:#f5f5f5;
      border:none;cursor:pointer;font-size:.9rem}
    .empty-state{text-align:center;padding:80px 20px;color:#bbb}
    /* ── Modal nuevo viaje ── */
    .modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);
      z-index:200;align-items:center;justify-content:center}
    .modal-overlay.open{display:flex}
    .modal{background:#fff;border-radius:24px;padding:32px;width:100%;max-width:480px;max-height:90vh;overflow-y:auto}
    .modal-title{font-size:1.2rem;font-weight:700;margin-bottom:8px}
    .modal-sub{color:#888;font-size:.85rem;margin-bottom:24px}
    .form-group{margin-bottom:16px}
    .form-group label{display:block;font-size:.85rem;font-weight:500;margin-bottom:6px;color:#555}
    .form-group input,.form-group textarea{width:100%;padding:10px 14px;
      border:1.5px solid #e0e0e0;border-radius:12px;font-size:.9rem;outline:none;transition:.2s}
    .form-group input:focus{border-color:#1a1a1a}
    .clima-detect{background:#f0f7f0;border-radius:12px;padding:12px 16px;
      font-size:.85rem;color:#2d6a2d;margin-top:8px;display:none}
    .modal-actions{display:flex;gap:10px;margin-top:24px}
    .btn-primary{flex:1;padding:12px;background:#1a1a1a;color:#fff;
      border:none;border-radius:16px;font-size:.95rem;font-weight:600;cursor:pointer}
    .btn-secondary{flex:1;padding:12px;background:#f0f0f0;color:#1a1a1a;
      border:none;border-radius:16px;font-size:.95rem;cursor:pointer}
    /* ── Modal detalle viaje ── */
    .modal-detalle{background:#fff;border-radius:24px;padding:28px;
      width:100%;max-width:680px;max-height:90vh;overflow-y:auto}
    .detalle-header{margin-bottom:20px}
    .detalle-destino{font-size:1.4rem;font-weight:700}
    .detalle-meta{color:#888;font-size:.85rem;margin-top:4px}
    .outfits-dias{display:flex;gap:14px;overflow-x:auto;padding-bottom:8px;margin-bottom:20px}
    .dia-col{flex-shrink:0;text-align:center}
    .dia-label{font-size:.78rem;font-weight:600;color:#888;margin-bottom:8px;text-transform:uppercase}
    .dia-look{width:100px;aspect-ratio:2/3;border-radius:14px;object-fit:cover;
      background:#f5f5f5;display:block}
    .dia-look-add{width:100px;aspect-ratio:2/3;border-radius:14px;background:#f0f0f0;
      display:flex;align-items:center;justify-content:center;font-size:1.6rem;
      color:#ccc;cursor:pointer;border:2px dashed #ddd}
    .btn-gen-look{width:100%;padding:12px;background:#1a1a1a;color:#fff;
      border:none;border-radius:14px;font-size:.9rem;font-weight:600;
      cursor:pointer;margin-top:8px}
    .spinner-small{width:18px;height:18px;border:2px solid rgba(255,255,255,.4);
      border-top-color:#fff;border-radius:50%;animation:spin 1s linear infinite;display:inline-block}
    @keyframes spin{to{transform:rotate(360deg)}}
    .toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
      background:#1a1a1a;color:#fff;padding:12px 24px;border-radius:24px;
      font-size:.9rem;opacity:0;transition:.3s;pointer-events:none;z-index:400}
    .toast.show{opacity:1}
  </style>
</head>
<body>
<div class="layout-with-sidebar">
  <jsp:include page="/includes/sidebar.jsp"/>
  <div class="main-content">
<div class="page">
  <div class="page-header">
    <div>
      <h1 class="page-title">Mis Viajes</h1>
      <p style="color:#888;font-size:.9rem;margin-top:4px">Organiza tu maleta con outfits perfectos</p>
    </div>
    <button class="btn-add" onclick="abrirModalNuevo()">+ Nuevo viaje</button>
  </div>

  <div class="viajes-grid" id="viajesGrid">
    <c:choose>
      <c:when test="${empty viajes}">
        <div class="empty-state" style="grid-column:1/-1">
          <div style="font-size:3rem;margin-bottom:14px">✈️</div>
          <p style="font-size:1.1rem;font-weight:600;margin-bottom:8px">¡Planea tu próximo viaje!</p>
          <p style="margin-bottom:20px">La app detectará el clima y te recomendará qué llevar</p>
          <button class="btn-add" onclick="abrirModalNuevo()">Crear viaje</button>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="v" items="${viajes}">
          <div class="viaje-card" data-id="${v.id}">
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
</div>

<%-- Modal nuevo viaje --%>
<div class="modal-overlay" id="modalNuevo">
  <div class="modal">
    <h2 class="modal-title">✈️ Tu próximo viaje</h2>
    <p class="modal-sub">Elige tu destino y las fechas — detectamos el clima automáticamente</p>
    <div class="form-group">
      <label>Destino *</label>
      <input type="text" id="inputDestino" placeholder="ej: Milan, Paris, Tokio"
             oninput="limpiarClima()"/>
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

<%-- Modal detalle viaje --%>
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
      <button onclick="cerrarDetalle()" style="width:100%;padding:11px;background:#f0f0f0;
        border:none;border-radius:14px;cursor:pointer;font-size:.9rem">Cerrar</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
const ctx = '${ctx}';
let viajeDetalleId = null;
let viajeDetalleFin = null;

// Cargar strips de outfits para cada viaje
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

// ── Modal nuevo viaje ─────────────────────────────────────────────────────
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

// ── Modal detalle viaje ───────────────────────────────────────────────────
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
  }
}

function mostrarToast(msg) {
  const t = document.getElementById('toast');
  t.textContent = msg; t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 3000);
}
</script>
  </div>
</div>
</body>
</html>
