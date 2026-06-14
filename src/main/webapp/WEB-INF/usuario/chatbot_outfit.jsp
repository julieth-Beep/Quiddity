<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
  <title>Chat IA — Quiddity</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Segoe UI',sans-serif;background:#f8f7f5;color:#1a1a1a;
      display:flex;flex-direction:column;height:100vh}
    .navbar{display:flex;align-items:center;justify-content:space-between;
      background:#fff;padding:14px 28px;border-bottom:1px solid #eee;flex-shrink:0}
    .logo-text{font-size:1.4rem;font-weight:700;color:#1a1a1a;text-decoration:none}
    .nav-links{list-style:none;display:flex;gap:8px}
    .nav-links li a{display:flex;flex-direction:column;align-items:center;gap:2px;
      padding:8px 14px;border-radius:12px;text-decoration:none;color:#666;font-size:.75rem;transition:.2s}
    .nav-links li a:hover,.nav-links li.active a{background:#f0f0f0;color:#1a1a1a}
    .btn-logout{padding:6px 14px;border-radius:20px;background:#1a1a1a;color:#fff;text-decoration:none;font-size:.8rem}
    /* ── Chat layout ── */
    .chat-container{flex:1;display:flex;flex-direction:column;max-width:700px;
      width:100%;margin:0 auto;padding:0 16px;overflow:hidden}
    .chat-header{padding:20px 0 12px;text-align:center;flex-shrink:0}
    .chat-header h1{font-size:1.3rem;font-weight:700}
    .chat-header p{color:#888;font-size:.85rem;margin-top:4px}
    .chat-messages{flex:1;overflow-y:auto;padding:12px 0;display:flex;
      flex-direction:column;gap:16px}
    /* ── Mensajes ── */
    .msg{display:flex;gap:10px;max-width:90%}
    .msg.user{align-self:flex-end;flex-direction:row-reverse}
    .msg.ia{align-self:flex-start}
    .msg-avatar{width:34px;height:34px;border-radius:50%;background:#f0f0f0;
      display:flex;align-items:center;justify-content:center;font-size:1rem;flex-shrink:0}
    .msg-bubble{background:#fff;border-radius:18px;padding:12px 16px;
      box-shadow:0 1px 4px rgba(0,0,0,.06);max-width:100%}
    .msg.user .msg-bubble{background:#1a1a1a;color:#fff}
    .msg-text{font-size:.9rem;line-height:1.5}
    .msg-img{margin-top:10px;border-radius:14px;width:100%;max-width:320px;
      display:block;cursor:pointer}
    .msg-img-actions{display:flex;gap:8px;margin-top:8px}
    .btn-small{padding:6px 14px;border-radius:12px;border:1.5px solid rgba(255,255,255,.3);
      background:rgba(255,255,255,.15);color:#fff;cursor:pointer;font-size:.78rem;font-weight:500}
    .msg.ia .btn-small{border-color:#e0e0e0;background:#f5f5f5;color:#1a1a1a}
    /* ── Sugerencias rápidas ── */
    .sugerencias{display:flex;gap:8px;flex-wrap:wrap;padding:8px 0;flex-shrink:0}
    .sug-btn{padding:8px 16px;border-radius:20px;border:1.5px solid #e0e0e0;
      background:#fff;cursor:pointer;font-size:.82rem;white-space:nowrap;transition:.2s}
    .sug-btn:hover{background:#f0f0f0;border-color:#ccc}
    /* ── Input área ── */
    .chat-input-area{padding:12px 0 20px;flex-shrink:0}
    .input-row{display:flex;gap:10px;background:#fff;border-radius:24px;
      padding:8px 8px 8px 18px;box-shadow:0 2px 12px rgba(0,0,0,.08)}
    .chat-input{flex:1;border:none;outline:none;font-size:.95rem;
      background:transparent;resize:none;max-height:100px;line-height:1.4}
    .btn-send{width:40px;height:40px;border-radius:50%;background:#1a1a1a;
      border:none;cursor:pointer;color:#fff;font-size:1.1rem;
      display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:.2s}
    .btn-send:disabled{background:#ccc;cursor:not-allowed}
    /* ── Typing indicator ── */
    .typing{display:none;align-self:flex-start}
    .typing .dots{display:flex;gap:4px;padding:10px 14px;background:#fff;
      border-radius:18px;box-shadow:0 1px 4px rgba(0,0,0,.06)}
    .dot{width:8px;height:8px;border-radius:50%;background:#ccc;
      animation:bounce .8s infinite}
    .dot:nth-child(2){animation-delay:.15s}
    .dot:nth-child(3){animation-delay:.3s}
    @keyframes bounce{0%,80%,100%{transform:translateY(0)}40%{transform:translateY(-6px)}}
    .toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
      background:#1a1a1a;color:#fff;padding:12px 24px;border-radius:24px;
      font-size:.9rem;opacity:0;transition:.3s;pointer-events:none;z-index:300}
    .toast.show{opacity:1}
  </style>
</head>
<body>
<div class="layout-with-sidebar">
  <jsp:include page="/includes/sidebar.jsp"/>
  <div class="main-content">
<div class="chat-container">
  <div class="chat-header">
    <h1>✨ Stylist IA</h1>
    <p>Cuéntame tu plan y te creo el outfit perfecto</p>
  </div>

  <div class="chat-messages" id="chatMessages">
    <%-- Mensaje inicial de la IA --%>
    <div class="msg ia">
      <div class="msg-avatar">🤖</div>
      <div class="msg-bubble">
        <p class="msg-text">¡Hola ${sessionScope.usuario.nombre}! 👋 Soy tu stylist personal.<br>
        Cuéntame tu plan y te genero una idea de outfit. Por ejemplo:<br>
        <em>"Cena romántica en verano"</em> o <em>"Reunión de trabajo informal"</em></p>
      </div>
    </div>
  </div>

  <div class="typing" id="typing">
    <div class="dots">
      <div class="dot"></div><div class="dot"></div><div class="dot"></div>
    </div>
  </div>

  <%-- Sugerencias rápidas --%>
  <div class="sugerencias" id="sugerencias">
    <button class="sug-btn" onclick="usarSugerencia(this)">☕ Brunch casual</button>
    <button class="sug-btn" onclick="usarSugerencia(this)">🌙 Salida nocturna</button>
    <button class="sug-btn" onclick="usarSugerencia(this)">💼 Reunión de trabajo</button>
    <button class="sug-btn" onclick="usarSugerencia(this)">🏖️ Día en la playa</button>
    <button class="sug-btn" onclick="usarSugerencia(this)">🎉 Fiesta de cumpleaños</button>
    <button class="sug-btn" onclick="usarSugerencia(this)">🛍️ Día de compras</button>
  </div>

  <div class="chat-input-area">
    <div class="input-row">
      <textarea class="chat-input" id="chatInput" rows="1"
        placeholder="Describe tu plan o pide una idea..."
        onkeydown="handleKey(event)"></textarea>
      <button class="btn-send" id="btnSend" onclick="enviarMensaje()">➤</button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
const ctx = '${ctx}';
let esperandoRespuesta = false;

function usarSugerencia(btn) {
  document.getElementById('chatInput').value = btn.textContent.replace(/^.{2}/,'').trim();
  document.getElementById('sugerencias').style.display = 'none';
  enviarMensaje();
}

function handleKey(e) {
  if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); enviarMensaje(); }
}

async function enviarMensaje() {
  if (esperandoRespuesta) return;
  const input   = document.getElementById('chatInput');
  const mensaje = input.value.trim();
  if (!mensaje) return;

  // Mostrar mensaje del usuario
  agregarMensaje('user', mensaje);
  input.value = '';
  autoResize(input);
  document.getElementById('sugerencias').style.display = 'none';

  // Mostrar typing
  esperandoRespuesta = true;
  document.getElementById('btnSend').disabled = true;
  document.getElementById('typing').style.display = 'flex';
  scrollAbajo();

  try {
    const res  = await fetch(ctx + '/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'mensaje=' + encodeURIComponent(mensaje)
    });
    const data = await res.json();

    document.getElementById('typing').style.display = 'none';

    if (res.ok) {
      agregarMensajeIA(data);
    } else {
      agregarMensaje('ia', '❌ ' + (data.error || 'Error al generar el outfit'));
    }
  } catch(err) {
    document.getElementById('typing').style.display = 'none';
    agregarMensaje('ia', '❌ Error de conexión. Intenta de nuevo.');
  } finally {
    esperandoRespuesta = false;
    document.getElementById('btnSend').disabled = false;
  }
}

function agregarMensaje(tipo, texto) {
  const msgs = document.getElementById('chatMessages');
  const div  = document.createElement('div');
  div.className = 'msg ' + tipo;
  div.innerHTML = '<div class="msg-avatar">' + (tipo === 'user' ? '👤' : '🤖') + '</div>'
    + '<div class="msg-bubble"><p class="msg-text">' + escapeHtml(texto) + '</p></div>';
  msgs.appendChild(div);
  scrollAbajo();
}

function agregarMensajeIA(data) {
  var msgs = document.getElementById('chatMessages');
  var div  = document.createElement('div');
  div.className = 'msg ia';
  div.setAttribute('data-look-id', data.id || '');
  var imgSrc = ctx + '/' + data.imagen;

  var avatar = document.createElement('div');
  avatar.className = 'msg-avatar';
  avatar.textContent = '🤖';

  var bubble = document.createElement('div');
  bubble.className = 'msg-bubble';

  var texto = document.createElement('p');
  texto.className = 'msg-text';
  texto.textContent = data.mensaje || 'Aquí tienes tu outfit';

  var img = document.createElement('img');
  img.className = 'msg-img';
  img.src = imgSrc;
  img.alt = 'outfit';
  img.onerror = function() { this.style.display = 'none'; };
  img.onclick = function() { ampliar(imgSrc); };

  var acciones = document.createElement('div');
  acciones.className = 'msg-img-actions';

  var btnCal = document.createElement('button');
  btnCal.className = 'btn-small';
  btnCal.textContent = '📅 Al calendario';
  btnCal.onclick = function() { guardarEnCal(data.id); };

  var btnFav = document.createElement('button');
  btnFav.className = 'btn-small';
  btnFav.textContent = '🤍 Favorito';
  btnFav.onclick = function() { marcarFav(data.id, btnFav); };

  acciones.appendChild(btnCal);
  acciones.appendChild(btnFav);
  bubble.appendChild(texto);
  bubble.appendChild(img);
  bubble.appendChild(acciones);
  div.appendChild(avatar);
  div.appendChild(bubble);
  msgs.appendChild(div);
  scrollAbajo();
}

async function guardarEnCal(idLook) {
  const fecha = prompt('¿Para qué fecha? (YYYY-MM-DD)');
  if (!fecha) return;
  const fd = new FormData();
  fd.append('fecha', fecha); fd.append('idLook', idLook); fd.append('momento', 'tarde');
  const res = await fetch(ctx + '/calendario', { method:'POST', body:fd });
  mostrarToast((await res.json()).mensaje ? '📅 Guardado en calendario' : '❌ Error');
}

async function marcarFav(idLook, btn) {
  const res = await fetch(ctx + '/look/' + idLook + '/fav', { method:'PUT' });
  if (res.ok) { btn.textContent = '❤️ Favorito'; mostrarToast('❤️ Guardado como favorito'); }
}

function ampliar(src) {
  const overlay = document.createElement('div');
  overlay.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:500;' +
    'display:flex;align-items:center;justify-content:center;cursor:pointer';
  overlay.innerHTML = '<img src="' + src + '" style="max-width:90vw;max-height:90vh;border-radius:16px"/>';
  overlay.onclick = () => document.body.removeChild(overlay);
  document.body.appendChild(overlay);
}

function scrollAbajo() {
  const msgs = document.getElementById('chatMessages');
  setTimeout(() => msgs.scrollTop = msgs.scrollHeight, 50);
}

function autoResize(el) {
  el.style.height = 'auto';
  el.style.height = Math.min(el.scrollHeight, 100) + 'px';
}
document.getElementById('chatInput').addEventListener('input', function() { autoResize(this); });

function escapeHtml(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;')
    .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
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
