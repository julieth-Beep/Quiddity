<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block"/>
  <title>Mis Looks — Quiddity</title>
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
    .page{max-width:1100px;margin:0 auto;padding:28px 20px}
    .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px}
    .page-title{font-size:1.6rem;font-weight:700}
    /* ── Filtros ── */
    .filtros{display:flex;gap:8px;margin-bottom:24px}
    .filtro-btn{padding:8px 18px;border-radius:24px;border:1.5px solid #e0e0e0;
      background:#fff;cursor:pointer;font-size:.85rem;font-weight:500;transition:.2s}
    .filtro-btn.active{background:#1a1a1a;color:#fff;border-color:#1a1a1a}
    /* ── Grid tipo Pinterest 2 columnas ── */
    .looks-grid{columns:2;gap:16px}
    @media(min-width:600px){.looks-grid{columns:3}}
    @media(min-width:900px){.looks-grid{columns:4}}
    .look-card{break-inside:avoid;margin-bottom:16px;background:#fff;
      border-radius:18px;overflow:hidden;position:relative;cursor:pointer;
      box-shadow:0 1px 6px rgba(0,0,0,.06);transition:.2s}
    .look-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.1)}
    .look-card img{width:100%;display:block;object-fit:cover}
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
    .empty-state{text-align:center;padding:80px 20px;color:#bbb}
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
  </style>
</head>
<body>
<div class="layout-with-sidebar">
  <jsp:include page="/includes/sidebar.jsp"/>
  <div class="main-content">
<div class="page">
  <div class="page-header">
    <div>
      <h1 class="page-title">Mis Looks</h1>
      <p style="color:#888;font-size:.9rem;margin-top:4px">${looks.size()} looks generados</p>
    </div>
    <a href="${ctx}/outfit" style="padding:10px 20px;background:#1a1a1a;color:#fff;
      border-radius:24px;text-decoration:none;font-size:.9rem;font-weight:500">+ Crear look</a>
  </div>

  <div class="filtros">
    <button class="filtro-btn active" onclick="filtrar('todos',this)">Todos</button>
    <button class="filtro-btn" onclick="filtrar('manual',this)">Manuales</button>
    <button class="filtro-btn" onclick="filtrar('ia',this)">Chat IA</button>
    <button class="filtro-btn" onclick="filtrar('favorito',this)">❤️ Favoritos</button>
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

function filtrar(tipo, btn) {
  document.querySelectorAll('.filtro-btn').forEach(b => b.classList.remove('active'));
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
  </div>
</div>
</body>
</html>
