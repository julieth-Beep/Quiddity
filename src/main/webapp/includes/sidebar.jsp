<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


        <!-- ═══════════════════════════════════════════════════════════
     SIDEBAR QUIDDITY — Minimalist Unisex Design (Salleist Style)
═══════════════════════════════════════════════════════════ -->
        <aside id="sidebar" class="sidebar">

            <!-- ══ HEADER ══ -->
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-brand">
                    <div class="brand-logo">
                        <span class="material-symbols-outlined">eco</span>
                    </div>
                    <span class="brand-text">QUIDDITY</span>
                </a>
            </div>

            <!-- ══ NAVEGACIÓN PRINCIPAL ══ -->
            <nav class="sidebar-nav">

                <!-- ── SECCIÓN PÚBLICA ── -->
                <div class="nav-section">
                    <p class="nav-section-label">Menu</p>
                    <ul class="nav-list">
                        <li class="nav-item ${activePage == 'home' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">
                                <span class="material-symbols-outlined nav-icon">home</span>
                                <span class="nav-text">Home</span>
                            </a>
                        </li>
                        <li class="nav-item ${activePage == 'catalogo' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/comprador/catalogo.jsp" class="nav-link">
                                <span class="material-symbols-outlined nav-icon">category</span>
                                <span class="nav-text">Catálogo</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- ══════════════════════════════════════════════
             PANEL USUARIO (rol = 3)
        ══════════════════════════════════════════════ -->
                <c:if test="${sessionScope.usuario.idRol == 3}">
                    <div class="nav-section">
                        <p class="nav-section-label">Personal</p>
                        <ul class="nav-list">
                            <li class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/usuario/dashboard" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">dashboard</span>
                                    <span class="nav-text">Dashboard</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'facescan' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/facefull" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">face</span>
                                    <span class="nav-text">Face Scan</span>
                                    <span class="nav-badge">AI</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'closet' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/closet" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">checkroom</span>
                                    <span class="nav-text">Mi Clóset</span>
                                </a>
                            </li>
                            <li class="nav-item ${seccionActiva == 'outfit' ? 'active' : ''}">
    <a href="${pageContext.request.contextPath}/outfit" class="nav-link">
        <span class="material-symbols-outlined nav-icon">style</span>
        <span class="nav-text">Armar Outfit</span>
    </a>
</li>

<li class="nav-item ${seccionActiva == 'historial' ? 'active' : ''}">
    <a href="${pageContext.request.contextPath}/look" class="nav-link">
        <span class="material-symbols-outlined nav-icon">photo_library</span>
        <span class="nav-text">Mis Looks</span>
    </a>
</li>

<li class="nav-item ${seccionActiva == 'chat' ? 'active' : ''}">
    <a href="${pageContext.request.contextPath}/chat" class="nav-link">
        <span class="material-symbols-outlined nav-icon">smart_toy</span>
        <span class="nav-text">Chat IA</span>
        <span class="nav-badge">AI</span>
    </a>
</li>

<li class="nav-item ${seccionActiva == 'calendario' ? 'active' : ''}">
    <a href="${pageContext.request.contextPath}/calendario" class="nav-link">
        <span class="material-symbols-outlined nav-icon">calendar_month</span>
        <span class="nav-text">Calendario</span>
    </a>
</li>

<li class="nav-item ${seccionActiva == 'viajes' ? 'active' : ''}">
    <a href="${pageContext.request.contextPath}/viajes" class="nav-link">
        <span class="material-symbols-outlined nav-icon">flight</span>
        <span class="nav-text">Viajes</span>
    </a>
