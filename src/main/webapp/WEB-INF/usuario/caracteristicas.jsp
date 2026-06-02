<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Caracteristicas - Quiddity</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --cream: #F5F0EA;
            --blush: #E8C4B8;
            --rose:  #C4796A;
            --plum:  #3D2B35;
            --gold:  #C9A96E;
            --glass: rgba(255,255,255,0.10);
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
            padding-bottom: 3rem;
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
            padding: 2rem 1rem 0.5rem;
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
            max-width: 380px;
            margin: 0 auto;
            line-height: 1.6;
        }
        .section-title {
            font-size: 0.7rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.4);
            text-align: center;
            margin-top: 2rem;
            margin-bottom: 1rem;
        }
        .options-grid {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: center;
            padding: 0 1rem;
            max-width: 500px;
            margin: 0 auto;
        }
        .option-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            background: var(--glass);
            border: 1.5px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 14px 18px;
            cursor: pointer;
            transition: all 0.22s ease;
            min-width: 90px;
            backdrop-filter: blur(6px);
            color: var(--cream);
        }
        .option-btn:hover {
            border-color: rgba(201,169,110,0.45);
            background: rgba(201,169,110,0.08);
            transform: translateY(-2px);
        }
        .option-btn.active {
            border-color: var(--gold);
            background: rgba(201,169,110,0.18);
            box-shadow: 0 0 18px rgba(201,169,110,0.2);
        }
        .option-btn svg {
            width: 36px;
            height: 44px;
        }
        .option-btn span {
            font-size: 0.7rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: rgba(245,240,234,0.65);
            transition: color 0.2s;
            text-align: center;
        }
        .option-btn.active span { color: var(--gold); }

        .divider {
            width: min(440px, 90vw);
            height: 1px;
            background: rgba(255,255,255,0.07);
            margin: 2rem auto 0;
        }

        .confirm-area {
            margin: 2rem auto 0;
            text-align: center;
            padding: 0 1rem;
        }
        .hint {
            font-size: 0.78rem;
            color: rgba(245,240,234,0.35);
            margin-bottom: 1rem;
            min-height: 1.2em;
        }
        #btnConfirmar {
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose) 100%);
            color: var(--plum);
            border: none;
            border-radius: 50px;
            padding: 14px 52px;
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
            max-width: 400px;
            text-align: center;
        }
    </style>
</head>
<body>

<header>
    <div class="logo">Quiddity</div>
    <div class="step-indicator">Paso 2 de 2 - Caracteristicas</div>
</header>

<div class="intro">
    <h1>Cuéntanos más</h1>
    <p>Selecciona las opciones que mejor te describen para personalizar tu experiencia.</p>
</div>

<!-- TIPO DE CUERPO -->
<p class="section-title">Tipo de cuerpo</p>
<div class="options-grid" id="gridCuerpo"></div>

<div class="divider"></div>

<!-- TIPO DE CABELLO -->
<p class="section-title">Tipo de cabello</p>
<div class="options-grid" id="gridCabello"></div>

<div class="divider"></div>

<!-- TIPO DE PIEL -->
<p class="section-title">Tipo de piel</p>
<div class="options-grid" id="gridPiel"></div>

<!-- CONFIRMAR -->
<div class="confirm-area">
    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>
    <p class="hint" id="hintText">Selecciona las 3 opciones para continuar</p>
    <form id="caractForm" action="${pageContext.request.contextPath}/caracteristicas" method="post">
        <input type="hidden" name="tipoCuerpo"  id="hiddenCuerpo">
        <input type="hidden" name="tipoCabello" id="hiddenCabello">
        <input type="hidden" name="tipoPiel"    id="hiddenPiel">
        <button type="submit" id="btnConfirmar">Finalizar perfil</button>
    </form>
</div>

<script>
var CUERPO = [
    { id:"rectangulo",   label:"Rectangulo",   svg:"<rect x='10' y='4' width='12' height='32' rx='3' fill='none' stroke='currentColor' stroke-width='1.5'/>" },
    { id:"pera",         label:"Pera",          svg:"<path d='M16,4 C16,4 10,4 10,12 C10,20 6,28 6,34 L26,34 C26,28 22,20 22,12 C22,4 16,4 16,4Z' fill='none' stroke='currentColor' stroke-width='1.5'/>" },
    { id:"manzana",      label:"Manzana",       svg:"<path d='M16,4 C9,4 6,10 6,16 C6,24 10,32 16,36 C22,32 26,24 26,16 C26,10 23,4 16,4Z' fill='none' stroke='currentColor' stroke-width='1.5'/>" },
    { id:"reloj_arena",  label:"Reloj de arena", svg:"<path d='M8,4 L24,4 L18,20 L24,36 L8,36 L14,20 Z' fill='none' stroke='currentColor' stroke-width='1.5'/>" },
    { id:"invertido",    label:"Invertido",     svg:"<path d='M6,4 L26,4 L20,20 C20,28 22,34 16,36 C10,34 12,28 12,20 Z' fill='none' stroke='currentColor' stroke-width='1.5'/>" }
];

