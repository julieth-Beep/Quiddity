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
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #8b5cf6;
            --bg-dark: #0f172a;
            --bg-card: #1e293b;
            --bg-card-hover: #334155;
            --text-light: #f1f5f9;
            --text-muted: #94a3b8;
            --border: #334155;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: var(--bg-dark);
            color: var(--text-light);
            min-height: 100vh;
        }

        .layout-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: var(--bg-card);
            border-right: 1px solid var(--border);
            padding: 1.5rem 1rem;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            transition: transform 0.3s ease;
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0 0.5rem 1.5rem;
            border-bottom: 1px solid var(--border);
            margin-bottom: 1.5rem;
        }

        .sidebar-brand i {
            font-size: 1.75rem;
            color: var(--primary);
        }

        .sidebar-brand h4 {
            font-weight: 700;
            color: var(--text-light);
            margin: 0;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            color: var(--text-muted);
            text-decoration: none;
            margin-bottom: 0.25rem;
            transition: all 0.2s;
        }

        .nav-item:hover, .nav-item.active {
            background: var(--primary);
            color: white;
        }

        .nav-item i { width: 20px; text-align: center; }

        .sidebar-footer {
            position: absolute;
            bottom: 1rem;
            left: 1rem;
            right: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border);
        }

        .user-mini {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .user-mini img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-mini .info { flex: 1; }
        .user-mini .name { font-size: 0.875rem; font-weight: 600; color: var(--text-light); }
        .user-mini .role { font-size: 0.75rem; color: var(--text-muted); }

        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .back-btn:hover { color: var(--primary); }

        .profile-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 0.75rem;
            overflow: hidden;
            max-width: 600px;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            margin-bottom: 1rem;
        }

        .profile-avatar-default {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 2.5rem;
            border: 4px solid white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            margin: 0 auto 1rem;
        }

        .profile-header h3 {
            font-weight: 700;
            color: white;
            margin: 0;
        }

        .profile-header .username {
            color: rgba(255,255,255,0.8);
            font-size: 0.875rem;
        }

        .profile-body {
            padding: 2rem;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border);
        }

        .info-row:last-child { border-bottom: none; }

        .info-label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .info-label i { color: var(--primary); width: 20px; }

        .info-value {
            font-weight: 600;
            color: var(--text-light);
            font-size: 0.875rem;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .role-admin { background: rgba(239, 68, 68, 0.15); color: #fca5a5; }
        .role-user { background: rgba(59, 130, 246, 0.15); color: #93c5fd; }
        .role-buyer { background: rgba(16, 185, 129, 0.15); color: #6ee7b7; }

        .profile-actions {
            display: flex;
            gap: 1rem;
            padding: 1.5rem 2rem;
            background: var(--bg-dark);
            border-top: 1px solid var(--border);
        }

        .btn-edit {
            flex: 1;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            color: white;
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
            color: white;
        }

        .btn-delete {
            flex: 1;
            background: transparent;
            border: 1px solid var(--danger);
            color: var(--danger);
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 1rem; }
        }

        .mobile-toggle {
            display: none;
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1001;
            background: var(--primary);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 0.5rem;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .mobile-toggle { display: flex; align-items: center; justify-content: center; }
        }
    </style>
</head>
<body>
    <button class="mobile-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <div class="layout-wrapper">
        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/usuarios" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Volver al listado
                    </a>
                    <h2 style="margin-top: 0.5rem;">
                        <i class="fas fa-id-card" style="color: var(--primary); margin-right: 0.5rem;"></i>
                        Perfil de Usuario
                    </h2>
                </div>
            </div>

            <div class="profile-card">
                <div class="profile-header">
                    <c:choose>
                        <c:when test="${not empty usuario.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/uploads/${usuario.fotoPerfil}" alt="Avatar" class="profile-avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="profile-avatar-default">
                                ${usuario.nombre.charAt(0)}${usuario.apellido.charAt(0)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <h3>${usuario.nombre} ${usuario.apellido}</h3>
                    <div class="username">@${usuario.userName}</div>
                </div>

                <div class="profile-body">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-id-card"></i>
                            <span>Documento</span>
                        </div>
                        <div class="info-value">${usuario.documento}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-envelope"></i>
                            <span>Email</span>
                        </div>
                        <div class="info-value">${usuario.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-user-tag"></i>
                            <span>Rol</span>
                        </div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${usuario.idRol == 1}">
                                    <span class="role-badge role-admin">
                                        <i class="fas fa-shield-alt"></i> Administrador
                                    </span>
                                </c:when>
                                <c:when test="${usuario.idRol == 2}">
                                    <span class="role-badge role-buyer">
                                        <i class="fas fa-shopping-bag"></i> Comprador
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-badge role-user">
                                        <i class="fas fa-user"></i> Usuario
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-hashtag"></i>
                            <span>ID de Usuario</span>
                        </div>
                        <div class="info-value">#${usuario.id}</div>
                    </div>
                </div>

                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/usuarios?id=${usuario.id}&editar=true" class="btn-edit">
                        <i class="fas fa-pen"></i> Editar Perfil
                    </a>
                    <c:if test="${sessionScope.usuario.idRol == 1 && usuario.id != sessionScope.usuario.id}">
                        <form method="post" action="${pageContext.request.contextPath}/usuarios" style="flex:1;" onsubmit="return confirm('¿Eliminar a ${usuario.nombre} ${usuario.apellido}? Esta acción no se puede deshacer.');">
                            <input type="hidden" name="action" value="eliminar">
                            <input type="hidden" name="id" value="${usuario.id}">
                            <button type="submit" class="btn-delete">
                                <i class="fas fa-trash"></i> Eliminar
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }
    </script>
    <%@ include file="/includes/sidebar.jsp" %>
</body>
</html>