</li>

                            <li class="nav-item ${activePage == 'caracteristicas' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/caracteristicas" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">face</span>
                                    <span class="nav-text">Características</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'rutinas' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/usuario/rutinas" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">self_improvement</span>
                                    <span class="nav-text">Rutinas</span>
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="nav-section">
                        <p class="nav-section-label">Shopping</p>
                        <ul class="nav-list">
                            <li class="nav-item ${activePage == 'carrito' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/carrito" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">shopping_bag</span>
                                    <span class="nav-text">Carrito</span>
                                    <span class="nav-count" id="cart-count">0</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'favoritos' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/comprador/favoritos.jsp" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">favorite</span>
                                    <span class="nav-text">Favoritos</span>
                                    <span class="nav-count" id="fav-count">0</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:if>

                <!-- ══════════════════════════════════════════════
             PANEL COMPRADOR (rol = 2)
        ══════════════════════════════════════════════ -->
                <c:if test="${sessionScope.usuario.idRol == 2}">
                    <div class="nav-section">
                        <p class="nav-section-label">Shopping</p>
                        <ul class="nav-list">
                            <li class="nav-item ${activePage == 'carrito' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/carrito" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">shopping_bag</span>
                                    <span class="nav-text">Carrito</span>
                                    <span class="nav-count" id="cart-count">0</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'favoritos' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/comprador/favoritos.jsp" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">favorite</span>
                                    <span class="nav-text">Favoritos</span>
                                    <span class="nav-count" id="fav-count">0</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'compras' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/comprador/compras.jsp" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">receipt_long</span>
                                    <span class="nav-text">Mis Compras</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:if>

                <!-- ══════════════════════════════════════════════
             PANEL ADMINISTRADOR (rol = 1)
        ══════════════════════════════════════════════ -->
                <c:if test="${sessionScope.usuario.idRol == 1}">
                    <div class="nav-section">
                        <p class="nav-section-label">Admin</p>
                        <ul class="nav-list">
                            <li class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">monitoring</span>
                                    <span class="nav-text">Dashboard</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'usuarios' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/admin/usuarios" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">group</span>
                                    <span class="nav-text">Usuarios</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'catalogo-admin' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/admin/catalogo" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">inventory_2</span>
                                    <span class="nav-text">Catálogo</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'pedidos' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/admin/pedidos" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">local_shipping</span>
                                    <span class="nav-text">Pedidos</span>
                                    <span class="nav-count" id="pending-orders">0</span>
                                </a>
                            </li>
                            <li class="nav-item ${activePage == 'estadisticas' ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/admin/estadisticas" class="nav-link">
                                    <span class="material-symbols-outlined nav-icon">bar_chart</span>
                                    <span class="nav-text">Estadísticas</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </nav>

            <!-- ══ USUARIO / FOOTER ══ -->
            <div class="sidebar-footer">
                <!-- User Profile -->
    <div class="user-profile">
        <div class="user-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                    <img src="${pageContext.request.contextPath}/uploads/perfiles/${sessionScope.usuario.fotoPerfil}"
                        alt="Avatar" 
                        class="avatar-img"
                        onerror="this.style.display='none'; this.parentElement.innerHTML='<span class=\'avatar-initials\'>${fn:substring(sessionScope.usuario.nombre, 0, 1)}</span>';" />
                </c:when>
                <c:otherwise>
                    <span class="avatar-initials">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuario.nombre}">
                                ${fn:substring(sessionScope.usuario.nombre, 0, 1)}
                            </c:when>
                            <c:otherwise>U</c:otherwise>
                        </c:choose>
                    </span>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="user-details">
            <p class="user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        ${sessionScope.usuario.nombre}
                    </c:when>
                    <c:otherwise>Invitado</c:otherwise>
                </c:choose>
            </p>
            <p class="user-role">
                <c:choose>
                    <c:when test="${sessionScope.usuario.idRol == 1}">Administrator</c:when>
                    <c:when test="${sessionScope.usuario.idRol == 2}">Buyer</c:when>
                    <c:when test="${sessionScope.usuario.idRol == 3}">Premium User</c:when>
                    <c:otherwise>Guest</c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

                <!-- Footer Links -->
                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/perfil" class="footer-link">
                        <span class="material-symbols-outlined">settings</span>
                        <span>Settings</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="footer-link logout">
                        <span class="material-symbols-outlined">logout</span>
                        <span>Log Out</span>
                    </a>
                </div>

                            </div>
        </aside>

        <!-- Overlay para móvil -->
        <div id="sidebar-overlay" class="sidebar-overlay"></div>

        <!-- Botón toggle móvil -->
        <button type="button" id="sidebar-toggle" class="sidebar-toggle" aria-label="Abrir menú">
            <span class="material-symbols-outlined">menu</span>
        </button>

        <!-- ═══════════════════════════════════════════════════════════
     ESTILOS — Minimalist Unisex (Salleist Inspired)
