<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil de ${usuario.nombre} ${usuario.apellido} - Quiddity</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet">
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

            --radius-sm: 12px;
            --radius-md: 14px;
            --radius-lg: 16px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
            --shadow: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            font-size: 12px;
            line-height: 1.5;
        }

        .material-symbols-rounded {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
            font-size: 18px;
        }

        /* ── LAYOUT ── */
        .layout-wrapper {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        .main-content {
            flex: 1;
            margin-left: 240px;
            width: calc(100% - 240px);
            padding: 16px 20px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-height: 100vh;
        }

        /* ── BREADCRUMB ── */
        .breadcrumb-bar {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 10px;
            font-weight: 600;
            color: var(--text-tertiary);
            flex-shrink: 0;
        }
        .breadcrumb-bar a {
            color: var(--text-tertiary);
            text-decoration: none;
            transition: color 0.2s;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .breadcrumb-bar a:hover { color: var(--accent-sky); }
        .breadcrumb-bar .sep { color: var(--border); font-size: 12px; }
        .breadcrumb-bar .current { color: var(--text-primary); font-weight: 700; }

        /* ── PAGE HEADER ── */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
            flex-shrink: 0;
            animation: fadeUp 0.5s ease forwards;
            opacity: 0;
        }
        .page-header-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .page-header-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            color: var(--accent-lavender);
            box-shadow: 0 4px 12px rgba(123, 31, 162, 0.12);
        }
        .page-header-text h1 {
            font-family: 'DM Sans', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.3px;
            margin: 0;
        }
        .page-header-text p {
            font-size: 11px;
            color: var(--text-secondary);
            font-weight: 500;
            margin: 2px 0 0;
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            background: var(--bg-soft);
            color: var(--text-secondary);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.25s ease;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .btn-back:hover {
            background: var(--pastel-sky);
            color: var(--accent-sky);
            border-color: var(--pastel-sky-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-sm);
        }

        /* ── FORM CARD ── */
        .form-card {
            background: var(--surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            overflow: hidden;
            animation: fadeUp 0.5s ease 0.08s forwards;
            opacity: 0;
            flex: 1;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-sm);
        }
        .form-card-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(to right, var(--bg-soft), var(--surface));
        }
        .form-card-header h2 {
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.2px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-card-header h2::before {
            content: '';
            width: 3px;
            height: 14px;
            border-radius: 2px;
            background: linear-gradient(180deg, var(--pastel-lavender-dark), var(--pastel-sky-dark));
            flex-shrink: 0;
            display: inline-block;
        }
        .form-card-body {
            padding: 20px;
            flex: 1;
        }

        /* ── TWO-COLUMN GRID ── */
        .form-layout {
            display: grid;
            grid-template-columns: 1fr 280px;
            gap: 20px;
            align-items: start;
        }
        .form-fields {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .form-sidebar {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* ── FORM GROUPS ── */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .form-group label {
            font-size: 9px;
            font-weight: 700;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .form-group input {
            padding: 10px 12px;
            border: 1.5px solid var(--border-light);
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 600;
            color: var(--text-primary);
            background: var(--bg-soft);
            transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
            line-height: 1.4;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--pastel-sky-dark);
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.08);
            background: var(--surface);
        }
        .form-group input[readonly] {
            background: var(--bg-soft);
            border-color: var(--border-light);
            color: var(--text-primary);
            cursor: default;
        }

        /* ── ROLE BADGE ── */
        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.03em;
        }
        .role-admin { background: var(--pastel-coral); color: var(--accent-coral); }
        .role-user { background: var(--pastel-sky); color: var(--accent-sky); }
        .role-buyer { background: var(--pastel-mint); color: var(--accent-mint); }

        /* ── USER BADGE CARD ── */
        .user-badge-card {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            background: var(--bg-soft);
            border-radius: var(--radius-md);
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-sm);
        }
        .user-badge-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .user-badge-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .user-badge-avatar-default {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 16px;
            box-shadow: 0 2px 8px rgba(123, 31, 162, 0.15);
        }
        .user-badge-info { flex: 1; min-width: 0; }
        .user-badge-info .badge-name {
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 2px;
        }
        .user-badge-info .badge-role {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .user-badge-info .badge-email {
            font-size: 11px;
            font-weight: 600;
            color: var(--accent-sky);
            margin-top: 2px;
        }

        /* ── AVATAR UPLOAD CARD ── */
        .avatar-upload-card {
            background: var(--bg-soft);
            border-radius: var(--radius-md);
            border: 1.5px dashed var(--border-light);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .avatar-upload-card:hover {
            border-color: var(--pastel-sky-dark);
        }
        .avatar-upload-card.has-image {
            border-style: solid;
            border-color: var(--border-light);
        }
        .avatar-preview-area {
            width: 100%;
            aspect-ratio: 1/1;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            position: relative;
        }
        .avatar-preview-area img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .avatar-preview-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            color: white;
        }
        .avatar-preview-placeholder .icon {
            font-size: 48px;
            opacity: 0.8;
        }

        /* ── FORM ACTIONS ── */
        .form-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            border-top: 1px solid var(--border-light);
            background: linear-gradient(to right, var(--bg-soft), var(--surface));
            flex-shrink: 0;
        }
        .form-actions-right { display: flex; gap: 10px; }
        .btn-form {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .btn-form.cancel {
            background: var(--bg-soft);
            color: var(--text-secondary);
            border: 1.5px solid var(--border-light);
        }
        .btn-form.cancel:hover {
            background: var(--border-light);
            transform: translateY(-2px);
        }
        .btn-form.save {
            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
            color: var(--accent-lavender);
            box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
        }
        .btn-form.save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(123, 31, 162, 0.25);
        }
        .btn-form.delete-btn {
            background: var(--pastel-coral);
            color: var(--accent-coral);
            border: 1.5px solid var(--pastel-coral-dark);
        }
        .btn-form.delete-btn:hover {
            background: var(--accent-coral);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(194, 24, 89, 0.2);
        }

        /* ── ANIMATIONS ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 1024px) {
            .main-content { margin-left: 0; width: 100%; }
            .form-layout { grid-template-columns: 1fr; }
            .form-sidebar { order: -1; }
        }
        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; }
            .main-content { padding: 12px 16px; }
            .form-card-body { padding: 16px; }
            .form-actions { padding: 12px 16px; flex-wrap: wrap; }
            .page-header { padding: 14px 16px; }
        }
    </style>
</head>
<body>
    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

        <main class="main-content">

            <!-- Breadcrumb -->
            <nav class="breadcrumb-bar">
                <span class="material-symbols-rounded" style="font-size:14px;">home</span>
                <a href="${pageContext.request.contextPath}/usuarios">Usuarios</a>
                <span class="sep">›</span>
                <span class="current">Perfil de Usuario</span>
            </nav>

            <!-- Page Header -->
            <div class="page-header">
                <div class="page-header-left">
                    <div class="page-header-icon">
                        <span class="material-symbols-rounded">person</span>
                    </div>
                    <div class="page-header-text">
                        <h1>Perfil de Usuario</h1>
                        <p>Visualiza la información completa del usuario.</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/usuarios" class="btn-back">
                    <span class="material-symbols-rounded" style="font-size:14px;">arrow_back</span>
                    Volver al listado
                </a>
            </div>

            <!-- Form Card -->
            <div class="form-card">
                <div class="form-card-header">
                    <h2>Información del usuario</h2>
                </div>
                <div class="form-card-body">
                    <div class="form-layout">
                        <div class="form-fields">

                            <!-- Nombre + Apellido -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Nombre</label>
                                    <input type="text" value="${usuario.nombre}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Apellido</label>
                                    <input type="text" value="${usuario.apellido}" readonly>
                                </div>
                            </div>

                            <!-- Email + Documento -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Email</label>
                                    <input type="email" value="${usuario.email}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Documento</label>
                                    <input type="text" value="${usuario.documento}" readonly>
                                </div>
                            </div>

                            <!-- Username + Rol -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Nombre de usuario</label>
                                    <input type="text" value="@${usuario.userName}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Rol</label>
                                    <div style="padding: 10px 12px;">
                                        <c:choose>
                                            <c:when test="${usuario.idRol == 1}">
                                                <span class="role-badge role-admin">
                                                    <span class="material-symbols-rounded" style="font-size:14px;">shield</span> Administrador
                                                </span>
                                            </c:when>
                                            <c:when test="${usuario.idRol == 2}">
                                                <span class="role-badge role-buyer">
                                                    <span class="material-symbols-rounded" style="font-size:14px;">shopping_bag</span> Comprador
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="role-badge role-user">
                                                    <span class="material-symbols-rounded" style="font-size:14px;">person</span> Usuario
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- ID -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label>ID de Usuario</label>
                                    <input type="text" value="#${usuario.id}" readonly>
                                </div>
                            </div>

                        </div><!-- /form-fields -->

                        <!-- Sidebar con avatar -->
                        <div class="form-sidebar">

                            <!-- Badge del usuario -->
                            <div class="user-badge-card">
                                <c:choose>
                                    <c:when test="${not empty usuario.fotoPerfil}">
                                        <div class="user-badge-avatar">
                                            <img src="${pageContext.request.contextPath}/foto-perfil/${usuario.fotoPerfil}" alt="${usuario.nombre}">
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-badge-avatar-default">
                                            ${usuario.nombre.charAt(0)}${usuario.apellido.charAt(0)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="user-badge-info">
                                    <div class="badge-name">${usuario.nombre} ${usuario.apellido}</div>
                                    <div class="badge-role">
                                        <c:choose>
                                            <c:when test="${usuario.idRol == 1}">Administrador</c:when>
                                            <c:when test="${usuario.idRol == 2}">Comprador</c:when>
                                            <c:otherwise>Usuario</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="badge-email">${usuario.email}</div>
                                </div>
                            </div>

                            <!-- Avatar preview -->
                            <div class="avatar-upload-card has-image">
                                <div class="avatar-preview-area">
                                    <c:choose>
                                        <c:when test="${not empty usuario.fotoPerfil}">
                                            <img src="${pageContext.request.contextPath}/foto-perfil/${usuario.fotoPerfil}" alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="avatar-preview-placeholder">
                                                <span class="material-symbols-rounded icon" style="font-size:48px;">account_circle</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div><!-- /form-sidebar -->
                    </div><!-- /form-layout -->
                </div><!-- /form-card-body -->

                <div class="form-actions">
                    <div>
                        <c:if test="${sessionScope.usuario.idRol == 1 && usuario.id != sessionScope.usuario.id}">
                            <form method="post" action="${pageContext.request.contextPath}/usuarios" style="display:inline;" onsubmit="return confirm('¿Eliminar a ${usuario.nombre} ${usuario.apellido}? Esta acción no se puede deshacer.');">
                                <input type="hidden" name="action" value="eliminar">
                                <input type="hidden" name="id" value="${usuario.id}">
                                <button type="submit" class="btn-form delete-btn">
                                    <span class="material-symbols-rounded" style="font-size:14px;">delete</span>
                                    Eliminar Usuario
                                </button>
                            </form>
                        </c:if>
                    </div>
                    <div class="form-actions-right">
                        <a href="${pageContext.request.contextPath}/usuarios" class="btn-form cancel">Cancelar</a>
                        <a href="${pageContext.request.contextPath}/usuarios?id=${usuario.id}&editar=true" class="btn-form save">
                            <span class="material-symbols-rounded" style="font-size:14px;">edit</span>
                            Editar Usuario
                        </a>
                    </div>
                </div>

            </div><!-- /form-card -->
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>s