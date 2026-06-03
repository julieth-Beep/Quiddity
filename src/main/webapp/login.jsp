<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login | Quiddity</title>
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect" />
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..700;1,400..700&family=Manrope:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

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

        /* ════════════════ LAYOUT ════════════════ */
        .page {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 100vh;
        }

        /* ════════════════ LEFT PANEL ════════════════ */
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
            object-position: center;
            opacity: 0.65;
            transform: scale(1.04);
            transition: transform 9s ease;
        }
        .left-panel:hover .bg-img { transform: scale(1); }

        .left-panel::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                linear-gradient(to top,  rgba(18,10,14,.92) 0%, rgba(18,10,14,.35) 48%, rgba(18,10,14,.08) 100%),
                linear-gradient(to right, rgba(18,10,14,.55) 0%, rgba(18,10,14,.0) 60%);
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
            animation: logoPulse 2.6s ease-in-out infinite;
        }
        @keyframes logoPulse {
            0%,100%{ transform:scale(1);opacity:1; }
            50%{ transform:scale(1.7);opacity:.5; }
        }

        .left-bottom {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

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

        /* ════════════════ RIGHT PANEL ════════════════ */
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
        .right-panel::after {
            content: '';
            position: absolute;
            width: 240px; height: 240px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(81,102,23,.06) 0%, transparent 70%);
            bottom: -80px; left: -80px;
            pointer-events: none;
        }

        .form-wrapper {
            width: 100%;
            max-width: 400px;
            position: relative;
            z-index: 1;
            animation: wrapIn .65s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes wrapIn {
            from { opacity:0; transform:translateY(22px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .prog {
            height: 2px;
            background: rgba(135,114,118,.1);
            margin-bottom: 40px;
            overflow: hidden;
        }
        .prog-fill {
            height: 100%;
            width: 0;
            background: linear-gradient(90deg, var(--p), #d4899e);
            animation: progGrow 1.1s .5s cubic-bezier(.22,1,.36,1) forwards;
        }
        @keyframes progGrow { to { width: 33%; } }

        .fw-eye {
            font-size: 9px; font-weight: 700;
            letter-spacing: .32em; text-transform: uppercase;
            color: var(--p); margin-bottom: 12px;
        }
        .fw-title {
            font-family: 'EB Garamond', serif;
            font-size: 38px; font-style: italic; font-weight: 400;
            color: var(--ink); line-height: 1.1; margin-bottom: 6px;
        }
        .fw-sub {
            font-size: 12px; color: var(--sub);
            line-height: 1.65; margin-bottom: 36px;
        }

        /* ── Alerts ── */
        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 13px 16px; margin-bottom: 22px;
            font-size: 12px; line-height: 1.5;
        }
        .alert-error   { background:#fdf2f5; border-left:3px solid var(--p); color:#7a2040; }
        .alert-success { background:#f4f7ed; border-left:3px solid var(--sec); color:#3a4a10; }

        /* ════════════════ GLASSMORPHISM FIELDS ════════════════ */
        .field { margin-bottom: 20px; position: relative; }

        .field label {
            display: block;
            font-size: 9px; font-weight: 700;
            letter-spacing: .26em; text-transform: uppercase;
            color: var(--out); margin-bottom: 8px;
            transition: color .2s, letter-spacing .3s;
        }
        .field.focused label { color: var(--p); letter-spacing: .32em; }
        .field.filled label  { color: var(--p2); }

        .glass-wrap {
            position: relative;
            background: rgba(241,236,239,.55);
            backdrop-filter: blur(14px) saturate(160%);
            -webkit-backdrop-filter: blur(14px) saturate(160%);
            border: 1.5px solid rgba(154,58,90,.12);
            transition: border-color .25s, background .25s, box-shadow .35s;
            overflow: hidden;
        }

        .glass-wrap::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 1px;
            background: linear-gradient(90deg,
                transparent 0%, rgba(255,255,255,.7) 40%,
                rgba(255,255,255,.9) 50%, rgba(255,255,255,.7) 60%,
                transparent 100%);
            opacity: .6;
        }

        .glass-wrap::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg,
                rgba(154,58,90,.06) 0%, rgba(212,137,158,.04) 100%);
            opacity: 0;
            transition: opacity .35s;
        }

        .field.focused .glass-wrap {
            border-color: rgba(154,58,90,.45);
            background: rgba(255,255,255,.82);
            box-shadow:
                0 0 0 3px rgba(154,58,90,.08),
                0 4px 20px rgba(154,58,90,.1),
                inset 0 1px 0 rgba(255,255,255,.9);
        }
        .field.focused .glass-wrap::after { opacity: 1; }
        .field.filled  .glass-wrap {
            border-color: rgba(136,73,90,.25);
            background: rgba(241,236,239,.72);
        }

        .glass-wrap .gi {
            position: absolute;
            left: 16px; top: 50%;
            transform: translateY(-50%);
            color: var(--out);
            font-size: 18px;
            pointer-events: none;
            transition: color .25s, transform .3s;
            z-index: 2;
        }
        .field.focused .glass-wrap .gi { color: var(--p); transform: translateY(-50%) scale(1.08); }
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
            -webkit-appearance: none;
        }
        .glass-wrap input::placeholder {
            color: rgba(135,114,118,.38);
            font-size: 13px;
            transition: opacity .2s;
        }
        .field.focused .glass-wrap input::placeholder { opacity: .5; }

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

        /* password strength dots */
        .pw-dots {
            display: flex; gap: 4px;
            position: absolute;
            bottom: -18px; left: 0;
        }
        .pw-dot {
            width: 18px; height: 2px;
            border-radius: 2px;
            background: rgba(135,114,118,.18);
            transition: background .3s, width .3s;
        }
        .pw-dot.on-weak   { background: #e05f5f; }
        .pw-dot.on-mid    { background: #e8a84a; }
        .pw-dot.on-strong { background: var(--sec); }

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

        /* ── Options row ── */
        .opt-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            margin-top: 24px;
        }
        .chk {
            display: flex; align-items: center; gap: 8px;
            font-size: 11px; color: var(--sub);
            cursor: pointer; user-select: none;
        }
        .chk input { width:14px;height:14px;accent-color:var(--p);cursor:pointer; }
        .fgt {
            font-size: 10px; font-weight: 700;
            letter-spacing: .1em; text-transform: uppercase;
            color: var(--p); text-decoration: none;
            opacity: .75; transition: opacity .2s;
        }
        .fgt:hover { opacity: 1; }

        /* ── Submit ── */
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
            margin-bottom: 28px;
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

        /* ── Divider ── */
        .dvd {
            display: flex; align-items: center; gap: 14px;
            font-size: 9px; font-weight: 700;
            letter-spacing: .22em; text-transform: uppercase;
            color: rgba(135,114,118,.38);
            margin-bottom: 20px;
        }
        .dvd::before,.dvd::after {
            content:''; flex:1; height:1px;
            background: rgba(135,114,118,.13);
        }

        /* ── Social ── */
        .soc-row { display:flex; gap:10px; margin-bottom:28px; }
        .soc-btn {
            flex:1; padding:12px 8px;
            border: 1.5px solid rgba(135,114,118,.16);
            background: transparent; cursor: pointer;
            font-family: 'Manrope', sans-serif;
            font-size: 9px; font-weight: 700;
            letter-spacing: .16em; text-transform: uppercase;
            color: var(--sub);
            display: flex; align-items: center;
            justify-content: center; gap: 7px;
            transition: border-color .2s, color .2s, background .2s;
        }
        .soc-btn svg { width:13px;height:13px;flex-shrink:0; }
        .soc-btn:hover {
            border-color: var(--p); color: var(--p);
            background: rgba(154,58,90,.03);
        }

        /* ── Footer ── */
        .fw-foot { text-align:center; font-size:12px; color:var(--sub); }
        .fw-foot a { color:var(--p); font-weight:700; text-decoration:none; }
        .fw-foot a:hover { text-decoration:underline; }
        .bk {
            display:inline-flex; align-items:center; gap:6px;
            margin-top:18px; font-size:9px; font-weight:600;
            letter-spacing:.2em; text-transform:uppercase;
            color:rgba(135,114,118,.38); text-decoration:none;
            transition:color .2s;
        }
        .bk:hover { color:var(--ink); }
        .bk .material-symbols-outlined { font-size:12px; }

        /* ── Responsive ── */
        @media(max-width:860px){
            .page { grid-template-columns:1fr; }
            .left-panel { display:none; }
            .right-panel { padding:48px 24px; background:var(--sf); }
            .form-wrapper { background:var(--w); padding:44px 32px; max-width:100%; }
        }
        @media(max-width:480px){
            .form-wrapper { padding:36px 20px; }
            .fw-title { font-size:32px; }
        }
    </style>
</head>
<body>
<div class="page">

    <!-- ════════ LEFT PANEL ════════ -->
    <div class="left-panel">
        <img class="bg-img"
             src="<%= ctx %>/uploads/catalogo/heroSection/filosofia1.jpg"
             alt="Quiddity botanical" />

        <div class="left-content">
            <a href="<%= ctx %>/index.jsp" class="left-logo">
                <span class="logo-dot"></span>
                Quiddity
            </a>

            <div></div>

            <div class="left-bottom">
                <span class="left-tag">
                    <span class="material-symbols-outlined" style="font-size:20px;">spa</span>
                    Bienvenid@ de nuevo
                </span>
                <p class="left-footer-text">© 2026 Quiddity Skincare</p>
            </div>
        </div>
    </div>

    <!-- ════════ RIGHT PANEL ════════ -->
    <div class="right-panel">
        <div class="form-wrapper">

            <div class="prog"><div class="prog-fill"></div></div>

            <p class="fw-eye">Acceder a tu cuenta</p>
            <h1 class="fw-title">Iniciar sesión</h1>
            <p class="fw-sub">Ingresa tus credenciales para continuar tu experiencia Quiddity.</p>

            <%-- Alerta de error --%>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <span class="material-symbols-outlined" style="font-size:15px;flex-shrink:0;">error</span>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <%-- Alerta de registro exitoso --%>
            <% if ("ok".equals(request.getParameter("registro"))) { %>
            <div class="alert alert-success">
                <span class="material-symbols-outlined" style="font-size:15px;flex-shrink:0;">check_circle</span>
                ¡Registro exitoso! Ya puedes iniciar sesión.
            </div>
            <% } %>

            <%-- ACTION apunta a LoginServlet, igual que el doc 1 --%>
            <form action="<%= ctx %>/login" method="POST" accept-charset="UTF-8" autocomplete="on">

                <!-- Email -->
                <div class="field" id="fld-email">
                    <label for="email">Correo electrónico</label>
                    <div class="glass-wrap">
                        <span class="material-symbols-outlined gi">mail</span>
                        <input type="text"
                               id="email"
                               name="email"
                               placeholder="tu@email.com"
                               autocomplete="email"
                               required
                               value='<%= request.getAttribute("emailPrevio") != null
                                         ? request.getAttribute("emailPrevio")
                                         : (request.getParameter("email") != null
                                            ? request.getParameter("email") : "") %>' />
                        <div class="gline"></div>
                    </div>
                </div>

                <!-- Password  ← name="contrasena" para que LoginServlet lo reciba -->
                <div class="field" id="fld-pw">
                    <label for="password">Contraseña</label>
                    <div class="glass-wrap">
                        <span class="material-symbols-outlined gi">lock</span>
                        <input type="password"
                               id="password"
                               name="contrasena"
                               placeholder="••••••••"
                               autocomplete="current-password"
                               required />
                        <button type="button" class="tgl-pw" onclick="togglePw()" aria-label="Mostrar contraseña">
                            <span class="material-symbols-outlined" id="pw-icon" style="font-size:17px;">visibility_off</span>
                        </button>
                        <div class="gline"></div>
                    </div>
                    <div class="pw-dots" id="pw-dots">
                        <div class="pw-dot" id="d1"></div>
                        <div class="pw-dot" id="d2"></div>
                        <div class="pw-dot" id="d3"></div>
                        <div class="pw-dot" id="d4"></div>
                    </div>
                </div>

                <div class="opt-row">
                    <label class="chk">
                        <input type="checkbox" name="remember" id="remember" />
                        Recordarme
                    </label>
                    <a href="<%= ctx %>/recuperar" class="fgt">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit" class="btn-go">
                    <span>Iniciar sesión</span>
                    <span class="material-symbols-outlined ia">arrow_forward</span>
                </button>

            </form>

            <div class="dvd">o continúa con</div>

            <div class="soc-row">
                <button type="button" class="soc-btn" onclick="alert('Google OAuth pendiente')">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12.48 10.92v3.28h7.84c-.24 1.84-.9 3.34-2.02 4.48-1.12 1.14-2.6 2.06-4.94 2.06-4.14 0-7.5-3.36-7.5-7.5s3.36-7.5 7.5-7.5c2.25 0 4.3.83 5.83 2.18l2.36-2.36C19.1 3.54 15.93 2 12.48 2 6.64 2 1.94 6.7 1.94 12.54s4.7 10.54 10.54 10.54c3.15 0 5.53-1.04 7.42-3 1.95-1.95 2.58-4.7 2.58-7.04 0-.67-.06-1.3-.18-1.92h-9.76z"/>
                    </svg>
                    Google
                </button>
                <button type="button" class="soc-btn" onclick="alert('Facebook OAuth pendiente')">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                    </svg>
                    Facebook
                </button>
            </div>

            <div class="fw-foot">
                ¿No tienes una cuenta? <a href="<%= ctx %>/registro.jsp">Regístrate gratis</a><br/>
                <a href="<%= ctx %>/index.jsp" class="bk">
                    <span class="material-symbols-outlined">arrow_back</span>
                    Volver al inicio
                </a>
            </div>

        </div>
    </div>

</div>

<script>
/* ── Toggle password ── */
function togglePw() {
    var i  = document.getElementById('password');
    var ic = document.getElementById('pw-icon');
    i.type = i.type === 'password' ? 'text' : 'password';
    ic.textContent = i.type === 'password' ? 'visibility_off' : 'visibility';
}

/* ── Field focus / fill states ── */
document.querySelectorAll('.field').forEach(function(fld) {
    var inp = fld.querySelector('input');
    if (!inp) return;

    inp.addEventListener('focus', function() { fld.classList.add('focused'); });

    inp.addEventListener('blur', function() {
        fld.classList.remove('focused');
        fld.classList.toggle('filled', inp.value.trim().length > 0);
    });

    if (inp.value.trim().length > 0) fld.classList.add('filled');
});

/* ── Password strength indicator ── */
(function() {
    var pw   = document.getElementById('password');
    var dots = ['d1','d2','d3','d4'].map(function(id){ return document.getElementById(id); });
    var cls  = ['', 'on-weak', 'on-mid', 'on-strong', 'on-strong'];

    function strength(v) {
        var s = 0;
        if (v.length >= 6)  s++;
        if (v.length >= 10) s++;
        if (/[A-Z]/.test(v) && /[0-9]/.test(v)) s++;
        if (/[^A-Za-z0-9]/.test(v)) s++;
        return s;
    }

    pw.addEventListener('input', function() {
        var s = pw.value.length === 0 ? 0 : Math.max(1, strength(pw.value));
        dots.forEach(function(d, i) {
            d.className = 'pw-dot' + (i < s ? ' ' + cls[s] : '');
        });
    });
})();
</script>
</body>
</html>
