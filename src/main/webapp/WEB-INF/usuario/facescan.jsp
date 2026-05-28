<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Face Full — Quiddity</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --cream:   #F5F0EA;
            --blush:   #E8C4B8;
            --rose:    #C4796A;
            --plum:    #3D2B35;
            --gold:    #C9A96E;
            --glass:   rgba(255,255,255,0.12);
            --overlay-active: rgba(201,169,110,0.55);
            --overlay-idle:   rgba(255,255,255,0.18);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: var(--plum);
            font-family: 'DM Sans', sans-serif;
            color: var(--cream);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-x: hidden;
        }

        /* ── HEADER ── */
        header {
            width: 100%;
            padding: 1.4rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .logo {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.6rem;
            font-weight: 300;
            letter-spacing: 0.18em;
            color: var(--gold);
        }
        .step-indicator {
            font-size: 0.72rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.45);
        }

        /* ── INTRO ── */
        .intro {
            text-align: center;
            padding: 2rem 1rem 1rem;
        }
        .intro h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(1.8rem, 5vw, 3rem);
            font-weight: 300;
            letter-spacing: 0.06em;
            margin-bottom: 0.5rem;
        }
        .intro p {
            font-size: 0.88rem;
            color: rgba(245,240,234,0.6);
            max-width: 360px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* ── CÁMARA + OVERLAY ── */
        .camera-stage {
            position: relative;
            width: min(380px, 92vw);
            aspect-ratio: 3/4;
            border-radius: 24px;
            overflow: hidden;
            margin: 1.4rem auto 0;
            box-shadow: 0 24px 60px rgba(0,0,0,0.5);
            border: 1px solid rgba(255,255,255,0.1);
        }

        #video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transform: scaleX(-1); /* espejo natural */
            display: block;
        }

        /* Placeholder cuando no hay cámara */
        .no-camera {
            width: 100%;
            height: 100%;
            background: linear-gradient(160deg, #2a1f27 0%, #1a1118 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            color: rgba(245,240,234,0.4);
            font-size: 0.85rem;
        }
        .no-camera svg { opacity: 0.3; }

        /* Overlay SVG de forma de cara activo */
        #face-overlay {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
            transition: opacity 0.35s ease;
        }

        /* Guía de posición siempre visible */
        .guide-ring {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -52%);
            width: 58%;
            aspect-ratio: 3/4;
            border: 1.5px dashed rgba(255,255,255,0.2);
            border-radius: 50%;
            pointer-events: none;
        }

        /* Etiqueta del shape activo */
        .shape-label {
            position: absolute;
            bottom: 16px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0,0,0,0.5);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            padding: 6px 18px;
            font-size: 0.78rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            white-space: nowrap;
            transition: opacity 0.3s;
        }

        /* ── SELECTOR DE FORMAS ── */
        .shapes-title {
            font-size: 0.7rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.4);
            text-align: center;
            margin-top: 1.6rem;
            margin-bottom: 0.9rem;
        }

        .shapes-grid {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: center;
            padding: 0 1rem;
            max-width: 440px;
            margin: 0 auto;
        }

        .shape-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            background: var(--glass);
            border: 1.5px solid rgba(255,255,255,0.1);
            border-radius: 14px;
            padding: 10px 14px;
            cursor: pointer;
            transition: all 0.22s ease;
            min-width: 72px;
            backdrop-filter: blur(6px);
        }
        .shape-btn:hover {
            border-color: rgba(201,169,110,0.45);
            background: rgba(201,169,110,0.08);
            transform: translateY(-2px);
        }
        .shape-btn.active {
            border-color: var(--gold);
            background: rgba(201,169,110,0.18);
            box-shadow: 0 0 18px rgba(201,169,110,0.2);
        }
        .shape-btn svg {
            width: 32px;
            height: 40px;
        }
        .shape-btn span {
            font-size: 0.68rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.65);
            transition: color 0.2s;
        }
        .shape-btn.active span { color: var(--gold); }

        /* ── BOTÓN CONFIRMAR ── */
        .confirm-area {
            margin: 1.8rem auto 2.5rem;
            text-align: center;
            padding: 0 1rem;
        }
        .hint {
            font-size: 0.78rem;
            color: rgba(245,240,234,0.38);
            margin-bottom: 1rem;
        }

        #btnConfirmar {
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose) 100%);
            color: var(--plum);
            border: none;
            border-radius: 50px;
            padding: 14px 48px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            letter-spacing: 0.1em;
            cursor: pointer;
            transition: all 0.25s ease;
            opacity: 0.35;
            pointer-events: none;
            text-transform: uppercase;
        }
        #btnConfirmar.enabled {
            opacity: 1;
            pointer-events: auto;
        }
        #btnConfirmar.enabled:hover {
            transform: scale(1.04);
            box-shadow: 0 8px 30px rgba(201,169,110,0.4);
        }

        /* Error */
        .alert-error {
            background: rgba(196,121,106,0.18);
            border: 1px solid rgba(196,121,106,0.4);
            border-radius: 12px;
            padding: 12px 20px;
            font-size: 0.82rem;
            color: var(--blush);
            margin: 0 auto 1rem;
            max-width: 360px;
            text-align: center;
        }
    </style>
