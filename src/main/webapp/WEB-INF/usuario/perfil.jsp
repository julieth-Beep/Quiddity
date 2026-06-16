<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Redirigir al login si no hay sesión --%>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%-- Leer mensajes de sesión (para sobrevivir el redirect) --%>
<c:set var="mensajeExito" value="${sessionScope.mensajeExito}" />
<c:set var="mensajeError" value="${sessionScope.mensajeError}" />
<c:set var="tabActiva"    value="${sessionScope.tabActiva}" />
<%
    session.removeAttribute("mensajeExito");
    session.removeAttribute("mensajeError");
    session.removeAttribute("tabActiva");
%>

<c:set var="activePage" value="perfil" scope="request" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil | Quiddity</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />

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

            --pastel-sky: #e3f2fd;
            --pastel-sky-dark: #bbdefb;
            --pastel-mint: #e8f5e9;
            --pastel-mint-dark: #c8e6c9;
            --pastel-lavender: #f3e5f5;
            --pastel-lavender-dark: #e1bee7;
            --pastel-cream: #fff3e0;
            --pastel-cream-dark: #ffe0b2;
            --pastel-coral: #fce4ec;
            --pastel-coral-dark: #f8bbd0;

            --accent-sky: #1976d2;
            --accent-mint: #388e3c;
            --accent-lavender: #7b1fa2;
            --accent-cream: #f57c00;
            --accent-coral: #c2185b;

            --success: #388e3c;
            --warning: #f57c00;
            --error: #c2185b;
            --error-bg: rgba(194,24,89,0.06);

            --primary: #9a3a5a;
            --primary-dark: #7a2e48;
            --primary-light: rgba(154,58,90,0.08);
            --tertiary: #88495a;

            --radius-sm: 10px;
            --radius-md: 14px;
            --radius-lg: 16px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);

            --gutter: 24px;
            --gap: 20px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            line-height: 1.4;
            -webkit-font-smoothing: antialiased;
            font-size: 12px;
            overflow: hidden;
            height: 100vh;
        }

        .layout-wrapper { display:flex; height:100vh; width:100vw; overflow:hidden; }
        .main-content {
            flex:1;
            margin-left:280px;
            height:100vh;
            background: var(--bg);
            display:flex;
            flex-direction:column;
            overflow:hidden;
        }

        .sidebar-toggle {
            display:none;
            position:fixed;
            top:20px; left:20px;
            z-index:998;
            width:44px; height:44px;
            background: var(--surface);
            border:1px solid var(--border);
            color: var(--text-primary);
            align-items:center;
            justify-content:center;
            cursor:pointer;
            box-shadow: var(--shadow-sm);
            border-radius: var(--radius-sm);
        }

        /* ===== HEADER ===== */
        .page-header { padding:16px var(--gutter) 0; width:100%; flex-shrink:0; }
        .breadcrumb {
            display:flex;
            align-items:center;
            gap:6px;
            font-size:11px;
            font-weight:600;
            color: var(--text-tertiary);
            margin-bottom:8px;
        }
        .breadcrumb a { color: var(--text-tertiary); text-decoration:none; transition:color 0.2s; }
        .breadcrumb a:hover { color: var(--primary); }
        .breadcrumb .material-symbols-outlined { font-size:14px; }
        .header-row { display:flex; align-items:flex-end; justify-content:space-between; gap:var(--gap); flex-wrap:wrap; margin-bottom:10px; }
        .header-title h1 {
            font-family: 'DM Sans', sans-serif;
            font-size: 22px;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text-primary);
            margin-bottom: 4px;
            letter-spacing: -0.3px;
        }
        .header-subtitle { font-size:12px; color: var(--text-secondary); font-weight:500; }

        /* ===== ALERTAS ===== */
        .alert {
            display:flex;
            align-items:center;
            gap:10px;
            padding:12px 20px;
            margin:0 auto 12px;
            max-width:1136px;
            font-size:13px;
            font-weight:600;
            border-radius: var(--radius-sm);
            animation: slideDown 0.4s cubic-bezier(0.22,1,0.36,1);
        }
        .alert-success { background: var(--pastel-mint); border-left:3px solid var(--accent-mint); color: var(--accent-mint); }
        .alert-error { background: var(--error-bg); border-left:3px solid var(--error); color: var(--error); }
        .alert .material-symbols-outlined { font-size:20px; flex-shrink:0; }
        @keyframes slideDown { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }

        /* ===== CONTENEDOR ===== */
        .profile-container { padding:0 var(--gutter) 8px; width:100%; flex:1; display:flex; flex-direction:column; min-height:0; }
        .profile-grid { display:grid; grid-template-columns:300px 1fr; gap:var(--gap); align-items:stretch; width:100%; height:100%; min-height:0; }

        /* ===== CARD PERFIL (lateral) ===== */
        .profile-card {
            background: var(--surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            overflow:hidden;
            display:flex;
            flex-direction:column;
            height:100%;
            width:100%;
            transition: all 0.3s ease;
            position: relative;
        }
        .profile-card:hover { box-shadow: var(--shadow); border-color: var(--border); }
        .profile-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 3px;
            background: var(--accent-lavender);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }
        .profile-card:hover::before { transform: scaleX(1); }

        .profile-card-header {
            padding: 28px 20px 24px;
            text-align:center;
            position:relative;
            background: linear-gradient(135deg, var(--pastel-lavender) 0%, var(--pastel-sky) 100%);
            border-bottom: 1px solid var(--border-light);
        }
        .profile-cover {
            position:absolute;
            top:0; left:0; right:0; height:100%;
            background: linear-gradient(135deg, rgba(154,58,90,0.06) 0%, rgba(123,31,162,0.04) 100%);
        }
        .profile-avatar-wrapper { position:relative; display:inline-block; z-index:1; }
        .profile-avatar {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            border: 4px solid var(--surface);
            background: var(--bg);
            display:flex;
            align-items:center;
            justify-content:center;
            overflow:hidden;
            box-shadow: var(--shadow-md);
        }
        .profile-avatar .material-symbols-outlined { font-size:40px; color: var(--text-tertiary); }
        .profile-avatar img { width:100%; height:100%; object-fit:cover; }
        .avatar-edit-btn {
            position:absolute;
            bottom: 0;
            right: 0;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--surface);
            border: 2px solid var(--border);
            color: var(--text-secondary);
            display:flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
        }
        .avatar-edit-btn:hover { background: var(--primary); color: #fff; border-color: var(--primary); transform: scale(1.1); }
        .avatar-edit-btn .material-symbols-outlined { font-size:14px !important; }
        .profile-name {
            font-family: 'DM Sans', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            margin-top: 14px;
            position:relative;
            z-index:1;
            letter-spacing: -0.2px;
        }
        .profile-role {
            display:inline-flex;
            align-items:center;
            gap: 4px;
            margin-top: 6px;
            padding: 4px 12px;
            background: rgba(255,255,255,0.85);
            backdrop-filter: blur(8px);
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--primary);
            border: 1px solid rgba(154,58,90,0.12);
            position:relative;
            z-index:1;
        }
        .profile-role .material-symbols-outlined { font-size:12px; }
        .profile-card-body { padding: 20px; overflow-y:auto; flex:1; min-height:0; }
        .profile-info-list { list-style:none; }
        .profile-info-item {
            display:flex;
            align-items:center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-light);
            transition: all 0.15s ease;
        }
        .profile-info-item:hover { background: var(--bg); margin: 0 -20px; padding-left: 20px; padding-right: 20px; border-radius: var(--radius-sm); }
        .profile-info-item:last-child { border-bottom:none; padding-bottom:0; }
        .profile-info-item:first-child { padding-top:0; }
        .profile-info-item:first-child:hover { margin-top: 0; }
        .profile-info-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display:flex;
            align-items:center;
            justify-content:center;
            background: var(--pastel-sky);
            flex-shrink:0;
            transition: all 0.2s ease;
        }
        .profile-info-item:hover .profile-info-icon { transform: scale(1.08); }
        .profile-info-icon .material-symbols-outlined { font-size:16px; color: var(--accent-sky); }
        .profile-info-content { min-width:0; }
        .profile-info-label { font-size: 9px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--text-tertiary); margin-bottom: 2px; }
        .profile-info-value { font-size: 12px; font-weight: 600; color: var(--text-primary); word-break:break-word; }
        .profile-card-footer {
            padding: 14px 16px;
            border-top: 1px solid var(--border-light);
            display:flex;
            gap: 8px;
            background: var(--bg-soft);
        }
        .profile-btn {
            flex:1;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap: 6px;
            padding: 9px 12px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-decoration:none;
            border: none;
            cursor:pointer;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            line-height: 18px;
            border-radius: var(--radius-sm);
        }
        .profile-btn-outline {
            background: var(--bg-soft);
            border: 1px solid var(--border);
            color: var(--text-primary);
        }
        .profile-btn-outline:hover {
            background: var(--pastel-sky);
            color: var(--accent-sky);
            border-color: var(--pastel-sky-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        .profile-btn-danger {
            background: var(--bg-soft);
            border: 1px solid var(--pastel-coral-dark);
            color: var(--accent-coral);
        }
        .profile-btn-danger:hover {
            background: var(--pastel-coral);
            color: var(--accent-coral);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        .profile-btn .material-symbols-outlined { font-size:16px; }

        /* ===== PANEL FORMULARIO ===== */
        .form-panel {
            background: var(--surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
            overflow:hidden;
            display:flex;
            flex-direction:column;
            height:100%;
            width:100%;
            transition: all 0.3s ease;
            position: relative;
        }
        .form-panel:hover { box-shadow: var(--shadow); border-color: var(--border); }
        .form-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 3px;
            background: var(--accent-sky);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }
        .form-panel:hover::before { transform: scaleX(1); }

        .form-tabs {
            display:flex;
            border-bottom: 1px solid var(--border-light);
            padding: 0 8px;
            background: var(--bg-soft);
            gap: 4px;
        }
        .form-tab {
            padding: 12px 18px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-tertiary);
            background: none;
            border: none;
            border-bottom: 2.5px solid transparent;
            cursor:pointer;
            transition: all 0.2s;
            display:flex;
            align-items:center;
            gap: 6px;
            letter-spacing: 0.02em;
            position: relative;
            top: 1px;
        }
        .form-tab:hover { color: var(--text-secondary); }
        .form-tab.active { color: var(--primary); border-bottom-color: var(--primary); }
        .form-tab .material-symbols-outlined { font-size:18px; }
        .form-tab-content { display:none; padding: 28px 24px; overflow-y:auto; flex:1; min-height:0; }
        .form-tab-content.active { display:block; animation:fadeIn 0.3s ease; }
        @keyframes fadeIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }

        .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap: 16px 20px; }
        .form-group { display:flex; flex-direction:column; gap: 6px; }
        .form-group.full-width { grid-column:1/-1; }
        .form-label { font-size: 11px; font-weight: 700; color: var(--text-primary); letter-spacing: 0.02em; text-transform: uppercase; }
        .form-label .required { color: var(--error); margin-left: 2px; }
        .form-hint { font-size: 11px; color: var(--text-tertiary); margin-top: 2px; font-weight: 500; }
        .form-input, .form-select {
            padding: 10px 12px 10px 40px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-primary);
            background: var(--bg-soft);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            outline:none;
            transition: all 0.2s;
            line-height: 18px;
        }
        .form-input:focus, .form-select:focus {
            border-color: var(--accent-sky);
            box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
        }
        .form-input::placeholder { color: var(--text-tertiary); }
        .form-input:disabled {
            background: var(--bg);
            color: var(--text-tertiary);
            cursor:not-allowed;
            border-color: var(--border-light);
        }
        .input-with-icon { position:relative; }
        .input-icon {
            position:absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-tertiary);
            pointer-events: none;
        }
        .input-icon .material-symbols-outlined { font-size:18px; }

        /* ===== UPLOAD FOTO ===== */
        .upload-foto-area {
            border: 2px dashed var(--border);
            border-radius: var(--radius-md);
            padding: 40px 24px;
            text-align:center;
            cursor:pointer;
            transition: all 0.25s ease;
            background: var(--bg-soft);
        }
        .upload-foto-area:hover {
            border-color: var(--accent-sky);
            background: var(--pastel-sky);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        .upload-foto-area .material-symbols-outlined { font-size: 40px; color: var(--text-tertiary); display:block; margin-bottom: 10px; transition: all 0.2s; }
        .upload-foto-area:hover .material-symbols-outlined { color: var(--accent-sky); transform: scale(1.1); }
        .upload-foto-area p { font-size: 14px; color: var(--text-secondary); font-weight: 600; }
        .upload-foto-area small { font-size: 12px; color: var(--text-tertiary); font-weight: 500; }
        .foto-preview { display:none; text-align:center; margin-top: 16px; }
        .foto-preview img {
            max-width: 140px;
            max-height: 140px;
            object-fit:cover;
            border: 2px solid var(--border-light);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
        }
        .foto-preview p { font-size: 12px; color: var(--text-tertiary); margin-top: 6px; font-weight: 500; }

        /* ===== BOTONES ===== */
        .form-actions {
            display:flex;
            align-items:center;
            justify-content:flex-end;
            gap: 10px;
            padding-top: 16px;
            border-top: 1px solid var(--border-light);
            margin-top: 8px;
        }
        .btn {
            display:inline-flex;
            align-items:center;
            gap: 6px;
            padding: 10px 22px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-decoration:none;
            border: none;
            cursor:pointer;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            line-height: 18px;
            border-radius: var(--radius-sm);
        }
        .btn-primary {
            background: var(--pastel-lavender);
            color: var(--accent-lavender);
            border: 1px solid var(--pastel-lavender-dark);
        }
        .btn-primary:hover {
            background: var(--pastel-lavender-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(123, 31, 162, 0.15);
        }
        .btn-secondary {
            background: var(--bg-soft);
            color: var(--text-primary);
            border: 1px solid var(--border);
        }
        .btn-secondary:hover {
            background: var(--pastel-sky);
            color: var(--accent-sky);
            border-color: var(--pastel-sky-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        .btn .material-symbols-outlined { font-size:18px; }

        /* ===== TOGGLES ===== */
        .toggle-group {
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding: 14px 0;
            border-bottom: 1px solid var(--border-light);
            transition: all 0.15s ease;
        }
        .toggle-group:hover { background: var(--bg); margin: 0 -24px; padding-left: 24px; padding-right: 24px; border-radius: var(--radius-sm); }
        .toggle-group:last-child { border-bottom:none; }
        .toggle-info { display:flex; flex-direction:column; gap: 3px; }
        .toggle-label { font-size: 13px; font-weight: 700; color: var(--text-primary); }
        .toggle-desc { font-size: 11px; color: var(--text-tertiary); font-weight: 500; }
        .toggle-switch { position:relative; width: 48px; height: 26px; flex-shrink:0; }
        .toggle-switch input { opacity:0; width:0; height:0; }
        .toggle-slider {
            position:absolute;
            cursor:pointer;
            inset:0;
            background: var(--border);
            transition: background 0.3s;
            border-radius: 26px;
        }
        .toggle-slider::before {
            content:'';
            position:absolute;
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background: var(--surface);
            transition: transform 0.3s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
            border-radius: 50%;
        }
        .toggle-switch input:checked + .toggle-slider { background: var(--accent-mint); }
        .toggle-switch input:checked + .toggle-slider::before { transform: translateX(22px); }

        /* ===== SEGURIDAD ===== */
        .security-section { margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-light); }
        .security-title {
            font-family: 'DM Sans', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
            letter-spacing: -0.2px;
        }
        .security-desc { font-size: 12px; color: var(--text-secondary); margin-bottom: 16px; font-weight: 500; }

        /* ===== FOOTER ===== */
        .page-footer {
            padding: 10px var(--gutter);
            width:100%;
            border-top: 1px solid var(--border-light);
            display:flex;
            align-items:center;
            justify-content:space-between;
            font-size: 11px;
            font-weight: 600;
            color: var(--text-tertiary);
            background: var(--surface);
        }
        .footer-links { display:flex; gap: 24px; }
        .footer-links a { color: var(--text-tertiary); text-decoration:none; transition: color 0.2s; }
        .footer-links a:hover { color: var(--primary); }

        /* ===== ANIMACIONES ===== */
        @keyframes fadeInUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-in { animation:fadeInUp 0.6s cubic-bezier(0.22,1,0.36,1) forwards; opacity:0; }
        .delay-1 { animation-delay:0.1s; }
        .delay-2 { animation-delay:0.2s; }

        /* ===== RESPONSIVE ===== */
        @media(max-width:1024px){
            .main-content { margin-left:0; }
            .sidebar-toggle { display:flex; }
            .profile-grid { grid-template-columns:1fr; height:auto; min-height:calc(100vh - 180px); }
            .profile-card { max-width:400px; margin:0 auto; }
        }
        @media(max-width:768px){
            .header-title h1 { font-size:20px; }
            .form-grid { grid-template-columns:1fr; }
            .form-tabs { overflow-x:auto; }
            .form-tab { white-space:nowrap; }
        }
        @media(max-width:480px){
            .page-header, .profile-container, .page-footer { padding-left:20px; padding-right:20px; }
            .form-tab-content { padding:20px 16px; }
        }
    </style>
</head>
<body>

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()">
        <span class="material-symbols-outlined">menu</span>
    </button>

    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

        <main class="main-content">

            <header class="page-header animate-in">
                <nav class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/usuario/dashboard">Inicio</a>
                    <span class="material-symbols-outlined">chevron_right</span>
                    <span>Mi Perfil</span>
                </nav>
                <div class="header-row">
                    <div class="header-title">
                        <h1>Mi Perfil</h1>
                        <p class="header-subtitle">Gestiona tu información personal y preferencias de cuenta.</p>
                    </div>
                </div>
            </header>

            <%-- Mensajes flash --%>
            <c:if test="${not empty mensajeExito}">
                <div class="alert alert-success" style="margin-left:var(--gutter);margin-right:var(--gutter)">
                    <span class="material-symbols-outlined">check_circle</span>
                    ${mensajeExito}
                </div>
            </c:if>
            <c:if test="${not empty mensajeError}">
                <div class="alert alert-error" style="margin-left:var(--gutter);margin-right:var(--gutter)">
                    <span class="material-symbols-outlined">error</span>
                    ${mensajeError}
                </div>
            </c:if>

            <div class="profile-container">
                <div class="profile-grid">

                    <%-- ═══ CARD LATERAL ═══ --%>
                    <aside class="profile-card animate-in delay-1">
                        <div class="profile-card-header">
                            <div class="profile-cover"></div>
                            <div class="profile-avatar-wrapper">
                                <div class="profile-avatar" id="avatarPreview">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                                            <img src="${pageContext.request.contextPath}/uploads/perfiles/${sessionScope.usuario.fotoPerfil}" alt="Foto de perfil">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined">person</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <label for="fotoInput" class="avatar-edit-btn" title="Cambiar foto">
                                    <span class="material-symbols-outlined">photo_camera</span>
                                </label>
                            </div>
                            <h2 class="profile-name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</h2>
                            <span class="profile-role">
                                <span class="material-symbols-outlined">verified</span>
                                <c:choose>
                                    <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                                    <c:when test="${sessionScope.usuario.idRol == 2}">Comprador</c:when>
                                    <c:otherwise>Usuario</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="profile-card-body">
                            <ul class="profile-info-list">
                                <li class="profile-info-item">
                                    <div class="profile-info-icon"><span class="material-symbols-outlined">mail</span></div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Correo</div>
                                        <div class="profile-info-value">${sessionScope.usuario.email}</div>
                                    </div>
                                </li>
                                <li class="profile-info-item">
                                    <div class="profile-info-icon"><span class="material-symbols-outlined">badge</span></div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Documento</div>
                                        <div class="profile-info-value">${sessionScope.usuario.documento}</div>
                                    </div>
                                </li>
                                <li class="profile-info-item">
                                    <div class="profile-info-icon"><span class="material-symbols-outlined">person_outline</span></div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Usuario</div>
                                        <div class="profile-info-value">${sessionScope.usuario.userName}</div>
                                    </div>
                                </li>
                            </ul>
                        </div>

                        <div class="profile-card-footer">
                            <button type="button" class="profile-btn profile-btn-outline" onclick="activarTabFoto()">
                                <span class="material-symbols-outlined">upload</span>
                                Subir foto
                            </button>
                            <a href="${pageContext.request.contextPath}/logout" class="profile-btn profile-btn-danger">
                                <span class="material-symbols-outlined">logout</span>
                                Salir
                            </a>
                        </div>
                    </aside>

                    <%-- ═══ PANEL FORMULARIO ═══ --%>
                    <div class="form-panel animate-in delay-2">

                        <div class="form-tabs">
                            <button type="button" class="form-tab active" data-tab="info">
                                <span class="material-symbols-outlined">person</span>Información
                            </button>
                            <button type="button" class="form-tab" data-tab="foto">
                                <span class="material-symbols-outlined">photo_camera</span>Foto
                            </button>
                            <button type="button" class="form-tab" data-tab="seguridad">
                                <span class="material-symbols-outlined">lock</span>Seguridad
                            </button>
                            <button type="button" class="form-tab" data-tab="preferencias">
                                <span class="material-symbols-outlined">settings</span>Preferencias
                            </button>
                        </div>

                        <%-- TAB: INFORMACIÓN --%>
                        <div class="form-tab-content active" id="tab-info">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="actualizarInfo">
                                <input type="hidden" name="id" value="${sessionScope.usuario.id}">

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label class="form-label">Nombre <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">person</span></span>
                                            <input type="text" name="nombre" class="form-input" value="${sessionScope.usuario.nombre}" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Apellido <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">person</span></span>
                                            <input type="text" name="apellido" class="form-input" value="${sessionScope.usuario.apellido}" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Correo electrónico <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">mail</span></span>
                                            <input type="email" name="email" class="form-input" value="${sessionScope.usuario.email}" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Nombre de usuario <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">alternate_email</span></span>
                                            <input type="text" name="userName" class="form-input" value="${sessionScope.usuario.userName}" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Documento / ID</label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">badge</span></span>
                                            <c:choose>
                                                <c:when test="${sessionScope.usuario.idRol == 1}">
                                                    <input type="text" name="documento" class="form-input" value="${sessionScope.usuario.documento}">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" class="form-input" value="${sessionScope.usuario.documento}" disabled>
                                                    <input type="hidden" name="documento" value="${sessionScope.usuario.documento}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${sessionScope.usuario.idRol != 1}">
                                            <span class="form-hint">El documento solo puede ser modificado por un administrador.</span>
                                        </c:if>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Rol</label>
                                        <c:choose>
                                            <c:when test="${sessionScope.usuario.idRol == 1}">
                                                <div class="input-with-icon">
                                                    <span class="input-icon"><span class="material-symbols-outlined">admin_panel_settings</span></span>
                                                    <input type="text" class="form-input" disabled value="Administrador">
                                                    <input type="hidden" name="idRol" value="1">
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="input-with-icon">
                                                    <span class="input-icon"><span class="material-symbols-outlined">admin_panel_settings</span></span>
                                                    <select name="idRol" class="form-input" style="padding-left:44px;">
                                                        <option value="3" ${sessionScope.usuario.idRol == 3 ? 'selected' : ''}>Usuario</option>
                                                        <option value="2" ${sessionScope.usuario.idRol == 2 ? 'selected' : ''}>Comprador</option>
                                                    </select>
                                                </div>
                                                <span class="form-hint">Como Usuario accedes a funciones de estilo. Como Comprador puedes agregar al carrito.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>Restablecer
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>Guardar cambios
                                    </button>
                                </div>
                            </form>
                        </div>

                        <%-- TAB: FOTO --%>
                        <div class="form-tab-content" id="tab-foto">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST"
                                  enctype="multipart/form-data" id="formFoto">
                                <input type="hidden" name="accion" value="subirFoto">

                                <p style="font-size:13px;color:var(--text-secondary);margin-bottom:16px;font-weight:500;">
                                    Sube una imagen para tu perfil. Máximo <strong>5 MB</strong>. Formatos permitidos: JPG, PNG, WEBP.
                                </p>

                                <div class="upload-foto-area" id="dropZone" onclick="document.getElementById('fotoInput').click()">
                                    <span class="material-symbols-outlined">cloud_upload</span>
                                    <p>Haz clic para seleccionar o arrastra una imagen aquí</p>
                                    <small>JPG, PNG, WEBP — máx. 5 MB</small>
                                </div>

                                <input type="file" name="foto" id="fotoInput" accept="image/*" style="display:none">

                                <div class="foto-preview" id="fotoPreview">
                                    <img id="fotoPreviewImg" src="" alt="Vista previa">
                                    <p id="fotoPreviewNombre"></p>
                                </div>

                                <div class="form-actions">
                                    <button type="button" class="btn btn-secondary" onclick="limpiarFoto()">
                                        <span class="material-symbols-outlined">close</span>Cancelar
                                    </button>
                                    <button type="submit" class="btn btn-primary" id="btnSubirFoto" disabled>
                                        <span class="material-symbols-outlined">upload</span>Subir foto
                                    </button>
                                </div>
                            </form>
                        </div>

                        <%-- TAB: SEGURIDAD --%>
                        <div class="form-tab-content" id="tab-seguridad">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="cambiarPassword">
                                <input type="hidden" name="id" value="${sessionScope.usuario.id}">

                                <div class="form-grid">
                                    <div class="form-group full-width">
                                        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:6px;">
                                            <label class="form-label" style="margin-bottom:0">Contraseña actual <span class="required">*</span></label>
                                            <a href="${pageContext.request.contextPath}/recuperar"
                                               style="font-size:12px; color:var(--accent-sky); font-weight:700; text-decoration:none;">
                                                ¿Olvidaste tu contraseña?
                                            </a>
                                        </div>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">lock</span></span>
                                            <input type="password" name="passwordActual" class="form-input"
                                                   placeholder="Tu contraseña actual" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Nueva contraseña <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">lock_open</span></span>
                                            <input type="password" name="passwordNueva" id="pwNueva" class="form-input" placeholder="Mínimo 8 caracteres" minlength="8" required>
                                        </div>
                                        <span class="form-hint">Debe incluir mayúsculas, minúsculas y números.</span>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Confirmar contraseña <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <span class="input-icon"><span class="material-symbols-outlined">lock_reset</span></span>
                                            <input type="password" name="passwordConfirmar" id="pwConfirmar" class="form-input" placeholder="Repite la contraseña" minlength="8" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>Cancelar
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>Actualizar contraseña
                                    </button>
                                </div>
                            </form>
                        </div>

                        <%-- TAB: PREFERENCIAS --%>
                        <div class="form-tab-content" id="tab-preferencias">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="actualizarPreferencias">

                                <div style="margin-bottom:8px">
                                    <h3 style="font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);margin-bottom:4px;letter-spacing:-0.2px;">Notificaciones</h3>
                                    <p style="font-size:12px;color:var(--text-secondary);font-weight:500;">Configura cómo y cuándo quieres recibirlas.</p>
                                </div>

                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Notificaciones por correo</span>
                                        <span class="toggle-desc">Recibe actualizaciones en tu correo electrónico.</span>
                                    </div>
                                    <label class="toggle-switch">
                                        <input type="checkbox" name="notificacionesEmail" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Notificaciones push</span>
                                        <span class="toggle-desc">Recibe notificaciones en tu navegador.</span>
                                    </div>
                                    <label class="toggle-switch">
                                        <input type="checkbox" name="notificacionesPush">
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Resumen semanal</span>
                                        <span class="toggle-desc">Recibe un resumen de actividad cada lunes.</span>
                                    </div>
                                    <label class="toggle-switch">
                                        <input type="checkbox" name="resumenSemanal" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>Restablecer
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>Guardar preferencias
                                    </button>
                                </div>
                            </form>
                        </div>

                    </div><%-- /form-panel --%>
                </div><%-- /profile-grid --%>
            </div><%-- /profile-container --%>

            <footer class="page-footer">
                <span>&copy; 2026 Quiddity. Todos los derechos reservados.</span>
                <div class="footer-links">
                    <a href="#">Ayuda</a>
                    <a href="#">Privacidad</a>
                    <a href="#">Términos</a>
                </div>
            </footer>

        </main>
    </div>

    <script>
        // ── Tabs ──────────────────────────────────────────────
        const tabActiva = '${not empty tabActiva ? tabActiva : ""}';

        function activarTab(nombre) {
            document.querySelectorAll('.form-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.form-tab-content').forEach(c => c.classList.remove('active'));
            document.querySelector('[data-tab="' + nombre + '"]').classList.add('active');
            document.getElementById('tab-' + nombre).classList.add('active');
        }

        document.querySelectorAll('.form-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                activarTab(this.dataset.tab);
            });
        });

        if (tabActiva) activarTab(tabActiva);

        function activarTabFoto() { activarTab('foto'); }

        // ── Preview foto ──────────────────────────────────────
        const fotoInput    = document.getElementById('fotoInput');
        const fotoPreview  = document.getElementById('fotoPreview');
        const previewImg   = document.getElementById('fotoPreviewImg');
        const previewNombre= document.getElementById('fotoPreviewNombre');
        const btnSubir     = document.getElementById('btnSubirFoto');
        const avatarPreview= document.getElementById('avatarPreview');

        fotoInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) return;

            if (file.size > 5 * 1024 * 1024) {
                alert('La imagen supera el límite de 5 MB.');
                limpiarFoto();
                return;
            }
            if (!file.type.startsWith('image/')) {
                alert('Por favor selecciona una imagen válida.');
                limpiarFoto();
                return;
            }

            const reader = new FileReader();
            reader.onload = function(ev) {
                previewImg.src = ev.target.result;
                previewNombre.textContent = file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
                fotoPreview.style.display = 'block';
                btnSubir.disabled = false;

                avatarPreview.innerHTML = '<img src="' + ev.target.result + '" alt="Vista previa">';
            };
            reader.readAsDataURL(file);
        });

        // Drag & Drop
        const dropZone = document.getElementById('dropZone');
        dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.style.borderColor = 'var(--accent-sky)'; dropZone.style.background = 'var(--pastel-sky)'; });
        dropZone.addEventListener('dragleave', () => { dropZone.style.borderColor = ''; dropZone.style.background = ''; });
        dropZone.addEventListener('drop', e => {
            e.preventDefault();
            dropZone.style.borderColor = '';
            dropZone.style.background = '';
            const file = e.dataTransfer.files[0];
            if (file) {
                const dt = new DataTransfer();
                dt.items.add(file);
                fotoInput.files = dt.files;
                fotoInput.dispatchEvent(new Event('change'));
            }
        });

        function limpiarFoto() {
            fotoInput.value = '';
            fotoPreview.style.display = 'none';
            previewImg.src = '';
            previewNombre.textContent = '';
            btnSubir.disabled = true;
        }

        // ── Sidebar móvil ─────────────────────────────────────
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            if (sidebar) sidebar.classList.toggle('open');
        }
    </script>

</body>
</html>