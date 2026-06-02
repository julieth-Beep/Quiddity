<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro | Quiddity</title>
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

        /* ════════════════════════════════════════════
           MODAL DE SELECCIÓN DE ROL — LIGHT GLASSMORPHISM
        ═════════════════════════════════════════════ */
        #role-modal {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: rgba(241, 236, 239, 0.65);
            backdrop-filter: blur(24px) saturate(180%);
            -webkit-backdrop-filter: blur(24px) saturate(180%);
            animation: backdropIn .5s ease both;
        }

        @keyframes backdropIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        #role-modal.hidden { display: none; }

        .modal-inner {
            width: 92vw;
            max-width: 1400px;
            height: 88vh;
            display: flex;
            flex-direction: column;
            padding: 48px 56px;
            
            background: rgba(255, 255, 255, 0.55);
            backdrop-filter: blur(32px) saturate(200%);
            -webkit-backdrop-filter: blur(32px) saturate(200%);
            border: 1px solid rgba(255, 255, 255, 0.65);
            border-radius: 24px;
            box-shadow:
                0 8px 32px rgba(154, 58, 90, 0.12),
                0 24px 80px rgba(28, 27, 29, 0.18),
                inset 0 1px 0 rgba(255, 255, 255, 0.85);
            
            animation: modalUp .6s cubic-bezier(.16,1,.3,1) both;
        }

        @keyframes modalUp {
            from { opacity:0; transform: translateY(40px) scale(.98); }
            to   { opacity:1; transform: translateY(0) scale(1); }
        }

        .modal-eye {
            text-align: center;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .38em;
            text-transform: uppercase;
            color: rgba(135, 114, 118, .55);
            margin-bottom: 16px;
        }

        .modal-title {
            font-family: 'EB Garamond', serif;
            font-size: clamp(32px, 4.2vw, 48px);
            font-style: italic;
            font-weight: 400;
            color: var(--ink);
            text-align: center;
            line-height: 1.05;
            margin-bottom: 8px;
        }

        .modal-sub {
            font-size: 13px;
            color: var(--sub);
            text-align: center;
            letter-spacing: .03em;
            margin-bottom: 42px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .role-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            flex: 1;
            align-content: center;
        }

        .role-card {
            position: relative;
            padding: 42px 36px;
            cursor: pointer;
            overflow: hidden;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.62);
            backdrop-filter: blur(28px) saturate(180%);
            -webkit-backdrop-filter: blur(28px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.75);
            box-shadow:
                inset 0 1px 0 rgba(255, 255, 255, 0.95),
                0 12px 48px rgba(154, 58, 90, 0.08);
            transition:
                background .4s,
                border-color .4s,
                box-shadow .4s,
                transform .4s cubic-bezier(.22,1,.36,1);
        }

        .role-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 1px;
            background: linear-gradient(90deg,
                transparent 0%,
                rgba(154,58,90,.25) 35%,
                rgba(154,58,90,.45) 50%,
                rgba(154,58,90,.25) 65%,
                transparent 100%);
            opacity: .6;
            transition: opacity .4s;
        }

        .role-card::after {
            content: '';
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity .4s;
            pointer-events: none;
        }

        .role-card.buyer::after {
            background: linear-gradient(135deg,
                rgba(154,58,90,.08) 0%,
                rgba(136,73,90,.04) 100%);
        }

        .role-card.user::after {
            background: linear-gradient(135deg,
                rgba(81,102,23,.08) 0%,
                rgba(81,102,23,.04) 100%);
        }

        .role-card:hover {
            transform: translateY(-6px);
            border-color: rgba(154,58,90,.35);
            background: rgba(255,255,255,.78);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,1),
                0 20px 64px rgba(154,58,90,.16);
        }

        .role-card:hover::before { opacity: 1; }
        .role-card:hover::after  { opacity: 1; }

        .role-card.selected {
            border-color: rgba(154,58,90,.55);
            background: rgba(255,255,255,.88);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,1),
                0 0 0 2px rgba(154,58,90,.18),
                0 24px 72px rgba(154,58,90,.22);
        }

        .role-card.buyer.selected {
            border-color: rgba(154,58,90,.65);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,1),
                0 0 0 2px rgba(154,58,90,.35),
                0 24px 72px rgba(154,58,90,.28);
        }

        .role-card.user.selected {
            border-color: rgba(81,102,23,.65);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,1),
                0 0 0 2px rgba(81,102,23,.35),
                0 24px 72px rgba(81,102,23,.28);
        }

        .role-card.selected::after { opacity: 1; }

        .role-card-content { position: relative; z-index: 1; }

        .rc-icon {
            width: 64px; height: 64px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 24px;
            font-size: 26px;
        }

        .buyer .rc-icon {
            background: rgba(154,58,90,.12);
            border: 1px solid rgba(154,58,90,.28);
            color: var(--p);
        }

        .user .rc-icon {
            background: rgba(81,102,23,.12);
            border: 1px solid rgba(81,102,23,.28);
            color: var(--sec);
        }

        .rc-tag {
            font-size: 9px;
            font-weight: 700;
            letter-spacing: .32em;
            text-transform: uppercase;
            margin-bottom: 10px;
            color: var(--out);
        }

        .rc-name {
            font-family: 'EB Garamond', serif;
            font-size: 28px;
            font-style: italic;
            font-weight: 400;
            color: var(--ink);
            line-height: 1.15;
            margin-bottom: 16px;
        }

        .rc-desc {
            font-size: 13px;
            color: var(--sub);
            line-height: 1.7;
            margin-bottom: 26px;
        }

        .rc-benefits {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 28px;
        }

        .rc-benefits li {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 12px;
            color: var(--ink);
            line-height: 1.5;
        }

        .rc-benefits .bi {
            font-size: 16px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .buyer .rc-benefits .bi { color: var(--p); }
        .user  .rc-benefits .bi { color: var(--sec); }

        .rc-choose {
            width: 100%;
            padding: 15px 24px;
            border: 1.5px solid rgba(135,114,118,.22);
            background: rgba(255,255,255,.72);
            color: var(--ink);
            font-family: 'Manrope', sans-serif;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .28em;
            text-transform: uppercase;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            transition: all .3s;
            position: relative; z-index: 2;
            border-radius: 12px;
        }

        .buyer .rc-choose { border-color: rgba(154,58,90,.35); }
        .user  .rc-choose { border-color: rgba(81,102,23,.35); }

        .rc-choose:hover {
            background: rgba(255,255,255,.92);
            border-color: rgba(154,58,90,.55);
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(154,58,90,.18);
        }

        .buyer .rc-choose:hover { border-color: rgba(154,58,90,.65); }
        .user  .rc-choose:hover { border-color: rgba(81,102,23,.65); }

        .rc-badge {
            position: absolute;
            top: 20px; right: 20px;
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--w);
            border: 2px solid var(--p);
            display: flex; align-items: center; justify-content: center;
            opacity: 0; transform: scale(.5);
            transition: opacity .35s, transform .35s;
            z-index: 2;
        }

        .user .rc-badge { border-color: var(--sec); }

        .role-card.selected .rc-badge {
            opacity: 1;
            transform: scale(1);
        }

        .rc-badge .material-symbols-outlined {
            font-size: 16px;
            font-variation-settings: 'FILL' 1, 'wght' 600;
        }

        /* ════════════════════════════════════════════
           PÁGINA PRINCIPAL — LAYOUT AJUSTADO
        ═════════════════════════════════════════════ */
        .page {
            display: grid;
            grid-template-columns: 1.65fr 1fr;
            min-height: 100vh;
        }

        .right-panel-img {
            position: relative;
            overflow: hidden;
            background: #160d11;
            order: 2;
        }

        .right-panel-img .bg-img {
            position: absolute;
            inset: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            object-position: 35% center;
            opacity: 0.65;
            transform: scale(1.04);
            transition: transform 9s ease;
        }
        .right-panel-img:hover .bg-img { transform: scale(1); }

        .right-panel-img::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                linear-gradient(to top,  rgba(18,10,14,.92) 0%, rgba(18,10,14,.35) 48%, rgba(18,10,14,.08) 100%),
                linear-gradient(to left,  rgba(18,10,14,.55) 0%, rgba(18,10,14,.0) 60%);
        }

        .right-img-content {
            position: relative;
            z-index: 2;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 40px 36px;
        }

        .right-logo {
            font-family: 'EB Garamond', serif;
            font-size: 20px;
            letter-spacing: .24em;
            color: var(--w);
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            align-self: flex-end;
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

        .right-img-bottom {
            display: flex;
            flex-direction: column;
            gap: 14px;
            align-items: flex-end;
            text-align: right;
        }

        .right-img-tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            align-self: flex-end;
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

        .right-footer-text {
            font-size: 8px;
            letter-spacing: .22em;
            text-transform: uppercase;
            color: rgba(255,255,255,.16);
            opacity: .85;
        }

        .left-panel-form {
            background: var(--w);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 48px 56px;
            position: relative;
            overflow: hidden;
            order: 1;
        }

        .left-panel-form::before {
            content: '';
            position: absolute;
            width: 340px; height: 340px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(154,58,90,.07) 0%, transparent 70%);
            top: -110px; left: -110px;
            pointer-events: none;
        }
        .left-panel-form::after {
            content: '';
            position: absolute;
            width: 240px; height: 240px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(81,102,23,.06) 0%, transparent 70%);
            bottom: -80px; right: -80px;
            pointer-events: none;
        }

        .form-wrapper {
            width: 100%;
            max-width: 520px;
            position: relative;
            z-index: 1;
            animation: wrapIn .65s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes wrapIn {
            from { opacity:0; transform:translateY(22px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .role-chip-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
        }

        .role-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 14px 6px 10px;
            font-size: 9px;
            font-weight: 700;
            letter-spacing: .22em;
            text-transform: uppercase;
        }

        .role-chip.chip-buyer {
            background: rgba(154,58,90,.08);
            border: 1px solid rgba(154,58,90,.22);
            color: var(--p);
        }

        .role-chip.chip-user {
            background: rgba(81,102,23,.08);
            border: 1px solid rgba(81,102,23,.22);
            color: var(--sec);
        }

        .role-chip .material-symbols-outlined { font-size: 14px; }

        .change-role-btn {
            font-size: 9px;
            font-weight: 700;
            letter-spacing: .18em;
            text-transform: uppercase;
            color: var(--out);
            background: none;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: color .2s;
            padding: 4px 0;
        }

        .change-role-btn:hover { color: var(--p); }
        .change-role-btn .material-symbols-outlined { font-size: 13px; }

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
        @keyframes progGrow { to { width: 66%; } }

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
            line-height: 1.65; margin-bottom: 28px;
        }

        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 13px 16px; margin-bottom: 22px;
            font-size: 12px; line-height: 1.5;
        }
        .alert-error   { background:#fdf2f5; border-left:3px solid var(--p); color:#7a2040; }
        .alert-success { background:#f4f7ed; border-left:3px solid var(--sec); color:#3a4a10; }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .field { margin-bottom: 20px; position: relative; }

        .field label {
            display: block;
            font-size: 9px; font-weight: 700;
            letter-spacing: .26em; text-transform: uppercase;
            color: var(--out); margin-bottom: 8px;
            transition: color .2s, letter-spacing .3s;
        }
        .field.focused label { color: var(--p); letter-spacing: .32em; }
        .field.filled  label { color: var(--p2); }

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
                rgba(255,255,255,.9) 50%, rgba(255,255,255,.7) 60%, transparent 100%);
            opacity: .6;
        }

        .glass-wrap::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(154,58,90,.06) 0%, rgba(212,137,158,.04) 100%);
            opacity: 0; transition: opacity .35s;
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

        .glass-wrap input,
        .glass-wrap select {
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
            appearance: none;
        }
        .glass-wrap select {
            cursor: pointer;
            padding-right: 40px;
        }
        .glass-wrap input::placeholder {
            color: rgba(135,114,118,.38);
            font-size: 13px;
            transition: opacity .2s;
        }
        .field.focused .glass-wrap input::placeholder { opacity: .5; }

        .glass-wrap .sel-arrow {
            position: absolute;
            right: 14px; top: 50%;
            transform: translateY(-50%);
            color: var(--out);
            pointer-events: none;
            z-index: 2;
            font-size: 16px;
        }

        .glass-wrap .gline {
            position: absolute;
            bottom: 0; left: 0;
            height: 2px; width: 0;
            background: linear-gradient(90deg, var(--p), #d4899e);
            transition: width .4s cubic-bezier(.22,1,.36,1);
            z-index: 3;
        }
        .field.focused .glass-wrap .gline { width: 100%; }
        .field.filled  .glass-wrap .gline { width:100%; background:linear-gradient(90deg,var(--p2),#b07080); }

        .pw-dots {
            display: flex; gap: 4px;
            position: absolute; bottom: -18px; left: 0;
        }
        .pw-dot {
            width: 18px; height: 2px; border-radius: 2px;
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
            padding: 4px; display: flex; align-items: center;
            transition: color .2s; z-index: 3;
        }
        .tgl-pw:hover { color: var(--p); }

        .terms {
            display: flex; align-items: flex-start; gap: 10px;
            margin-bottom: 26px; font-size: 11px; color: var(--sub);
        }
        .terms input[type="checkbox"] {
            width:14px; height:14px; accent-color:var(--p); cursor:pointer; margin-top:2px;
        }
        .terms a { color:var(--p); text-decoration:none; }
        .terms a:hover { text-decoration:underline; }

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
        }
        .btn-go::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, var(--p), #c4748e);
            transform: scaleX(0); transform-origin: left;
            transition: transform .44s cubic-bezier(.22,1,.36,1);
        }
        .btn-go:hover::before { transform: scaleX(1); }
        .btn-go span, .btn-go .ia { position:relative; z-index:1; }
        .ia { transition: transform .3s; font-size:15px; }
        .btn-go:hover .ia { transform: translateX(5px); }

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
        @media(max-width: 1100px) {
            .page { grid-template-columns: 1fr; }
            .right-panel-img { display: none; }
            .left-panel-form { padding: 40px 28px; background: var(--sf); }
            .form-wrapper { background: var(--w); padding: 44px 32px; max-width: 100%; }
            .role-cards { grid-template-columns: 1fr; }
            .modal-inner { 
                width: 96vw; 
                height: auto; 
                max-height: 92vh; 
                padding: 36px 28px; 
                overflow-y: auto;
            }
        }
        @media(max-width: 540px) {
            .form-row { grid-template-columns: 1fr; }
            .form-wrapper { padding: 36px 20px; }
            .fw-title { font-size: 32px; }
            .modal-title { font-size: 28px; }
            .modal-inner { padding: 28px 20px; }
            .role-card { padding: 32px 24px; border-radius: 16px; }
            .rc-name { font-size: 24px; }
        }
    </style>
</head>
<body>

<!-- ════════════════════════════════════════════
     MODAL DE SELECCIÓN DE ROL
════════════════════════════════════════════ -->
<div id="role-modal">
    <div class="modal-inner">
        <p class="modal-eye">Quiddity · Paso 1 de 2</p>
        <h2 class="modal-title">¿Cómo deseas unirte?</h2>
        <p class="modal-sub">Elige tu perfil — siempre podrás revisarlo antes de continuar</p>

        <div class="role-cards">

            <!-- ── Comprador ── -->
            <div class="role-card buyer" id="card-buyer" onclick="selectRole('COMPRADOR')">
                <div class="rc-badge">
                    <span class="material-symbols-outlined">check</span>
                </div>
                <div class="role-card-content">
                    <div class="rc-icon">
                        <span class="material-symbols-outlined">shopping_bag</span>
                    </div>
                    <p class="rc-tag">Comprador</p>
                    <h3 class="rc-name">Vive la experiencia<br/>de compra</h3>
                    <p class="rc-desc">Accede al catálogo completo, colecciones exclusivas y descuentos especiales pensados para ti.</p>
                    <ul class="rc-benefits">
                        <li>
                            <span class="material-symbols-outlined bi">storefront</span>
                            Catálogo completo con filtros avanzados
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">local_offer</span>
                            Precios especiales y ofertas exclusivas
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">favorite</span>
                            Lista de deseos y seguimiento de pedidos
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">workspace_premium</span>
                            Programa de puntos y recompensas
                        </li>
                    </ul>
                    <button class="rc-choose" onclick="selectRole('COMPRADOR')">
                        <span class="material-symbols-outlined" style="font-size:14px;">arrow_forward</span>
                        Registrarme como Comprador
                    </button>
                </div>
            </div>

            <!-- ── Usuario ── -->
            <div class="role-card user" id="card-user" onclick="selectRole('USUARIO')">
                <div class="rc-badge">
                    <span class="material-symbols-outlined">check</span>
                </div>
                <div class="role-card-content">
                    <div class="rc-icon">
                        <span class="material-symbols-outlined">person_celebrate</span>
                    </div>
                    <p class="rc-tag">Usuario</p>
                    <h3 class="rc-name">Acceso completo<br/>a la comunidad</h3>
                    <p class="rc-desc">Disfruta de todos los servicios: compras, asesorías personalizadas, closet virtual y mucho más.</p>
                    <ul class="rc-benefits">
                        <li>
                            <span class="material-symbols-outlined bi">checkroom</span>
                            Closet virtual e inteligencia de moda
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">face_retouching_natural</span>
                            Asesorías de maquillaje personalizadas
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">calendar_month</span>
                            Reserva de servicios y citas en línea
                        </li>
                        <li>
                            <span class="material-symbols-outlined bi">auto_stories</span>
                            Contenido exclusivo, journal y comunidad
                        </li>
                    </ul>
                    <button class="rc-choose" onclick="selectRole('USUARIO')">
                        <span class="material-symbols-outlined" style="font-size:14px;">arrow_forward</span>
                        Registrarme como Usuario
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ════════════════════════════════════════════
     PÁGINA PRINCIPAL
════════════════════════════════════════════ -->
<div class="page">

    <!-- ════════ LEFT PANEL (formulario) ════════ -->
    <div class="left-panel-form">
        <div class="form-wrapper">

            <div class="prog"><div class="prog-fill"></div></div>

            <div class="role-chip-row">
                <span class="role-chip" id="role-chip"></span>
                <button type="button" class="change-role-btn" onclick="openRoleModal()">
                    <span class="material-symbols-outlined">swap_horiz</span>
                    Cambiar rol
                </button>
            </div>

            <p class="fw-eye">Crear cuenta en Quiddity</p>
            <h1 class="fw-title">Regístrate</h1>
            <p class="fw-sub">Completa tus datos para comenzar tu experiencia.</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <span class="material-symbols-outlined" style="font-size:15px;flex-shrink:0;">error</span>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="<%= ctx %>/registro" method="POST" id="regForm" autocomplete="on">
                <input type="hidden" name="rol" id="rol-input" value="" />

                <div class="form-row">
                    <div class="field" id="fld-nombre">
                        <label for="nombre">Nombre</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">person</span>
                            <input type="text" id="nombre" name="nombre"
                                   placeholder="Tu nombre"
                                   autocomplete="given-name" required
                                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" />
                            <div class="gline"></div>
                        </div>
                    </div>
                    <div class="field" id="fld-apellido">
                        <label for="apellido">Apellido</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">person</span>
                            <input type="text" id="apellido" name="apellido"
                                   placeholder="Tu apellido"
                                   autocomplete="family-name" required
                                   value="<%= request.getParameter("apellido") != null ? request.getParameter("apellido") : "" %>" />
                            <div class="gline"></div>
                        </div>
                    </div>
                </div>

                <div class="field" id="fld-email">
                    <label for="email">Correo electrónico</label>
                    <div class="glass-wrap">
                        <span class="material-symbols-outlined gi">mail</span>
                        <input type="email" id="email" name="email"
                               placeholder="tu@email.com"
                               autocomplete="email" required
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
                        <div class="gline"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="field" id="fld-doc">
                        <label for="documento">Documento</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">badge</span>
                            <input type="text" id="documento" name="documento"
                                   placeholder="1234567890"
                                   required
                                   value="<%= request.getParameter("documento") != null ? request.getParameter("documento") : "" %>" />
                            <div class="gline"></div>
                        </div>
                    </div>
                    <div class="field" id="fld-user">
                        <label for="userName">Nombre de usuario</label>
                        <div class="glass-wrap">
                            <span class="material-symbols-outlined gi">alternate_email</span>
                            <input type="text" id="userName" name="userName"
                                   placeholder="@usuario"
                                   required
                                   value="<%= request.getParameter("userName") != null ? request.getParameter("userName") : "" %>" />
                            <div class="gline"></div>
                        </div>
                    </div>
                </div>

                <div class="field" id="fld-pw" style="margin-bottom:32px;">
                    <label for="contrasena">Contraseña</label>
                    <div class="glass-wrap">
                        <span class="material-symbols-outlined gi">lock</span>
                        <input type="password" id="contrasena" name="contrasena"
                               placeholder="Mínimo 6 caracteres"
                               autocomplete="new-password" required minlength="6" />
                        <button type="button" class="tgl-pw" onclick="togglePw('contrasena','pw-icon1')" aria-label="Mostrar contraseña">
                            <span class="material-symbols-outlined" id="pw-icon1" style="font-size:17px;">visibility_off</span>
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

                <div class="field" id="fld-pw2">
                    <label for="confirmarContrasena">Confirmar contraseña</label>
                    <div class="glass-wrap">
                        <span class="material-symbols-outlined gi">lock</span>
                        <input type="password" id="confirmarContrasena" name="confirmarContrasena"
                               placeholder="Repite tu contraseña"
                               autocomplete="new-password" required minlength="6" />
                        <button type="button" class="tgl-pw" onclick="togglePw('confirmarContrasena','pw-icon2')" aria-label="Mostrar contraseña">
                            <span class="material-symbols-outlined" id="pw-icon2" style="font-size:17px;">visibility_off</span>
                        </button>
                        <div class="gline"></div>
                    </div>
                </div>

                <div class="terms">
                    <input type="checkbox" id="terminos" name="terminos" required />
                    <label for="terminos">
                        Acepto los <a href="#">Términos y Condiciones</a> y la <a href="#">Política de Privacidad</a> de Quiddity.
                    </label>
                </div>

                <button type="submit" class="btn-go">
                    <span>Crear cuenta</span>
                    <span class="material-symbols-outlined ia">arrow_forward</span>
                </button>
            </form>

            <div class="fw-foot">
                ¿Ya tienes cuenta? <a href="<%= ctx %>/login.jsp">Inicia sesión</a><br/>
                <a href="<%= ctx %>/index.jsp" class="bk">
                    <span class="material-symbols-outlined">arrow_back</span>
                    Volver al inicio
                </a>
            </div>

        </div>
    </div>

    <!-- ════════ RIGHT PANEL (imagen) ════════ -->
    <div class="right-panel-img">
        <img class="bg-img"
             src="<%= ctx %>/uploads/catalogo/heroSection/filosofia1.jpg"
             alt="Quiddity botanical" />

        <div class="right-img-content">
            <a href="<%= ctx %>/index.jsp" class="right-logo">
                Quiddity
                <span class="logo-dot"></span>
            </a>
            <div></div>
            <div class="right-img-bottom">
                <span class="right-img-tag">
                    Bienvenid@ a Quiddity
                    <span class="material-symbols-outlined" style="font-size:18px;">spa</span>
                </span>
                <p class="right-footer-text">© 2026 Quiddity Skincare</p>
            </div>
        </div>
    </div>

</div>

<%@ include file="chatbot.jsp" %>

<script>
var selectedRole = null;

function selectRole(rol) {
    selectedRole = rol;
    document.getElementById('card-buyer').classList.remove('selected');
    document.getElementById('card-user').classList.remove('selected');
    if (rol === 'COMPRADOR') {
        document.getElementById('card-buyer').classList.add('selected');
    } else {
        document.getElementById('card-user').classList.add('selected');
    }
    setTimeout(function() { closeRoleModal(rol); }, 280);
}

function closeRoleModal(rol) {
    document.getElementById('role-modal').classList.add('hidden');
    document.getElementById('rol-input').value = rol;
    var chip = document.getElementById('role-chip');
    if (rol === 'COMPRADOR') {
        chip.className = 'role-chip chip-buyer';
        chip.innerHTML = '<span class="material-symbols-outlined">shopping_bag</span>Comprador';
    } else {
        chip.className = 'role-chip chip-user';
        chip.innerHTML = '<span class="material-symbols-outlined">person_celebrate</span>Usuario';
    }
}

function openRoleModal() {
    var modal = document.getElementById('role-modal');
    modal.classList.remove('hidden');
    var inner = modal.querySelector('.modal-inner');
    inner.style.animation = 'none';
    inner.offsetHeight;
    inner.style.animation = '';
}

(function() {
    var preRol = '<%= request.getParameter("rol") != null ? request.getParameter("rol") : "" %>';
    if (preRol === 'COMPRADOR' || preRol === 'USUARIO') {
        selectRole(preRol);
    }
})();

function togglePw(inputId, iconId) {
    var i  = document.getElementById(inputId);
    var ic = document.getElementById(iconId);
    i.type = i.type === 'password' ? 'text' : 'password';
    ic.textContent = i.type === 'password' ? 'visibility_off' : 'visibility';
}

document.querySelectorAll('.field').forEach(function(fld) {
    var inp = fld.querySelector('input, select');
    if (!inp) return;
    inp.addEventListener('focus',  function() { fld.classList.add('focused'); });
    inp.addEventListener('blur',   function() {
        fld.classList.remove('focused');
        fld.classList.toggle('filled', inp.value.trim().length > 0);
    });
    if (inp.value && inp.value.trim().length > 0) fld.classList.add('filled');
});

(function() {
    var pw   = document.getElementById('contrasena');
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
            d.className = 'pw-dot';
            if (i < s) d.classList.add(cls[s]);
        });
    });
})();

document.getElementById('regForm').addEventListener('submit', function(e) {
    if (!selectedRole) {
        e.preventDefault();
        openRoleModal();
        return;
    }
    var pw1 = document.getElementById('contrasena').value;
    var pw2 = document.getElementById('confirmarContrasena').value;
    if (pw1 !== pw2) {
        e.preventDefault();
        var fld = document.getElementById('fld-pw2');
        fld.querySelector('.glass-wrap').style.borderColor = 'rgba(224,95,95,.6)';
        document.getElementById('confirmarContrasena').focus();
    }
});
</script>
</body>
</html>