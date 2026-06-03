<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar contraseña | Quiddity</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;1,400&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@300,0&display=swap" rel="stylesheet">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --p:   #9a3a5a;
            --p2:  #88495a;
            --sec: #516617;
            --ink: #1c1b1d;
            --sub: #544246;
            --out: #877276;
            --sf:  #f1ecef;
            --w:   #ffffff;
        }

        html, body {
            height: 100%;
            font-family: 'Manrope', sans-serif;
            background: var(--sf);
            color: var(--ink);
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        .page {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 100vh;
        }

        /* ── Panel izquierdo (igual que login) ── */
        .left-panel {
            position: relative;
            overflow: hidden;
            background: #160d11;
        }
        .left-panel .bg-img {
            position: absolute;
            inset: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            opacity: 0.55;
        }
        .left-panel::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                linear-gradient(to top, rgba(18,10,14,.92) 0%, rgba(18,10,14,.3) 55%, rgba(18,10,14,.08) 100%),
                linear-gradient(to right, rgba(18,10,14,.5) 0%, rgba(18,10,14,0) 60%);
        }
        .left-content {
            position: relative;
            z-index: 2;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 48px 52px;
        }
        .left-logo {
            font-family: 'EB Garamond', serif;
            font-size: 20px;
            letter-spacing: .24em;
            color: var(--w);
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        .logo-dot {
            width: 7px; height: 7px;
            border-radius: 50%;
            background: var(--p);
            animation: pulse 2.6s ease-in-out infinite;
        }
        @keyframes pulse { 0%,100%{transform:scale(1);opacity:1} 50%{transform:scale(1.7);opacity:.5} }
        .left-tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            align-self: flex-start;
            font-size: 9px;
            font-weight: 700;
            letter-spacing: .32em;
            text-transform: uppercase;
            color: rgba(255,255,255,.45);
            border: 1px solid rgba(255,255,255,.12);
            padding: 7px 16px;
            backdrop-filter: blur(6px);
            background: rgba(255,255,255,.04);
        }
        .left-footer-text {
            font-size: 9px;
            letter-spacing: .22em;
            text-transform: uppercase;
            color: rgba(255,255,255,.16);
        }

        /* ── Panel derecho ── */
        .right-panel {
            background: var(--w);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 48px;
            position: relative;
            overflow: hidden;
        }
        .right-panel::before {
            content: '';
            position: absolute;
            width: 340px; height: 340px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(154,58,90,.07) 0%, transparent 70%);
            top: -110px; right: -110px;
            pointer-events: none;
        }

        .form-wrapper {
            width: 100%;
            max-width: 400px;
            position: relative;
            z-index: 1;
            animation: fadeUp .65s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes fadeUp { from{opacity:0;transform:translateY(22px)} to{opacity:1;transform:translateY(0)} }

        /* Indicador de paso */
        .step-bar {
            display: flex;
            gap: 6px;
            margin-bottom: 36px;
        }
        .step-seg {
            height: 3px;
            flex: 1;
            background: rgba(135,114,118,.15);
            border-radius: 2px;
            overflow: hidden;
        }
        .step-seg .fill {
            height: 100%;
            width: 0;
            background: linear-gradient(90deg, var(--p), #d4899e);
            border-radius: 2px;
            transition: width .5s cubic-bezier(.22,1,.36,1);
        }
        .step-seg.done .fill   { width: 100%; }
        .step-seg.active .fill { width: 60%; animation: pulse2 1.8s ease-in-out infinite alternate; }
        @keyframes pulse2 { to { width: 85%; } }

        .fw-eye   { font-size: 9px; font-weight: 700; letter-spacing: .32em; text-transform: uppercase; color: var(--p); margin-bottom: 10px; }
        .fw-title { font-family: 'EB Garamond', serif; font-size: 36px; font-style: italic; font-weight: 400; color: var(--ink); line-height: 1.1; margin-bottom: 6px; }
        .fw-sub   { font-size: 12px; color: var(--sub); line-height: 1.65; margin-bottom: 32px; }

        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 13px 16px; margin-bottom: 20px;
            font-size: 12px; line-height: 1.5;
        }
        .alert-error   { background: #fdf2f5; border-left: 3px solid var(--p); color: #7a2040; }
        .alert-success { background: #f4f7ed; border-left: 3px solid var(--sec); color: #3a4a10; }

        /* Campos */
        .field { margin-bottom: 20px; position: relative; }
        .field label {
            display: block;
            font-size: 9px; font-weight: 700;
            letter-spacing: .26em; text-transform: uppercase;
            color: var(--out); margin-bottom: 8px;
        }
        .field.focused label { color: var(--p); }
        .field.filled  label { color: var(--p2); }

        .glass-wrap {
            position: relative;
            background: rgba(241,236,239,.55);
            backdrop-filter: blur(14px) saturate(160%);
            border: 1.5px solid rgba(154,58,90,.12);
            transition: border-color .25s, background .25s, box-shadow .35s;
            overflow: hidden;
        }
        .field.focused .glass-wrap {
            border-color: rgba(154,58,90,.45);
            background: rgba(255,255,255,.82);
            box-shadow: 0 0 0 3px rgba(154,58,90,.08), 0 4px 20px rgba(154,58,90,.1);
        }
        .field.filled .glass-wrap { border-color: rgba(136,73,90,.25); background: rgba(241,236,239,.72); }

        .glass-wrap .gi {
            position: absolute;
            left: 16px; top: 50%;
            transform: translateY(-50%);
            color: var(--out);
            font-size: 18px;
            pointer-events: none;
            transition: color .25s;
            z-index: 2;
        }
        .field.focused .glass-wrap .gi { color: var(--p); }
        .field.filled  .glass-wrap .gi { color: var(--p2); }

        .glass-wrap input {
            width: 100%;
            padding: 14px 44px 14px 46px;
            border: none;
            background: transparent;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
            color: var(--ink);
            outline: none;
            position: relative;
            z-index: 2;
        }
        .glass-wrap input::placeholder { color: rgba(135,114,118,.38); font-size: 13px; }

        .glass-wrap .gline {
            position: absolute;
            bottom: 0; left: 0;
            height: 2px; width: 0;
            background: linear-gradient(90deg, var(--p), #d4899e);
            transition: width .4s cubic-bezier(.22,1,.36,1);
            z-index: 3;
        }
        .field.focused .glass-wrap .gline { width: 100%; }
        .field.filled  .glass-wrap .gline { width: 100%; background: linear-gradient(90deg,var(--p2),#b07080); }

        .tgl-pw {
            position: absolute; right: 14px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            cursor: pointer; color: var(--out);
            padding: 4px;
            display: flex; align-items: center;
            transition: color .2s; z-index: 3;
        }
        .tgl-pw:hover { color: var(--p); }

        /* Tarjeta de email confirmado */
        .email-badge {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            background: rgba(154,58,90,.06);
            border: 1px solid rgba(154,58,90,.18);
            margin-bottom: 24px;
            font-size: 13px;
        }
        .email-badge .material-symbols-outlined { color: var(--p); font-size: 20px; flex-shrink: 0; }
        .email-badge strong { font-weight: 700; color: var(--ink); display: block; }
        .email-badge span   { color: var(--sub); font-size: 11px; }

        /* Botón */
        .btn-go {
            width: 100%; padding: 16px 24px;
            background: var(--ink); color: var(--w);
            border: none; cursor: pointer;
            font-family: 'Manrope', sans-serif;
            font-size: 10px; font-weight: 700;
            letter-spacing: .24em; text-transform: uppercase;
            display: flex; align-items: center;
            justify-content: center; gap: 10px;
            position: relative; overflow: hidden;
            margin-bottom: 24px;
            margin-top: 8px;
        }
        .btn-go::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, var(--p), #c4748e);
            transform: scaleX(0); transform-origin: left;
            transition: transform .44s cubic-bezier(.22,1,.36,1);
        }
        .btn-go:hover::before { transform: scaleX(1); }
        .btn-go span, .btn-go .ia { position: relative; z-index: 1; }
        .ia { transition: transform .3s; font-size: 15px; }
        .btn-go:hover .ia { transform: translateX(5px); }

        .fw-foot { text-align: center; font-size: 12px; color: var(--sub); }
        .fw-foot a { color: var(--p); font-weight: 700; text-decoration: none; }
        .fw-foot a:hover { text-decoration: underline; }
        .bk {
            display: inline-flex; align-items: center; gap: 6px;
            margin-top: 16px; font-size: 9px; font-weight: 600;
            letter-spacing: .2em; text-transform: uppercase;
            color: rgba(135,114,118,.38); text-decoration: none;
            transition: color .2s;
        }
        .bk:hover { color: var(--ink); }

        @media(max-width:860px){
            .page { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 48px 24px; background: var(--sf); }
            .form-wrapper { background: var(--w); padding: 44px 32px; max-width: 100%; }
        }
        @media(max-width:480px){
            .form-wrapper { padding: 36px 20px; }
            .fw-title { font-size: 30px; }
        }
    </style>
</head>
<body>
<div class="page">

    <!-- Panel izquierdo -->
    <div class="left-panel">
        <img class="bg-img" src="<%= ctx %>/uploads/catalogo/heroSection/filosofia1.jpg" alt="Quiddity">
        <div class="left-content">
            <a href="<%= ctx %>/index.jsp" class="left-logo">
                <span class="logo-dot"></span>
                Quiddity
            </a>
            <div></div>
            <div>
                <span class="left-tag">
                    <span class="material-symbols-outlined" style="font-size:18px">lock_reset</span>
                    Recupera tu acceso
                </span>
                <p class="left-footer-text" style="margin-top:16px">© 2026 Quiddity Skincare</p>
            </div>
        </div>
    </div>

    <!-- Panel derecho -->
    <div class="right-panel">
        <div class="form-wrapper">

            <%
                String paso        = (String)  request.getAttribute("paso");
                String emailVerif  = (String)  request.getAttribute("emailVerificado");
                String nombreU     = (String)  request.getAttribute("nombreUsuario");
                String emailPrev   = (String)  request.getAttribute("emailPrevio");
                String errorMsg    = (String)  request.getAttribute("error");
                if (paso == null) paso = "1";
            %>

            <!-- Barra de pasos -->
            <div class="step-bar">
                <div class="step-seg <%= paso.equals("1") ? "active" : "done" %>"><div class="fill"></div></div>
                <div class="step-seg <%= paso.equals("2") ? "active" : (paso.equals("3") ? "done" : "") %>"><div class="fill"></div></div>
            </div>

            <% if (errorMsg != null) { %>
            <div class="alert alert-error">
                <span class="material-symbols-outlined" style="font-size:15px;flex-shrink:0">error</span>
                <%= errorMsg %>
            </div>
            <% } %>

            <!-- ═══ PASO 1: ingresar email ═══ -->
            <% if ("1".equals(paso)) { %>
                <p class="fw-eye">Paso 1 de 2</p>
                <h1 class="fw-title">Recuperar contraseña</h1>
                <p class="fw-sub">Ingresa el correo con el que te registraste y te mostraremos el formulario para crear una nueva contraseña.</p>

                <form action="<%= ctx %>/recuperar" method="POST" autocomplete="off">
                    <input type="hidden" name="paso" value="1">

                    <div class="field" id="fld-email">
                        <label for="email">Correo electrónico</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">mail</span>
                            <input type="email" id="email" name="email"
                                   placeholder="tu@email.com" required
                                   value="<%= emailPrev != null ? emailPrev : "" %>">
                            <div class="gline"></div>
                        </div>
                    </div>

                    <button type="submit" class="btn-go">
                        <span>Verificar cuenta</span>
                        <span class="material-symbols-outlined ia">arrow_forward</span>
                    </button>
                </form>

            <!-- ═══ PASO 2: nueva contraseña ═══ -->
            <% } else if ("2".equals(paso)) { %>
                <p class="fw-eye">Paso 2 de 2</p>
                <h1 class="fw-title">Nueva contraseña</h1>
                <p class="fw-sub">Hola <strong><%= nombreU != null ? nombreU : "" %></strong>, elige una contraseña segura para tu cuenta.</p>

                <div class="email-badge">
                    <span class="material-symbols-outlined">verified_user</span>
                    <div>
                        <strong><%= emailVerif %></strong>
                        <span>Cuenta verificada</span>
                    </div>
                </div>

                <form action="<%= ctx %>/recuperar" method="POST" autocomplete="off">
                    <input type="hidden" name="paso" value="2">

                    <div class="field" id="fld-nueva">
                        <label for="nuevaContrasena">Nueva contraseña</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">lock_open</span>
                            <input type="password" id="nuevaContrasena" name="nuevaContrasena"
                                   placeholder="Mínimo 8 caracteres" minlength="8" required>
                            <button type="button" class="tgl-pw" onclick="togglePw('nuevaContrasena','ic1')" aria-label="Mostrar">
                                <span class="material-symbols-outlined" id="ic1" style="font-size:17px">visibility_off</span>
                            </button>
                            <div class="gline"></div>
                        </div>
                    </div>

                    <div class="field" id="fld-confirmar">
                        <label for="confirmarContrasena">Confirmar contraseña</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">lock</span>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena"
                                   placeholder="Repite la contraseña" minlength="8" required>
                            <button type="button" class="tgl-pw" onclick="togglePw('confirmarContrasena','ic2')" aria-label="Mostrar">
                                <span class="material-symbols-outlined" id="ic2" style="font-size:17px">visibility_off</span>
                            </button>
                            <div class="gline"></div>
                        </div>
                    </div>

                    <button type="submit" class="btn-go">
                        <span>Guardar contraseña</span>
                        <span class="material-symbols-outlined ia">check</span>
                    </button>
                </form>
            <% } %>

            <div class="fw-foot">
                <a href="<%= ctx %>/login" class="bk">
                    <span class="material-symbols-outlined" style="font-size:12px">arrow_back</span>
                    Volver al inicio de sesión
                </a>
            </div>

        </div>
    </div>
</div>

<script>
function togglePw(inputId, iconId) {
    var inp = document.getElementById(inputId);
    var ic  = document.getElementById(iconId);
    inp.type = inp.type === 'password' ? 'text' : 'password';
    ic.textContent = inp.type === 'password' ? 'visibility_off' : 'visibility';
}

document.querySelectorAll('.field').forEach(function(fld) {
    var inp = fld.querySelector('input');
    if (!inp) return;
    inp.addEventListener('focus', function()  { fld.classList.add('focused'); });
    inp.addEventListener('blur',  function()  {
        fld.classList.remove('focused');
        fld.classList.toggle('filled', inp.value.trim().length > 0);
    });
    if (inp.value.trim().length > 0) fld.classList.add('filled');
});
</script>
</body>
</html>