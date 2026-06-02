<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- ── Sidebar ── -->
<aside id="sidebar" class="sidebar">
    <!-- Header del sidebar -->
    <div class="sidebar-header">
        <div class="sidebar-brand">
            <span class="material-symbols-outlined brand-icon">spa</span>
            <span class="brand-text">Belleza</span>
        </div>
        <button type="button" id="sidebar-close" class="sidebar-close-btn" aria-label="Cerrar menú">
            <span class="material-symbols-outlined">close</span>
        </button>
    </div>

    <!-- Info del usuario -->
    <div class="sidebar-user">
        <div class="user-avatar">
            <span class="material-symbols-outlined">person</span>
        </div>
        <div class="user-info">
            <p class="user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        ${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}
                    </c:when>
                    <c:otherwise>Invitado</c:otherwise>
                </c:choose>
            </p>
            <p class="user-role">
                <c:choose>
                    <c:when test="${sessionScope.usuario.idRol == 1}">Administrador</c:when>
                    <c:when test="${sessionScope.usuario.idRol == 2}">Comprador</c:when>
                    <c:when test="${sessionScope.usuario.idRol == 3}">Usuario</c:when>
                    <c:otherwise>Sin rol</c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <!-- Navegación -->
    <nav class="sidebar-nav">
        <p class="nav-section-title">Menú Principal</p>

        <ul class="nav-list">

            <!-- ── Catálogo (todos los roles) ── -->
            <li class="nav-item ${activePage == 'catalogo' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/catalogo" class="nav-link">
                    <span class="material-symbols-outlined nav-icon">category</span>
                    <span class="nav-text">Catálogo</span>
                </a>
            </li>

            <!-- ══════════════════════════════════
                 SECCIÓN ADMIN (rol = 1)
                 Rutas: /admin/dashboard, /admin/usuarios, /admin/reportes
                 ══════════════════════════════════ -->
            <c:if test="${sessionScope.usuario.idRol == 1}">
                <li class="nav-divider"></li>
                <p class="nav-section-title">Administración</p>

                <li class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">dashboard</span>
                        <span class="nav-text">Dashboard</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'usuarios' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/usuarios" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">group</span>
                        <span class="nav-text">Usuarios</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'reportes' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/reportes" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">bar_chart</span>
                        <span class="nav-text">Reportes</span>
                    </a>
                </li>
            </c:if>

            <!-- ══════════════════════════════════
                 SECCIÓN COMPRADOR (rol = 2)
                 Rutas: /carrito
                 ══════════════════════════════════ -->
            <c:if test="${sessionScope.usuario.idRol == 2}">
                <li class="nav-divider"></li>
                <p class="nav-section-title">Compras</p>

                <li class="nav-item ${activePage == 'carrito' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/carrito" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">shopping_cart</span>
                        <span class="nav-text">Mi Carrito</span>
                    </a>
                </li>
            </c:if>

            <!-- ══════════════════════════════════
                 SECCIÓN USUARIO (rol = 3)
                 Rutas: /usuario/dashboard, /caracteristicas,
                        /estadoAnimo, /facefull, /chatbot
                 ══════════════════════════════════ -->
            <c:if test="${sessionScope.usuario.idRol == 3}">
                <li class="nav-divider"></li>
                <p class="nav-section-title">Mi Cuenta</p>

                <li class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/usuario/dashboard" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">dashboard</span>
                        <span class="nav-text">Dashboard</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'caracteristicas' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/caracteristicas" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">face</span>
                        <span class="nav-text">Características</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'estadoAnimo' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/estadoAnimo" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">mood</span>
                        <span class="nav-text">Estado de Ánimo</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'facescan' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/facefull" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">photo_camera</span>
                        <span class="nav-text">Face Scan</span>
                    </a>
                </li>
                <li class="nav-item ${activePage == 'chatbot' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/chatbot" class="nav-link">
                        <span class="material-symbols-outlined nav-icon">chat</span>
                        <span class="nav-text">Chatbot</span>
                    </a>
                </li>
            </c:if>

        </ul>
    </nav>

    <!-- Footer del sidebar -->
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/usuarios?id=${sessionScope.usuario.id}"
           class="footer-link ${activePage == 'perfil' ? 'active' : ''}">
            <span class="material-symbols-outlined">settings_account_box</span>
            <span>Perfil</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="footer-link logout-link">
            <span class="material-symbols-outlined">logout</span>
            <span>Cerrar Sesión</span>
        </a>
    </div>
</aside>

<!-- Overlay para móvil -->
<div id="sidebar-overlay" class="sidebar-overlay"></div>