var CABELLO = [
    { id:"liso",       label:"Liso",        svg:"<path d='M10,6 C10,6 10,30 10,34 M16,4 C16,4 16,30 16,34 M22,6 C22,6 22,30 22,34' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" },
    { id:"ondulado",   label:"Ondulado",    svg:"<path d='M8,8 C10,6 12,10 14,8 C16,6 18,10 20,8 C22,6 24,10 26,8 M8,16 C10,14 12,18 14,16 C16,14 18,18 20,16 C22,14 24,18 26,16 M8,24 C10,22 12,26 14,24 C16,22 18,26 20,24 C22,22 24,26 26,24' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" },
    { id:"rizado",     label:"Rizado",      svg:"<path d='M12,8 C9,8 8,12 11,13 C8,13 7,17 10,18 C7,18 6,22 9,23 C6,24 7,30 12,30 M20,8 C23,8 24,12 21,13 C24,13 25,17 22,18 C25,18 26,22 23,23 C26,24 25,30 20,30' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" },
    { id:"muy_rizado", label:"Muy rizado",  svg:"<path d='M11,6 C8,6 7,9 9,10 C7,10 6,13 8,14 C6,14 5,17 7,18 C5,19 6,24 10,24 M16,4 C14,4 13,7 15,8 C13,8 12,11 14,12 C12,12 11,15 13,16 C11,17 12,22 16,22 M21,6 C24,6 25,9 23,10 C25,10 26,13 24,14 C26,14 27,17 25,18 C27,19 26,24 22,24' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" },
    { id:"corto",      label:"Corto",       svg:"<path d='M10,16 C10,10 13,6 16,6 C19,6 22,10 22,16 C22,22 19,26 16,26 C13,26 10,22 10,16Z M10,16 L8,18 M22,16 L24,18' fill='none' stroke='currentColor' stroke-width='1.5'/>" }
];

var PIEL = [
    { id:"normal",    label:"Normal",    svg:"<circle cx='16' cy='20' r='12' fill='none' stroke='currentColor' stroke-width='1.5'/><path d='M12,16 C12,14 20,14 20,16' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" },
    { id:"seca",      label:"Seca",      svg:"<circle cx='16' cy='20' r='12' fill='none' stroke='currentColor' stroke-width='1.5' stroke-dasharray='3,2'/>" },
    { id:"grasa",     label:"Grasa",     svg:"<circle cx='16' cy='20' r='12' fill='none' stroke='currentColor' stroke-width='1.5'/><circle cx='13' cy='17' r='1.5' fill='currentColor'/><circle cx='19' cy='17' r='1.5' fill='currentColor'/><circle cx='16' cy='23' r='1.5' fill='currentColor'/>" },
    { id:"mixta",     label:"Mixta",     svg:"<circle cx='16' cy='20' r='12' fill='none' stroke='currentColor' stroke-width='1.5'/><path d='M16,8 L16,32' fill='none' stroke='currentColor' stroke-width='1' stroke-dasharray='2,2'/>" },
    { id:"sensible",  label:"Sensible",  svg:"<circle cx='16' cy='20' r='12' fill='none' stroke='currentColor' stroke-width='1.5'/><path d='M12,22 C13,20 19,20 20,22' fill='none' stroke='currentColor' stroke-width='1.5' stroke-linecap='round'/>" }
];

var selCuerpo  = null;
var selCabello = null;
var selPiel    = null;

function renderGrupo(datos, gridId, campoHidden, getVal, setVal, prefijo) {
    var grid = document.getElementById(gridId);
    for (var i = 0; i < datos.length; i++) {
        (function(item) {
            var btn = document.createElement("button");
            btn.type = "button";
            btn.className = "option-btn";
            btn.setAttribute("data-id", item.id);
            btn.innerHTML = "<svg viewBox='0 0 32 40' xmlns='http://www.w3.org/2000/svg' fill='none' stroke='currentColor' stroke-width='1.5'>" + item.svg + "</svg><span>" + item.label + "</span>";
            btn.onclick = function() {
                setVal(item.id);
                document.getElementById(campoHidden).value = item.id;
                var btns = grid.querySelectorAll(".option-btn");
                for (var j = 0; j < btns.length; j++) {
                    btns[j].classList.toggle("active", btns[j].getAttribute("data-id") === item.id);
                }
                actualizarBoton();
            };
            grid.appendChild(btn);
        })(datos[i]);
    }
}

renderGrupo(CUERPO,  "gridCuerpo",  "hiddenCuerpo",  function(){ return selCuerpo; },  function(v){ selCuerpo = v; },  "c");
renderGrupo(CABELLO, "gridCabello", "hiddenCabello", function(){ return selCabello; }, function(v){ selCabello = v; }, "cb");
renderGrupo(PIEL,    "gridPiel",    "hiddenPiel",    function(){ return selPiel; },    function(v){ selPiel = v; },    "p");

function actualizarBoton() {
    var btn  = document.getElementById("btnConfirmar");
    var hint = document.getElementById("hintText");
    var falta = [];
    if (!selCuerpo)  falta.push("cuerpo");
    if (!selCabello) falta.push("cabello");
    if (!selPiel)    falta.push("piel");

    if (falta.length === 0) {
        btn.classList.add("enabled");
        hint.textContent = "Listo, puedes continuar";
    } else {
        btn.classList.remove("enabled");
        hint.textContent = "Falta seleccionar: " + falta.join(", ");
    }
}
</script>
</body>
</html>