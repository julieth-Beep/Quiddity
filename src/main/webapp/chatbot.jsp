<%@ page pageEncoding="UTF-8" %>
    <%-- chatbot.jsp — Widget flotante de QuiddityBot (v2.0) Diseño floral elegante para plataforma de belleza
        ───────────────────────────────────────────────────────────────────────────── USO: incluir al final del <body>
        en TODAS las páginas donde quieras el chat.
        En cada JSP, justo antes de </body>:
        <%@ include file="/WEB-INF/includes/chatbot.jsp" %>
            --%>

            <!-- ═══════════════════  BOTÓN FLOTANTE TULIPÁN  ═══════════════════ -->
            <div id="qb-float-container">
                <!-- Mensaje de invitación -->
                <div id="qb-invite-msg">
                    <span>¿Tienes dudas?</span>
                    <small>Resuélvelas conmigo</small>
                </div>

                <!-- Tulipán SVG -->
                <button id="qb-toggle" aria-label="Abrir asistente Quiddity">
                    <svg id="qb-tulip" viewBox="0 0 100 120" xmlns="http://www.w3.org/2000/svg">
                        <!-- Tallo -->
                        <path d="M50 45 Q50 70 50 110" stroke="#7CB342" stroke-width="3" fill="none"
                            stroke-linecap="round" />
                        <!-- Hoja izquierda -->
                        <path d="M50 80 Q35 75 30 90 Q40 85 50 82" fill="#8BC34A" opacity="0.8" />
                        <!-- Hoja derecha -->
                        <path d="M50 85 Q65 80 70 95 Q60 90 50 87" fill="#8BC34A" opacity="0.8" />
                        <!-- Pétalo izquierdo -->
                        <path d="M50 45 Q30 25 25 45 Q30 55 50 50" fill="#E8B4B8" stroke="#D4A5A9" stroke-width="0.5" />
                        <!-- Pétalo derecho -->
                        <path d="M50 45 Q70 25 75 45 Q70 55 50 50" fill="#E8B4B8" stroke="#D4A5A9" stroke-width="0.5" />
                        <!-- Pétalo central -->
                        <path d="M50 45 Q42 15 50 5 Q58 15 50 45" fill="#F4C2C2" stroke="#E8B4B8" stroke-width="0.5" />
                        <!-- Brillo en pétalo central -->
                        <path d="M48 35 Q50 20 52 30" stroke="#FFF" stroke-width="1.5" fill="none" opacity="0.6"
                            stroke-linecap="round" />
                    </svg>
                    <span id="qb-dot"></span>
                </button>
            </div>

            <!-- ═══════════════════  VENTANA CHAT  ═══════════════════ -->
            <div id="qb-panel" aria-label="Asistente QuiddityBot" hidden>

                <!-- Header -->
                <div id="qb-header">
                    <div class="qb-info">
                        <div class="qb-avatar">
                            <svg viewBox="0 0 40 48" xmlns="http://www.w3.org/2000/svg">
                                <path d="M20 18 Q20 30 20 44" stroke="#7CB342" stroke-width="2" fill="none"
                                    stroke-linecap="round" />
                                <path d="M20 32 Q14 30 12 38 Q16 35 20 33" fill="#8BC34A" opacity="0.8" />
                                <path d="M20 35 Q26 33 28 41 Q24 38 20 36" fill="#8BC34A" opacity="0.8" />
                                <path d="M20 18 Q12 8 10 18 Q12 24 20 20" fill="#E8B4B8" />
                                <path d="M20 18 Q28 8 30 18 Q28 24 20 20" fill="#E8B4B8" />
                                <path d="M20 18 Q17 6 20 2 Q23 6 20 18" fill="#F4C2C2" />
                            </svg>
                        </div>
                        <div>
                            <p class="qb-name">QuiddityBot</p>
                            <p id="qb-rol"></p>
                        </div>
                    </div>
                    <button id="qb-close" aria-label="Cerrar">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round">
                            <path d="M18 6L6 18M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <!-- Mensajes -->
                <div id="qb-messages" role="log" aria-live="polite" aria-label="Conversación"></div>

                <!-- Input -->
                <div id="qb-footer">
                    <input id="qb-input" type="text" placeholder="Escribe tu pregunta..." maxlength="500"
                        autocomplete="off" aria-label="Mensaje" />
                    <button id="qb-send" aria-label="Enviar">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z" />
                        </svg>
                    </button>
                </div>
            </div>

            <!-- ═══════════════════  ESTILOS  ═══════════════════ -->
            <style>
                /* ══ Tokens de color — paleta suave y elegante ══ */
                :root {
                    --qb-cream: #FAF7F2;
                    --qb-ivory: #FFFEF9;
                    --qb-blush: #E8B4B8;
                    --qb-rose-soft: #D4A5A9;
                    --qb-rose-warm: #C9A9A6;
                    --qb-sage: #7CB342;
                    --qb-sage-light: #8BC34A;
                    --qb-text: #4A3F3A;
                    --qb-text-light: #8C7B72;
                    --qb-border: #E8DDD4;
                    --qb-gold: #D4AF37;
                    --qb-gold-soft: #E8D5A3;
                    --qb-radius: 20px;
                    --qb-shadow: 0 8px 32px rgba(74, 63, 58, 0.08);
                    --qb-shadow-lg: 0 12px 48px rgba(74, 63, 58, 0.12);
                }

                /* ══ Contenedor flotante ══ */
                #qb-float-container {
                    position: fixed;
                    bottom: 32px;
                    right: 32px;
                    z-index: 9998;
                    display: flex;
                    align-items: flex-end;
                    gap: 14px;
                    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
                }

                /* ══ Mensaje de invitación ══ */
                #qb-invite-msg {
                    background: var(--qb-ivory);
                    border: 1px solid var(--qb-border);
                    border-radius: 18px 18px 4px 18px;
                    padding: 12px 18px;
                    box-shadow: var(--qb-shadow);
                    opacity: 0;
                    transform: translateX(20px) scale(0.9);
                    animation: qb-invite-appear 0.6s ease 2s forwards;
                    max-width: 180px;
                    pointer-events: none;
                }

                #qb-invite-msg span {
                    display: block;
                    color: var(--qb-text);
                    font-size: 0.88rem;
                    font-weight: 600;
                    line-height: 1.3;
                }

                #qb-invite-msg small {
                    display: block;
                    color: var(--qb-text-light);
                    font-size: 0.75rem;
                    margin-top: 3px;
                    font-style: italic;
                }

                @keyframes qb-invite-appear {
                    to {
                        opacity: 1;
                        transform: translateX(0) scale(1);
                    }
                }

                /* ══ Tulipán botón ══ */
                #qb-toggle {
                    position: relative;
                    width: 68px;
                    height: 82px;
                    background: transparent;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                    filter: drop-shadow(0 4px 12px rgba(212, 165, 169, 0.35));
                    transition: transform 0.3s ease, filter 0.3s ease;
                }

                #qb-toggle:hover {
                    transform: translateY(-4px) scale(1.05);
                    filter: drop-shadow(0 8px 20px rgba(212, 165, 169, 0.5));
                }

                #qb-toggle:active {
                    transform: translateY(-2px) scale(0.98);
                }

                #qb-tulip {
                    width: 100%;
                    height: 100%;
                    overflow: visible;
                }

                /* Animación sutil del tulipán */
                @keyframes qb-tulip-sway {

                    0%,
                    100% {
                        transform: rotate(-2deg);
                    }

                    50% {
                        transform: rotate(2deg);
                    }
                }

                #qb-tulip {
                    animation: qb-tulip-sway 4s ease-in-out infinite;
                    transform-origin: bottom center;
                }

                /* Punto de notificación */
                #qb-dot {
                    position: absolute;
                    top: 8px;
                    right: 2px;
                    width: 10px;
                    height: 10px;
                    border-radius: 50%;
                    background: var(--qb-gold);
                    border: 2px solid var(--qb-ivory);
                    box-shadow: 0 2px 6px rgba(212, 175, 55, 0.4);
                    display: none;
                }

                #qb-dot.visible {
                    display: block;
                    animation: qb-pulse 2s ease-in-out infinite;
                }

                @keyframes qb-pulse {

                    0%,
                    100% {
                        transform: scale(1);
                        opacity: 1;
                    }

                    50% {
                        transform: scale(1.2);
                        opacity: 0.7;
                    }
                }

                /* Ocultar mensaje cuando el panel está abierto */
                #qb-panel:not([hidden])~#qb-float-container #qb-invite-msg,
                #qb-panel:not([hidden])~#qb-float-container #qb-dot {
                    opacity: 0 !important;
                    pointer-events: none;
                }

                /* ══ Panel del chat ══ */
                #qb-panel {
                    position: fixed;
                    bottom: 130px;
                    right: 32px;
                    z-index: 9999;
                    width: 360px;
                    max-height: 520px;
                    background: var(--qb-ivory);
                    border: 1px solid var(--qb-border);
                    border-radius: var(--qb-radius);
                    box-shadow: var(--qb-shadow-lg);
                    display: flex;
                    flex-direction: column;
                    overflow: hidden;
                    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
                    animation: qb-panel-in 0.35s cubic-bezier(0.16, 1, 0.3, 1);
                }

                #qb-panel[hidden] {
                    display: none !important;
                }

                @keyframes qb-panel-in {
                    from {
                        opacity: 0;
                        transform: translateY(20px) scale(0.96);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0) scale(1);
                    }
                }

                /* ══ Header ══ */
                #qb-header {
                    background: linear-gradient(135deg, var(--qb-blush), var(--qb-rose-soft));
                    padding: 16px 18px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    color: #fff;
                }

                .qb-info {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .qb-avatar {
                    width: 38px;
                    height: 38px;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.25);
                    backdrop-filter: blur(4px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 6px;
                }

                .qb-avatar svg {
                    width: 100%;
                    height: 100%;
                }

                .qb-name {
                    margin: 0;
                    font-size: 0.95rem;
                    font-weight: 600;
                    letter-spacing: 0.2px;
                }

                #qb-rol {
                    margin: 2px 0 0;
                    font-size: 0.74rem;
                    opacity: 0.85;
                    font-style: italic;
                    font-weight: 400;
                }

                #qb-close {
                    background: rgba(255, 255, 255, 0.15);
                    border: none;
                    color: #fff;
                    width: 32px;
                    height: 32px;
                    border-radius: 10px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s ease;
                }

                #qb-close:hover {
                    background: rgba(255, 255, 255, 0.3);
                    transform: rotate(90deg);
                }

                /* ══ Mensajes ══ */
                #qb-messages {
                    flex: 1;
                    overflow-y: auto;
                    padding: 16px 14px;
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                    scroll-behavior: smooth;
                    background: var(--qb-cream);
                }

                #qb-messages::-webkit-scrollbar {
                    width: 5px;
                }

                #qb-messages::-webkit-scrollbar-track {
                    background: transparent;
                }

                #qb-messages::-webkit-scrollbar-thumb {
                    background: var(--qb-border);
                    border-radius: 10px;
                }

                /* ══ Burbujas ══ */
                .qb-bubble {
                    max-width: 80%;
                    padding: 11px 15px;
                    border-radius: 16px;
                    font-size: 0.87rem;
                    line-height: 1.55;
                    word-break: break-word;
                    white-space: pre-wrap;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
                }

                .qb-bubble.bot {
                    background: #fff;
                    border: 1px solid var(--qb-border);
                    color: var(--qb-text);
                    align-self: flex-start;
                    border-bottom-left-radius: 5px;
                }

                .qb-bubble.user {
                    background: linear-gradient(135deg, var(--qb-blush), var(--qb-rose-warm));
                    color: #fff;
                    align-self: flex-end;
                    border-bottom-right-radius: 5px;
                }

                .qb-bubble.typing {
                    background: #fff;
                    border: 1px dashed var(--qb-border);
                    color: var(--qb-text-light);
                    align-self: flex-start;
                    font-style: italic;
                    font-size: 0.82rem;
                    padding: 9px 14px;
                }

                /* ══ Botón de acción (para aplicar rol recomendado) ══ */
                .qb-action-btn {
                    align-self: flex-start;
                    margin-top: 8px;
                    background: linear-gradient(135deg, var(--qb-blush), var(--qb-rose-soft));
                    color: #fff;
                    border: none;
                    padding: 10px 18px;
                    border-radius: 14px;
                    font-size: 0.85rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    box-shadow: 0 2px 8px rgba(212, 165, 169, 0.3);
                }

                .qb-action-btn:hover {
                    transform: scale(1.05);
                    box-shadow: 0 4px 14px rgba(212, 165, 169, 0.45);
                }

                /* ══ Footer / input ══ */
                #qb-footer {
                    display: flex;
                    gap: 10px;
                    padding: 12px 14px;
                    border-top: 1px solid var(--qb-border);
                    background: #fff;
                }

                #qb-input {
                    flex: 1;
                    border: 1.5px solid var(--qb-border);
                    border-radius: 22px;
                    padding: 10px 16px;
                    font-size: 0.88rem;
                    outline: none;
                    font-family: inherit;
                    background: var(--qb-cream);
                    color: var(--qb-text);
                    transition: all 0.25s ease;
                }

                #qb-input:focus {
                    border-color: var(--qb-blush);
                    background: #fff;
                    box-shadow: 0 0 0 3px rgba(232, 180, 184, 0.15);
                }

                #qb-input::placeholder {
                    color: var(--qb-text-light);
                    opacity: 0.7;
                }

                #qb-send {
                    width: 40px;
                    height: 40px;
                    flex-shrink: 0;
                    border-radius: 50%;
                    background: linear-gradient(135deg, var(--qb-blush), var(--qb-rose-soft));
                    border: none;
                    color: #fff;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s ease;
                    box-shadow: 0 2px 8px rgba(212, 165, 169, 0.3);
                }

                #qb-send:hover {
                    transform: scale(1.08);
                    box-shadow: 0 4px 14px rgba(212, 165, 169, 0.45);
                }

                #qb-send:active {
                    transform: scale(0.95);
                }

                #qb-send:disabled {
                    opacity: 0.4;
                    cursor: not-allowed;
                    transform: none;
                }

                /* ══ Responsive ══ */
                @media (max-width: 440px) {
                    #qb-panel {
                        width: calc(100vw - 24px);
                        right: 12px;
                        bottom: 120px;
                        max-height: calc(100vh - 160px);
                    }

                    #qb-float-container {
                        bottom: 20px;
                        right: 20px;
                    }

                    #qb-invite-msg {
                        display: none;
                    }
                }
            </style>

            <!-- ═══════════════════  JAVASCRIPT  ═══════════════════ -->
            <script>
                (function () {
                    'use strict';

                    const ctx = '${pageContext.request.contextPath}';
                    const toggle = document.getElementById('qb-toggle');
                    const panel = document.getElementById('qb-panel');
                    const closeB = document.getElementById('qb-close');
                    const input = document.getElementById('qb-input');
                    const sendBtn = document.getElementById('qb-send');
                    const msgs = document.getElementById('qb-messages');
                    const rolLbl = document.getElementById('qb-rol');
                    const dot = document.getElementById('qb-dot');
                    const invite = document.getElementById('qb-invite-msg');

                    let ready = false;
                    let flujoRegistroCompleto = false;

                    // Detectar si estamos en página de registro
                    const esRegistro = window.location.pathname.includes('registro') ||
                        window.location.pathname.includes('Registro');

                    // ── Reset chat ──────────────────────────────────────────────────────────
                    function resetChat() {
                        ready = false;
                        flujoRegistroCompleto = false;
                        msgs.innerHTML = '';
                        rolLbl.textContent = '';
                        input.value = '';
                        input.placeholder = 'Escribe tu pregunta...';
                        input.disabled = false;
                        sendBtn.disabled = false;
                    }

                    // ── Abrir / cerrar ──────────────────────────────────────────────────────
                    toggle.addEventListener('click', () => {
                        const isHidden = panel.hasAttribute('hidden');
                        if (isHidden) {
                            panel.removeAttribute('hidden');
                            dot.classList.remove('visible');
                            invite.style.opacity = '0';
                            invite.style.pointerEvents = 'none';
                            if (!ready) initChat();
                            else input.focus();
                        } else {
                            panel.setAttribute('hidden', '');
                            resetChat();
                        }
                    });

                    closeB.addEventListener('click', () => {
                        panel.setAttribute('hidden', '');
                        resetChat();
                    });

                    // ── Iniciar: obtener bienvenida ─────────────────────────────────────────
                    function initChat() {
                        ready = true;
                        fetch(ctx + '/chatbot', { method: 'GET' })
                            .then(r => r.json())
                            .then(data => {
                                rolLbl.textContent = data.nombreRol || '';

                                // Si es registro e invitado, iniciar flujo de registro automáticamente
                                if (esRegistro && data.rol === 4) {
                                    appendMsg('bot', '¡Hola! 🌸 Soy QuiddityBot. Veo que estás creando una cuenta. ' +
                                        'Para recomendarte la mejor experiencia, me gustaría conocerte un poco. ' +
                                        '¿Qué te interesa más de nuestra plataforma? ' +
                                        '(a) Comprar productos de belleza y moda, ' +
                                        '(b) Crear outfits y recibir sugerencias de estilo, o ' +
                                        '(c) Ambas cosas');
                                } else {
                                    appendMsg('bot', data.bienvenida || '¡Hola! ¿En qué puedo ayudarte?');
                                }

                                input.focus();
                            })
                            .catch(() => {
                                appendMsg('bot', '¡Hola! ¿En qué puedo ayudarte?');
                                input.focus();
                            });
                    }

                    // ── Enviar mensaje ──────────────────────────────────────────────────────
                    function send() {
                        const text = input.value.trim();
                        if (!text || sendBtn.disabled || (esRegistro && flujoRegistroCompleto)) return;

                        appendMsg('user', text);
                        input.value = '';
                        sendBtn.disabled = true;

                        const loader = appendMsg('typing', '✦ escribiendo...');

                        // Determinar modo según contexto
                        const modo = (esRegistro && !flujoRegistroCompleto) ? 'registro' : 'chat';

                        fetch(ctx + '/chatbot', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ pregunta: text, modo: modo })
                        })
                            .then(r => r.json())
                            .then(data => {
                                loader.remove();

                                // Si hay recomendación de rol, mostrar botón para aplicar
                                if (data.rolRecomendado && data.finFlujo) {
                                    flujoRegistroCompleto = true;
                                    appendMsg('bot', data.respuesta);
                                    mostrarBotonRol(data.rolRecomendado);
                                } else {
                                    appendMsg('bot', data.respuesta || data.error || 'No pude responder eso. Intenta de nuevo.');
                                }
                            })
                            .catch(() => {
                                loader.remove();
                                appendMsg('bot', 'Ocurrió un error de conexión. Por favor intenta más tarde.');
                            })
                            .finally(() => {
                                if (!flujoRegistroCompleto) {
                                    sendBtn.disabled = false;
                                    input.focus();
                                }
                            });
                    }

                    sendBtn.addEventListener('click', send);
                    input.addEventListener('keydown', e => {
                        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); }
                    });

                    // ── Mostrar botón para aplicar rol recomendado ──────────────────────────
                    function mostrarBotonRol(rolId) {
                        const wrapper = document.createElement('div');
                        wrapper.style.cssText = 'align-self:flex-start;margin-top:8px;';

                        const btn = document.createElement('button');
                        btn.className = 'qb-action-btn';
                        btn.textContent = rolId === 2
                            ? '✨ Aplicar: Usuario (acceso completo)'
                            : '💳 Aplicar: Comprador';

                        btn.addEventListener('click', () => {
                            // Buscar campo de rol en el formulario de registro
                            const rolInput = document.getElementById('idrol') ||
                                document.querySelector('input[name="idrol"]') ||
                                document.querySelector('select[name="idrol"]');

                            if (rolInput) {
                                rolInput.value = rolId;
                                // Resaltar visualmente si es visible
                                rolInput.style.background = '#e8f5e9';
                                rolInput.style.borderColor = '#7CB342';

                                // Mostrar confirmación
                                const confirmMsg = document.createElement('div');
                                confirmMsg.className = 'qb-bubble bot';
                                confirmMsg.style.cssText = 'margin-top:8px;font-size:0.82rem;background:#f1f8e9;border-color:#c5e1a5;';
                                confirmMsg.textContent = '¡Perfecto! He seleccionado el rol recomendado en tu formulario. Completa tus datos para finalizar el registro. 🌸';
                                msgs.appendChild(confirmMsg);
                                msgs.scrollTop = msgs.scrollHeight;
                            } else {
                                // Si no hay campo de rol, mostrar mensaje manual
                                const manualMsg = document.createElement('div');
                                manualMsg.className = 'qb-bubble bot';
                                manualMsg.style.cssText = 'margin-top:8px;font-size:0.82rem;';
                                manualMsg.textContent = 'Rol recomendado: ' + (rolId === 2 ? 'Usuario' : 'Comprador') +
                                    '. Por favor selecciónalo manualmente en el formulario. 🌸';
                                msgs.appendChild(manualMsg);
                                msgs.scrollTop = msgs.scrollHeight;
                            }

                            // Deshabilitar input y cambiar placeholder
                            input.disabled = true;
                            input.placeholder = 'Registro completado';
                            sendBtn.disabled = true;
                            btn.style.display = 'none';
                        });

                        wrapper.appendChild(btn);
                        msgs.appendChild(wrapper);
                        msgs.scrollTop = msgs.scrollHeight;
                    }

                    // ── Helpers ─────────────────────────────────────────────────────────────
                    function appendMsg(type, text) {
                        const el = document.createElement('div');
                        el.className = 'qb-bubble ' + type;
                        el.textContent = text;
                        msgs.appendChild(el);
                        msgs.scrollTop = msgs.scrollHeight;
                        return el;
                    }

                    // Mostrar punto de notificación después de 4s
                    setTimeout(() => {
                        if (panel.hasAttribute('hidden')) dot.classList.add('visible');
                    }, 4000);

                })();
            </script>