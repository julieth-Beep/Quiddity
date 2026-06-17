<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Características - Quiddity</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=DM+Sans:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <style>
        /* ── Variables (igual que el dashboard) ── */
        :root {
            --bg: #F8F9FA;
            --bg-soft: #FFFFFF;
            --surface: #FFFFFF;
            --text-primary: #1a1a2e;
            --text-secondary: #6c757d;
            --text-tertiary: #adb5bd;
            --border: #e9ecef;
            --border-light: #f1f3f5;

            --pastel-sky: #e3f2fd;
            --pastel-mint: #e8f5e9;
            --pastel-lavender: #f3e5f5;
            --pastel-cream: #fff3e0;
            --pastel-coral: #fce4ec;
            --pastel-gold: #fff8e1;
            --pastel-gold-dark: #ffe082;

            --accent-gold: #C9A96E;
            --accent-coral: #c2185b;

            --radius-sm: 10px;
            --radius-md: 12px;
            --radius-lg: 14px;
            --radius-xl: 20px;
            --radius-full: 999px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
        }

        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            font-size: 12px;
            line-height: 1.4;
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .layout-with-sidebar {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .main-content {
            flex: 1;
            padding: 12px 20px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
        }

        .page {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        /* ── Welcome Section ── */
        .welcome-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 10px 16px;
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

        .welcome-title span { color: var(--accent-gold); }

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
            background: linear-gradient(135deg, var(--pastel-gold), var(--pastel-cream));
            border: 1px solid var(--pastel-gold-dark);
            border-radius: var(--radius-md);
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--accent-gold);
        }

        .step-badge .material-symbols-outlined {
            font-size: 14px;
            color: var(--accent-gold);
        }

        /* ── Progreso ── */
        .progress-wrapper {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 10px 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 16px;
            animation: fadeUp 0.4s ease 0.05s forwards;
            opacity: 0;
        }

        .progress-steps {
            display: flex;
            gap: 6px;
            flex: 1;
        }

        .progress-dot {
            width: 100%;
            height: 4px;
            border-radius: 2px;
            background: var(--border);
            transition: background 0.4s ease;
        }

        .progress-dot.filled {
            background: var(--accent-gold);
        }

        .progress-label {
            font-size: 11px;
            font-weight: 600;
            color: var(--text-secondary);
            white-space: nowrap;
        }

        .progress-label strong {
            color: var(--text-primary);
        }

        /* ── Secciones ── */
        .section-title {
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title .material-symbols-outlined {
            font-size: 18px;
            color: var(--accent-gold);
        }

        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border-light);
        }

        /* Grid de opciones: ocupa todo el ancho */
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 12px;
            margin-bottom: 4px;
        }

        .option-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            padding: 14px 10px;
            cursor: pointer;
            transition: all 0.25s ease;
            color: var(--text-secondary);
            box-shadow: var(--shadow-sm);
        }

        .option-btn:hover {
            border-color: var(--accent-gold);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .option-btn.active {
            border-color: var(--accent-gold);
            background: var(--pastel-gold);
            color: var(--accent-gold);
            box-shadow: 0 4px 12px rgba(201,169,110,0.15);
        }

        .option-btn svg {
            width: 32px;
            height: 40px;
            color: currentColor;
        }

        .option-btn span {
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            text-align: center;
        }

        /* ── Resumen ── */
        .summary-panel {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px 24px;
            animation: fadeUp 0.4s ease 0.15s forwards;
            opacity: 0;
        }

        .summary-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .summary-item .label {
            color: var(--text-tertiary);
        }

        .summary-item .value {
            font-weight: 700;
            color: var(--text-primary);
        }

        .summary-item .value.placeholder {
            color: var(--text-tertiary);
            font-weight: 400;
        }

        .summary-item .check-icon {
            color: var(--accent-gold);
            font-size: 16px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .summary-item .check-icon.visible {
            opacity: 1;
        }

        /* ── Área de confirmación ── */
        .confirm-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            padding: 8px 0 16px;
        }

        .hint {
            font-size: 12px;
            color: var(--text-tertiary);
            font-weight: 500;
            min-height: 1.2em;
            transition: color 0.3s ease;
        }

        .hint.ready {
            color: var(--accent-gold);
            font-weight: 600;
        }

        #btnConfirmar {
            background: linear-gradient(135deg, var(--accent-gold), #b8953a);
            color: white;
            border: none;
            border-radius: var(--radius-full);
            padding: 14px 52px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0.4;
            pointer-events: none;
            box-shadow: var(--shadow-sm);
        }

        #btnConfirmar.enabled {
            opacity: 1;
            pointer-events: auto;
        }

        #btnConfirmar.enabled:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 24px rgba(201,169,110,0.35);
        }

        .alert-error {
            background: var(--pastel-coral);
            border: 1px solid #f8bbd0;
            border-radius: var(--radius-sm);
            padding: 10px 16px;
            font-size: 12px;
            font-weight: 600;
            color: var(--accent-coral);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ── Animaciones ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .anim-fade-up {
            animation: fadeUp 0.4s ease forwards;
            opacity: 0;
        }

        .delay-1 { animation-delay: 0.06s; }
        .delay-2 { animation-delay: 0.12s; }
        .delay-3 { animation-delay: 0.18s; }

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

        @media (max-width: 600px) {
            .main-content { padding: 8px 12px; }
            .welcome-section { flex-direction: column; gap: 8px; text-align: center; }
            .options-grid { grid-template-columns: repeat(3, 1fr); gap: 8px; }
            .progress-wrapper { flex-wrap: wrap; justify-content: center; }
            .summary-panel { flex-direction: column; align-items: stretch; text-align: center; gap: 6px; }
        }
    </style>
</head>
<body>
<div class="layout-with-sidebar">
    <%@ include file="/includes/sidebar.jsp" %>
    <div class="main-content">
        <div class="page">

            <!-- ── Welcome Section ── -->
            <div class="welcome-section anim-fade-up">
                <div class="welcome-content">
                    <h1 class="welcome-title">Tus <span>Características</span></h1>
                    <p class="welcome-subtitle">Selecciona las opciones que mejor te describan para una experiencia personalizada</p>
                </div>
                <div class="welcome-actions">
                    <div class="step-badge">
                        <span class="material-symbols-outlined">auto_awesome</span>
                        Paso 5 de 5
                    </div>
                </div>
            </div>

            <!-- ── Progreso ── -->
            <div class="progress-wrapper anim-fade-up delay-1">
                <div class="progress-steps" id="progressSteps">
                    <div class="progress-dot filled"></div>
                    <div class="progress-dot filled"></div>
                    <div class="progress-dot" id="progressDot3"></div>
                </div>
                <div class="progress-label">
                    <strong id="progressCount">0</strong> de 3 seleccionados
                </div>
            </div>

            <!-- ── Cuerpo ── -->
            <div class="anim-fade-up delay-2">
                <div class="section-title">
                    <span class="material-symbols-outlined">accessibility</span> Tipo de cuerpo
                </div>
                <div class="options-grid" id="gridCuerpo"></div>
            </div>

            <!-- ── Cabello ── -->
            <div class="anim-fade-up delay-2">
                <div class="section-title">
                    <span class="material-symbols-outlined">face</span> Tipo de cabello
                </div>
                <div class="options-grid" id="gridCabello"></div>
            </div>

            <!-- ── Piel ── -->
            <div class="anim-fade-up delay-3">
                <div class="section-title">
                    <span class="material-symbols-outlined">spa</span> Tipo de piel
                </div>
                <div class="options-grid" id="gridPiel"></div>
            </div>

            <!-- ── Resumen ── -->
            <div class="summary-panel anim-fade-up delay-3" id="summaryPanel">
                <div class="summary-item">
                    <span class="label">Cuerpo:</span>
                    <span class="value placeholder" id="summaryCuerpo">—</span>
                    <span class="material-symbols-outlined check-icon" id="checkCuerpo">check_circle</span>
                </div>
                <div class="summary-item">
                    <span class="label">Cabello:</span>
                    <span class="value placeholder" id="summaryCabello">—</span>
                    <span class="material-symbols-outlined check-icon" id="checkCabello">check_circle</span>
                </div>
                <div class="summary-item">
                    <span class="label">Piel:</span>
                    <span class="value placeholder" id="summaryPiel">—</span>
                    <span class="material-symbols-outlined check-icon" id="checkPiel">check_circle</span>
                </div>
            </div>

            <!-- ── Confirmar ── -->
            <div class="confirm-area anim-fade-up delay-3">
                <c:if test="${not empty error}">
                    <div class="alert-error">
                        <span class="material-symbols-outlined" style="font-size:16px;">error</span>
                        ${error}
                    </div>
                </c:if>
                <p class="hint" id="hintText">Selecciona las 3 opciones para continuar</p>
                <form id="caractForm" action="${pageContext.request.contextPath}/caracteristicas" method="post">
                    <input type="hidden" name="tipoCuerpo"  id="hiddenCuerpo">
                    <input type="hidden" name="tipoCabello" id="hiddenCabello">
                    <input type="hidden" name="tipoPiel"    id="hiddenPiel">
                    <button type="submit" id="btnConfirmar">Finalizar perfil</button>
                </form>
            </div>

        </div>
    </div>
</div>

<script>
    // ── Datos (exactamente igual que antes) ──
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

    // ── Estado ──
    var selCuerpo  = null;
    var selCabello = null;
    var selPiel    = null;

    // ── Render ──
    function renderGrupo(datos, gridId, campoHidden, setVal, labelSummaryId, checkId) {
        var grid = document.getElementById(gridId);
        datos.forEach(function(item) {
            var btn = document.createElement("button");
            btn.type = "button";
            btn.className = "option-btn";
            btn.setAttribute("data-id", item.id);
            btn.innerHTML = "<svg viewBox='0 0 32 40' xmlns='http://www.w3.org/2000/svg' fill='none' stroke='currentColor' stroke-width='1.5'>" + item.svg + "</svg><span>" + item.label + "</span>";
            btn.onclick = function() {
                setVal(item.id);
                document.getElementById(campoHidden).value = item.id;
                var btns = grid.querySelectorAll(".option-btn");
                btns.forEach(function(b) {
                    b.classList.toggle("active", b.getAttribute("data-id") === item.id);
                });
                // Actualizar resumen
                var labelEl = document.getElementById(labelSummaryId);
                labelEl.textContent = item.label;
                labelEl.classList.remove("placeholder");
                var checkEl = document.getElementById(checkId);
                checkEl.classList.add("visible");
                actualizarEstado();
            };
            grid.appendChild(btn);
        });
    }

    renderGrupo(CUERPO,  "gridCuerpo",  "hiddenCuerpo",  function(v){ selCuerpo = v; },  "summaryCuerpo", "checkCuerpo");
    renderGrupo(CABELLO, "gridCabello", "hiddenCabello", function(v){ selCabello = v; }, "summaryCabello", "checkCabello");
    renderGrupo(PIEL,    "gridPiel",    "hiddenPiel",    function(v){ selPiel = v; },    "summaryPiel", "checkPiel");

    // ── Actualizar estado ──
    function actualizarEstado() {
        var btn  = document.getElementById("btnConfirmar");
        var hint = document.getElementById("hintText");
        var count = 0;
        if (selCuerpo)  count++;
        if (selCabello) count++;
        if (selPiel)    count++;

        document.getElementById("progressCount").textContent = count;
        var dot3 = document.getElementById("progressDot3");
        if (count === 3) {
            dot3.classList.add("filled");
        } else {
            dot3.classList.remove("filled");
        }

        if (count === 3) {
            btn.classList.add("enabled");
            hint.textContent = "¡Listo! Puedes continuar.";
            hint.classList.add("ready");
        } else {
            btn.classList.remove("enabled");
            hint.textContent = "Selecciona las 3 opciones para continuar";
            hint.classList.remove("ready");
        }
    }

    // Inicializar resumen con placeholders
    document.querySelectorAll(".summary-item .value").forEach(function(el) {
        if (el.textContent.trim() === "") {
            el.textContent = "—";
            el.classList.add("placeholder");
        }
    });
</script>
</body>
</html>