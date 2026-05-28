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
            --cream: #F5F0EA;
            --blush: #E8C4B8;
            --rose:  #C4796A;
            --plum:  #3D2B35;
            --gold:  #C9A96E;
            --glass: rgba(255,255,255,0.12);
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            background: var(--plum);
            font-family: "DM Sans", sans-serif;
            color: var(--cream);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-x: hidden;
        }
        header {
            width: 100%;
            padding: 1.4rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .logo {
            font-family: "Cormorant Garamond", serif;
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
        .intro {
            text-align: center;
            padding: 2rem 1rem 1rem;
        }
        .intro h1 {
            font-family: "Cormorant Garamond", serif;
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
        .camera-stage {
            position: relative;
            width: min(380px, 92vw);
            aspect-ratio: 3/4;
            border-radius: 24px;
            overflow: hidden;
            margin: 1.4rem auto 0;
            box-shadow: 0 24px 60px rgba(0,0,0,0.5);
            border: 1px solid rgba(255,255,255,0.1);
            background: #1a1118;
        }
        #video {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            transform: scaleX(-1);
        }
        #overlayCanvas {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
        }
        .no-camera {
            position: absolute;
            top:0; left:0;
            width:100%; height:100%;
            background: linear-gradient(160deg, #2a1f27 0%, #1a1118 100%);
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            color: rgba(245,240,234,0.4);
            font-size: 0.85rem;
        }
        .no-camera svg { opacity:0.3; }
        .shape-label {
            position: absolute;
            bottom: 16px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0,0,0,0.55);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            padding: 6px 18px;
            font-size: 0.78rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            white-space: nowrap;
            display: none;
            z-index: 10;
        }
        .section-title {
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
            color: var(--cream);
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
        .shape-btn svg { width:32px; height:40px; }
        .shape-btn span {
            font-size: 0.68rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.65);
            transition: color 0.2s;
        }
        .shape-btn.active span { color: var(--gold); }
        .skin-grid {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            justify-content: center;
            padding: 0 1rem;
            max-width: 440px;
            margin: 0 auto;
        }
        .skin-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 7px;
            background: none;
            border: none;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .skin-btn:hover { transform: translateY(-2px); }
        .skin-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2.5px solid rgba(255,255,255,0.15);
            transition: all 0.22s ease;
        }
        .skin-btn.active .skin-circle {
            border-color: #fff;
            box-shadow: 0 0 0 3px rgba(255,255,255,0.5);
        }
        .skin-btn span {
            font-size: 0.63rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.55);
        }
        .skin-btn.active span { color: var(--cream); }
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
            font-family: "DM Sans", sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            letter-spacing: 0.1em;
            cursor: pointer;
            transition: all 0.25s ease;
            opacity: 0.35;
            pointer-events: none;
            text-transform: uppercase;
        }
        #btnConfirmar.enabled { opacity:1; pointer-events:auto; }
        #btnConfirmar.enabled:hover {
            transform: scale(1.04);
            box-shadow: 0 8px 30px rgba(201,169,110,0.4);
        }
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
    <div class="step-indicator">Face Full &mdash; Escaneo facial</div>
</header>

<div class="intro">
    <h1>Descubre tu forma</h1>
    <p>Centra tu rostro en el encuadre y selecciona la silueta que mejor coincida con tu cara.</p>
</div>

<div class="camera-stage">
    <video id="video" autoplay playsinline muted></video>
    <canvas id="overlayCanvas"></canvas>
    <div class="no-camera" id="noCamMsg">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
            <path d="M23 7l-7 5 7 5V7z"/>
            <rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
        </svg>
        <span>Permite el acceso a la camara</span>
    </div>
    <div class="shape-label" id="shapeLabel"></div>
</div>

<p class="section-title">Selecciona tu forma de cara</p>
<div class="shapes-grid" id="shapesGrid"></div>

<p class="section-title" style="margin-top:1.8rem;">Selecciona tu tono de piel</p>
<div class="skin-grid" id="skinGrid"></div>

<div class="confirm-area">
    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>
    <p class="hint" id="hintText">Elige la forma que mejor describa tu rostro</p>
    <form id="faceScanForm" action="${pageContext.request.contextPath}/facefull" method="post">
        <input type="hidden" name="formaCara" id="hiddenFormaCara">
        <input type="hidden" name="tonoPiel"  id="hiddenTonoPiel">
        <button type="submit" id="btnConfirmar">Confirmar y continuar</button>
    </form>