</head>
<body>

<header>
    <div class="logo">Quiddity</div>
    <div class="step-indicator">Face Full — Escaneo facial</div>
</header>

<div class="intro">
    <h1>Descubre tu forma</h1>
    <p>Centra tu rostro en el encuadre y selecciona la silueta que mejor coincida con tu cara.</p>
</div>

<!-- CÁMARA -->
<div class="camera-stage">
    <video id="video" autoplay playsinline muted></video>
    <div class="no-camera" id="noCamMsg" style="display:none;">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
            <path d="M23 7l-7 5 7 5V7z"/><rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
        </svg>
        <span>Permite el acceso a la cámara</span>
    </div>
    <svg id="face-overlay" viewBox="0 0 380 506" preserveAspectRatio="xMidYMid meet"></svg>
    <div class="guide-ring"></div>
    <div class="shape-label" id="shapeLabel" style="display:none;"></div>
</div>

<!-- SELECTOR -->
<p class="shapes-title">Selecciona tu forma de cara</p>

<div class="shapes-grid" id="shapesGrid">
    <!-- generado por JS -->
</div>

<!-- CONFIRMAR -->
<div class="confirm-area">
    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>
    <p class="hint" id="hintText">Elige la forma que mejor describa tu rostro</p>

    <form id="faceScanForm" action="${pageContext.request.contextPath}/facefull" method="post">
        <input type="hidden" name="formaCara" id="hiddenFormaCara">
        <button type="submit" id="btnConfirmar">Confirmar y continuar</button>
    </form>
</div>

