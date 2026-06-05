<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Usuarios - Quiddity</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        /* ═══════════════════════════════════════════════════════════
           VARIABLES DEL TEMA — Coinciden con sidebar.jsp
        ═══════════════════════════════════════════════════════════ */
        :root {
            --uc-p:      #6366f1;
            --uc-p-dark: #4f46e5;
            --uc-sec:    #8b5cf6;
            --uc-card:   #1e293b;
            --uc-brd:    #334155;
            --uc-txt:    #f1f5f9;
            --uc-muted:  #94a3b8;
            --uc-ok:     #10b981;
            --uc-warn:   #f59e0b;
            --uc-err:    #ef4444;
            --uc-info:   #3b82f6;
        }

        /* ═══════════════════════════════════════════════════════════
           ESTILOS SOLO PARA EL CONTENIDO — NO tocar body ni .main-content
        ═══════════════════════════════════════════════════════════ */
        .usuarios-content {
            padding: 2rem;
            min-height: 100vh;
        }

        /* ── Page header ── */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        .page-header h2 {
            font-family: 'EB Garamond', serif;
            font-size: 42px;
            font-weight: 400;
            color: #2A2623;
            margin-bottom: 8px;
        }
        .page-header p {
            color: #8B8882;
            font-size: 15px;
            margin: 0;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--uc-p), var(--uc-sec));
            border: none;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            cursor: pointer;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99,102,241,.4);
            color: white;
        }

        /* ── Stats ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: #FFFFFF;
            border: 1px solid #E8E4DE;
            border-radius: 12px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.3s;
        }
        .stat-card:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
            transform: translateY(-2px);
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }
        .stat-icon.admin { background: rgba(239,68,68,.1);  color: #C45C4E; }
        .stat-icon.user  { background: rgba(59,130,246,.1); color: #3b82f6; }
        .stat-icon.buyer { background: rgba(16,185,129,.1); color: #2D5A3D; }
        .stat-icon.total { background: rgba(139,92,246,.1); color: #8b5cf6; }
        .stat-info h4 {
            font-family: 'EB Garamond', serif;
            font-size: 36px;
            font-weight: 400;
            color: #2A2623;
            margin: 0;
        }
        .stat-info p {
            font-size: 13px;
            color: #8B8882;
            margin: 0;
        }

        /* ── Filter bar ── */
        .filter-bar {
            background: #FFFFFF;
            border: 1px solid #E8E4DE;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-bar .form-select,
        .filter-bar .form-control {
            background: #FAF8F5;
            border: 1px solid #E8E4DE;
            color: #1F1D1B;
            border-radius: 8px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            padding: 10px 12px;
        }
        .filter-bar .form-select:focus,
        .filter-bar .form-control:focus {
            border-color: #4A5D3A;
            box-shadow: 0 0 0 3px rgba(74, 93, 58, 0.1);
            background: #FAF8F5;
            color: #1F1D1B;
        }
        .filter-label {
            font-weight: 600;
            color: #1F1D1B;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
        }
        .filter-icon { color: #4A5D3A; }

        .filter-btn {
            background: #4A5D3A;
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .filter-btn:hover { background: #3D4D30; }
        .clear-btn {
            background: transparent;
            border: 1px solid #E8E4DE;
            color: #8B8882;
            padding: 10px 20px;
            border-radius: 8px;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .clear-btn:hover {
            border-color: #C45C4E;
            color: #C45C4E;
        }

        /* ── Table ── */
        .table-card {
            background: #FFFFFF;
            border: 1px solid #E8E4DE;
            border-radius: 12px;
            overflow: hidden;
        }
        .table-card table {
            width: 100%;
            border-collapse: collapse;
        }
        .table-card thead th {
            background: #FAF8F5;
            color: #8B8882;
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            padding: 16px 20px;
            border-bottom: 1px solid #E8E4DE;
        }
        .table-card tbody td {
            padding: 16px 20px;
            border-bottom: 1px solid #E8E4DE;
            color: #1F1D1B;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            vertical-align: middle;
        }
        .table-card tbody tr:hover td {
            background: rgba(74, 93, 58, 0.03);
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #E8E4DE;
        }
        .user-avatar-default {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4A5D3A, #B8956A);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 14px;
            flex-shrink: 0;
        }
        .user-name {
            font-weight: 600;
            color: #1F1D1B;
            font-family: 'Manrope', sans-serif;
            font-size: 14px;
        }
        .user-email {
            font-size: 12px;
            color: #8B8882;
            font-family: 'Manrope', sans-serif;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .role-admin {
            background: rgba(196, 92, 78, 0.15);
            color: #C45C4E;
        }
        .role-user {
            background: rgba(59, 130, 246, 0.15);
            color: #3b82f6;
        }
        .role-buyer {
            background: rgba(45, 90, 61, 0.15);
            color: #2D5A3D;
        }

        .action-btns {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 13px;
            text-decoration: none;
        }
        .action-btn.view {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
        }
        .action-btn.edit {
            background: rgba(184, 149, 106, 0.1);
            color: #B8956A;
        }
        .action-btn.delete {
            background: rgba(196, 92, 78, 0.1);
            color: #C45C4E;
        }
        .action-btn.role {
            background: rgba(139, 92, 246, 0.1);
            color: #8b5cf6;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }

        .empty-state {
            text-align: center;
            padding: 48px;
            color: #8B8882;
            font-family: 'Manrope', sans-serif;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
            color: #8B8882;
        }
        .empty-state h4 {
            font-family: 'EB Garamond', serif;
            font-size: 20px;
            font-weight: 400;
            color: #2A2623;
            margin-bottom: 8px;
        }
        .empty-state p {
            font-size: 14px;
            color: #8B8882;
        }

        /* ── Toast ── */
        .toast-container {
            position: fixed;
            top: 16px;
            right: 16px;
            z-index: 9999;
        }
        .toast-custom {
            background: #FFFFFF;
            border: 1px solid #E8E4DE;
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            animation: slideInToast 0.3s ease;
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
        }
        @keyframes slideInToast {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .toast-custom.success {
            border-left: 4px solid #2D5A3D;
            color: #2D5A3D;
        }
        .toast-custom.error {
            border-left: 4px solid #C45C4E;
            color: #C45C4E;
        }

        /* ── Responsive ── */
        @media (max-width: 1200px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 1024px) {
            .usuarios-content { padding: 24px; padding-top: 64px; }
        }
        @media (max-width: 768px) {
            .stats-row { grid-template-columns: 1fr; }
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .page-header h2 { font-size: 28px; }
            .filter-bar { flex-direction: column; align-items: stretch; }
            .table-card { overflow-x: auto; }
        }
    </style>
</head>
<body>
    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

        <main class="main-content usuarios-content">

            <!-- Toast Messages -->
            <c:if test="${not empty param.success}">
                <div class="toast-container">
                    <div class="toast-custom success">
                        <i class="fas fa-check-circle"></i>
                        <span>${param.success}</span>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="toast-container">
                    <div class="toast-custom error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${param.error}</span>
                    </div>
                </div>
            </c:if>

            <!-- Page header -->
            <div class="page-header">
                <div>
                    <h2>Usuarios</h2>
                    <p>Gestiona todos los usuarios del sistema</p>
                </div>
                <a href="${pageContext.request.contextPath}/usuarios?action=nuevo" class="btn-primary-custom">
                    <i class="fas fa-plus"></i> Nuevo Usuario
                </a>
            </div>

            <!-- Conteo por rol -->
            <c:set var="countAdmin"     value="0" />
            <c:set var="countComprador" value="0" />
            <c:set var="countUsuario"   value="0" />
            <c:forEach var="u" items="${usuarios}">
                <c:if test="${u.idRol == 1}"><c:set var="countAdmin"     value="${countAdmin     + 1}" /></c:if>
                <c:if test="${u.idRol == 2}"><c:set var="countComprador" value="${countComprador + 1}" /></c:if>
                <c:if test="${u.idRol == 3}"><c:set var="countUsuario"   value="${countUsuario   + 1}" /></c:if>
            </c:forEach>

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon total"><i class="fas fa-users"></i></div>
                    <div class="stat-info"><h4>${usuarios.size()}</h4><p>Total Usuarios</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon admin"><i class="fas fa-shield-alt"></i></div>
                    <div class="stat-info"><h4>${countAdmin}</h4><p>Administradores</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon buyer"><i class="fas fa-shopping-bag"></i></div>
                    <div class="stat-info"><h4>${countComprador}</h4><p>Compradores</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon user"><i class="fas fa-user"></i></div>
                    <div class="stat-info"><h4>${countUsuario}</h4><p>Usuarios</p></div>
                </div>
            </div>

            <!-- Filter bar -->
            <div class="filter-bar">
                <div style="display:flex; align-items:center; gap:8px;">
                    <i class="fas fa-filter filter-icon"></i>
                    <span class="filter-label">Filtrar por:</span>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/usuarios"
                      style="display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
                    <select name="rol" class="form-select" style="min-width:160px;">
                        <option value="">Todos los roles</option>
                        <option value="1" ${param.rol == '1' ? 'selected' : ''}>Administrador</option>
                        <option value="2" ${param.rol == '2' ? 'selected' : ''}>Comprador</option>
                        <option value="3" ${param.rol == '3' ? 'selected' : ''}>Usuario</option>
                    </select>
                    <input type="text" name="buscar" class="form-control"
                           placeholder="Buscar por nombre, email..."
                           value="${param.buscar}" style="min-width:220px;">
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-search"></i> Filtrar
                    </button>
                    <a href="${pageContext.request.contextPath}/usuarios" class="clear-btn">
                        <i class="fas fa-undo"></i> Limpiar
                    </a>
                </form>
            </div>

            <!-- Users Table -->
            <div class="table-card">
                <c:choose>
                    <c:when test="${empty usuarios}">
                        <div class="empty-state">
                            <i class="fas fa-user-slash"></i>
                            <h4>No hay usuarios registrados</h4>
                            <p>Comienza agregando un nuevo usuario al sistema.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Usuario</th>
                                    <th>Documento</th>
                                    <th>Rol</th>
                                    <th>Email</th>
                                    <th style="text-align:center;">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usuarios}">
                                    <c:set var="nombreCompleto" value="${u.nombre} ${u.apellido}"/>
                                    <c:set var="matchRol"    value="${empty param.rol    || u.idRol == param.rol}"/>
                                    <c:set var="matchBuscar" value="${empty param.buscar ||
                                        nombreCompleto.toLowerCase().contains(param.buscar.toLowerCase()) ||
                                        u.email.toLowerCase().contains(param.buscar.toLowerCase()) ||
                                        u.documento.contains(param.buscar)}"/>

                                    <c:if test="${matchRol && matchBuscar}">
                                        <tr>
                                            <td>
                                                <div class="user-cell">
                                                    <c:choose>
                                                        <c:when test="${not empty u.fotoPerfil}">
                                                            <img src="${pageContext.request.contextPath}/uploads/${u.fotoPerfil}"
                                                                 alt="" class="user-avatar">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="user-avatar-default">
                                                                ${u.nombre.charAt(0)}${u.apellido.charAt(0)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="user-name">${u.nombre} ${u.apellido}</div>
                                                        <div class="user-email">@${u.userName}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${u.documento}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.idRol == 1}">
                                                        <span class="role-badge role-admin">
                                                            <i class="fas fa-shield-alt"></i> Admin
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${u.idRol == 2}">
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
                                            </td>
                                            <td>${u.email}</td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${pageContext.request.contextPath}/usuarios?id=${u.id}"
                                                       class="action-btn view" title="Ver perfil">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/usuarios?id=${u.id}&editar=true"
                                                       class="action-btn edit" title="Editar">
                                                        <i class="fas fa-pen"></i>
                                                    </a>
                                                    <form method="post" action="${pageContext.request.contextPath}/usuarios"
                                                          style="display:inline;"
                                                          onsubmit="return confirm('¿Eliminar a ${u.nombre} ${u.apellido}?');">
                                                        <input type="hidden" name="action" value="eliminar">
                                                        <input type="hidden" name="id"     value="${u.id}">
                                                        <button type="submit" class="action-btn delete" title="Eliminar">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                    <c:if test="${sessionScope.usuario.idRol == 1 && u.id != sessionScope.usuario.id}">
                                                        <form method="post" action="${pageContext.request.contextPath}/usuarios"
                                                              style="display:inline;">
                                                            <input type="hidden" name="action" value="cambiarRol">
                                                            <input type="hidden" name="id"     value="${u.id}">
                                                            <input type="hidden" name="idrol"  value="${u.idRol == 1 ? 3 : 1}">
                                                            <button type="submit" class="action-btn role" title="Cambiar rol">
                                                                <i class="fas fa-exchange-alt"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        setTimeout(() => {
            document.querySelectorAll('.toast-container').forEach(t => t.style.display = 'none');
        }, 4000);
    </script>
</body>
</html>