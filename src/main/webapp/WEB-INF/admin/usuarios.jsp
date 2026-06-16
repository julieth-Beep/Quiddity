<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="es">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Usuarios — Quiddity</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
                <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">

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
                        --pastel-sage: #f1f8e9;
                        --pastel-sage-dark: #dcedc8;

                        --accent-sky: #1976d2;
                        --accent-mint: #388e3c;
                        --accent-lavender: #7b1fa2;
                        --accent-cream: #f57c00;
                        --accent-coral: #c2185b;
                        --accent-sage: #689f38;

                        --radius-sm: 12px;
                        --radius-md: 14px;
                        --radius-lg: 16px;
                        --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
                        --shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                        --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.08);
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        background: var(--bg);
                        color: var(--text-primary);
                        line-height: 1.4;
                        -webkit-font-smoothing: antialiased;
                        font-size: 12px;
                        overflow-x: hidden;
                        position: relative;
                    }

                    /* Ilustraciones flotantes */
                    body::before {
                        content: '';
                        position: fixed;
                        top: -200px;
                        right: -200px;
                        width: 600px;
                        height: 600px;
                        background: radial-gradient(circle, var(--pastel-lavender) 0%, transparent 70%);
                        opacity: 0.5;
                        z-index: 0;
                        animation: floatBlob 12s ease-in-out infinite;
                        pointer-events: none;
                    }

                    body::after {
                        content: '';
                        position: fixed;
                        bottom: -200px;
                        left: -200px;
                        width: 500px;
                        height: 500px;
                        background: radial-gradient(circle, var(--pastel-mint) 0%, transparent 70%);
                        opacity: 0.4;
                        z-index: 0;
                        animation: floatBlob 15s ease-in-out infinite reverse;
                        pointer-events: none;
                    }

                    @keyframes floatBlob {

                        0%,
                        100% {
                            transform: translate(0, 0) scale(1);
                        }

                        33% {
                            transform: translate(30px, -40px) scale(1.05);
                        }

                        66% {
                            transform: translate(-20px, 30px) scale(0.95);
                        }
                    }

                    /* Layout */
                    .layout-wrapper {
                        display: flex;
                        height: 100vh;
                        overflow: hidden;
                    }

                    .main-content {
                        flex: 1;
                        padding: 16px 20px;
                        display: flex;
                        flex-direction: column;
                        height: 100vh;
                        overflow-y: auto;
                        position: relative;
                        z-index: 1;
                    }

                    /* Welcome section */
                    .welcome-section {
                        margin-bottom: 14px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        background: var(--surface);
                        border-radius: var(--radius-lg);
                        padding: 16px 20px;
                        border: 1px solid var(--border);
                        box-shadow: var(--shadow-sm);
                    }

                    .welcome-content {
                        flex: 1;
                    }

                    .welcome-title {
                        font-family: 'DM Sans', sans-serif;
                        font-size: 22px;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin: 0 0 3px 0;
                        letter-spacing: -0.3px;
                    }

                    .welcome-subtitle {
                        font-size: 12px;
                        color: var(--text-secondary);
                        font-weight: 500;
                        margin: 0;
                    }

                    .btn-new-user {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        padding: 8px 16px;
                        background: var(--pastel-sky);
                        border: 1px solid var(--pastel-sky-dark);
                        border-radius: var(--radius-md);
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        font-size: 12px;
                        font-weight: 600;
                        color: var(--accent-sky);
                        text-decoration: none;
                        transition: all 0.25s ease;
                    }

                    .btn-new-user:hover {
                        background: var(--pastel-sky-dark);
                        transform: translateY(-1px);
                        box-shadow: var(--shadow);
                        color: var(--accent-sky);
                    }

                    /* Stats cards (KPIs) */
                    .stats-row {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 12px;
                        margin-bottom: 14px;
                    }

                    .stat-card {
                        background: var(--surface);
                        border-radius: var(--radius-md);
                        padding: 14px 16px;
                        box-shadow: var(--shadow-sm);
                        border: 1px solid var(--border-light);
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        cursor: default;
                    }

                    .stat-card:hover {
                        transform: translateY(-3px);
                        box-shadow: var(--shadow);
                        border-color: var(--pastel-sky-dark);
                    }

                    .stat-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 3px;
                        transform: scaleX(0);
                        transform-origin: left;
                        transition: transform 0.3s ease;
                    }

                    .stat-card.total::before {
                        background: var(--accent-lavender);
                    }

                    .stat-card.admin::before {
                        background: var(--accent-coral);
                    }

                    .stat-card.buyer::before {
                        background: var(--accent-mint);
                    }

                    .stat-card.user::before {
                        background: var(--accent-sky);
                    }

                    .stat-card:hover::before {
                        transform: scaleX(1);
                    }

                    .stat-icon {
                        width: 32px;
                        height: 32px;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: all 0.3s ease;
                        flex-shrink: 0;
                        font-size: 16px;
                    }

                    .stat-card:hover .stat-icon {
                        transform: scale(1.1);
                    }

                    .stat-icon.total {
                        background: var(--pastel-lavender);
                        color: var(--accent-lavender);
                    }

                    .stat-icon.admin {
                        background: var(--pastel-coral);
                        color: var(--accent-coral);
                    }

                    .stat-icon.buyer {
                        background: var(--pastel-mint);
                        color: var(--accent-mint);
                    }

                    .stat-icon.user {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                    }

                    .stat-info h4 {
                        font-family: 'DM Sans', sans-serif;
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin: 0;
                        line-height: 1;
                        letter-spacing: -0.5px;
                    }

                    .stat-info p {
                        font-size: 10px;
                        font-weight: 700;
                        color: var(--text-secondary);
                        text-transform: uppercase;
                        letter-spacing: 0.06em;
                        margin: 4px 0 0;
                    }

                    /* Filter bar */
                    .filter-bar {
                        background: var(--surface);
                        border-radius: var(--radius-md);
                        padding: 12px 16px;
                        margin-bottom: 14px;
                        display: flex;
                        gap: 12px;
                        align-items: center;
                        flex-wrap: wrap;
                        box-shadow: var(--shadow-sm);
                        border: 1px solid var(--border-light);
                    }

                    .filter-label-group {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        padding-right: 12px;
                        border-right: 1px solid var(--border-light);
                    }

                    .filter-icon-wrap {
                        width: 28px;
                        height: 28px;
                        border-radius: 8px;
                        background: var(--pastel-lavender);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--accent-lavender);
                        font-size: 14px;
                    }

                    .filter-label {
                        font-weight: 700;
                        font-size: 12px;
                        color: var(--text-primary);
                    }

                    .filter-bar form {
                        display: flex;
                        gap: 8px;
                        align-items: center;
                        flex-wrap: wrap;
                        flex: 1;
                    }

                    .filter-bar .form-select,
                    .filter-bar .form-control {
                        background: var(--bg-soft);
                        border: 1px solid var(--border-light);
                        border-radius: var(--radius-sm);
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        font-size: 12px;
                        font-weight: 500;
                        padding: 6px 10px;
                        color: var(--text-primary);
                    }

                    .filter-bar .form-select:focus,
                    .filter-bar .form-control:focus {
                        border-color: var(--accent-lavender);
                        box-shadow: 0 0 0 3px rgba(123, 31, 162, 0.1);
                        outline: none;
                    }

                    .filter-btn,
                    .clear-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 6px 14px;
                        border-radius: var(--radius-sm);
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        font-size: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        border: none;
                    }

                    .filter-btn {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                        border: 1px solid var(--pastel-sky-dark);
                    }

                    .filter-btn:hover {
                        background: var(--pastel-sky-dark);
                        transform: translateY(-1px);
                    }

                    .clear-btn {
                        background: transparent;
                        color: var(--text-secondary);
                        border: 1px solid var(--border-light);
                        text-decoration: none;
                    }

                    .clear-btn:hover {
                        border-color: var(--accent-coral);
                        color: var(--accent-coral);
                        background: var(--pastel-coral);
                        transform: translateY(-1px);
                    }

                    /* View toggle dentro de filter-bar */
                    .view-controls {
                        display: flex;
                        align-items: center;
                        margin-left: auto;
                    }

                    .view-toggle {
                        display: flex;
                        gap: 4px;
                        background: var(--bg-soft);
                        border: 1px solid var(--border-light);
                        padding: 3px;
                        border-radius: var(--radius-sm);
                    }

                    .view-btn {
                        width: 28px;
                        height: 28px;
                        border-radius: 8px;
                        border: none;
                        background: transparent;
                        color: var(--text-tertiary);
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: all 0.2s;
                        font-size: 14px;
                    }

                    .view-btn.active {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                    }

                    .view-btn:hover:not(.active) {
                        background: var(--border-light);
                        color: var(--text-primary);
                    }

                    /* Users Grid (cards) */
                    .users-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                        gap: 12px;
                    }

                    .users-grid.active {
                        display: grid;
                    }

                    .users-grid:not(.active) {
                        display: none;
                    }

                    .user-card {
                        background: var(--surface);
                        border-radius: var(--radius-md);
                        padding: 12px;
                        border: 1px solid var(--border-light);
                        box-shadow: var(--shadow-sm);
                        transition: all 0.3s ease;
                        position: relative;
                        overflow: hidden;
                        cursor: pointer;
                    }

                    .user-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 3px;
                        background: linear-gradient(90deg, var(--pastel-lavender), var(--pastel-sky));
                        transform: scaleX(0);
                        transform-origin: left;
                        transition: transform 0.3s ease;
                    }

                    .user-card.role-admin::before {
                        background: linear-gradient(90deg, var(--pastel-coral), var(--pastel-cream));
                    }

                    .user-card.role-buyer::before {
                        background: linear-gradient(90deg, var(--pastel-mint), var(--pastel-sage));
                    }

                    .user-card.role-user::before {
                        background: linear-gradient(90deg, var(--pastel-sky), var(--pastel-lavender));
                    }

                    .user-card:hover {
                        transform: translateY(-3px);
                        box-shadow: var(--shadow);
                        border-color: var(--border);
                    }

                    .user-card:hover::before {
                        transform: scaleX(1);
                    }

                    .user-card-header {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        margin-bottom: 10px;
                    }

                    .user-card-avatar,
                    .user-card-avatar-default {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid white;
                        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                        flex-shrink: 0;
                    }

                    .user-card-avatar-default {
                        background: linear-gradient(135deg, var(--accent-lavender), var(--accent-sky));
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-weight: 700;
                        font-size: 14px;
                    }

                    .user-card-info {
                        flex: 1;
                        min-width: 0;
                    }

                    .user-card-name {
                        font-family: 'DM Sans', sans-serif;
                        font-weight: 700;
                        font-size: 13px;
                        color: var(--text-primary);
                        margin-bottom: 2px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .user-card-username {
                        font-size: 10px;
                        color: var(--text-tertiary);
                        font-weight: 600;
                    }

                    .user-card-role-badge {
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 3px 8px;
                        border-radius: 20px;
                        font-size: 9px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.03em;
                    }

                    .role-badge-admin {
                        background: var(--pastel-coral);
                        color: var(--accent-coral);
                    }

                    .role-badge-user {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                    }

                    .role-badge-buyer {
                        background: var(--pastel-mint);
                        color: var(--accent-mint);
                    }

                    .user-card-details {
                        display: flex;
                        flex-direction: column;
                        gap: 6px;
                        padding: 8px 10px;
                        background: var(--bg-soft);
                        border-radius: var(--radius-sm);
                        margin-bottom: 10px;
                    }

                    .user-card-detail {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 11px;
                        color: var(--text-secondary);
                    }

                    .user-card-detail i {
                        width: 14px;
                        color: var(--accent-lavender);
                        font-size: 11px;
                    }

                    .user-card-detail span {
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        font-weight: 500;
                    }

                    /* ========== NUEVOS ESTILOS PARA BOTONES DE ACCIÓN (glassmorphism) ========== */
                    .user-card-actions {
                        display: flex;
                        gap: 8px;
                        justify-content: center;
                        align-items: center;
                    }

                    .user-card-actions form {
                        margin: 0;
                        display: inline-flex;
                    }

                    .user-card-actions a,
                    .user-card-actions button {
                        width: 32px;
                        height: 32px;
                        border-radius: 10px;
                        border: none;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                        font-size: 14px;
                        text-decoration: none;
                        font-weight: 600;
                        padding: 0;
                        margin: 0;
                    }

                    .user-card-actions a i,
                    .user-card-actions button i {
                        font-size: 14px;
                        margin: 0;
                        padding: 0;
                    }

                    .user-card-actions a:hover,
                    .user-card-actions button:hover {
                        transform: translateY(-2px) scale(1.05);
                        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
                    }

                    .action-view {
                        background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-lavender));
                        color: var(--accent-sky);
                    }

                    .action-edit {
                        background: linear-gradient(135deg, var(--pastel-cream), var(--pastel-coral));
                        color: var(--accent-cream);
                    }

                    .action-delete {
                        background: linear-gradient(135deg, var(--pastel-coral), #FECDD3);
                        color: var(--accent-coral);
                    }

                    .action-role {
                        background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
                        color: var(--accent-lavender);
                    }

                    /* Estilos para vista de tabla */
                    .table-card .user-card-actions a,
                    .table-card .user-card-actions button {
                        width: 32px;
                        height: 32px;
                        font-size: 12px;
                    }

                    .table-card .user-card-actions a i,
                    .table-card .user-card-actions button i {
                        font-size: 12px;
                    }

                    /* ================================================================ */

                    /* Table view */
                    .table-card {
                        background: var(--surface);
                        border-radius: var(--radius-md);
                        border: 1px solid var(--border-light);
                        overflow: hidden;
                        box-shadow: var(--shadow-sm);
                        display: none;
                    }

                    .table-card.active {
                        display: block;
                    }

                    .table-card table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    .table-card th {
                        text-align: left;
                        padding: 10px 16px;
                        font-size: 10px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.06em;
                        color: var(--text-tertiary);
                        border-bottom: 1.5px solid var(--border-light);
                        background: var(--bg-soft);
                    }

                    .table-card td {
                        padding: 12px 16px;
                        font-size: 12px;
                        color: var(--text-primary);
                        border-bottom: 1px solid var(--border-light);
                        vertical-align: middle;
                    }

                    .table-card tr:last-child td {
                        border-bottom: none;
                    }

                    .table-card tbody tr:hover {
                        background: var(--bg-soft);
                    }

                    /* Empty state */
                    .empty-state {
                        text-align: center;
                        padding: 40px 20px;
                        color: var(--text-secondary);
                    }

                    .empty-state-icon {
                        width: 60px;
                        height: 60px;
                        margin: 0 auto 16px;
                        border-radius: 50%;
                        background: var(--pastel-lavender);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--accent-lavender);
                        font-size: 24px;
                    }

                    /* Modal mejorado */
                    .modal-overlay {
                        position: fixed;
                        inset: 0;
                        background: rgba(0, 0, 0, 0.4);
                        backdrop-filter: blur(4px);
                        z-index: 9998;
                        display: none;
                        align-items: center;
                        justify-content: center;
                    }

                    .modal-overlay.active {
                        display: flex;
                    }

                    .modal-content {
                        background: var(--surface);
                        border-radius: var(--radius-lg);
                        max-width: 480px;
                        width: 90%;
                        max-height: 85vh;
                        overflow-y: auto;
                        box-shadow: var(--shadow-md);
                        border: 1px solid var(--border);
                    }

                    .modal-body {
                        padding: 48px 24px 24px;
                        text-align: center;
                    }


                    /* Animaciones */
                    @keyframes fadeUp {
                        from {
                            opacity: 0;
                            transform: translateY(12px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .anim-fade-up {
                        animation: fadeUp 0.5s ease forwards;
                        opacity: 0;
                    }

                    .delay-1 {
                        animation-delay: 0.04s;
                    }

                    .delay-2 {
                        animation-delay: 0.08s;
                    }

                    .delay-3 {
                        animation-delay: 0.12s;
                    }

                    .delay-4 {
                        animation-delay: 0.16s;
                    }


                    /* ═══════════════════════════════════════════════════════════════════
   MODALES — basados en Pedidos (ver/cambiar rol) y Catalogo (eliminar)
   ═══════════════════════════════════════════════════════════════════ */

                    /* ── Overlay base (de Pedidos, limpio) ── */
                    .modal-overlay {
                        display: none;
                        position: fixed;
                        inset: 0;
                        z-index: 10000;
                        background: rgba(26, 26, 46, 0.25);
                        backdrop-filter: blur(8px);
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }

                    .modal-overlay.show {
                        display: flex;
                        animation: modalFadeIn 0.3s ease;
                    }

                    @keyframes modalFadeIn {
                        from {
                            opacity: 0;
                        }

                        to {
                            opacity: 1;
                        }
                    }

                    /* ── Card contenedor (de Pedidos, sin tanto glass) ── */
                    .modal-card {
                        background: var(--surface);
                        border-radius: var(--radius-lg);
                        box-shadow: var(--shadow-lg);
                        border: 1px solid var(--border-light);
                        width: 100%;
                        max-width: 520px;
                        max-height: 90vh;
                        overflow: hidden;
                        display: flex;
                        flex-direction: column;
                        animation: modalSlideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                    }

                    @keyframes modalSlideUp {
                        from {
                            opacity: 0;
                            transform: translateY(40px) scale(0.96);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0) scale(1);
                        }
                    }

                    /* ── Header (de Pedidos) ── */
                    .modal-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 20px 24px 16px;
                        border-bottom: 1px solid var(--border-light);
                    }

                    .modal-header-left {
                        display: flex;
                        align-items: center;
                        gap: 14px;
                    }

                    .modal-user-icon {
                        width: 48px;
                        height: 48px;
                        border-radius: 14px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 20px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                    }

                    .modal-user-icon.lavender {
                        background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
                        color: var(--accent-lavender);
                    }

                    .modal-user-icon.mint {
                        background: linear-gradient(135deg, var(--pastel-mint), var(--pastel-sage));
                        color: var(--accent-mint);
                    }

                    .modal-user-icon.coral {
                        background: linear-gradient(135deg, var(--pastel-coral), #FECDD3);
                        color: var(--accent-coral);
                    }

                    .modal-header-info h3 {
                        font-family: 'DM Sans', sans-serif;
                        font-size: 18px;
                        font-weight: 700;
                        margin: 0 0 2px;
                        letter-spacing: -0.3px;
                    }

                    .modal-header-info p {
                        font-size: 11px;
                        color: var(--text-secondary);
                        font-weight: 600;
                        margin: 0;
                    }

                    .modal-close {
                        width: 32px;
                        height: 32px;
                        border-radius: 10px;
                        border: none;
                        background: var(--bg-soft);
                        color: var(--text-secondary);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: all 0.2s;
                        font-size: 14px;
                        border: 1px solid var(--border-light);
                    }

                    .modal-close:hover {
                        background: var(--pastel-coral);
                        color: var(--accent-coral);
                        transform: rotate(90deg);
                    }

                    /* ── Body (de Pedidos) ── */
                    .modal-body {
                        padding: 20px 24px;
                        overflow-y: auto;
                        flex: 1;
                    }

                    .modal-section {
                        margin-bottom: 20px;
                    }

                    .modal-section:last-child {
                        margin-bottom: 0;
                    }

                    .modal-section-title {
                        font-size: 10px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.08em;
                        color: var(--text-tertiary);
                        margin-bottom: 10px;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    /* ── Info grid (de Pedidos) ── */
                    .info-grid {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 10px;
                    }

                    .info-item {
                        background: var(--bg-soft);
                        border: 1px solid var(--border-light);
                        border-radius: var(--radius-sm);
                        padding: 12px 14px;
                    }

                    .info-item.full {
                        grid-column: 1 / -1;
                    }

                    .info-item label {
                        font-size: 9px;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.06em;
                        color: var(--text-tertiary);
                        display: block;
                        margin-bottom: 4px;
                    }

                    .info-item value {
                        font-size: 13px;
                        font-weight: 600;
                        color: var(--text-primary);
                        display: block;
                    }

                    /* ── Footer (de Pedidos) ── */
                    .modal-footer {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 16px 24px 20px;
                        border-top: 1px solid var(--border-light);
                        background: var(--bg-soft);
                        gap: 12px;
                        flex-wrap: wrap;
                    }

                    .modal-actions {
                        display: flex;
                        gap: 8px;
                        flex-wrap: wrap;
                        margin-left: auto;
                    }

                    .modal-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 10px 18px;
                        border-radius: var(--radius-sm);
                        font-size: 11px;
                        font-weight: 700;
                        text-decoration: none;
                        transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                        border: none;
                        cursor: pointer;
                        font-family: 'Plus Jakarta Sans', sans-serif;
                    }

                    .modal-btn:hover {
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-md);
                    }

                    .modal-btn.edit {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                    }

                    .modal-btn.role {
                        background: var(--pastel-mint);
                        color: var(--accent-mint);
                    }

                    .modal-btn.delete {
                        background: var(--pastel-coral);
                        color: var(--accent-coral);
                    }

                    .modal-btn.back {
                        background: var(--bg-soft);
                        color: var(--text-secondary);
                        border: 1px solid var(--border-light);
                    }

                    /* ── Delete confirm (de Catalogo) ── */
                    .delete-confirm-body {
                        text-align: center;
                        padding: 32px 28px 24px;
                    }

                    .delete-confirm-icon {
                        width: 64px;
                        height: 64px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, var(--pastel-coral), #FECDD3);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 14px;
                        font-size: 24px;
                        color: var(--accent-coral);
                    }

                    .delete-confirm-title {
                        font-family: 'DM Sans', sans-serif;
                        font-size: 18px;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 6px;
                    }

                    .delete-confirm-text {
                        font-size: 12px;
                        color: var(--text-secondary);
                        margin-bottom: 12px;
                    }

                    .delete-confirm-user {
                        font-family: 'DM Sans', sans-serif;
                        font-size: 16px;
                        font-weight: 700;
                        color: var(--accent-coral);
                        margin-bottom: 16px;
                        padding: 10px 16px;
                        background: var(--pastel-coral);
                        border-radius: var(--radius-sm);
                        display: inline-block;
                    }

                    /* ── Role options (de Pedidos/status-option adaptado) ── */
                    .role-change-current {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 11px;
                        font-weight: 700;
                        margin-bottom: 16px;
                    }

                    .role-options-modal {
                        display: flex;
                        gap: 10px;
                        justify-content: center;
                        flex-wrap: wrap;
                    }

                    .role-option-modal {
                        flex: 1;
                        min-width: 100px;
                        max-width: 140px;
                    }

                    .role-option-modal input {
                        display: none;
                    }

                    .role-option-modal label {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 8px;
                        padding: 16px 10px;
                        background: var(--bg-soft);
                        border: 2px solid var(--border);
                        border-radius: var(--radius-sm);
                        cursor: pointer;
                        transition: all 0.25s ease;
                        text-align: center;
                    }

                    .role-modal-icon {
                        width: 36px;
                        height: 36px;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 16px;
                    }

                    .role-option-modal .admin .role-modal-icon {
                        background: var(--pastel-coral);
                        color: var(--accent-coral);
                    }

                    .role-option-modal .buyer .role-modal-icon {
                        background: var(--pastel-mint);
                        color: var(--accent-mint);
                    }

                    .role-option-modal .user .role-modal-icon {
                        background: var(--pastel-sky);
                        color: var(--accent-sky);
                    }

                    .role-modal-title {
                        font-size: 12px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .role-modal-desc {
                        font-size: 10px;
                        color: var(--text-tertiary);
                        font-weight: 500;
                    }

                    .role-option-modal input:checked+label {
                        border-color: var(--accent-mint);
                        background: linear-gradient(135deg, var(--pastel-mint), rgba(56, 142, 60, 0.05));
                        box-shadow: 0 4px 16px rgba(56, 142, 60, 0.12);
                        transform: translateY(-2px);
                    }

                    .role-option-modal input:checked+label .role-modal-icon {
                        transform: scale(1.1);
                    }


                    /* Responsive */
                    @media (max-width: 1024px) {
                        .stats-row {
                            grid-template-columns: repeat(2, 1fr);
                        }
                    }

                    @media (max-width: 768px) {
                        .stats-row {
                            grid-template-columns: 1fr;
                        }

                        .welcome-section {
                            flex-direction: column;
                            align-items: flex-start;
                            gap: 12px;
                        }

                        .filter-bar {
                            flex-direction: column;
                            align-items: stretch;
                        }

                        .view-controls {
                            margin-left: 0;
                            justify-content: flex-end;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="layout-wrapper">
                    <%@ include file="/includes/sidebar.jsp" %>

                        <main class="main-content">
                            <!-- Welcome Section -->
                            <div class="welcome-section anim-fade-up">
                                <div class="welcome-content">
                                    <h1 class="welcome-title">Gestión de Usuarios</h1>
                                    <p class="welcome-subtitle">Administra todos los usuarios del sistema Quiddity</p>
                                </div>
                                <div class="welcome-actions">
                                    <a href="${pageContext.request.contextPath}/admin/usuarios?action=nuevo"
                                        class="btn-new-user">
                                        <i class="fas fa-plus"></i> Nuevo Usuario
                                    </a>
                                </div>
                            </div>

                            <!-- Stats KPIs -->
                            <c:set var="countAdmin" value="0" />
                            <c:set var="countComprador" value="0" />
                            <c:set var="countUsuario" value="0" />
                            <c:forEach var="u" items="${usuarios}">
                                <c:if test="${u.idRol == 1}">
                                    <c:set var="countAdmin" value="${countAdmin + 1}" />
                                </c:if>
                                <c:if test="${u.idRol == 2}">
                                    <c:set var="countComprador" value="${countComprador + 1}" />
                                </c:if>
                                <c:if test="${u.idRol == 3}">
                                    <c:set var="countUsuario" value="${countUsuario + 1}" />
                                </c:if>
                            </c:forEach>

                            <div class="stats-row">
                                <div class="stat-card total anim-fade-up delay-1">
                                    <div class="stat-icon total"><i class="fas fa-users"></i></div>
                                    <div class="stat-info">
                                        <h4>${usuarios.size()}</h4>
                                        <p>Total Usuarios</p>
                                    </div>
                                </div>
                                <div class="stat-card admin anim-fade-up delay-2">
                                    <div class="stat-icon admin"><i class="fas fa-shield-alt"></i></div>
                                    <div class="stat-info">
                                        <h4>${countAdmin}</h4>
                                        <p>Administradores</p>
                                    </div>
                                </div>
                                <div class="stat-card buyer anim-fade-up delay-3">
                                    <div class="stat-icon buyer"><i class="fas fa-shopping-bag"></i></div>
                                    <div class="stat-info">
                                        <h4>${countComprador}</h4>
                                        <p>Compradores</p>
                                    </div>
                                </div>
                                <div class="stat-card user anim-fade-up delay-4">
                                    <div class="stat-icon user"><i class="fas fa-user"></i></div>
                                    <div class="stat-info">
                                        <h4>${countUsuario}</h4>
                                        <p>Usuarios</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Filter bar + View toggle -->
                            <div class="filter-bar anim-fade-up delay-2">
                                <div class="filter-label-group">
                                    <div class="filter-icon-wrap"><i class="fas fa-filter"></i></div>
                                    <span class="filter-label">Filtrar</span>
                                </div>
                                <form method="get" action="${pageContext.request.contextPath}/admin/usuarios"
                                    id="filterForm">
                                    <select name="rol" class="form-select" style="min-width:140px;">
                                        <option value="">Todos los roles</option>
                                        <option value="1" ${param.rol=='1' ? 'selected' : '' }>Administrador</option>
                                        <option value="2" ${param.rol=='2' ? 'selected' : '' }>Comprador</option>
                                        <option value="3" ${param.rol=='3' ? 'selected' : '' }>Usuario</option>
                                    </select>
                                    <input type="text" name="buscar" class="form-control"
                                        placeholder="Buscar por nombre, email o documento..." value="${param.buscar}"
                                        style="min-width:200px;">
                                    <button type="submit" class="filter-btn"><i class="fas fa-search"></i>
                                        Buscar</button>
                                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="clear-btn"><i
                                            class="fas fa-undo"></i> Limpiar</a>
                                </form>
                                <div class="view-controls">
                                    <div class="view-toggle">
                                        <button class="view-btn active" data-view="grid" title="Cuadrícula"><i
                                                class="fas fa-th-large"></i></button>
                                        <button class="view-btn" data-view="table" title="Tabla"><i
                                                class="fas fa-list"></i></button>
                                    </div>
                                </div>
                            </div>

                            <!-- Users Grid View -->
                            <div class="users-grid active" id="usersGrid">
                                <c:choose>
                                    <c:when test="${empty usuarios}">
                                        <div class="empty-state" style="grid-column:1/-1;">
                                            <div class="empty-state-icon"><i class="fas fa-user-slash"></i></div>
                                            <h4>No hay usuarios registrados</h4>
                                            <p>Comienza agregando un nuevo usuario al sistema.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="u" items="${usuarios}">
                                            <c:set var="nombreCompleto" value="${u.nombre} ${u.apellido}" />
                                            <c:set var="matchRol" value="${empty param.rol || u.idRol == param.rol}" />
                                            <c:set var="matchBuscar" value="${empty param.buscar ||
                            fn:toLowerCase(nombreCompleto).contains(fn:toLowerCase(param.buscar)) ||
                            fn:toLowerCase(u.email).contains(fn:toLowerCase(param.buscar)) ||
                            u.documento.contains(param.buscar)}" />
                                            <c:if test="${matchRol && matchBuscar}">
                                                <c:set var="roleClass" value="role-user" />
                                                <c:set var="roleBadgeClass" value="role-badge-user" />
                                                <c:set var="roleLabel" value="Usuario" />
                                                <c:set var="roleIcon" value="fa-user" />
                                                <c:if test="${u.idRol == 1}">
                                                    <c:set var="roleClass" value="role-admin" />
                                                    <c:set var="roleBadgeClass" value="role-badge-admin" />
                                                    <c:set var="roleLabel" value="Admin" />
                                                    <c:set var="roleIcon" value="fa-shield-alt" />
                                                </c:if>
                                                <c:if test="${u.idRol == 2}">
                                                    <c:set var="roleClass" value="role-buyer" />
                                                    <c:set var="roleBadgeClass" value="role-badge-buyer" />
                                                    <c:set var="roleLabel" value="Comprador" />
                                                    <c:set var="roleIcon" value="fa-shopping-bag" />
                                                </c:if>
                                                <div class="user-card ${roleClass}"
    data-name="${u.nombre} ${u.apellido}"
    data-nombre="${u.nombre}"
    data-apellido="${u.apellido}"
    data-email="${u.email}"
    data-doc="${u.documento}"
    data-username="${u.userName}"
    data-role="${roleLabel}"
    data-role-id="${u.idRol}"
    data-foto="${not empty u.fotoPerfil ? pageContext.request.contextPath.concat('/uploads/perfiles/').concat(u.fotoPerfil) : ''}"
    data-id="${u.id}">
                                                    <span class="user-card-role-badge ${roleBadgeClass}"><i
                                                            class="fas ${roleIcon}"></i> ${roleLabel}</span>
                                                    <div class="user-card-header">
                                                        <c:choose>
                                                            <%-- URL externa (Supabase, CDN, etc.) --%>
                                                                <c:when test="${fn:startsWith(u.fotoPerfil, 'http')}">
                                                                    <img src="${u.fotoPerfil}" class="user-card-avatar"
                                                                        alt="${fn:escapeXml(u.nombre)}"
                                                                        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                    <div class="user-card-avatar-default"
                                                                        style="display:none;">
                                                                        ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                    </div>
                                                                </c:when>
                                                                <%-- Ruta completa tipo
                                                                    uploads/perfiles/maria_gonzalez.jpg (nuevo formato)
                                                                    --%>
                                                                    <c:when
                                                                        test="${fn:startsWith(u.fotoPerfil, 'uploads/')}">
                                                                        <img src="${pageContext.request.contextPath}/${u.fotoPerfil}"
                                                                            class="user-card-avatar"
                                                                            alt="${fn:escapeXml(u.nombre)}"
                                                                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                        <div class="user-card-avatar-default"
                                                                            style="display:none;">
                                                                            ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                        </div>
                                                                    </c:when>
                                                                    <%-- Ruta antigua tipo perfil2.png (fallback) --%>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/uploads/perfiles/${u.fotoPerfil}"
                                                                                class="user-card-avatar"
                                                                                alt="${fn:escapeXml(u.nombre)}"
                                                                                onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                            <div class="user-card-avatar-default"
                                                                                style="display:none;">
                                                                                ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                            </div>
                                                                        </c:otherwise>
                                                        </c:choose>
                                                        <div class="user-card-info">
                                                            <div class="user-card-name">${u.nombre} ${u.apellido}</div>
                                                            <div class="user-card-username">@${u.userName}</div>
                                                        </div>
                                                    </div>
                                                    <div class="user-card-details">
                                                        <div class="user-card-detail"><i
                                                                class="fas fa-id-card"></i><span>${u.documento}</span>
                                                        </div>
                                                        <div class="user-card-detail"><i
                                                                class="fas fa-envelope"></i><span>${u.email}</span>
                                                        </div>
                                                    </div>
                                                    <div class="user-card-actions" onclick="event.stopPropagation()">
                                                        <button type="button" class="action-view" title="Ver"
                                                            onclick="event.stopPropagation(); openUserModal(this.closest('.user-card'));">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <a href="${ctx}/admin/usuarios?accion=editar&id=${u.id}"
                                                            class="action-edit" title="Editar"
                                                            onclick="event.stopPropagation()">
                                                            <i class="fas fa-pen"></i>
                                                        </a>
                                                        <c:if
                                                            test="${sessionScope.usuario.idRol == 1 && u.id != sessionScope.usuario.id}">
                                                            <button type="button" class="action-role"
                                                                title="Cambiar rol"
                                                                onclick="event.stopPropagation(); openRoleModalDirect(${u.id}, ${u.idRol}, '${fn:escapeXml(u.nombre)} ${fn:escapeXml(u.apellido)}')">
                                                                <i class="fas fa-exchange-alt"></i>
                                                            </button>
                                                        </c:if>
                                                        <button type="button" class="action-delete" title="Eliminar"
                                                            onclick="event.stopPropagation(); openDeleteModalDirect(${u.id}, '${fn:escapeXml(u.nombre)} ${fn:escapeXml(u.apellido)}')">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Users Table View -->
                            <div class="table-card" id="usersTable">
                                <c:choose>
                                    <c:when test="${empty usuarios}">
                                        <div class="empty-state">
                                            <div class="empty-state-icon"><i class="fas fa-user-slash"></i></div>
                                            <h4>No hay usuarios registrados</h4>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Usuario</th>
                                                    <th>Documento</th>
                                                    <th>Email</th>
                                                    <th>Rol</th>
                                                    <th style="text-align:center">Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="u" items="${usuarios}">
                                                    <c:set var="nombreCompleto" value="${u.nombre} ${u.apellido}" />
                                                    <c:set var="matchRol"
                                                        value="${empty param.rol || u.idRol == param.rol}" />
                                                    <c:set var="matchBuscar" value="${empty param.buscar ||
                                    fn:toLowerCase(nombreCompleto).contains(fn:toLowerCase(param.buscar)) ||
                                    fn:toLowerCase(u.email).contains(fn:toLowerCase(param.buscar)) ||
                                    u.documento.contains(param.buscar)}" />
                                                    <c:if test="${matchRol && matchBuscar}">
                                                        <c:set var="roleBadgeClass" value="role-badge-user" />
                                                        <c:set var="roleIcon" value="fa-user" />
                                                        <c:set var="roleLabel" value="Usuario" />
                                                        <c:if test="${u.idRol == 1}">
                                                            <c:set var="roleBadgeClass" value="role-badge-admin" />
                                                            <c:set var="roleIcon" value="fa-shield-alt" />
                                                            <c:set var="roleLabel" value="Admin" />
                                                        </c:if>
                                                        <c:if test="${u.idRol == 2}">
                                                            <c:set var="roleBadgeClass" value="role-badge-buyer" />
                                                            <c:set var="roleIcon" value="fa-shopping-bag" />
                                                            <c:set var="roleLabel" value="Comprador" />
                                                        </c:if>
                                                        <tr>
                                                            <td>
                                                                <div style="display:flex;align-items:center;gap:10px;">
                                                                    <c:choose>
                                                                        <%-- URL externa --%>
                                                                            <c:when
                                                                                test="${fn:startsWith(u.fotoPerfil, 'http')}">
                                                                                <img src="${u.fotoPerfil}"
                                                                                    style="width:32px;height:32px;border-radius:50%;object-fit:cover;"
                                                                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                                <div
                                                                                    style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--accent-lavender),var(--accent-sky));display:none;align-items:center;justify-content:center;color:white;font-weight:700;">
                                                                                    ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                                </div>
                                                                            </c:when>
                                                                            <%-- Ruta completa uploads/perfiles/... --%>
                                                                                <c:when
                                                                                    test="${fn:startsWith(u.fotoPerfil, 'uploads/')}">
                                                                                    <img src="${pageContext.request.contextPath}/${u.fotoPerfil}"
                                                                                        style="width:32px;height:32px;border-radius:50%;object-fit:cover;"
                                                                                        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                                    <div
                                                                                        style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--accent-lavender),var(--accent-sky));display:none;align-items:center;justify-content:center;color:white;font-weight:700;">
                                                                                        ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                                    </div>
                                                                                </c:when>
                                                                                <%-- Ruta antigua fallback --%>
                                                                                    <c:otherwise>
                                                                                        <img src="${pageContext.request.contextPath}/uploads/perfiles/${u.fotoPerfil}"
                                                                                            style="width:32px;height:32px;border-radius:50%;object-fit:cover;"
                                                                                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                                                        <div
                                                                                            style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--accent-lavender),var(--accent-sky));display:none;align-items:center;justify-content:center;color:white;font-weight:700;">
                                                                                            ${fn:substring(u.nombre,0,1)}${fn:substring(u.apellido,0,1)}
                                                                                        </div>
                                                                                    </c:otherwise>
                                                                    </c:choose>
                                                                    <div>
                                                                        <div style="font-weight:700;">${u.nombre}
                                                                            ${u.apellido}</div>
                                                                        <div
                                                                            style="font-size:10px;color:var(--text-tertiary);">
                                                                            @${u.userName}</div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>${u.documento}</td>
                                                            <td>${u.email}</td>
                                                            <td><span class="user-card-role-badge ${roleBadgeClass}"
                                                                    style="position:static;"><i
                                                                        class="fas ${roleIcon}"></i> ${roleLabel}</span>
                                                            </td>
                                                            <td style="text-align:center">
                                                                <div class="user-card-actions"
                                                                    style="justify-content:center;">
                                                                    <button type="button" class="action-view"
                                                                        onclick="event.stopPropagation(); openUserModalFromTable(${u.id})">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <a href="${pageContext.request.contextPath}/admin/usuarios?accion=editar&id=${u.id}"
                                                                        class="action-edit"
                                                                        onclick="event.stopPropagation()">
                                                                        <i class="fas fa-pen"></i>
                                                                    </a>
                                                                    <c:if
                                                                        test="${sessionScope.usuario.idRol == 1 && u.id != sessionScope.usuario.id}">
                                                                        <button type="button" class="action-role"
                                                                            onclick="event.stopPropagation(); openRoleModalDirect(${u.id}, ${u.idRol}, '${fn:escapeXml(u.nombre)} ${fn:escapeXml(u.apellido)}')">
                                                                            <i class="fas fa-exchange-alt"></i>
                                                                        </button>
                                                                    </c:if>
                                                                    <button type="button" class="action-delete"
                                                                        onclick="event.stopPropagation(); openDeleteModalDirect(${u.id}, '${fn:escapeXml(u.nombre)} ${fn:escapeXml(u.apellido)}')">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
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

                <!-- ═══════════════════════════════════════════════════════════════════
     MODAL VER USUARIO — estilo Pedidos (header + body + footer)
     ═══════════════════════════════════════════════════════════════════ -->
                <div class="modal-overlay" id="userModal">
                    <div class="modal-card">
                        <div class="modal-header">
                            <div class="modal-header-left">
                                <div class="modal-user-icon lavender"><i class="fas fa-user"></i></div>
                                <div class="modal-header-info">
                                    <h3 id="modalName">—</h3>
                                    <p id="modalUsername">—</p>
                                </div>
                            </div>
                            <button class="modal-close" onclick="closeUserModal()" title="Cerrar"><i
                                    class="fas fa-times"></i></button>
                        </div>
                        <div class="modal-body">
                            <div class="modal-section">
                                <div class="modal-section-title"><i class="fas fa-id-card"></i> Información del usuario
                                </div>
                                <div class="info-grid">
    <div class="info-item">
        <label>Nombre</label>
        <value id="modalNombre">—</value>
    </div>
    <div class="info-item">
        <label>Apellido</label>
        <value id="modalApellido">—</value>
    </div>
    <div class="info-item full">
        <label>Email</label>
        <value id="modalEmail">—</value>
    </div>
    <div class="info-item">
        <label>Documento</label>
        <value id="modalDoc">—</value>
    </div>
    <div class="info-item">
    <label>Username</label>
    <value id="modalUsernameDetail">—</value>
    </div>
    <div class="info-item">
        <label>Rol</label>
        <value id="modalRole">—</value>
    </div>
    <div class="info-item">
        <label>ID de Usuario</label>
        <value id="modalId">—</value>
    </div>