</div>

<script>
var SHAPES = [
    { id:"ovalada",     label:"Ovalada",    path:"M190,60 C255,60 305,140 305,253 C305,366 255,446 190,446 C125,446 75,366 75,253 C75,140 125,60 190,60 Z" },
    { id:"redonda",     label:"Redonda",    path:"M190,70 C268,70 320,130 320,253 C320,370 265,446 190,446 C115,446 60,370 60,253 C60,130 112,70 190,70 Z" },
    { id:"cuadrada",    label:"Cuadrada",   path:"M100,75 C135,65 245,65 280,75 C310,85 320,110 320,253 C320,396 310,421 280,431 C245,441 135,441 100,431 C70,421 60,396 60,253 C60,110 70,85 100,75 Z" },
    { id:"corazon",     label:"Corazon",    path:"M130,70 C155,62 225,62 250,70 C285,80 310,110 310,160 C310,240 260,340 190,446 C120,340 70,240 70,160 C70,110 95,80 130,70 Z" },
    { id:"diamante",    label:"Diamante",   path:"M190,65 C230,65 295,100 305,175 C315,240 270,360 190,446 C110,360 65,240 75,175 C85,100 150,65 190,65 Z" },
    { id:"rectangular", label:"Oblonga",    path:"M115,60 C148,52 232,52 265,60 C292,68 300,95 300,253 C300,411 292,438 265,446 C232,454 148,454 115,446 C88,438 80,411 80,253 C80,95 88,68 115,60 Z" },
    { id:"triangular",  label:"Triangular", path:"M75,160 C78,105 108,72 190,65 C272,72 302,105 305,160 C315,240 260,360 190,446 C120,360 65,240 75,160 Z" }
];

var ICONS = {
    ovalada:     "<ellipse cx=\"16\" cy=\"20\" rx=\"8\" ry=\"12\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    redonda:     "<circle cx=\"16\" cy=\"20\" r=\"11\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    cuadrada:    "<rect x=\"5\" y=\"8\" width=\"22\" height=\"24\" rx=\"3\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    corazon:     "<path d=\"M16,8 C16,8 6,5 6,13 C6,20 16,27 16,27 C16,27 26,20 26,13 C26,5 16,8 16,8Z\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    diamante:    "<polygon points=\"16,4 27,18 16,36 5,18\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    rectangular: "<rect x=\"8\" y=\"4\" width=\"16\" height=\"32\" rx=\"4\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>",
    triangular:  "<polygon points=\"16,4 28,36 4,36\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"/>"
};

var SKIN_TONES = [
    { id:"muy_claro",  label:"Muy claro",  color:"#FDDBB4", r:253, g:219, b:180 },
    { id:"claro",      label:"Claro",      color:"#F0C08A", r:240, g:192, b:138 },
    { id:"medio",      label:"Medio",      color:"#D4956A", r:212, g:149, b:106 },
    { id:"bronceado",  label:"Bronceado",  color:"#B97048", r:185, g:112, b:72  },
    { id:"oscuro",     label:"Oscuro",     color:"#7D4A2A", r:125, g:74,  b:42  },
    { id:"muy_oscuro", label:"Muy oscuro", color:"#3B1F0E", r:59,  g:31,  b:14  }
];

var selectedShapeId = null;
var selectedSkinId  = null;

var canvas = document.getElementById("overlayCanvas");
var ctx    = canvas.getContext("2d");
var VB_W   = 380;
var VB_H   = 506;

function resizeCanvas() {
    var stage = canvas.parentElement;
    canvas.width  = stage.clientWidth;
    canvas.height = stage.clientHeight;
    redraw();
}

function redraw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    if (!selectedShapeId) return;

    var shape  = null;
    for (var i = 0; i < SHAPES.length; i++) {
        if (SHAPES[i].id === selectedShapeId) { shape = SHAPES[i]; break; }
    }
    if (!shape) return;

    var scaleX = canvas.width  / VB_W;
    var scaleY = canvas.height / VB_H;

    ctx.save();
    ctx.scale(scaleX, scaleY);

    var p = new Path2D(shape.path);

    if (selectedSkinId) {
        var tone = null;
        for (var j = 0; j < SKIN_TONES.length; j++) {
            if (SKIN_TONES[j].id === selectedSkinId) { tone = SKIN_TONES[j]; break; }
        }
        if (tone) {
            ctx.fillStyle = "rgba(" + tone.r + "," + tone.g + "," + tone.b + ",0.40)";
            ctx.fill(p);
        }
    }

    ctx.strokeStyle = "rgba(255,255,255,0.92)";
    ctx.lineWidth   = 3.5;
    ctx.lineJoin    = "round";
    ctx.stroke(p);

    ctx.restore();
}

