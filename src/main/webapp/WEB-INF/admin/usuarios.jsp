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

        .layout-wrapper { display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: 260px; background: var(--bg-card); border-right: 1px solid var(--border);
            padding: 1.5rem 1rem; position: fixed; height: 100vh; overflow-y: auto;
            z-index: 1000; transition: transform 0.3s ease;
        }
        .sidebar-brand { display: flex; align-items: center; gap: 0.75rem; padding: 0 0.5rem 1.5rem; border-bottom: 1px solid var(--border); margin-bottom: 1.5rem; }
        .sidebar-brand i { font-size: 1.75rem; color: var(--primary); }
        .sidebar-brand h4 { font-weight: 700; color: var(--text-light); margin: 0; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; border-radius: 0.5rem; color: var(--text-muted); text-decoration: none; margin-bottom: 0.25rem; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: var(--primary); color: white; }
        .nav-item i { width: 20px; text-align: center; }
        .sidebar-footer { position: absolute; bottom: 1rem; left: 1rem; right: 1rem; padding-top: 1rem; border-top: 1px solid var(--border); }
        .user-mini { display: flex; align-items: center; gap: 0.75rem; }
        .user-mini img { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }
        .user-mini .info { flex: 1; }
        .user-mini .name { font-size: 0.875rem; font-weight: 600; color: var(--text-light); }
        .user-mini .role { font-size: 0.75rem; color: var(--text-muted); }

        /* Main Content */
        .main-content { flex: 1; margin-left: 260px; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header h2 { font-weight: 700; color: var(--text-light); }
        .btn-primary-custom { background: linear-gradient(135deg, var(--primary), var(--secondary)); border: none; color: white; padding: 0.625rem 1.25rem; border-radius: 0.5rem; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; transition: transform 0.2s, box-shadow 0.2s; }
        .btn-primary-custom:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4); color: white; }

        /* Stats Cards */
        .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 0.75rem; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-icon { width: 48px; height: 48px; border-radius: 0.75rem; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        .stat-icon.admin { background: rgba(239, 68, 68, 0.15); color: var(--danger); }
        .stat-icon.user { background: rgba(59, 130, 246, 0.15); color: var(--info); }
        .stat-icon.buyer { background: rgba(16, 185, 129, 0.15); color: var(--success); }
        .stat-icon.total { background: rgba(139, 92, 246, 0.15); color: var(--secondary); }
        .stat-info h4 { font-size: 1.5rem; font-weight: 700; margin: 0; color: var(--text-light); }
        .stat-info p { font-size: 0.875rem; color: var(--text-muted); margin: 0; }

        /* Filter Bar */
        .filter-bar { background: var(--bg-card); border: 1px solid var(--border); border-radius: 0.75rem; padding: 1rem 1.25rem; margin-bottom: 1.5rem; display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; }
        .filter-bar .form-select, .filter-bar .form-control { background: var(--bg-dark); border: 1px solid var(--border); color: var(--text-light); border-radius: 0.5rem; }
        .filter-bar .form-select:focus, .filter-bar .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2); background: var(--bg-dark); color: var(--text-light); }
        .filter-btn { background: var(--primary); border: none; color: white; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .filter-btn:hover { background: var(--primary-dark); }
        .clear-btn { background: transparent; border: 1px solid var(--border); color: var(--text-muted); padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .clear-btn:hover { border-color: var(--primary); color: var(--primary); }

        /* Table */
        .table-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 0.75rem; overflow: hidden; }
        .table-card table { width: 100%; border-collapse: collapse; }
        .table-card thead th { background: var(--bg-dark); color: var(--text-muted); font-weight: 600; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; padding: 1rem 1.25rem; border-bottom: 1px solid var(--border); }
        .table-card tbody td { padding: 1rem 1.25rem; border-bottom: 1px solid var(--border); color: var(--text-light); font-size: 0.875rem; vertical-align: middle; }
        .table-card tbody tr:hover td { background: rgba(99, 102, 241, 0.05); }
        .user-cell { display: flex; align-items: center; gap: 0.75rem; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid var(--border); }
        .user-avatar-default { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.875rem; }
        .user-name { font-weight: 600; color: var(--text-light); }
        .user-email { font-size: 0.75rem; color: var(--text-muted); }
        .role-badge { display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.35rem 0.75rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; }
        .role-admin { background: rgba(239, 68, 68, 0.15); color: #fca5a5; }
        .role-user { background: rgba(59, 130, 246, 0.15); color: #93c5fd; }
        .role-buyer { background: rgba(16, 185, 129, 0.15); color: #6ee7b7; }
        .action-btns { display: flex; gap: 0.5rem; }
        .action-btn { width: 32px; height: 32px; border-radius: 0.5rem; border: none; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-size: 0.875rem; }
        .action-btn.view { background: rgba(59, 130, 246, 0.15); color: var(--info); }
        .action-btn.edit { background: rgba(245, 158, 11, 0.15); color: var(--warning); }
        .action-btn.delete { background: rgba(239, 68, 68, 0.15); color: var(--danger); }
        .action-btn.role { background: rgba(139, 92, 246, 0.15); color: var(--secondary); }
        .action-btn:hover { transform: scale(1.1); }
        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; opacity: 0.5; }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 1rem; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .filter-bar { flex-direction: column; align-items: stretch; }
            .table-card { overflow-x: auto; }
        }
        .mobile-toggle { display: none; position: fixed; top: 1rem; left: 1rem; z-index: 1001; background: var(--primary); border: none; color: white; width: 40px; height: 40px; border-radius: 0.5rem; cursor: pointer; }
        @media (max-width: 768px) { .mobile-toggle { display: flex; align-items: center; justify-content: center; } }

        /* Toast */
        .toast-container { position: fixed; top: 1rem; right: 1rem; z-index: 9999; }
        .toast-custom { background: var(--bg-card); border: 1px solid var(--border); border-radius: 0.75rem; padding: 1rem 1.25rem; display: flex; align-items: center; gap: 0.75rem; box-shadow: 0 10px 30px rgba(0,0,0,0.3); animation: slideIn 0.3s ease; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        .toast-custom.success { border-left: 4px solid var(--success); }
        .toast-custom.error { border-left: 4px solid var(--danger); }
    </style>
</head>
<body>
    <button class="mobile-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Toast Messages -->
            <c:if test="${not empty param.success}">
                <div class="toast-container">
                    <div class="toast-custom success">
                        <i class="fas fa-check-circle" style="color: var(--success);"></i>
                        <span>${param.success}</span>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="toast-container">
                    <div class="toast-custom error">
                        <i class="fas fa-exclamation-circle" style="color: var(--danger);"></i>
                        <span>${param.error}</span>
                    </div>
                </div>
            </c:if>

            <div class="page-header">
                <div>
                    <h2><i class="fas fa-users" style="color: var(--primary); margin-right: 0.5rem;"></i>Usuarios</h2>
                    <p style="color: var(--text-muted); margin: 0;">Gestiona todos los usuarios del sistema</p>
                </div>
                <a href="${pageContext.request.contextPath}/usuarios?action=nuevo" class="btn-primary-custom">
                    <i class="fas fa-plus"></i> Nuevo Usuario
                </a>
            </div>

            <%-- ✅ CORRECCIÓN: Contar con JSTL en lugar de Java Streams --%>
            <c:set var="countAdmin" value="0" />
            <c:set var="countComprador" value="0" />
            <c:set var="countUsuario" value="0" />
            <c:forEach var="u" items="${usuarios}">
                <c:if test="${u.idRol == 1}"><c:set var="countAdmin" value="${countAdmin + 1}" /></c:if>
                <c:if test="${u.idRol == 2}"><c:set var="countComprador" value="${countComprador + 1}" /></c:if>
                <c:if test="${u.idRol == 3}"><c:set var="countUsuario" value="${countUsuario + 1}" /></c:if>
            </c:forEach>

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon total"><i class="fas fa-users"></i></div>
                    <div class="stat-info">
                        <h4>${usuarios.size()}</h4>
                        <p>Total Usuarios</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon admin"><i class="fas fa-shield-alt"></i></div>
                    <div class="stat-info">
                        <h4>${countAdmin}</h4>
                        <p>Administradores</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon buyer"><i class="fas fa-shopping-bag"></i></div>
                    <div class="stat-info">
                        <h4>${countComprador}</h4>
                        <p>Compradores</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon user"><i class="fas fa-user"></i></div>
                    <div class="stat-info">
                        <h4>${countUsuario}</h4>
                        <p>Usuarios</p>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="filter-bar">
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-filter" style="color: var(--primary);"></i>
                    <span style="font-weight: 600; color: var(--text-light);">Filtrar por:</span>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/usuarios" style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
                    <select name="rol" class="form-select" style="min-width: 160px;">
                        <option value="">Todos los roles</option>
                        <option value="1" ${param.rol == '1' ? 'selected' : ''}>Administrador</option>
                        <option value="2" ${param.rol == '2' ? 'selected' : ''}>Comprador</option>
                        <option value="3" ${param.rol == '3' ? 'selected' : ''}>Usuario</option>
                    </select>
                    <input type="text" name="buscar" class="form-control" placeholder="Buscar por nombre, email..." 
                           value="${param.buscar}" style="min-width: 220px;">
                    <button type="submit" class="filter-btn"><i class="fas fa-search"></i> Filtrar</button>
                    <a href="${pageContext.request.contextPath}/usuarios" class="clear-btn"><i class="fas fa-undo"></i> Limpiar</a>
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
                                    <th style="text-align: center;">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usuarios}">
                                    <c:set var="rolFiltrado" value="${param.rol}"/>
                                    <c:set var="busqueda" value="${param.buscar}"/>
                                    <c:set var="nombreCompleto" value="${u.nombre} ${u.apellido}"/>
                                    <c:set var="matchRol" value="${empty rolFiltrado || u.idRol == rolFiltrado}"/>
                                    <c:set var="matchBuscar" value="${empty busqueda || nombreCompleto.toLowerCase().contains(busqueda.toLowerCase()) || u.email.toLowerCase().contains(busqueda.toLowerCase()) || u.documento.contains(busqueda)}"/>

                                    <c:if test="${matchRol && matchBuscar}">
                                        <tr>
                                            <td>
                                                <div class="user-cell">
                                                    <c:choose>
                                                        <c:when test="${not empty u.fotoPerfil}">
                                                            <img src="${pageContext.request.contextPath}/uploads/${u.fotoPerfil}" alt="" class="user-avatar">
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
                                                        <span class="role-badge role-admin"><i class="fas fa-shield-alt"></i> Admin</span>
                                                    </c:when>
                                                    <c:when test="${u.idRol == 2}">
                                                        <span class="role-badge role-buyer"><i class="fas fa-shopping-bag"></i> Comprador</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="role-badge role-user"><i class="fas fa-user"></i> Usuario</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${u.email}</td>
                                            <td>
                                                <div class="action-btns" style="justify-content: center;">
                                                    <a href="${pageContext.request.contextPath}/usuarios?id=${u.id}" class="action-btn view" title="Ver perfil">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/usuarios?id=${u.id}&editar=true" class="action-btn edit" title="Editar">
                                                        <i class="fas fa-pen"></i>
                                                    </a>
                                                    <form method="post" action="${pageContext.request.contextPath}/usuarios" style="display:inline;" onsubmit="return confirm('¿Eliminar a ${u.nombre} ${u.apellido}?');">
                                                        <input type="hidden" name="action" value="eliminar">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <button type="submit" class="action-btn delete" title="Eliminar">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                    <c:if test="${sessionScope.usuario.idRol == 1 && u.id != sessionScope.usuario.id}">
                                                        <form method="post" action="${pageContext.request.contextPath}/usuarios" style="display:inline;">
                                                            <input type="hidden" name="action" value="cambiarRol">
                                                            <input type="hidden" name="id" value="${u.id}">
                                                            <input type="hidden" name="idrol" value="${u.idRol == 1 ? 3 : 1}">
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
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }
        // Auto-hide toast after 4 seconds
        setTimeout(() => {
            document.querySelectorAll('.toast-container').forEach(t => t.style.display = 'none');
        }, 4000);
    </script>
</body>
</html>