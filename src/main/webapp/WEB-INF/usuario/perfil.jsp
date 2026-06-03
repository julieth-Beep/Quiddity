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
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;600&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />

    <style>
        :root {
            --primary: #9a3a5a;
            --primary-light: rgba(154,58,90,0.08);
            --primary-medium: rgba(154,58,90,0.15);
            --primary-dark: #7a2e48;
            --secondary: #516617;
            --tertiary: #88495a;
            --background: #ffffff;
            --surface: #ffffff;
            --on-surface: #1c1b1d;
            --on-surface-variant: #544246;
            --outline: #877276;
            --surface-container-low: #ffffff;
            --surface-variant: #f1ecef;
            --surface-variant-hover: #e8e3e6;
            --success: #516617;
            --warning: #c47e00;
            --error: #b3261e;
            --error-light: rgba(179,38,30,0.08);
            --element-gap: 24px;
            --gutter: 32px;
            --radius: 0px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Manrope',sans-serif; background:var(--background); color:var(--on-surface); line-height:1.5; -webkit-font-smoothing:antialiased; }

        .layout-wrapper { display:flex; min-height:100vh; }
        .main-content { flex:1; margin-left:280px; min-height:100vh; background:var(--background); }

        .sidebar-toggle { display:none; position:fixed; top:20px; left:20px; z-index:998; width:44px; height:44px; background:var(--surface); border:1px solid var(--surface-variant); color:var(--on-surface); align-items:center; justify-content:center; cursor:pointer; box-shadow:0 2px 8px rgba(0,0,0,0.08); }

        .page-header { padding:40px var(--gutter) 0; max-width:1200px; margin:0 auto; }
        .breadcrumb { display:flex; align-items:center; gap:8px; font-size:13px; color:var(--outline); margin-bottom:16px; }
        .breadcrumb a { color:var(--outline); text-decoration:none; }
        .breadcrumb a:hover { color:var(--primary); }
        .breadcrumb .material-symbols-outlined { font-size:16px; }
        .header-row { display:flex; align-items:flex-end; justify-content:space-between; gap:var(--element-gap); flex-wrap:wrap; margin-bottom:40px; }
        .header-title h1 { font-family:'EB Garamond',Georgia,serif; font-size:48px; font-weight:400; line-height:56px; color:var(--on-surface); margin-bottom:8px; }
        .header-subtitle { font-size:16px; color:var(--on-surface-variant); }

        .alert { display:flex; align-items:center; gap:12px; padding:16px 24px; margin:0 auto 24px; max-width:1136px; font-size:14px; font-weight:500; animation:slideDown 0.4s cubic-bezier(0.22,1,0.36,1); }
        .alert-success { background:rgba(81,102,23,0.08); border-left:3px solid var(--success); color:var(--success); }
        .alert-error   { background:var(--error-light); border-left:3px solid var(--error); color:var(--error); }
        .alert .material-symbols-outlined { font-size:20px; flex-shrink:0; }
        @keyframes slideDown { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }

        .profile-container { padding:0 var(--gutter) 48px; max-width:1200px; margin:0 auto; }
        .profile-grid { display:grid; grid-template-columns:320px 1fr; gap:var(--element-gap); align-items:start; }

        /* Card lateral */
        .profile-card { background:var(--surface); border:1px solid var(--surface-variant); overflow:hidden; }
        .profile-card-header { padding:32px; text-align:center; border-bottom:1px solid var(--surface-variant); position:relative; }
        .profile-cover { position:absolute; top:0; left:0; right:0; height:80px; background:linear-gradient(135deg,var(--primary) 0%,var(--tertiary) 100%); }
        .profile-avatar-wrapper { position:relative; display:inline-block; margin-top:24px; }
        .profile-avatar { width:120px; height:120px; border:4px solid var(--surface); background:var(--surface-variant); display:flex; align-items:center; justify-content:center; overflow:hidden; }
        .profile-avatar .material-symbols-outlined { font-size:56px; color:var(--outline); }
        .profile-avatar img { width:100%; height:100%; object-fit:cover; }
        .avatar-edit-btn { position:absolute; bottom:4px; right:4px; width:36px; height:36px; background:var(--primary); border:3px solid var(--surface); color:#fff; display:flex; align-items:center; justify-content:center; cursor:pointer; transition:background 0.2s; }
        .avatar-edit-btn:hover { background:var(--primary-dark); }
        .avatar-edit-btn .material-symbols-outlined { font-size:18px !important; }
        .profile-name { font-family:'EB Garamond',Georgia,serif; font-size:24px; font-weight:400; color:var(--on-surface); margin-top:16px; }
        .profile-role { display:inline-flex; align-items:center; gap:6px; margin-top:6px; padding:4px 14px; background:var(--primary-light); font-size:12px; font-weight:600; letter-spacing:0.05em; text-transform:uppercase; color:var(--primary); }
        .profile-role .material-symbols-outlined { font-size:14px; }
        .profile-card-body { padding:24px 28px; }
        .profile-info-list { list-style:none; }
        .profile-info-item { display:flex; align-items:flex-start; gap:14px; padding:14px 0; border-bottom:1px solid var(--surface-variant); }
        .profile-info-item:last-child { border-bottom:none; padding-bottom:0; }
        .profile-info-item:first-child { padding-top:0; }
        .profile-info-icon { width:36px; height:36px; display:flex; align-items:center; justify-content:center; background:var(--surface-variant); flex-shrink:0; }
        .profile-info-icon .material-symbols-outlined { font-size:18px; color:var(--primary); }
        .profile-info-content { min-width:0; }
        .profile-info-label { font-size:11px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase; color:var(--outline); margin-bottom:2px; }
        .profile-info-value { font-size:14px; font-weight:500; color:var(--on-surface); word-break:break-word; }
        .profile-card-footer { padding:20px 28px; border-top:1px solid var(--surface-variant); display:flex; gap:8px; }
        .profile-btn { flex:1; display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:12px 16px; font-family:'Manrope',sans-serif; font-size:13px; font-weight:600; letter-spacing:0.02em; text-decoration:none; border:none; cursor:pointer; transition:all 0.2s; line-height:20px; }
        .profile-btn-outline { background:none; border:1px solid var(--outline); color:var(--on-surface); }
        .profile-btn-outline:hover { background:var(--surface-variant); }
        .profile-btn-danger { background:none; border:1px solid var(--error); color:var(--error); }
        .profile-btn-danger:hover { background:var(--error-light); }
        .profile-btn .material-symbols-outlined { font-size:16px; }

        /* Panel formulario */
        .form-panel { background:var(--surface); border:1px solid var(--surface-variant); }
        .form-tabs { display:flex; border-bottom:1px solid var(--surface-variant); }
        .form-tab { padding:16px 28px; font-family:'Manrope',sans-serif; font-size:14px; font-weight:600; color:var(--outline); background:none; border:none; border-bottom:2px solid transparent; cursor:pointer; transition:all 0.2s; display:flex; align-items:center; gap:8px; }
        .form-tab:hover { color:var(--on-surface-variant); }
        .form-tab.active { color:var(--primary); border-bottom-color:var(--primary); }
        .form-tab .material-symbols-outlined { font-size:18px; }
        .form-tab-content { display:none; padding:32px 28px; }
        .form-tab-content.active { display:block; animation:fadeIn 0.3s ease; }
        @keyframes fadeIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }

        .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:20px 24px; }
        .form-group { display:flex; flex-direction:column; gap:6px; }
        .form-group.full-width { grid-column:1/-1; }
        .form-label { font-size:13px; font-weight:600; color:var(--on-surface); letter-spacing:0.02em; }
        .form-label .required { color:var(--error); margin-left:2px; }
        .form-hint { font-size:12px; color:var(--outline); margin-top:2px; }
        .form-input,.form-select { padding:12px 16px; font-family:'Manrope',sans-serif; font-size:14px; color:var(--on-surface); background:var(--surface); border:1px solid var(--outline); outline:none; transition:border-color 0.2s,box-shadow 0.2s; line-height:20px; }
        .form-input:focus,.form-select:focus { border-color:var(--primary); box-shadow:0 0 0 3px var(--primary-light); }
        .form-input::placeholder { color:var(--outline); }
        .form-input:disabled { background:var(--surface-variant); color:var(--outline); cursor:not-allowed; }
        .input-with-icon { position:relative; }
        .input-with-icon .form-input { padding-left:44px; }
        .input-icon { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--outline); }
        .input-icon .material-symbols-outlined { font-size:18px; }

        /* Upload foto */
        .upload-foto-area { border:2px dashed var(--outline); padding:24px; text-align:center; cursor:pointer; transition:all 0.2s; }
        .upload-foto-area:hover { border-color:var(--primary); background:var(--primary-light); }
        .upload-foto-area .material-symbols-outlined { font-size:40px; color:var(--outline); display:block; margin-bottom:8px; }
        .upload-foto-area p { font-size:14px; color:var(--outline); }
        .upload-foto-area small { font-size:12px; color:var(--outline); }
        .foto-preview { display:none; text-align:center; margin-top:12px; }
        .foto-preview img { max-width:120px; max-height:120px; object-fit:cover; border:2px solid var(--surface-variant); }
        .foto-preview p { font-size:12px; color:var(--outline); margin-top:4px; }

        .form-actions { display:flex; align-items:center; justify-content:flex-end; gap:12px; padding-top:24px; border-top:1px solid var(--surface-variant); margin-top:8px; }
        .btn { display:inline-flex; align-items:center; gap:8px; padding:12px 28px; font-family:'Manrope',sans-serif; font-size:14px; font-weight:600; letter-spacing:0.02em; text-decoration:none; border:none; cursor:pointer; transition:all 0.2s; line-height:20px; }
        .btn-primary { background:var(--primary); color:#fff; }
        .btn-primary:hover { background:var(--primary-dark); transform:translateY(-1px); box-shadow:0 4px 12px rgba(154,58,90,0.25); }
        .btn-secondary { background:var(--surface-variant); color:var(--on-surface); border:1px solid var(--outline); }
        .btn-secondary:hover { background:var(--surface-variant-hover); }
        .btn .material-symbols-outlined { font-size:18px; }

        .toggle-group { display:flex; align-items:center; justify-content:space-between; padding:16px 0; border-bottom:1px solid var(--surface-variant); }
        .toggle-group:last-child { border-bottom:none; }
        .toggle-info { display:flex; flex-direction:column; gap:2px; }
        .toggle-label { font-size:14px; font-weight:600; color:var(--on-surface); }
        .toggle-desc { font-size:12px; color:var(--outline); }
        .toggle-switch { position:relative; width:48px; height:26px; flex-shrink:0; }
        .toggle-switch input { opacity:0; width:0; height:0; }
        .toggle-slider { position:absolute; cursor:pointer; inset:0; background:var(--surface-variant); transition:background 0.3s; }
        .toggle-slider::before { content:''; position:absolute; height:20px; width:20px; left:3px; bottom:3px; background:var(--surface); transition:transform 0.3s; box-shadow:0 1px 3px rgba(0,0,0,0.15); }
        .toggle-switch input:checked + .toggle-slider { background:var(--primary); }
        .toggle-switch input:checked + .toggle-slider::before { transform:translateX(22px); }

        .security-section { margin-top:24px; padding-top:24px; border-top:1px solid var(--surface-variant); }
        .security-title { font-family:'EB Garamond',Georgia,serif; font-size:24px; font-weight:400; color:var(--on-surface); margin-bottom:4px; }
        .security-desc { font-size:14px; color:var(--on-surface-variant); margin-bottom:24px; }

        .page-footer { padding:32px var(--gutter); max-width:1200px; margin:0 auto; border-top:1px solid var(--surface-variant); display:flex; align-items:center; justify-content:space-between; font-size:13px; color:var(--outline); }
        .footer-links { display:flex; gap:24px; }
        .footer-links a { color:var(--outline); text-decoration:none; }
        .footer-links a:hover { color:var(--primary); }

        @keyframes fadeInUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-in { animation:fadeInUp 0.6s cubic-bezier(0.22,1,0.36,1) forwards; opacity:0; }
        .delay-1 { animation-delay:0.1s; }
        .delay-2 { animation-delay:0.2s; }

        @media(max-width:1024px){ .main-content{margin-left:0} .sidebar-toggle{display:flex} .profile-grid{grid-template-columns:1fr} .profile-card{max-width:400px;margin:0 auto} }
        @media(max-width:768px){ .header-title h1{font-size:32px} .form-grid{grid-template-columns:1fr} .form-tabs{overflow-x:auto} .form-tab{white-space:nowrap} }
        @media(max-width:480px){ .page-header,.profile-container,.page-footer{padding-left:20px;padding-right:20px} .form-tab-content{padding:24px 20px} }
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
                <div class="alert alert-success" style="margin-left:32px;margin-right:32px">
                    <span class="material-symbols-outlined">check_circle</span>
                    ${mensajeExito}
                </div>
            </c:if>
            <c:if test="${not empty mensajeError}">
                <div class="alert alert-error" style="margin-left:32px;margin-right:32px">
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
                                <li class="profile-info-item">
                                    <div class="profile-info-icon"><span class="material-symbols-outlined">tag</span></div>
                                    <div class="profile-info-content">
                                        <div class="profile-info-label">ID</div>
                                        <div class="profile-info-value">#${sessionScope.usuario.id}</div>
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
                <%-- Admin: puede editarlo --%>
                <input type="text" name="documento" class="form-input" value="${sessionScope.usuario.documento}">
            </c:when>
            <c:otherwise>
                <%-- Usuario normal: solo lectura --%>
                <input type="text" class="form-input" value="${sessionScope.usuario.documento}" disabled>
                <input type="hidden" name="documento" value="${sessionScope.usuario.documento}">
            </c:otherwise>
        </c:choose>
    </div>
    <c:if test="${sessionScope.usuario.idRol != 1}">
        <span class="form-hint">El documento solo puede ser modificado por un administrador.</span>
    </c:if>
</div>

            <%-- Rol: Admin no puede cambiarse, usuario/comprador sí pueden alternar --%>
            <div class="form-group">
                <label class="form-label">Rol</label>
                <c:choose>
                    <c:when test="${sessionScope.usuario.idRol == 1}">
                        <%-- Admin: solo lectura --%>
                        <div class="input-with-icon">
                            <span class="input-icon"><span class="material-symbols-outlined">admin_panel_settings</span></span>
                            <input type="text" class="form-input" disabled value="Administrador">
                            <input type="hidden" name="idRol" value="1">
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Usuario / Comprador: puede cambiar entre los dos --%>
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

                                <p style="font-size:14px;color:var(--on-surface-variant);margin-bottom:20px;">
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
           style="font-size:12px; color:var(--primary); font-weight:600; text-decoration:none;">
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
                                    <h3 style="font-family:'EB Garamond',Georgia,serif;font-size:24px;font-weight:400;color:var(--on-surface);margin-bottom:4px">Notificaciones</h3>
                                    <p style="font-size:14px;color:var(--on-surface-variant)">Configura cómo y cuándo quieres recibirlas.</p>
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

                // Actualizar avatar lateral
                avatarPreview.innerHTML = '<img src="' + ev.target.result + '" alt="Vista previa">';
            };
            reader.readAsDataURL(file);
        });

        // Drag & Drop
        const dropZone = document.getElementById('dropZone');
        dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.style.borderColor = 'var(--primary)'; });
        dropZone.addEventListener('dragleave', () => { dropZone.style.borderColor = ''; });
        dropZone.addEventListener('drop', e => {
            e.preventDefault();
            dropZone.style.borderColor = '';
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