<!-- ── Estilos del Sidebar ── -->
<style>
    :root {
        --primary: #9a3a5a;
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
        --element-gap: 24px;
        --gutter: 32px;
    }

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 280px;
        height: 100vh;
        background: var(--surface);
        border-right: 1px solid var(--surface-variant);
        display: flex;
        flex-direction: column;
        z-index: 1000;
        transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        overflow-y: auto;
        overflow-x: hidden;
    }
    .sidebar::-webkit-scrollbar { width: 4px; }
    .sidebar::-webkit-scrollbar-track { background: var(--background); }
    .sidebar::-webkit-scrollbar-thumb { background: #e6e1e4; }

    .sidebar-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 24px var(--gutter) 20px;
        border-bottom: 1px solid var(--surface-variant);
    }
    .sidebar-brand {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .brand-icon {
        font-size: 28px !important;
        color: var(--primary);
    }
    .brand-text {
        font-family: 'EB Garamond', Georgia, serif;
        font-size: 24px;
        font-weight: 400;
        color: var(--on-surface);
        line-height: 32px;
    }
    .sidebar-close-btn {
        display: none;
        background: none;
        border: none;
        cursor: pointer;
        padding: 4px;
        color: var(--on-surface-variant);
        transition: color 0.2s;
    }
    .sidebar-close-btn:hover { color: var(--on-surface); }

    .sidebar-user {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 20px var(--gutter);
        border-bottom: 1px solid var(--surface-variant);
    }
    .user-avatar {
        width: 44px;
        height: 44px;
        border-radius: 9999px;
        background: var(--surface-variant);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .user-avatar .material-symbols-outlined {
        font-size: 24px;
        color: var(--primary);
    }
    .user-info { min-width: 0; overflow: hidden; }
    .user-name {
        font-family: 'Manrope', sans-serif;
        font-size: 16px;
        font-weight: 600;
        color: var(--on-surface);
        line-height: 24px;
        margin: 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .user-role {
        font-family: 'Manrope', sans-serif;
        font-size: 13px;
        font-weight: 400;
        color: var(--on-surface-variant);
        line-height: 20px;
        margin: 0;
        letter-spacing: 0.02em;
    }

    .sidebar-nav {
        flex: 1;
        padding: 16px 0;
        overflow-y: auto;
    }
    .nav-section-title {
        font-family: 'Manrope', sans-serif;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: var(--outline);
        padding: 0 var(--gutter);
        margin: 16px 0 8px;
    }
    .nav-list { list-style: none; margin: 0; padding: 0; }
    .nav-item {
        margin: 2px var(--gutter);
        border-radius: 0;
    }
    .nav-item.active { background: rgba(154, 58, 90, 0.08); }
    .nav-item.active .nav-link { color: var(--primary); }
    .nav-item.active .nav-icon {
        color: var(--primary);
        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    .nav-link {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 12px 16px;
        text-decoration: none;
        color: var(--on-surface-variant);
        font-family: 'Manrope', sans-serif;
        font-size: 14px;
        font-weight: 500;
        line-height: 20px;
        transition: color 0.2s, background 0.2s;
    }
    .nav-link:hover {
        color: var(--on-surface);
        background: rgba(28, 27, 29, 0.04);
    }
    .nav-icon {
        font-size: 22px !important;
        color: var(--on-surface-variant);
        transition: color 0.2s;
        flex-shrink: 0;
    }
    .nav-text { white-space: nowrap; }
    .nav-divider {
        height: 1px;
        background: var(--surface-variant);
        margin: 16px var(--gutter);
    }

    .sidebar-footer {
        padding: 16px var(--gutter) 24px;
        border-top: 1px solid var(--surface-variant);
        display: flex;
        flex-direction: column;
        gap: 4px;
    }
    .footer-link {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 10px 16px;
        text-decoration: none;
        color: var(--on-surface-variant);
        font-family: 'Manrope', sans-serif;
        font-size: 14px;
        font-weight: 500;
        line-height: 20px;
        transition: color 0.2s, background 0.2s;
    }
    .footer-link:hover {
        color: var(--on-surface);
        background: rgba(28, 27, 29, 0.04);
    }
    .footer-link.active {
        color: var(--primary);
        background: rgba(154, 58, 90, 0.08);
    }
    .footer-link .material-symbols-outlined {
        font-size: 22px !important;
        flex-shrink: 0;
    }
    .logout-link:hover { color: #b3261e; }

    .sidebar-overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(28, 27, 29, 0.5);
        z-index: 999;
        opacity: 0;
        transition: opacity 0.3s;
    }
    .sidebar-overlay.active {
        display: block;
        opacity: 1;
    }

    .layout-with-sidebar {
        display: flex;
        min-height: 100vh;
    }
    .main-content {
        flex: 1;
        margin-left: 280px;
        min-height: 100vh;
        background: var(--background);
    }

    .sidebar-toggle {
        display: none;
        position: fixed;
        top: 16px;
        left: 16px;
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
    .sidebar-toggle .material-symbols-outlined { font-size: 24px; }

    @media (max-width: 1024px) {
        .sidebar { transform: translateX(-100%); }
        .sidebar.open { transform: translateX(0); }
        .sidebar-close-btn {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .main-content { margin-left: 0; }
        .sidebar-toggle { display: flex; }
    }
    @media (max-width: 640px) {
        .sidebar { width: 100%; max-width: 320px; }
    }
</style>

<!-- ── Script del Sidebar ── -->
<script>
    (function() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        const closeBtn = document.getElementById('sidebar-close');

        function openSidebar() {
            sidebar.classList.add('open');
            overlay.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function closeSidebar() {
            sidebar.classList.remove('open');
            overlay.classList.remove('active');
            document.body.style.overflow = '';
        }
        if (closeBtn) { closeBtn.addEventListener('click', closeSidebar); }
        if (overlay) { overlay.addEventListener('click', closeSidebar); }

        window.toggleSidebar = function() {
            if (sidebar.classList.contains('open')) { closeSidebar(); }
            else { openSidebar(); }
        };
        window.addEventListener('resize', function() {
            if (window.innerWidth > 1024) { closeSidebar(); }
        });
    })();
</script>
