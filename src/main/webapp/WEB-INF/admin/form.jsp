<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty usuario ? 'Nuevo Usuario' : 'Editar Usuario'} - Quiddity</title>
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

        .page-header h2 {
            font-weight: 700;
            color: var(--text-light);
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

        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 0.75rem;
            overflow: hidden;
            max-width: 800px;
        }

        .form-card-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 1.5rem 2rem;
            color: white;
        }

        .form-card-header h3 {
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .form-card-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--text-light);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-label .required {
            color: var(--danger);
            margin-left: 0.25rem;
        }

        .form-control-custom, .form-select-custom {
            width: 100%;
            padding: 0.75rem 1rem;
            background: var(--bg-dark);
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            color: var(--text-light);
            font-size: 0.875rem;
            transition: all 0.2s;
        }

        .form-control-custom:focus, .form-select-custom:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .form-control-custom::placeholder { color: var(--text-muted); }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--border);
            margin-bottom: 1rem;
        }

        .avatar-default {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 2rem;
            border: 3px solid var(--border);
            margin-bottom: 1rem;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            border-radius: 0.5rem;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
        }

        .btn-cancel {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text-muted);
            padding: 0.875rem 2rem;
            border-radius: 0.5rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            border-color: var(--danger);
            color: var(--danger);
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 0.5rem;
            padding: 1rem 1.25rem;
            color: #fca5a5;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .input-icon-wrapper {
            position: relative;
        }

        .input-icon-wrapper i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .input-icon-wrapper .form-control-custom {
            padding-left: 2.5rem;
        }

        .role-selector {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .role-option {
            flex: 1;
            min-width: 140px;
        }

        .role-option input {
            display: none;
        }

        .role-option label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem;
            background: var(--bg-dark);
            border: 2px solid var(--border);
            border-radius: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .role-option label i {
            font-size: 1.5rem;
        }

        .role-option label span {
            font-size: 0.875rem;
            font-weight: 600;
        }

        .role-option input:checked + label {
            border-color: var(--primary);
            background: rgba(99, 102, 241, 0.1);
        }

        .role-option.admin label i { color: var(--danger); }
        .role-option.buyer label i { color: var(--success); }
        .role-option.user label i { color: var(--info); }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 1rem; }
            .form-row { grid-template-columns: 1fr; }
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
                        <i class="fas ${empty usuario ? 'fa-user-plus' : 'fa-user-edit'}" style="color: var(--primary); margin-right: 0.5rem;"></i>
                        ${empty usuario ? 'Nuevo Usuario' : 'Editar Usuario'}
                    </h2>
                </div>
            </div>

            <div class="form-card">
                <div class="form-card-header">
                    <h3>
                        <i class="fas ${empty usuario ? 'fa-plus-circle' : 'fa-edit'}"></i>
                        ${empty usuario ? 'Crear nuevo usuario' : 'Editar información de '.concat(usuario.nombre).concat(' ').concat(usuario.apellido)}
                    </h3>
                </div>
                <div class="form-card-body">
                    <c:if test="${not empty error}">
                        <div class="alert-error">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/usuarios">
                        <input type="hidden" name="action" value="${empty usuario ? 'crear' : 'editar'}">
                        <c:if test="${not empty usuario}">
                            <input type="hidden" name="id" value="${usuario.id}">
                        </c:if>

                        <!-- Avatar Preview -->
                        <div style="text-align: center; margin-bottom: 2rem;">
                            <c:choose>
                                <c:when test="${not empty usuario.fotoPerfil}">
                                    <img src="${pageContext.request.contextPath}/uploads/${usuario.fotoPerfil}" alt="Avatar" class="avatar-preview" id="avatarPreview">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-default" id="avatarPreview">
                                        <c:choose>
                                            <c:when test="${not empty usuario}">
                                                ${usuario.nombre.charAt(0)}${usuario.apellido.charAt(0)}
                                            </c:when>
                                            <c:otherwise>?</c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nombre <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-user"></i>
                                    <input type="text" name="nombre" class="form-control-custom" 
                                           value="${usuario.nombre}" required placeholder="Ej: Juan">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Apellido <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-user"></i>
                                    <input type="text" name="apellido" class="form-control-custom" 
                                           value="${usuario.apellido}" required placeholder="Ej: Pérez">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-envelope"></i>
                                    <input type="email" name="email" class="form-control-custom" 
                                           value="${usuario.email}" required placeholder="ejemplo@correo.com">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Documento <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-id-card"></i>
                                    <input type="text" name="documento" class="form-control-custom" 
                                           value="${usuario.documento}" required placeholder="Número de documento">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nombre de usuario <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-at"></i>
                                    <input type="text" name="username" class="form-control-custom" 
                                           value="${usuario.userName}" required placeholder="@username">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Foto de perfil (URL)</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-image"></i>
                                    <input type="text" name="fotoperfil" class="form-control-custom" 
                                           value="${usuario.fotoPerfil}" placeholder="nombre_archivo.jpg">
                                </div>
                            </div>
                        </div>

                        <c:if test="${empty usuario}">
                            <div class="form-group">
                                <label class="form-label">Contraseña <span class="required">*</span></label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" name="contrasena" class="form-control-custom" 
                                           required placeholder="Mínimo 6 caracteres">
                                </div>
                            </div>
                        </c:if>

                        <!-- Role Selector -->
                        <div class="form-group">
                            <label class="form-label">Rol <span class="required">*</span></label>
                            <div class="role-selector">
                                <div class="role-option admin">
                                    <input type="radio" name="idrol" id="rolAdmin" value="1" 
                                           ${usuario.idRol == 1 ? 'checked' : ''} ${not empty usuario && sessionScope.usuario.idRol != 1 ? 'disabled' : ''}>
                                    <label for="rolAdmin">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Administrador</span>
                                        <small style="color: var(--text-muted); font-size: 0.75rem;">Control total</small>
                                    </label>
                                </div>
                                <div class="role-option buyer">
                                    <input type="radio" name="idrol" id="rolBuyer" value="2" 
                                           ${usuario.idRol == 2 ? 'checked' : ''} ${not empty usuario && sessionScope.usuario.idRol != 1 ? 'disabled' : ''}>
                                    <label for="rolBuyer">
                                        <i class="fas fa-shopping-bag"></i>
                                        <span>Comprador</span>
                                        <small style="color: var(--text-muted); font-size: 0.75rem;">Puede comprar</small>
                                    </label>
                                </div>
                                <div class="role-option user">
                                    <input type="radio" name="idrol" id="rolUser" value="3" 
                                           ${empty usuario || usuario.idRol == 3 ? 'checked' : ''} ${not empty usuario && sessionScope.usuario.idRol != 1 ? 'disabled' : ''}>
                                    <label for="rolUser">
                                        <i class="fas fa-user"></i>
                                        <span>Usuario</span>
                                        <small style="color: var(--text-muted); font-size: 0.75rem;">Acceso básico</small>
                                    </label>
                                </div>
                            </div>
                            <c:if test="${not empty usuario && sessionScope.usuario.idRol != 1}">
                                <small style="color: var(--text-muted); display: block; margin-top: 0.5rem;">
                                    <i class="fas fa-info-circle"></i> Solo los administradores pueden cambiar el rol.
                                </small>
                            </c:if>
                        </div>

                        <div style="display: flex; gap: 1rem; justify-content: flex-end; margin-top: 2rem;">
                            <a href="${pageContext.request.contextPath}/usuarios" class="btn-cancel">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                            <button type="submit" class="btn-submit">
                                <i class="fas ${empty usuario ? 'fa-plus' : 'fa-save'}"></i>
                                ${empty usuario ? 'Crear Usuario' : 'Guardar Cambios'}
                            </button>
                        </div>
                    </form>
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