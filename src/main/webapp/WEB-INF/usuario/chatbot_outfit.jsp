<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+akarta+Sans:wght@400;500;600;700&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
  <title>Chat IA — Quiddity</title>
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
    }

    /* ═══════════════════════════════════════════════════════════════════
       CHAT CONTAINER
       ═══════════════════════════════════════════════════════════════════ */
    .chat-container {
      flex: 1;
      display: flex;
      flex-direction: column;
      max-width: 800px;
      width: 100%;
      margin: 0 auto;
      padding: 0 24px;
      overflow: hidden;
    }

    /* ── Chat Header ── */
    .chat-header {
      padding: 24px 0 16px;
      text-align: center;
      flex-shrink: 0;
      border-bottom: 1px solid var(--border-light);
      margin-bottom: 8px;
    }

    .chat-header h1 {
      font-family: 'DM Sans', sans-serif;
      font-size: 20px;
      font-weight: 700;
      color: var(--text-primary);
      letter-spacing: -0.3px;
      margin-bottom: 4px;
    }

    .chat-header h1 span { color: var(--accent); }

    .chat-header p {
      color: var(--text-secondary);
      font-size: 12px;
      font-weight: 500;
    }

    /* ── Chat Messages ── */
    .chat-messages {
      flex: 1;
      overflow-y: auto;
      padding: 16px 0;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* ── Messages ── */
    .msg {
      display: flex;
      gap: 10px;
      max-width: 85%;
      animation: fadeUp 0.3s ease forwards;
    }

    .msg.user { align-self: flex-end; flex-direction: row-reverse; }
    .msg.ia { align-self: flex-start; }

    .msg-avatar {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: var(--accent-light);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      flex-shrink: 0;
      border: 2px solid var(--border-light);
    }

    .msg.user .msg-avatar { background: var(--accent); color: white; }

    .msg-bubble {
      background: var(--surface);
      border-radius: var(--radius-lg);
      padding: 14px 18px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
      max-width: 100%;
    }

    .msg.user .msg-bubble {
      background: var(--accent);
      color: #fff;
      border-color: var(--accent);
    }

    .msg-text {
      font-size: 13px;
      line-height: 1.6;
      color: var(--text-primary);
    }

    .msg.user .msg-text { color: #fff; }

    .msg-text em {
      color: var(--accent);
      font-style: italic;
    }

    .msg.user .msg-text em { color: #c7d2fe; }

    /* ── Message Image ── */
    .msg-img {
      margin-top: 12px;
      border-radius: var(--radius-md);
      width: 100%;
      max-width: 320px;
      display: block;
      cursor: pointer;
      border: 1px solid var(--border-light);
      transition: transform var(--transition-fast);
    }

    .msg-img:hover { transform: scale(1.02); }

    /* ── Image Actions ── */
    .msg-img-actions {
      display: flex;
      gap: 8px;
      margin-top: 10px;
    }

    .btn-small {
      padding: 8px 16px;
      border-radius: var(--radius-sm);
      border: 1.5px solid var(--border);
      background: var(--surface);
      color: var(--text-secondary);
      cursor: pointer;
      font-size: 11px;
      font-weight: 600;
      font-family: 'Plus Jakarta Sans', sans-serif;
      transition: all var(--transition-fast);
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    .btn-small:hover {
      background: var(--accent-light);
      border-color: var(--accent);
      color: var(--accent);
    }

    .msg.user .btn-small {
      border-color: rgba(255,255,255,0.3);
      background: rgba(255,255,255,0.15);
      color: #fff;
    }

    .msg.user .btn-small:hover {
      background: rgba(255,255,255,0.25);
      border-color: rgba(255,255,255,0.5);
    }

    /* ── Sugerencias rápidas ── */
    .sugerencias {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      padding: 12px 0;
      flex-shrink: 0;
      border-top: 1px solid var(--border-light);
      margin-top: 4px;
    }

    .sug-btn {
      padding: 8px 16px;
      border-radius: var(--radius-full);
      border: 1.5px solid var(--border);
      background: var(--surface);
      cursor: pointer;
      font-size: 12px;
      font-weight: 600;
      white-space: nowrap;
      transition: all var(--transition-fast);
      font-family: 'Plus Jakarta Sans', sans-serif;
      color: var(--text-secondary);
    }

    .sug-btn:hover {
      background: var(--accent-light);
      border-color: var(--accent);
      color: var(--accent);
      transform: translateY(-1px);
    }

    /* ── Input área ── */
    .chat-input-area {
      padding: 12px 0 24px;
      flex-shrink: 0;
    }

    .input-row {
      display: flex;
      gap: 10px;
      background: var(--surface);
      border-radius: var(--radius-xl);
      padding: 10px 10px 10px 20px;
      box-shadow: var(--shadow-md);
      border: 1.5px solid var(--border-light);
      transition: border-color var(--transition-fast);
    }

    .input-row:focus-within {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(67,56,202,0.08), var(--shadow-md);
    }

    .chat-input {
      flex: 1;
      border: none;
      outline: none;
      font-size: 14px;
      font-weight: 500;
      background: transparent;
      resize: none;
      max-height: 100px;
      line-height: 1.5;
      font-family: 'Plus Jakarta Sans', sans-serif;
      color: var(--text-primary);
    }

    .chat-input::placeholder { color: var(--text-tertiary); }

    .btn-send {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: var(--accent);
      border: none;
      cursor: pointer;
      color: #fff;
      font-size: 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      transition: all var(--transition-fast);
    }

    .btn-send:hover {
      background: var(--accent-hover);
      transform: scale(1.05);
    }

    .btn-send:disabled {
      background: var(--text-tertiary);
      cursor: not-allowed;
      transform: none;
    }

    /* ── Typing indicator ── */
    .typing {
      display: none;
      align-self: flex-start;
      margin-left: 42px;
    }

    .typing .dots {
      display: flex;
      gap: 6px;
      padding: 12px 16px;
      background: var(--surface);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border-light);
    }

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--text-tertiary);
      animation: bounce 0.8s infinite;
    }

    .dot:nth-child(2) { animation-delay: 0.15s }
    .dot:nth-child(3) { animation-delay: 0.3s }

    @keyframes bounce {
      0%, 80%, 100% { transform: translateY(0) }
      40% { transform: translateY(-6px) }
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

  <main class="main-content">
    <div class="chat-container">
      <div class="chat-header">
        <h1><span style="color:var(--accent);">✨</span> Stylist IA</h1>
        <p>Cuéntame tu plan y te creo el outfit perfecto</p>
      </div>

      <div class="chat-messages" id="chatMessages">
        <%-- Mensaje inicial de la IA --%>
        <div class="msg ia">
          <div class="msg-avatar">
            <span class="material-symbols-outlined" style="font-size:16px;color:var(--accent);">smart_toy</span>
          </div>
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
          <button class="btn-send" id="btnSend" onclick="enviarMensaje()">
            <span class="material-symbols-outlined" style="font-size:18px;">send</span>
          </button>
        </div>
      </div>
    </div>
  </main>
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
</body>
</html>