<script>
// ─────────────────────────────────────────────
// Definición de formas con SVG + paths de cara
// ─────────────────────────────────────────────
const SHAPES = [
    {
        id: 'ovalada',
        label: 'Ovalada',
        // Elipse perfecta
        path: 'M190,60 C255,60 305,140 305,253 C305,366 255,446 190,446 C125,446 75,366 75,253 C75,140 125,60 190,60 Z',
        icon: `<ellipse cx="16" cy="20" rx="8" ry="12" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    },
    {
        id: 'redonda',
        label: 'Redonda',
        path: 'M190,70 C268,70 320,130 320,253 C320,370 265,446 190,446 C115,446 60,370 60,253 C60,130 112,70 190,70 Z',
        icon: `<circle cx="16" cy="20" r="11" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    },
    {
        id: 'cuadrada',
        label: 'Cuadrada',
        path: 'M100,75 C135,65 245,65 280,75 C310,85 320,110 320,253 C320,396 310,421 280,431 C245,441 135,441 100,431 C70,421 60,396 60,253 C60,110 70,85 100,75 Z',
        icon: `<rect x="5" y="8" width="22" height="24" rx="3" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    },
    {
        id: 'corazon',
        label: 'Corazón',
        path: 'M130,70 C155,62 225,62 250,70 C285,80 310,110 310,160 C310,240 260,340 190,446 C120,340 70,240 70,160 C70,110 95,80 130,70 Z',
        icon: `<path d="M16 32 C16 32 4 22 4 14 C4 9 8 6 12 7 C14 7.5 16 9 16 9 C16 9 18 7.5 20 7 C24 6 28 9 28 14 C28 22 16 32 16 32Z" transform="scale(0.6) translate(2,2)" fill="none" stroke="currentColor" stroke-width="2"/>`
    },
    {
        id: 'diamante',
        label: 'Diamante',
        path: 'M190,65 C230,65 295,100 305,175 C315,240 270,360 190,446 C110,360 65,240 75,175 C85,100 150,65 190,65 Z',
        icon: `<polygon points="16,6 27,18 16,34 5,18" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    },
    {
        id: 'rectangular',
        label: 'Oblonga',
        path: 'M115,60 C148,52 232,52 265,60 C292,68 300,95 300,253 C300,411 292,438 265,446 C232,454 148,454 115,446 C88,438 80,411 80,253 C80,95 88,68 115,60 Z',
        icon: `<rect x="8" y="4" width="16" height="32" rx="4" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    },
    {
        id: 'triangular',
        label: 'Triangular',
        path: 'M75,160 C78,105 108,72 190,65 C272,72 302,105 305,160 C315,240 260,360 190,446 C120,360 65,240 75,160 Z',
        icon: `<polygon points="16,6 28,34 4,34" fill="none" stroke="currentColor" stroke-width="1.5"/>`
    }
];

// ─────────────────────────────────────────────
// Estado
// ─────────────────────────────────────────────
let selectedId = null;

// ─────────────────────────────────────────────
// Renderizar botones del selector
// ─────────────────────────────────────────────
const grid = document.getElementById('shapesGrid');
SHAPES.forEach(shape => {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'shape-btn';
    btn.dataset.id = shape.id;
    btn.innerHTML = `
        <svg viewBox="0 0 32 40" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="1.5">
            ${shape.icon}
        </svg>
        <span>${shape.label}</span>`;
    btn.addEventListener('click', () => seleccionarForma(shape.id));
    grid.appendChild(btn);
});

// ─────────────────────────────────────────────
// Lógica de selección
// ─────────────────────────────────────────────
function seleccionarForma(id) {
    selectedId = id;
    const shape = SHAPES.find(s => s.id === id);

    // Actualizar botones
    document.querySelectorAll('.shape-btn').forEach(b => {
        b.classList.toggle('active', b.dataset.id === id);
    });

    // Dibujar overlay en la cámara
    const overlay = document.getElementById('face-overlay');
    overlay.innerHTML = `
        <path d="${shape.path}"
              fill="rgba(201,169,110,0.15)"
              stroke="rgba(201,169,110,0.75)"
              stroke-width="2"
              stroke-dasharray="8 4"/>`;

    // Mostrar etiqueta
    const label = document.getElementById('shapeLabel');
    label.textContent = shape.label;
    label.style.display = 'block';

    // Activar botón confirmar
    document.getElementById('hiddenFormaCara').value = id;
    const btnConfirmar = document.getElementById('btnConfirmar');
    btnConfirmar.classList.add('enabled');
    document.getElementById('hintText').textContent = `Forma seleccionada: ${shape.label}`;
}

// ─────────────────────────────────────────────
// Iniciar cámara
// ─────────────────────────────────────────────
(async function initCamera() {
    const video = document.getElementById('video');
    const noCamMsg = document.getElementById('noCamMsg');
    try {
        const stream = await navigator.mediaDevices.getUserMedia({
            video: { facingMode: 'user', width: { ideal: 640 }, height: { ideal: 853 } },
            audio: false
        });
        video.srcObject = stream;
        video.style.display = 'block';
    } catch (err) {
        console.warn('Cámara no disponible:', err);
        video.style.display = 'none';
        noCamMsg.style.display = 'flex';
    }
})();
</script>

</body>
</html>