// Botones de forma
var shapesGrid = document.getElementById("shapesGrid");
for (var i = 0; i < SHAPES.length; i++) {
    (function(shape) {
        var btn = document.createElement("button");
        btn.type      = "button";
        btn.className = "shape-btn";
        btn.setAttribute("data-id", shape.id);
        btn.innerHTML = "<svg viewBox=\"0 0 32 40\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\">" + ICONS[shape.id] + "</svg><span>" + shape.label + "</span>";
        btn.onclick = function() { seleccionarForma(shape.id); };
        shapesGrid.appendChild(btn);
    })(SHAPES[i]);
}

// Botones de tono
var skinGrid = document.getElementById("skinGrid");
for (var k = 0; k < SKIN_TONES.length; k++) {
    (function(tone) {
        var btn = document.createElement("button");
        btn.type      = "button";
        btn.className = "skin-btn";
        btn.setAttribute("data-id", tone.id);
        btn.innerHTML = "<div class=\"skin-circle\" style=\"background:" + tone.color + ";\"></div><span>" + tone.label + "</span>";
        btn.onclick = function() { seleccionarTono(tone.id); };
        skinGrid.appendChild(btn);
    })(SKIN_TONES[k]);
}

function seleccionarForma(id) {
    selectedShapeId = id;
    var btns = document.querySelectorAll(".shape-btn");
    for (var i = 0; i < btns.length; i++) {
        if (btns[i].getAttribute("data-id") === id) btns[i].classList.add("active");
        else btns[i].classList.remove("active");
    }
    var lbl = document.getElementById("shapeLabel");
    for (var j = 0; j < SHAPES.length; j++) {
        if (SHAPES[j].id === id) { lbl.textContent = SHAPES[j].label; break; }
    }
    lbl.style.display = "block";
    document.getElementById("hiddenFormaCara").value = id;
    document.getElementById("btnConfirmar").classList.add("enabled");
    actualizarHint();
    redraw();
}

function seleccionarTono(id) {
    selectedSkinId = id;
    var btns = document.querySelectorAll(".skin-btn");
    for (var i = 0; i < btns.length; i++) {
        if (btns[i].getAttribute("data-id") === id) btns[i].classList.add("active");
        else btns[i].classList.remove("active");
    }
    document.getElementById("hiddenTonoPiel").value = id;
    actualizarHint();
    redraw();
}

function actualizarHint() {
    var hint = document.getElementById("hintText");
    if (selectedShapeId && selectedSkinId) {
        var sLabel = "", tLabel = "";
        for (var i = 0; i < SHAPES.length; i++) { if (SHAPES[i].id === selectedShapeId) { sLabel = SHAPES[i].label; break; } }
        for (var j = 0; j < SKIN_TONES.length; j++) { if (SKIN_TONES[j].id === selectedSkinId) { tLabel = SKIN_TONES[j].label; break; } }
        hint.textContent = "Forma: " + sLabel + " - Tono: " + tLabel;
    } else if (selectedShapeId) {
        for (var k = 0; k < SHAPES.length; k++) { if (SHAPES[k].id === selectedShapeId) { hint.textContent = "Forma: " + SHAPES[k].label; break; } }
    }
}

// Camara
(function() {
    var video    = document.getElementById("video");
    var noCamMsg = document.getElementById("noCamMsg");
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: { facingMode: { ideal: "user" }, width: { ideal: 640 }, height: { ideal: 853 } }, audio: false })
        .then(function(stream) {
            video.srcObject = stream;
            video.addEventListener("loadedmetadata", resizeCanvas);
            resizeCanvas();
        })
        .catch(function(err) {
            console.warn("Camara no disponible:", err);
            video.style.display = "none";
            noCamMsg.style.display = "flex";
            resizeCanvas();
        });
    } else {
        video.style.display = "none";
        noCamMsg.style.display = "flex";
        resizeCanvas();
    }
})();

window.addEventListener("resize", resizeCanvas);
</script>
</body>
</html>