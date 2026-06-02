<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Página activa para el sidebar --%>
<c:set var="activePage" value="perfil" scope="request" />

<%-- ============================================================
     DATOS DEL USUARIO - Reemplazar con tu bean/DAO real
     En producción estos vienen del Servlet que hace forward
     ============================================================ --%>
<c:if test="${empty sessionScope.usuario}">
    <%-- Redirigir al login si no hay sesión --%>
    <% response.sendRedirect(request.getContextPath() + "/login.jsp"); %>
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil | Belleza</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;600&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Material Symbols -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />

    <style>
        /* ═══════════════════════════════════════════════
           VARIABLES DEL TEMA
           ═══════════════════════════════════════════════ */
        :root {
            --primary: #9a3a5a;
            --primary-light: rgba(154, 58, 90, 0.08);
            --primary-medium: rgba(154, 58, 90, 0.15);
            --primary-dark: #7a2e48;
            --secondary: #516617;
            --tertiary: #88495a;
            --background: #ffffff;
            --surface: #ffffff;
            --on-surface: #1c1b1d;
            --on-surface-variant: #544246;
            --outline: #877276;
            --surface-container-low: #ffffff;
            --surface-container-lowest: #ffffff;
            --surface-variant: #f1ecef;
            --surface-variant-hover: #e8e3e6;
            --success: #516617;
            --warning: #c47e00;
            --error: #b3261e;
            --error-light: rgba(179, 38, 30, 0.08);
            --element-gap: 24px;
            --gutter: 32px;
            --radius: 0px;
            --radius-full: 9999px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Manrope', sans-serif;
            background: var(--background);
            color: var(--on-surface);
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        /* ═══════════════════════════════════════════════
           LAYOUT CON SIDEBAR
           ═══════════════════════════════════════════════ */
        .layout-wrapper { display: flex; min-height: 100vh; }
        .main-content {
            flex: 1;
            margin-left: 280px;
            min-height: 100vh;
            background: var(--background);
        }

        .sidebar-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 998;
            width: 44px;
            height: 44px;
            background: var(--surface);
            border: 1px solid var(--surface-variant);
            color: var(--on-surface);
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        /* ═══════════════════════════════════════════════
           HEADER DE PÁGINA
           ═══════════════════════════════════════════════ */
        .page-header {
            padding: 40px var(--gutter) 0;
            max-width: 1200px;
            margin: 0 auto;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--outline);
            letter-spacing: 0.02em;
            margin-bottom: 16px;
        }
        .breadcrumb .material-symbols-outlined { font-size: 16px; }
        .breadcrumb a {
            color: var(--outline);
            text-decoration: none;
            transition: color 0.2s;
        }
        .breadcrumb a:hover { color: var(--primary); }

        .header-row {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: var(--element-gap);
            flex-wrap: wrap;
            margin-bottom: 40px;
        }

        .header-title h1 {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 48px;
            font-weight: 400;
            line-height: 56px;
            color: var(--on-surface);
            margin-bottom: 8px;
        }
        .header-subtitle {
            font-size: 16px;
            color: var(--on-surface-variant);
            line-height: 24px;
        }

        /* ═══════════════════════════════════════════════
           ALERTAS / MENSAJES
           ═══════════════════════════════════════════════ */
        .alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 24px;
            margin: 0 var(--gutter) 24px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            font-size: 14px;
            font-weight: 500;
            animation: slideDown 0.4s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .alert-success {
            background: rgba(81, 102, 23, 0.08);
            border-left: 3px solid var(--success);
            color: var(--success);
        }
        .alert-error {
            background: var(--error-light);
            border-left: 3px solid var(--error);
            color: var(--error);
        }
        .alert .material-symbols-outlined { font-size: 20px; flex-shrink: 0; }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ═══════════════════════════════════════════════
           GRID DE PERFIL
           ═══════════════════════════════════════════════ */
        .profile-container {
            padding: 0 var(--gutter) 48px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .profile-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: var(--element-gap);
            align-items: start;
        }

        /* ═══════════════════════════════════════════════
           CARD LATERAL (INFO DEL USUARIO)
           ═══════════════════════════════════════════════ */
        .profile-card {
            background: var(--surface);
            border: 1px solid var(--surface-variant);
            overflow: hidden;
        }
        .profile-card-header {
            padding: 32px;
            text-align: center;
            border-bottom: 1px solid var(--surface-variant);
            position: relative;
        }
        .profile-cover {
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 80px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--tertiary) 100%);
        }
        .profile-avatar-wrapper {
            position: relative;
            display: inline-block;
            margin-top: 24px;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border: 4px solid var(--surface);
            background: var(--surface-variant);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .profile-avatar .material-symbols-outlined {
            font-size: 56px;
            color: var(--outline);
        }
        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .avatar-edit-btn {
            position: absolute;
            bottom: 4px;
            right: 4px;
            width: 36px;
            height: 36px;
            background: var(--primary);
            border: 3px solid var(--surface);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.2s;
        }
        .avatar-edit-btn:hover { background: var(--primary-dark); }
        .avatar-edit-btn .material-symbols-outlined { font-size: 18px !important; }

        .profile-name {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 24px;
            font-weight: 400;
            line-height: 32px;
            color: var(--on-surface);
            margin-top: 16px;
        }
        .profile-role {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 6px;
            padding: 4px 14px;
            background: var(--primary-light);
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--primary);
        }
        .profile-role .material-symbols-outlined { font-size: 14px; }

        .profile-card-body { padding: 24px 28px; }
        .profile-info-list { list-style: none; }
        .profile-info-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--surface-variant);
        }
        .profile-info-item:last-child { border-bottom: none; padding-bottom: 0; }
        .profile-info-item:first-child { padding-top: 0; }
        .profile-info-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--surface-variant);
            flex-shrink: 0;
        }
        .profile-info-icon .material-symbols-outlined { font-size: 18px; color: var(--primary); }
        .profile-info-content { min-width: 0; }
        .profile-info-label {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--outline);
            margin-bottom: 2px;
        }
        .profile-info-value {
            font-size: 14px;
            font-weight: 500;
            color: var(--on-surface);
            word-break: break-word;
        }

        .profile-card-footer {
            padding: 20px 28px;
            border-top: 1px solid var(--surface-variant);
            display: flex;
            gap: 8px;
        }
        .profile-btn {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 16px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            line-height: 20px;
        }
        .profile-btn-outline {
            background: none;
            border: 1px solid var(--outline);
            color: var(--on-surface);
        }
        .profile-btn-outline:hover { background: var(--surface-variant); }
        .profile-btn-danger {
            background: none;
            border: 1px solid var(--error);
            color: var(--error);
        }
        .profile-btn-danger:hover { background: var(--error-light); }
        .profile-btn .material-symbols-outlined { font-size: 16px; }

        /* ═══════════════════════════════════════════════
           PANEL DE FORMULARIO
           ═══════════════════════════════════════════════ */
        .form-panel {
            background: var(--surface);
            border: 1px solid var(--surface-variant);
        }
        .form-tabs {
            display: flex;
            border-bottom: 1px solid var(--surface-variant);
        }
        .form-tab {
            padding: 16px 28px;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
            font-weight: 600;
            color: var(--outline);
            background: none;
            border: none;
            border-bottom: 2px solid transparent;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-tab:hover { color: var(--on-surface-variant); }
        .form-tab.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }
        .form-tab .material-symbols-outlined { font-size: 18px; }

        .form-tab-content {
            display: none;
            padding: 32px 28px;
        }
        .form-tab-content.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ═══════════════════════════════════════════════
           FORMULARIOS
           ═══════════════════════════════════════════════ */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px 24px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--on-surface);
            letter-spacing: 0.02em;
        }
        .form-label .required { color: var(--error); margin-left: 2px; }
        .form-hint {
            font-size: 12px;
            color: var(--outline);
            margin-top: 2px;
        }

        .form-input,
        .form-select,
        .form-textarea {
            padding: 12px 16px;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
            color: var(--on-surface);
            background: var(--surface);
            border: 1px solid var(--outline);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            line-height: 20px;
        }
        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-light);
        }
        .form-input::placeholder,
        .form-textarea::placeholder { color: var(--outline); }
        .form-input:disabled,
        .form-select:disabled {
            background: var(--surface-variant);
            color: var(--outline);
            cursor: not-allowed;
        }
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%23877276' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 40px;
        }

        .input-with-icon { position: relative; }
        .input-with-icon .form-input { padding-left: 44px; }
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--outline);
        }
        .input-icon .material-symbols-outlined { font-size: 18px; }

        /* Toggle switch */
        .toggle-group {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 0;
            border-bottom: 1px solid var(--surface-variant);
        }
        .toggle-group:last-child { border-bottom: none; }
        .toggle-info { display: flex; flex-direction: column; gap: 2px; }
        .toggle-label { font-size: 14px; font-weight: 600; color: var(--on-surface); }
        .toggle-desc { font-size: 12px; color: var(--outline); }
        .toggle-switch {
            position: relative;
            width: 48px;
            height: 26px;
            flex-shrink: 0;
        }
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            inset: 0;
            background: var(--surface-variant);
            transition: background 0.3s;
        }
        .toggle-slider::before {
            content: '';
            position: absolute;
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background: var(--surface);
            transition: transform 0.3s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
        }
        .toggle-switch input:checked + .toggle-slider { background: var(--primary); }
        .toggle-switch input:checked + .toggle-slider::before { transform: translateX(22px); }

        /* ═══════════════════════════════════════════════
           BOTONES DEL FORMULARIO
           ═══════════════════════════════════════════════ */
        .form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 24px;
            border-top: 1px solid var(--surface-variant);
            margin-top: 8px;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            line-height: 20px;
        }
        .btn-primary {
            background: var(--primary);
            color: #ffffff;
        }
        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(154, 58, 90, 0.25);
        }
        .btn-secondary {
            background: var(--surface-variant);
            color: var(--on-surface);
            border: 1px solid var(--outline);
        }
        .btn-secondary:hover { background: var(--surface-variant-hover); }
        .btn .material-symbols-outlined { font-size: 18px; }

        /* ═══════════════════════════════════════════════
           SECCIÓN DE SEGURIDAD (CONTRASEÑA)
           ═══════════════════════════════════════════════ */
        .security-section {
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid var(--surface-variant);
        }
        .security-title {
            font-family: 'EB Garamond', Georgia, serif;
            font-size: 24px;
            font-weight: 400;
            line-height: 32px;
            color: var(--on-surface);
            margin-bottom: 4px;
        }
        .security-desc {
            font-size: 14px;
            color: var(--on-surface-variant);
            margin-bottom: 24px;
        }

        /* ═══════════════════════════════════════════════
           FOOTER
           ═══════════════════════════════════════════════ */
        .page-footer {
            padding: 32px var(--gutter);
            max-width: 1200px;
            margin: 0 auto;
            border-top: 1px solid var(--surface-variant);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
            color: var(--outline);
        }
        .footer-links { display: flex; gap: 24px; }
        .footer-links a {
            color: var(--outline);
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-links a:hover { color: var(--primary); }

        /* ═══════════════════════════════════════════════
           ANIMACIONES
           ═══════════════════════════════════════════════ */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-in {
            animation: fadeInUp 0.6s cubic-bezier(0.22, 1, 0.36, 1) forwards;
            opacity: 0;
        }
        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        .delay-3 { animation-delay: 0.3s; }

        /* ═══════════════════════════════════════════════
           RESPONSIVE
           ═══════════════════════════════════════════════ */
        @media (max-width: 1024px) {
            .main-content { margin-left: 0; }
            .sidebar-toggle { display: flex; }
            .profile-grid { grid-template-columns: 1fr; }
            .profile-card { max-width: 400px; margin: 0 auto; }
        }
        @media (max-width: 768px) {
            .header-title h1 { font-size: 32px; line-height: 40px; }
            .form-grid { grid-template-columns: 1fr; }
            .form-tabs { overflow-x: auto; -webkit-overflow-scrolling: touch; }
            .form-tab { white-space: nowrap; }
            .page-footer { flex-direction: column; gap: 12px; text-align: center; }
        }
        @media (max-width: 480px) {
            .page-header,
            .profile-container,
            .page-footer { padding-left: 20px; padding-right: 20px; }
            .form-tab-content { padding: 24px 20px; }
            .profile-card-header,
            .profile-card-body,
            .profile-card-footer { padding-left: 20px; padding-right: 20px; }
        }
    </style>
</head>
<body>

    <!-- Botón hamburguesa para móvil -->
    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()">
        <span class="material-symbols-outlined">menu</span>
    </button>

    <div class="layout-wrapper">
        <!-- Sidebar -->
        <%@ include file="/includes/sidebar.jsp" %>

        <!-- Contenido Principal -->
        <main class="main-content">

            <!-- ═══════════════════════════════════════════════
                 HEADER
                 ═══════════════════════════════════════════════ -->
            <header class="page-header animate-in">
                <nav class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp">Inicio</a>
                    <span class="material-symbols-outlined">chevron_right</span>
                    <span>Mi Perfil</span>
                </nav>

                <div class="header-row">
                    <div class="header-title">
                        <h1>Mi Perfil</h1>
                        <p class="header-subtitle">
                            Gestiona tu información personal y preferencias de cuenta.
                        </p>
                    </div>
                </div>
            </header>

            <!-- ═══════════════════════════════════════════════
                 ALERTAS
                 ═══════════════════════════════════════════════ -->
            <c:if test="${not empty requestScope.mensajeExito}">
            <div class="alert alert-success">
                <span class="material-symbols-outlined">check_circle</span>
                ${requestScope.mensajeExito}
            </div>
            </c:if>

            <c:if test="${not empty requestScope.mensajeError}">
            <div class="alert alert-error">
                <span class="material-symbols-outlined">error</span>
                ${requestScope.mensajeError}
            </div>
            </c:if>

            <!-- ═══════════════════════════════════════════════
                 CONTENIDO DEL PERFIL
                 ═══════════════════════════════════════════════ -->
            <div class="profile-container">
                <div class="profile-grid">

                    <!-- ═══════════════════════════════════════
                         CARD LATERAL: INFO DEL USUARIO
                         ═══════════════════════════════════════ -->
                    <aside class="profile-card animate-in delay-1">
                        <div class="profile-card-header">
                            <div class="profile-cover"></div>
                            <div class="profile-avatar-wrapper">
                                <div class="profile-avatar">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                                            <img src="${pageContext.request.contextPath}/uploads/${sessionScope.usuario.fotoPerfil}" alt="Foto de perfil">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined">person</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <label for="avatar-input" class="avatar-edit-btn" title="Cambiar foto">
                                    <span class="material-symbols-outlined">photo_camera</span>
                                </label>
                                <input type="file" id="avatar-input" accept="image/*" style="display: none;">
                            </div>
                            <h2 class="profile-name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</h2>
                            <span class="profile-role">
                                <span class="material-symbols-outlined">verified</span>
                                <c:choose>
                                    <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                                    <c:when test="${sessionScope.usuario.idRol == 2}">Comprador</c:when>
                                    <c:when test="${sessionScope.usuario.idRol == 3}">Usuario</c:when>
                                    <c:otherwise>Sin rol</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="profile-card-body">
                            <ul class="profile-info-list">
                                <li class="profile-info-item">
                                    <div class="profile-info-icon">
                                        <span class="material-symbols-outlined">mail</span>
                                    </div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Correo electrónico</div>
                                        <div class="profile-info-value">${sessionScope.usuario.email}</div>
                                    </div>
                                </li>
                                <li class="profile-info-item">
                                    <div class="profile-info-icon">
                                        <span class="material-symbols-outlined">badge</span>
                                    </div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Documento</div>
                                        <div class="profile-info-value">${sessionScope.usuario.documento}</div>
                                    </div>
                                </li>
                                <li class="profile-info-item">
                                    <div class="profile-info-icon">
                                        <span class="material-symbols-outlined">person_outline</span>
                                    </div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">Usuario</div>
                                        <div class="profile-info-value">${sessionScope.usuario.userName}</div>
                                    </div>
                                </li>
                                <li class="profile-info-item">
                                    <div class="profile-info-icon">
                                        <span class="material-symbols-outlined">calendar_today</span>
                                    </div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">ID de usuario</div>
                                        <div class="profile-info-value">#${sessionScope.usuario.id}</div>
                                    </div>
                                </li>
                            </ul>
                        </div>

                        <div class="profile-card-footer">
                            <button type="button" class="profile-btn profile-btn-outline" onclick="document.getElementById('avatar-input').click()">
                                <span class="material-symbols-outlined">upload</span>
                                Subir foto
                            </button>
                            <a href="${pageContext.request.contextPath}/logout" class="profile-btn profile-btn-danger">
                                <span class="material-symbols-outlined">logout</span>
                                Salir
                            </a>
                        </div>
                    </aside>

                    <!-- ═══════════════════════════════════════
                         PANEL DE FORMULARIO (TABS)
                         ═══════════════════════════════════════ -->
                    <div class="form-panel animate-in delay-2">

                        <!-- Tabs -->
                        <div class="form-tabs">
                            <button type="button" class="form-tab active" data-tab="info">
                                <span class="material-symbols-outlined">person</span>
                                Información
                            </button>
                            <button type="button" class="form-tab" data-tab="seguridad">
                                <span class="material-symbols-outlined">lock</span>
                                Seguridad
                            </button>
                            <button type="button" class="form-tab" data-tab="preferencias">
                                <span class="material-symbols-outlined">settings</span>
                                Preferencias
                            </button>
                        </div>

                        <!-- TAB: INFORMACIÓN PERSONAL -->
                        <div class="form-tab-content active" id="tab-info">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="actualizarInfo">
                                <input type="hidden" name="id" value="${sessionScope.usuario.id}">

                                <div class="form-grid">
                                    <!-- Nombre -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Nombre <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">person</span>
                                            </span>
                                            <input type="text" name="nombre" class="form-input" 
                                                   value="${sessionScope.usuario.nombre}" placeholder="Tu nombre" required>
                                        </div>
                                    </div>

                                    <!-- Apellido -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Apellido <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">person</span>
                                            </span>
                                            <input type="text" name="apellido" class="form-input" 
                                                   value="${sessionScope.usuario.apellido}" placeholder="Tu apellido" required>
                                        </div>
                                    </div>

                                    <!-- Correo electrónico -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Correo electrónico <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">mail</span>
                                            </span>
                                            <input type="email" name="email" class="form-input" 
                                                   value="${sessionScope.usuario.email}" placeholder="tu@email.com" required>
                                        </div>
                                    </div>

                                    <!-- Username -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Nombre de usuario <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">alternate_email</span>
                                            </span>
                                            <input type="text" name="userName" class="form-input" 
                                                   value="${sessionScope.usuario.userName}" placeholder="@usuario" required>
                                        </div>
                                    </div>

                                    <!-- Documento -->
                                    <div class="form-group">
                                        <label class="form-label">Documento / ID</label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">badge</span>
                                            </span>
                                            <input type="text" name="documento" class="form-input" 
                                                   value="${sessionScope.usuario.documento}" placeholder="Número de documento">
                                        </div>
                                    </div>

                                    <!-- Rol (solo lectura) -->
                                    <div class="form-group">
                                        <label class="form-label">Rol</label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">admin_panel_settings</span>
                                            </span>
                                            <input type="text" class="form-input" disabled
                                                   value="<c:choose><c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when><c:when test="${sessionScope.usuario.idRol == 2}">Comprador</c:when><c:when test="${sessionScope.usuario.idRol == 3}">Usuario</c:when><c:otherwise>Sin rol</c:otherwise></c:choose>">
                                        </div>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>
                                        Restablecer
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>
                                        Guardar cambios
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- TAB: SEGURIDAD -->
                        <div class="form-tab-content" id="tab-seguridad">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="cambiarPassword">
                                <input type="hidden" name="id" value="${sessionScope.usuario.id}">

                                <div class="form-grid">
                                    <!-- Contraseña actual -->
                                    <div class="form-group full-width">
                                        <label class="form-label">
                                            Contraseña actual <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">lock</span>
                                            </span>
                                            <input type="password" name="passwordActual" class="form-input" 
                                                   placeholder="Ingresa tu contraseña actual" required>
                                        </div>
                                    </div>

                                    <!-- Nueva contraseña -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Nueva contraseña <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">lock_open</span>
                                            </span>
                                            <input type="password" name="passwordNueva" class="form-input" 
                                                   placeholder="Mínimo 8 caracteres" minlength="8" required>
                                        </div>
                                        <span class="form-hint">Debe incluir mayúsculas, minúsculas y números.</span>
                                    </div>

                                    <!-- Confirmar contraseña -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Confirmar contraseña <span class="required">*</span>
                                        </label>
                                        <div class="input-with-icon">
                                            <span class="input-icon">
                                                <span class="material-symbols-outlined">lock_reset</span>
                                            </span>
                                            <input type="password" name="passwordConfirmar" class="form-input" 
                                                   placeholder="Repite la nueva contraseña" minlength="8" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="security-section">
                                    <h3 class="security-title">Sesiones activas</h3>
                                    <p class="security-desc">Estos son los dispositivos que han iniciado sesión en tu cuenta.</p>

                                    <div style="border: 1px solid var(--surface-variant); padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
                                        <div style="display: flex; align-items: center; gap: 14px;">
                                            <span class="material-symbols-outlined" style="font-size: 24px; color: var(--primary);">computer</span>
                                            <div>
                                                <div style="font-weight: 600; font-size: 14px;">Windows — Chrome</div>
                                                <div style="font-size: 12px; color: var(--outline);">Ciudad de México, MX • Actual</div>
                                            </div>
                                        </div>
                                        <span style="font-size: 12px; font-weight: 600; color: var(--success); padding: 4px 10px; background: rgba(81,102,23,0.08);">Activa</span>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>
                                        Cancelar
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>
                                        Actualizar contraseña
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- TAB: PREFERENCIAS -->
                        <div class="form-tab-content" id="tab-preferencias">
                            <form action="${pageContext.request.contextPath}/perfil" method="POST">
                                <input type="hidden" name="accion" value="actualizarPreferencias">

                                <div style="margin-bottom: 8px;">
                                    <h3 style="font-family: 'EB Garamond', Georgia, serif; font-size: 24px; font-weight: 400; line-height: 32px; color: var(--on-surface); margin-bottom: 4px;">Notificaciones</h3>
                                    <p style="font-size: 14px; color: var(--on-surface-variant);">Configura cómo y cuándo quieres recibir notificaciones.</p>
                                </div>

                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Notificaciones por correo</span>
                                        <span class="toggle-desc">Recibe actualizaciones y alertas en tu correo electrónico.</span>
                                    </div>
                                    <label class="toggle-switch">
                                        <input type="checkbox" name="notificacionesEmail" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>

                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Notificaciones push</span>
                                        <span class="toggle-desc">Recibe notificaciones en tu navegador o dispositivo móvil.</span>
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

                                <div style="margin-top: 32px; margin-bottom: 8px;">
                                    <h3 style="font-family: 'EB Garamond', Georgia, serif; font-size: 24px; font-weight: 400; line-height: 32px; color: var(--on-surface); margin-bottom: 4px;">Apariencia</h3>
                                    <p style="font-size: 14px; color: var(--on-surface-variant);">Personaliza la apariencia de la interfaz.</p>
                                </div>

                                <div class="toggle-group">
                                    <div class="toggle-info">
                                        <span class="toggle-label">Modo oscuro</span>
                                        <span class="toggle-desc">Usa un tema oscuro para reducir la fatiga visual.</span>
                                    </div>
                                    <label class="toggle-switch">
                                        <input type="checkbox" name="modoOscuro">
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>

                                <div class="form-actions">
                                    <button type="reset" class="btn btn-secondary">
                                        <span class="material-symbols-outlined">refresh</span>
                                        Restablecer
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="material-symbols-outlined">save</span>
                                        Guardar preferencias
                                    </button>
                                </div>
                            </form>
                        </div>

                    </div>
                </div>
            </div>

            <!-- ═══════════════════════════════════════════════
                 FOOTER
                 ═══════════════════════════════════════════════ -->
            <footer class="page-footer">
                <span> 2026 Belleza. Todos los derechos reservados.</span>
                <div class="footer-links">
                    <a href="#">Ayuda</a>
                    <a href="#">Privacidad</a>
                    <a href="#">Términos</a>
                </div>
            </footer>

        </main>
    </div>

    <!-- ═══════════════════════════════════════════════
         SCRIPTS
         ═══════════════════════════════════════════════ -->
    <script>
        // Cambio de tabs
        document.querySelectorAll('.form-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                const targetTab = this.dataset.tab;
                document.querySelectorAll('.form-tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.form-tab-content').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                document.getElementById('tab-' + targetTab).classList.add('active');
            });
        });

        // Preview de foto de perfil
        document.getElementById('avatar-input').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    const avatar = document.querySelector('.profile-avatar');
                    avatar.innerHTML = '<img src="' + event.target.result + '" alt="Foto de perfil">';
                };
                reader.readAsDataURL(file);
            }
        });
    </script>

</body>
</html>