═══════════════════════════════════════════════════════════ -->
        <style>
            :root {
                --sidebar-bg: #ffffff;
                --sidebar-border: #f0f0f0;
                --text-primary: #1a1a1a;
                --text-secondary: #737373;
                --text-muted: #a3a3a3;
                --hover-bg: #fafafa;
                --active-bg: #1a1a1a;
                --active-text: #ffffff;
                --accent: #9a3a5a;
                --accent-soft: rgba(154, 58, 90, 0.1);
                --badge-bg: #1a1a1a;
                --badge-text: #ffffff;
                --border-color: #e5e5e5;
                --sidebar-width: 240px;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: var(--sidebar-width);
                height: 100vh;
                background: var(--sidebar-bg);
                border-right: 1px solid var(--sidebar-border);
                display: flex;
                flex-direction: column;
                z-index: 1000;
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                overflow: hidden;
            }

            /* ── HEADER ── */
            .sidebar-header {
                padding: 24px 20px;
                border-bottom: 1px solid var(--sidebar-border);
            }

            .sidebar-brand {
                display: flex;
                align-items: center;
                gap: 12px;
                text-decoration: none;
            }

            .brand-logo {
                width: 36px;
                height: 36px;
                background: var(--active-bg);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: transform 0.2s ease;
            }

            .sidebar-brand:hover .brand-logo {
                transform: scale(1.05);
            }

            .brand-logo .material-symbols-outlined {
                font-size: 20px !important;
                color: white;
            }

            .brand-text {
                font-family: 'Manrope', sans-serif;
                font-size: 18px;
                font-weight: 700;
                color: var(--text-primary);
                letter-spacing: 0.02em;
            }

            /* ── NAVEGACIÓN ── */
            .sidebar-nav {
                flex: 1;
                padding: 20px 12px;
                overflow-y: auto;
            }

            .sidebar-nav::-webkit-scrollbar {
                width: 4px;
            }

            .sidebar-nav::-webkit-scrollbar-track {
                background: transparent;
            }

            .sidebar-nav::-webkit-scrollbar-thumb {
                background: var(--border-color);
                border-radius: 2px;
            }

            .nav-section {
                margin-bottom: 24px;
            }

            .nav-section-label {
                font-family: 'Manrope', sans-serif;
                font-size: 11px;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.1em;
                padding: 0 12px;
                margin-bottom: 12px;
            }

            .nav-list {
                list-style: none;
            }

            .nav-item {
                margin-bottom: 2px;
            }

            .nav-link {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 12px;
                text-decoration: none;
                color: var(--text-secondary);
                font-family: 'Manrope', sans-serif;
                font-size: 13px;
                font-weight: 500;
                border-radius: 8px;
                transition: all 0.2s ease;
                position: relative;
            }

            .nav-link:hover {
                background: var(--hover-bg);
                color: var(--text-primary);
            }

            .nav-item.active .nav-link {
                background: var(--active-bg);
                color: var(--active-text);
            }

            .nav-icon {
                font-size: 18px !important;
                flex-shrink: 0;
                transition: transform 0.2s ease;
            }

            .nav-link:hover .nav-icon {
                transform: scale(1.05);
            }

            .nav-text {
                flex: 1;
                white-space: nowrap;
            }

            /* ── Badges ── */
            .nav-badge {
                display: inline-flex;
                align-items: center;
                padding: 2px 8px;
                border-radius: 6px;
                background: var(--accent);
                color: white;
                font-family: 'Manrope', sans-serif;
                font-size: 9px;
                font-weight: 700;
                letter-spacing: 0.05em;
                text-transform: uppercase;
            }

            .nav-count {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 20px;
                height: 20px;
                padding: 0 6px;
                border-radius: 10px;
                background: var(--hover-bg);
                color: var(--text-secondary);
                font-family: 'Manrope', sans-serif;
                font-size: 11px;
                font-weight: 600;
                transition: all 0.2s ease;
            }

            .nav-count:not(:empty) {
                background: var(--active-bg);
                color: white;
            }

            /* ── FOOTER ── */
            .sidebar-footer {
                padding: 16px;
                border-top: 1px solid var(--sidebar-border);
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            /* User Profile */
            .user-profile {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                background: var(--hover-bg);
                border-radius: 10px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                background: var(--active-bg);
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
                flex-shrink: 0;
            }

            .avatar-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .avatar-initials {
                font-family: 'Manrope', sans-serif;
                font-size: 14px;
                font-weight: 600;
                color: white;
            }

            .user-details {
                flex: 1;
                min-width: 0;
            }

            .user-name {
                font-family: 'Manrope', sans-serif;
                font-size: 13px;
                font-weight: 600;
                color: var(--text-primary);
                margin: 0 0 2px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .user-role {
                font-family: 'Manrope', sans-serif;
                font-size: 11px;
                color: var(--text-muted);
                margin: 0;
            }

            /* Footer Links */
            .footer-links {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .footer-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 8px 12px;
                text-decoration: none;
                color: var(--text-secondary);
                font-family: 'Manrope', sans-serif;
                font-size: 13px;
                font-weight: 500;
                border-radius: 8px;
                transition: all 0.2s ease;
            }

            .footer-link:hover {
                background: var(--hover-bg);
                color: var(--text-primary);
            }

            .footer-link .material-symbols-outlined {
                font-size: 18px !important;
            }

            .footer-link.logout:hover {
                color: #dc2626;
                background: rgba(220, 38, 38, 0.05);
            }

            .footer-link.logout:hover .material-symbols-outlined {
                color: #dc2626;
            }

            /* Upgrade Card */
            .upgrade-card {
                background: var(--active-bg);
                border-radius: 12px;
                padding: 16px;
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .upgrade-icon {
                width: 40px;
                height: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .upgrade-icon .material-symbols-outlined {
                font-size: 22px !important;
                color: white;
            }

            .upgrade-content {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .upgrade-title {
                font-family: 'Manrope', sans-serif;
                font-size: 14px;
                font-weight: 600;
                color: white;
                margin: 0;
            }

            .upgrade-desc {
                font-family: 'Manrope', sans-serif;
                font-size: 12px;
                color: rgba(255, 255, 255, 0.6);
                margin: 0;
            }

            .upgrade-btn {
                width: 100%;
                padding: 10px;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 8px;
                color: white;
                font-family: 'Manrope', sans-serif;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .upgrade-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                border-color: rgba(255, 255, 255, 0.3);
            }

            /* ── OVERLAY ── */
            .sidebar-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(4px);
                z-index: 999;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .sidebar-overlay.active {
                display: block;
                opacity: 1;
            }

            /* ── TOGGLE MÓVIL ── */
            .sidebar-toggle {
                display: none;
                position: fixed;
                top: 16px;
                left: 16px;
                z-index: 998;
                width: 40px;
                height: 40px;
                background: white;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--text-primary);
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                transition: all 0.2s ease;
            }

            .sidebar-toggle:hover {
                background: var(--hover-bg);
            }

            .sidebar-toggle .material-symbols-outlined {
                font-size: 20px;
            }

            /* ── LAYOUT ── */
            .layout-with-sidebar {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                margin-left: var(--sidebar-width);
                min-height: 100vh;
                /* SIN background forzado — cada página define el suyo */
            }

            /* ── RESPONSIVE ── */
            @media (max-width: 1024px) {
                .sidebar {
                    transform: translateX(-100%);
                    box-shadow: 4px 0 24px rgba(0, 0, 0, 0.1);
                }

                .sidebar.open {
                    transform: translateX(0);
                }

                .main-content {
                    margin-left: 0;
                }

                .sidebar-toggle {
                    display: flex;
                }
            }

            @media (max-width: 640px) {
                .sidebar {
                    width: 100%;
                    max-width: 300px;
                }

                :root {
                    --sidebar-width: 100%;
                }
            }

            /* ── ANIMACIONES ── */
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(-8px);
                }

                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .nav-item {
                animation: slideIn 0.3s ease backwards;
            }

            .nav-item:nth-child(1) {
                animation-delay: 0.02s;
            }

            .nav-item:nth-child(2) {
                animation-delay: 0.04s;
            }

            .nav-item:nth-child(3) {
                animation-delay: 0.06s;
            }

            .nav-item:nth-child(4) {
                animation-delay: 0.08s;
            }

            .nav-item:nth-child(5) {
                animation-delay: 0.1s;
            }

            .nav-item:nth-child(6) {
                animation-delay: 0.12s;
            }
        </style>

        <!-- ═══════════════════════════════════════════════════════════
     SCRIPT
═══════════════════════════════════════════════════════════ -->
        <script>
            (function () {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebar-overlay');
                const toggleBtn = document.getElementById('sidebar-toggle');

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

                if (overlay) overlay.addEventListener('click', closeSidebar);
                if (toggleBtn) toggleBtn.addEventListener('click', openSidebar);

                window.toggleSidebar = function () {
                    sidebar.classList.contains('open') ? closeSidebar() : openSidebar();
                };

                window.addEventListener('resize', function () {
                    if (window.innerWidth > 1024) closeSidebar();
                });

                // Cerrar al hacer click en un link (móvil)
                document.querySelectorAll('.nav-link, .footer-link').forEach(link => {
                    link.addEventListener('click', function () {
                        if (window.innerWidth <= 1024) {
                            setTimeout(closeSidebar, 150);
                        }
                    });
                });
            })();
        </script>