</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div id="modalRoleBadge"></div>
                            <div class="modal-actions">
                                <a id="modalEditBtn" href="#" class="modal-btn edit"><i class="fas fa-pen"></i>
                                    Editar</a>
                                <button type="button" class="modal-btn role" onclick="openRoleModalFromList()"><i
                                        class="fas fa-exchange-alt"></i> Cambiar Rol</button>
                                <button type="button" class="modal-btn delete" onclick="openDeleteModalFromList()"><i
                                        class="fas fa-trash"></i> Eliminar</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ═══════════════════════════════════════════════════════════════════
     MODAL ELIMINAR USUARIO — estilo Catalogo (icono + confirm + footer)
     ═══════════════════════════════════════════════════════════════════ -->
                <div class="modal-overlay" id="deleteUserModal">
                    <div class="modal-card" style="max-width:420px;">
                        <div class="modal-header" style="border-bottom:none; padding-bottom:8px;">
                            <div class="modal-header-left">
                                <div class="modal-user-icon coral"><i class="fas fa-trash"></i></div>
                                <div class="modal-header-info">
                                    <h3>Eliminar Usuario</h3>
                                    <p>Esta acción no se puede deshacer</p>
                                </div>
                            </div>
                            <button class="modal-close" onclick="closeDeleteUserModal()"><i
                                    class="fas fa-times"></i></button>
                        </div>
                        <div class="modal-body" style="padding-top:0;">
                            <div class="delete-confirm-body" style="padding:0 28px 24px;">
                                <div class="delete-confirm-icon"><i class="fas fa-exclamation-triangle"></i></div>
                                <h3 class="delete-confirm-title">¿Eliminar usuario?</h3>
                                <p class="delete-confirm-text">El usuario perderá todo acceso al sistema
                                    permanentemente.</p>
                                <div class="delete-confirm-user" id="deleteUserNameModal">—</div>
                            </div>
                        </div>
                        <div class="modal-footer" style="justify-content:center;">
                            <form method="post" action="${pageContext.request.contextPath}/admin/usuarios"
                                id="deleteUserFormModal" style="display:flex; gap:10px;">
                                <input type="hidden" name="action" value="eliminar">
                                <input type="hidden" name="id" id="deleteUserIdModal">
                                <button type="button" class="modal-btn back"
                                    onclick="closeDeleteUserModal()">Cancelar</button>
                                <button type="submit" class="modal-btn delete"><i class="fas fa-trash"></i> Eliminar
                                    Definitivamente</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ═══════════════════════════════════════════════════════════════════
     MODAL CAMBIAR ROL — estilo Pedidos (header + selector + footer)
     ═══════════════════════════════════════════════════════════════════ -->
                <div class="modal-overlay" id="changeRoleModal">
                    <div class="modal-card" style="max-width:440px;">
                        <div class="modal-header" style="border-bottom:none; padding-bottom:8px;">
                            <div class="modal-header-left">
                                <div class="modal-user-icon mint"><i class="fas fa-exchange-alt"></i></div>
                                <div class="modal-header-info">
                                    <h3>Cambiar Rol</h3>
                                    <p>Selecciona el nuevo rol para este usuario</p>
                                </div>
                            </div>
                            <button class="modal-close" onclick="closeChangeRoleModal()"><i
                                    class="fas fa-times"></i></button>
                        </div>
                        <div class="modal-body" style="padding-top:0;">
                            <div style="text-align:center;">
                                <div class="role-change-current" id="roleCurrentBadgeModal"></div>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/usuarios"
                                id="changeRoleFormModal">
                                <input type="hidden" name="action" value="cambiarRol">
                                <input type="hidden" name="id" id="changeRoleUserIdModal">
                                <div class="role-options-modal">
                                    <div class="role-option-modal admin">
                                        <input type="radio" name="idrol" id="roleModalAdminList" value="1">
                                        <label for="roleModalAdminList">
                                            <div class="role-modal-icon"><i class="fas fa-shield-alt"></i></div>
                                            <span class="role-modal-title">Administrador</span>
                                            <span class="role-modal-desc">Control total</span>
                                        </label>
                                    </div>
                                    <div class="role-option-modal buyer">
                                        <input type="radio" name="idrol" id="roleModalBuyerList" value="2">
                                        <label for="roleModalBuyerList">
                                            <div class="role-modal-icon"><i class="fas fa-shopping-bag"></i></div>
                                            <span class="role-modal-title">Comprador</span>
                                            <span class="role-modal-desc">Puede comprar</span>
                                        </label>
                                    </div>
                                    <div class="role-option-modal user">
                                        <input type="radio" name="idrol" id="roleModalUserList" value="3">
                                        <label for="roleModalUserList">
                                            <div class="role-modal-icon"><i class="fas fa-user"></i></div>
                                            <span class="role-modal-title">Usuario</span>
                                            <span class="role-modal-desc">Acceso básico</span>
                                        </label>
                                    </div>
                                </div>
                                <div style="display:flex; gap:10px; justify-content:center; margin-top:20px;">
                                    <button type="button" class="modal-btn back"
                                        onclick="closeChangeRoleModal()">Cancelar</button>
                                    <button type="submit" class="modal-btn role"><i class="fas fa-check"></i> Confirmar
                                        Cambio</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    // View toggle (grid/table)
                    const viewBtns = document.querySelectorAll('.view-btn');
                    const usersGrid = document.getElementById('usersGrid');
                    const usersTable = document.getElementById('usersTable');
                    viewBtns.forEach(btn => {
                        btn.addEventListener('click', () => {
                            viewBtns.forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            if (btn.dataset.view === 'grid') {
                                usersGrid.classList.add('active');
                                usersTable.classList.remove('active');
                            } else {
                                usersGrid.classList.remove('active');
                                usersTable.classList.add('active');
                            }
                        });
                    });

                    // ═══════════════════════════════════════════════════════════════════
                    // MODAL VER USUARIO — desde card (grid)
                    // ═══════════════════════════════════════════════════════════════════
                    function openUserModal(card) {
    const modal = document.getElementById('userModal');
    
    // Todos los datos del usuario
    document.getElementById('modalName').innerText = card.dataset.name;
    document.getElementById('modalNombre').innerText = card.dataset.nombre || '';
    document.getElementById('modalApellido').innerText = card.dataset.apellido || '';
    document.getElementById('modalUsernameDetail').innerText = '@' + card.dataset.username;
    document.getElementById('modalNombre').innerText = card.dataset.nombre || '';
    document.getElementById('modalApellido').innerText = card.dataset.apellido || '';
    document.getElementById('modalDoc').innerText = card.dataset.doc;
    document.getElementById('modalEmail').innerText = card.dataset.email;
    document.getElementById('modalRole').innerText = card.dataset.role;
    document.getElementById('modalId').innerText = '#' + card.dataset.id;

    // Badge de rol
    const roleId = card.dataset.roleId;
    let badgeClass = 'role-badge-user', icon = 'fa-user';
    if (roleId == 1) { badgeClass = 'role-badge-admin'; icon = 'fa-shield-alt'; }
    if (roleId == 2) { badgeClass = 'role-badge-buyer'; icon = 'fa-shopping-bag'; }
    document.getElementById('modalRoleBadge').innerHTML =
        '<span class="user-card-role-badge ' + badgeClass + '"><i class="fas ' + icon + '"></i> ' + card.dataset.role + '</span>';

    // Guardar datos para otros modales
    modal.dataset.userId = card.dataset.id;
    modal.dataset.userName = card.dataset.name;
    modal.dataset.roleId = roleId;

    document.getElementById('modalEditBtn').href = '${pageContext.request.contextPath}/admin/usuarios?accion=editar&id=' + card.dataset.id;
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
}

                    // MODAL VER USUARIO — desde tabla (busca la card por data-id)
                    function openUserModalFromTable(userId) {
                        const card = document.querySelector('.user-card[data-id="' + userId + '"]');
                        if (card) openUserModal(card);
                    }

                    function closeUserModal() {
                        document.getElementById('userModal').classList.remove('show');
                        document.body.style.overflow = '';
                    }

                    // ═══════════════════════════════════════════════════════════════════
                    // MODAL ELIMINAR — directo (sin pasar por ver)
                    // ═══════════════════════════════════════════════════════════════════
                    function openDeleteModalDirect(userId, userName) {
                        document.getElementById('deleteUserIdModal').value = userId;
                        document.getElementById('deleteUserNameModal').textContent = userName;
                        document.getElementById('deleteUserModal').classList.add('show');
                        document.body.style.overflow = 'hidden';
                    }

                    // MODAL ELIMINAR — desde el modal de ver
                    function openDeleteModalFromList() {
                        const viewModal = document.getElementById('userModal');
                        const userId = viewModal.dataset.userId;
                        const userName = viewModal.dataset.userName;
                        if (!userId) return;

                        document.getElementById('deleteUserIdModal').value = userId;
                        document.getElementById('deleteUserNameModal').textContent = userName;
                        closeUserModal();
                        setTimeout(() => {
                            document.getElementById('deleteUserModal').classList.add('show');
                            document.body.style.overflow = 'hidden';
                        }, 200);
                    }

                    function closeDeleteUserModal() {
                        document.getElementById('deleteUserModal').classList.remove('show');
                        document.body.style.overflow = '';
                    }

                    // ═══════════════════════════════════════════════════════════════════
                    // MODAL CAMBIAR ROL — directo (sin pasar por ver)
                    // ═══════════════════════════════════════════════════════════════════
                    function openRoleModalDirect(userId, roleId, userName) {
                        document.getElementById('changeRoleUserIdModal').value = userId;

                        // Marcar rol actual
                        document.querySelectorAll('#changeRoleModal .role-option-modal input').forEach(r => r.checked = false);
                        const currentRadio = document.querySelector('#changeRoleModal input[value="' + roleId + '"]');
                        if (currentRadio) currentRadio.checked = true;

                        // Badge del rol actual
                        let badgeClass = 'role-badge-user', label = 'Usuario';
                        if (roleId == 1) { badgeClass = 'role-badge-admin'; label = 'Administrador'; }
                        if (roleId == 2) { badgeClass = 'role-badge-buyer'; label = 'Comprador'; }
                        document.getElementById('roleCurrentBadgeModal').innerHTML =
                            '<span class="user-card-role-badge ' + badgeClass + '">Rol actual: ' + label + '</span>';

                        document.getElementById('changeRoleModal').classList.add('show');
                        document.body.style.overflow = 'hidden';
                    }

                    // MODAL CAMBIAR ROL — desde el modal de ver
                    function openRoleModalFromList() {
                        const viewModal = document.getElementById('userModal');
                        const userId = viewModal.dataset.userId;
                        const roleId = viewModal.dataset.roleId;
                        if (!userId) return;

                        document.getElementById('changeRoleUserIdModal').value = userId;

                        document.querySelectorAll('#changeRoleModal .role-option-modal input').forEach(r => r.checked = false);
                        const currentRadio = document.querySelector('#changeRoleModal input[value="' + roleId + '"]');
                        if (currentRadio) currentRadio.checked = true;

                        let badgeClass = 'role-badge-user', label = 'Usuario';
                        if (roleId == 1) { badgeClass = 'role-badge-admin'; label = 'Administrador'; }
                        if (roleId == 2) { badgeClass = 'role-badge-buyer'; label = 'Comprador'; }
                        document.getElementById('roleCurrentBadgeModal').innerHTML =
                            '<span class="user-card-role-badge ' + badgeClass + '">Rol actual: ' + label + '</span>';

                        closeUserModal();
                        setTimeout(() => {
                            document.getElementById('changeRoleModal').classList.add('show');
                            document.body.style.overflow = 'hidden';
                        }, 200);
                    }

                    function closeChangeRoleModal() {
                        document.getElementById('changeRoleModal').classList.remove('show');
                        document.body.style.overflow = '';
                    }

                    // Click outside to close
                    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
                        overlay.addEventListener('click', function (e) {
                            if (e.target === overlay) {
                                overlay.classList.remove('show');
                                document.body.style.overflow = '';
                            }
                        });
                    });

                    // ESC key
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            document.querySelectorAll('.modal-overlay.show').forEach(function (m) {
                                m.classList.remove('show');
                            });
                            document.body.style.overflow = '';
                        }
                    });

                    // Attach click to cards (solo grid, no tabla)
                    document.querySelectorAll('#usersGrid .user-card').forEach(card => {
                        card.addEventListener('click', () => openUserModal(card));
                    });

                    // Auto-hide toast
                    setTimeout(() => {
                        document.querySelectorAll('.toast-container')?.forEach(t => t.remove());
                    }, 4000);
                </script>
            </body>

            </html>