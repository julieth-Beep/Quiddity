<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // FIX: Si viene por action=nuevo, FORZAR limpieza completa
    if ("nuevo".equals(request.getParameter("action"))) {
        request.removeAttribute("usuario");
        request.setAttribute("usuario", null);
    }
    
    String ctx = request.getContextPath();
    String accion = request.getParameter("accion");
    if (accion == null) accion = "nuevo";
    
    // CRÍTICO: Solo buscar en REQUEST, no en session
    Object usuarioObj = request.getAttribute("usuario");
    boolean hayUsuario = (usuarioObj != null && usuarioObj instanceof com.quiddity.model.Usuario);
    
    String pageTitle   = !hayUsuario ? "Nuevo Usuario"
                       : "editar".equals(accion)  ? "Editar Usuario"
                       : "Detalles de Usuario";
    String pageIcon    = !hayUsuario ? "person_add"
                       : "editar".equals(accion)  ? "edit"
                       : "person";
    String accionForm  = "editar".equals(accion) && hayUsuario ? "editar" : "crear";
    boolean isVer      = "ver".equals(accion) && hayUsuario;
    boolean isEdit     = "editar".equals(accion) && hayUsuario;
    boolean isNew      = !hayUsuario;
%>
<!DOCTYPE html>
                <html lang="es">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <%= pageTitle %> — Quiddity Admin
                    </title>
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&family=EB+Garamond:ital,wght@0,400..800;1,400..800&display=swap"
                        rel="stylesheet">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
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
                            --shadow-lg: 0 12px 32px rgba(0, 0, 0, 0.12);
                            --primary: #9a3a5a;
                            --primary-dark: #7a2e48;
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
                            -webkit-font-smoothing: antialiased;
                            font-size: 13px;
                            line-height: 1.5;
                        }

                        .material-symbols-outlined {
                            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
                            vertical-align: middle;
                        }

                        ::-webkit-scrollbar {
                            width: 4px;
                        }

                        ::-webkit-scrollbar-track {
                            background: transparent;
                        }

                        ::-webkit-scrollbar-thumb {
                            background: var(--border);
                            border-radius: 2px;
                        }

                        /* ── LAYOUT ── */
                        .layout-wrapper {
                            display: flex;
                            min-height: 100vh;
                            width: 100%;
                        }

                        .main-content {
                            flex: 1;
                            padding: 24px 40px;
                            display: flex;
                            flex-direction: column;
                            gap: 20px;
                            
                        }

                        /* ── BREADCRUMB ── */
                        .breadcrumb-bar {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            font-size: 11px;
                            font-weight: 600;
                            color: var(--text-tertiary);
                        }

                        .breadcrumb-bar a {
                            color: var(--text-secondary);
                            text-decoration: none;
                            transition: color 0.2s;
                        }

                        .breadcrumb-bar a:hover {
                            color: var(--accent-sky);
                        }

                        .breadcrumb-bar .sep {
                            color: var(--border);
                        }

                        .breadcrumb-bar .current {
                            color: var(--text-primary);
                        }

                        /* ── HEADER DE PÁGINA ── */
                        .page-header {
                            display: flex;
                            align-items: flex-start;
                            justify-content: space-between;
                            background: var(--surface);
                            border-radius: var(--radius-lg);
                            padding: 20px 32px;
                            border: 1px solid var(--border);
                            box-shadow: var(--shadow-sm);
                            animation: fadeUp 0.45s ease forwards;
                            opacity: 0;
                        }

                        .page-header-left {
                            display: flex;
                            align-items: center;
                            gap: 16px;
                        }

                        .page-header-icon {
                            width: 52px;
                            height: 52px;
                            border-radius: var(--radius-md);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 24px;
                            flex-shrink: 0;
                        }

                        .page-header-icon.add {
                            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
                            color: var(--accent-lavender);
                        }

                        .page-header-icon.edit {
                            background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-mint));
                            color: var(--accent-sky);
                        }

                        .page-header-icon.view {
                            background: linear-gradient(135deg, var(--pastel-cream), var(--pastel-mint));
                            color: var(--accent-cream);
                        }

                        .page-header-text h1 {
                            font-family: 'DM Sans', sans-serif;
                            font-size: 22px;
                            font-weight: 700;
                            color: var(--text-primary);
                            letter-spacing: -0.4px;
                            margin-bottom: 3px;
                        }

                        .page-header-text p {
                            font-size: 12px;
                            color: var(--text-secondary);
                            font-weight: 500;
                        }

                        .btn-back {
                            display: inline-flex;
                            align-items: center;
                            gap: 7px;
                            padding: 10px 18px;
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
                            transition: all 0.2s ease;
                            font-family: 'Plus Jakarta Sans', sans-serif;
                        }

                        .btn-back:hover {
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                            border-color: var(--pastel-sky-dark);
                        }

                        /* ── TOAST ── */
                        .toast-container {
                            position: fixed;
                            top: 24px;
                            right: 24px;
                            z-index: 9999;
                            display: flex;
                            flex-direction: column;
                            gap: 10px;
                            pointer-events: none;
                        }

                        .toast-item {
                            background: var(--surface);
                            border: 1px solid var(--border-light);
                            border-radius: var(--radius-md);
                            padding: 14px 20px;
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            box-shadow: var(--shadow-lg);
                            animation: slideInToast 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                            font-size: 12px;
                            font-weight: 600;
                            min-width: 300px;
                            border-left: 4px solid var(--accent-sky);
                            font-family: 'Plus Jakarta Sans', sans-serif;
                            pointer-events: auto;
                        }

                        .toast-item.success {
                            border-left-color: var(--accent-mint);
                        }

                        .toast-item.error {
                            border-left-color: var(--accent-coral);
                        }

                        .toast-icon {
                            width: 32px;
                            height: 32px;
                            border-radius: 8px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 14px;
                            flex-shrink: 0;
                        }

                        .toast-item.success .toast-icon {
                            background: var(--pastel-mint);
                            color: var(--accent-mint);
                        }

                        .toast-item.error .toast-icon {
                            background: var(--pastel-coral);
                            color: var(--accent-coral);
                        }

                        @keyframes slideInToast {
                            from {
                                transform: translateX(120%);
                                opacity: 0;
                            }

                            to {
                                transform: translateX(0);
                                opacity: 1;
                            }
                        }

                        /* ── FORM CARD ── */
                        .form-card {
                            background: var(--surface);
                            border-radius: var(--radius-lg);
                            border: 1px solid var(--border);
                            box-shadow: var(--shadow-sm);
                            overflow: hidden;
                            animation: fadeUp 0.5s ease 0.08s forwards;
                            opacity: 0;
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                        }

                        .form-card-header {
                            padding: 18px 32px;
                            border-bottom: 1px solid var(--border-light);
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            background: linear-gradient(to right, var(--bg), var(--surface));
                        }

                        .form-card-header h2 {
                            font-family: 'DM Sans', sans-serif;
                            font-size: 13px;
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
                            background: var(--accent-sky);
                            flex-shrink: 0;
                            display: inline-block;
                        }

                        .form-card-body {
                            padding: 28px 32px;
                            flex: 1;
                        }

                        /* ── TWO-COLUMN GRID ── */
                        .form-layout {
                            display: grid;
                            grid-template-columns: 1fr 320px;
                            gap: 24px;
                            align-items: start;
                        }

                        .form-fields {
                            display: flex;
                            flex-direction: column;
                            gap: 16px;
                        }

                        .form-sidebar {
                            display: flex;
                            flex-direction: column;
                            gap: 16px;
                        }

                        /* ── FORM GROUPS ── */
                        .form-row {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 14px;
                        }

                        .form-row.thirds {
                            grid-template-columns: 1fr 1fr 1fr;
                        }

                        .form-group {
                            display: flex;
                            flex-direction: column;
                            gap: 6px;
                        }

                        .form-group label {
                            font-size: 10px;
                            font-weight: 700;
                            color: var(--text-secondary);
                            text-transform: uppercase;
                            letter-spacing: 0.1em;
                            font-family: 'Plus Jakarta Sans', sans-serif;
                        }

                        .form-group label .required {
                            color: var(--accent-coral);
                            margin-left: 2px;
                        }

                        .form-group label .optional {
                            color: var(--text-tertiary);
                            font-weight: 400;
                            text-transform: none;
                            letter-spacing: 0;
                            font-size: 10px;
                            margin-left: 4px;
                        }

                        .form-group input,
                        .form-group select,
                        .form-group textarea {
                            padding: 11px 14px;
                            border: 1.5px solid var(--border);
                            border-radius: var(--radius-sm);
                            font-size: 13px;
                            font-weight: 500;
                            color: var(--text-primary);
                            background: var(--bg-soft);
                            transition: all 0.2s;
                            font-family: 'Plus Jakarta Sans', sans-serif;
                            line-height: 1.4;
                        }

                        .form-group input:focus,
                        .form-group select:focus,
                        .form-group textarea:focus {
                            outline: none;
                            border-color: var(--accent-sky);
                            box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
                            background: var(--surface);
                        }

                        .form-group input::placeholder,
                        .form-group textarea::placeholder {
                            color: var(--text-tertiary);
                            font-weight: 400;
                        }

                        .form-group textarea {
                            resize: vertical;
                            min-height: 90px;
                        }

                        .form-group select {
                            cursor: pointer;
                        }

                        .form-group input[type="file"] {
                            padding: 9px 14px;
                            cursor: pointer;
                            font-size: 12px;
                            color: var(--text-secondary);
                        }

                        .form-group input[type="file"]::file-selector-button {
                            padding: 5px 12px;
                            margin-right: 12px;
                            border: 1px solid var(--border);
                            border-radius: 8px;
                            background: var(--bg);
                            color: var(--text-secondary);
                            font-family: 'Plus Jakarta Sans', sans-serif;
                            font-size: 10px;
                            font-weight: 700;
                            letter-spacing: 0.06em;
                            text-transform: uppercase;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .form-group input[type="file"]::file-selector-button:hover {
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                            border-color: var(--pastel-sky-dark);
                        }

                        .input-hint {
                            font-size: 10px;
                            color: var(--text-tertiary);
                            font-weight: 500;
                            margin-top: 2px;
                        }

                        .input-prefix-group {
                            position: relative;
                        }

                        .input-prefix-group .prefix {
                            position: absolute;
                            left: 14px;
                            top: 50%;
                            transform: translateY(-50%);
                            font-size: 13px;
                            font-weight: 700;
                            color: var(--text-tertiary);
                            pointer-events: none;
                        }

                        .input-prefix-group input {
                            padding-left: 26px;
                        }

                        /* ── AVATAR SIDEBAR ── */
                        .avatar-upload-card {
                            background: var(--bg);
                            border-radius: var(--radius-md);
                            border: 1.5px dashed var(--border);
                            overflow: hidden;
                            transition: border-color 0.2s;
                        }

                        .avatar-upload-card:hover {
                            border-color: var(--accent-sky);
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
                            background: linear-gradient(135deg, #f5f5f5, #ebebeb);
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
                            color: var(--text-tertiary);
                        }

                        .avatar-preview-placeholder .icon {
                            font-size: 40px;
                        }

                        .avatar-preview-placeholder p {
                            font-size: 11px;
                            font-weight: 600;
                            text-align: center;
                        }

                        .avatar-upload-footer {
                            padding: 12px 14px;
                            border-top: 1px solid var(--border-light);
                        }

                        .avatar-upload-footer label {
                            display: flex;
                            align-items: center;
                            gap: 7px;
                            cursor: pointer;
                            font-size: 11px;
                            font-weight: 700;
                            color: var(--accent-sky);
                            text-transform: uppercase;
                            letter-spacing: 0.06em;
                            justify-content: center;
                        }

                        .avatar-upload-footer label .material-symbols-outlined {
                            font-size: 15px;
                        }

                        #avatarInput {
                            display: none;
                        }

                        /* ── ROLE SELECTOR ── */
                        .role-selector {
                            display: flex;
                            gap: 10px;
                            flex-wrap: wrap;
                        }

                        .role-option {
                            flex: 1;
                            min-width: 140px;
                            position: relative;
                        }

                        .role-option input {
                            display: none;
                        }

                        .role-option label {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 6px;
                            padding: 16px 12px;
                            background: var(--bg-soft);
                            border: 1.5px solid var(--border);
                            border-radius: var(--radius-sm);
                            cursor: pointer;
                            transition: all 0.25s ease;
                            text-align: center;
                            font-family: 'Plus Jakarta Sans', sans-serif;
                        }

                        .role-option label .role-icon {
                            width: 36px;
                            height: 36px;
                            border-radius: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 16px;
                            transition: all 0.3s ease;
                        }

                        .role-option.admin label .role-icon {
                            background: var(--pastel-coral);
                            color: var(--accent-coral);
                        }

                        .role-option.buyer label .role-icon {
                            background: var(--pastel-mint);
                            color: var(--accent-mint);
                        }

                        .role-option.user label .role-icon {
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                        }

                        .role-option label .role-title {
                            font-size: 12px;
                            font-weight: 700;
                            color: var(--text-primary);
                            text-transform: none;
                            letter-spacing: 0;
                        }

                        .role-option label .role-desc {
                            font-size: 10px;
                            color: var(--text-tertiary);
                            font-weight: 500;
                        }

                        .role-option input:checked+label {
                            border-color: var(--accent-sky);
                            background: linear-gradient(135deg, var(--pastel-sky), rgba(25, 118, 210, 0.05));
                            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.1);
                        }

                        .role-option input:checked+label .role-icon {
                            transform: scale(1.1);
                        }

                        .role-option input:disabled+label {
                            opacity: 0.5;
                            cursor: not-allowed;
                            filter: grayscale(0.6);
                        }

                        /* ── FORM ACTIONS ── */
                        .form-actions {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            padding: 18px 32px;
                            border-top: 1px solid var(--border-light);
                            background: linear-gradient(to right, var(--bg), var(--surface));
                            margin-top: auto;
                        }

                        .form-actions-right {
                            display: flex;
                            gap: 10px;
                        }

                        .btn-form {
                            display: inline-flex;
                            align-items: center;
                            gap: 7px;
                            padding: 11px 24px;
                            font-size: 11px;
                            font-weight: 700;
                            letter-spacing: 0.07em;
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
                            color: var(--text-primary);
                            border: 1.5px solid var(--border);
                        }

                        .btn-form.cancel:hover {
                            background: var(--border-light);
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
                        }

                        /* ── VIEW-ONLY MODE ── */
                        .view-mode .form-group input,
                        .view-mode .form-group select,
                        .view-mode .form-group textarea {
                            background: var(--bg);
                            border-color: var(--border-light);
                            color: var(--text-primary);
                            pointer-events: none;
                        }

                        .view-mode .role-option label {
                            pointer-events: none;
                        }

                        .view-mode .avatar-upload-footer {
                            display: none;
                        }

                        .view-mode .form-actions .btn-form.save {
                            display: none;
                        }

                        /* ── USER INFO BADGE (editar/ver) ── */
                        .user-badge-card {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 14px 16px;
                            background: var(--bg);
                            border-radius: var(--radius-md);
                            border: 1px solid var(--border-light);
                        }

                        .user-badge-avatar {
                            width: 48px;
                            height: 48px;
                            border-radius: 50%;
                            overflow: hidden;
                            background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
                            flex-shrink: 0;
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
                            background: linear-gradient(135deg, var(--accent-lavender), var(--accent-sky));
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 700;
                            font-size: 16px;
                        }

                        .user-badge-info {
                            flex: 1;
                            min-width: 0;
                        }

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
                            font-size: 12px;
                            font-weight: 700;
                            color: var(--accent-sky);
                            margin-top: 2px;
                        }

                        /* ── GLASSMORPHISM MODALS ── */
                        .modal-glass-overlay {
                            position: fixed;
                            inset: 0;
                            background: rgba(26, 26, 46, 0.45);
                            backdrop-filter: blur(12px) saturate(1.2);
                            -webkit-backdrop-filter: blur(12px) saturate(1.2);
                            z-index: 9998;
                            display: none;
                            align-items: center;
                            justify-content: center;
                            padding: 20px;
                            opacity: 0;
                            transition: opacity 0.3s ease;
                        }

                        .modal-glass-overlay.active {
                            display: flex;
                            opacity: 1;
                        }

                        .modal-glass-content {
                            background: rgba(255, 255, 255, 0.92);
                            border-radius: var(--radius-lg);
                            max-width: 480px;
                            width: 100%;
                            max-height: 85vh;
                            overflow-y: auto;
                            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
                            border: 1px solid rgba(255, 255, 255, 0.6);
                            animation: glassSlideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                            position: relative;
                            backdrop-filter: blur(20px);
                        }

                        @keyframes glassSlideUp {
                            from {
                                opacity: 0;
                                transform: translateY(30px) scale(0.96);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0) scale(1);
                            }
                        }

                        .modal-glass-header {
                            height: 110px;
                            position: relative;
                            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
                            overflow: hidden;
                        }

                        .modal-glass-header-bg {
                            position: absolute;
                            inset: 0;
                            background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky), var(--pastel-mint));
                            opacity: 0.8;
                        }

                        .modal-glass-header-pattern {
                            position: absolute;
                            inset: 0;
                            background-image: radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.4) 0%, transparent 50%),
                                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.3) 0%, transparent 40%);
                        }

                        .modal-glass-close {
                            position: absolute;
                            top: 12px;
                            right: 12px;
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            background: rgba(255, 255, 255, 0.85);
                            border: 1px solid rgba(255, 255, 255, 0.5);
                            cursor: pointer;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            transition: all 0.2s ease;
                            color: var(--text-secondary);
                            z-index: 10;
                            backdrop-filter: blur(4px);
                        }

                        .modal-glass-close:hover {
                            background: var(--pastel-coral);
                            color: var(--accent-coral);
                            transform: rotate(90deg);
                        }

                        .modal-glass-avatar-wrap {
                            position: absolute;
                            bottom: -40px;
                            left: 50%;
                            transform: translateX(-50%);
                            z-index: 5;
                        }

                        .modal-glass-avatar,
                        .modal-glass-avatar-default {
                            width: 80px;
                            height: 80px;
                            border-radius: 50%;
                            border: 4px solid rgba(255, 255, 255, 0.9);
                            object-fit: cover;
                            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
                            background: linear-gradient(135deg, var(--accent-lavender), var(--accent-sky));
                        }

                        .modal-glass-avatar-default {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 700;
                            font-size: 28px;
                        }

                        .modal-glass-body {
                            padding: 52px 28px 24px;
                            text-align: center;
                        }

                        .modal-glass-name {
                            font-family: 'DM Sans', sans-serif;
                            font-size: 22px;
                            font-weight: 700;
                            color: var(--text-primary);
                            margin-bottom: 4px;
                            letter-spacing: -0.3px;
                        }

                        .modal-glass-username {
                            font-size: 12px;
                            color: var(--text-tertiary);
                            font-weight: 600;
                            margin-bottom: 12px;
                        }

                        .modal-glass-role-badge {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            padding: 4px 12px;
                            border-radius: 20px;
                            font-size: 10px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.06em;
                            margin-bottom: 20px;
                        }

                        .modal-glass-details {
                            text-align: left;
                            background: rgba(248, 249, 250, 0.6);
                            border-radius: var(--radius-md);
                            padding: 16px;
                            border: 1px solid var(--border-light);
                            margin-bottom: 20px;
                        }

                        .modal-glass-detail-row {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 10px 0;
                            border-bottom: 1px solid var(--border-light);
                        }

                        .modal-glass-detail-row:last-child {
                            border-bottom: none;
                        }

                        .modal-glass-detail-row i {
                            width: 32px;
                            height: 32px;
                            border-radius: 8px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 13px;
                            flex-shrink: 0;
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                        }

                        .modal-glass-detail-row .detail-label {
                            font-size: 10px;
                            font-weight: 700;
                            color: var(--text-tertiary);
                            text-transform: uppercase;
                            letter-spacing: 0.06em;
                            margin-bottom: 2px;
                        }

                        .modal-glass-detail-row .detail-value {
                            font-size: 13px;
                            font-weight: 600;
                            color: var(--text-primary);
                        }

                        .modal-glass-actions {
                            display: flex;
                            gap: 10px;
                            justify-content: center;
                            flex-wrap: wrap;
                        }

                        .modal-glass-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            padding: 10px 20px;
                            border-radius: var(--radius-sm);
                            font-size: 12px;
                            font-weight: 700;
                            text-decoration: none;
                            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                            border: none;
                            cursor: pointer;
                            font-family: 'Plus Jakarta Sans', sans-serif;
                        }

                        .modal-glass-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: var(--shadow-md);
                        }

                        .modal-glass-btn.edit {
                            background: linear-gradient(135deg, var(--pastel-sky), var(--pastel-lavender));
                            color: var(--accent-sky);
                        }

                        .modal-glass-btn.role {
                            background: linear-gradient(135deg, var(--pastel-mint), var(--pastel-sage));
                            color: var(--accent-mint);
                        }

                        .modal-glass-btn.delete {
                            background: linear-gradient(135deg, var(--pastel-coral), #FECDD3);
                            color: var(--accent-coral);
                        }

                        .modal-glass-btn.back {
                            background: var(--bg-soft);
                            color: var(--text-secondary);
                            border: 1px solid var(--border-light);
                        }

                        /* ── DELETE CONFIRMATION MODAL ── */
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
                            margin: 0 auto 16px;
                            font-size: 28px;
                            color: var(--accent-coral);
                            animation: pulseIcon 2s ease-in-out infinite;
                        }

                        @keyframes pulseIcon {

                            0%,
                            100% {
                                transform: scale(1);
                            }

                            50% {
                                transform: scale(1.05);
                            }
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
                            margin-bottom: 20px;
                        }

                        .delete-confirm-user {
                            font-family: 'DM Sans', sans-serif;
                            font-size: 16px;
                            font-weight: 700;
                            color: var(--accent-coral);
                            margin-bottom: 20px;
                            padding: 10px 16px;
                            background: var(--pastel-coral);
                            border-radius: var(--radius-sm);
                            display: inline-block;
                        }

                        .delete-type-options-glass {
                            display: flex;
                            gap: 8px;
                            justify-content: center;
                            margin-bottom: 20px;
                            flex-wrap: wrap;
                        }

                        .delete-type-option {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                            padding: 8px 14px;
                            border: 1.5px solid var(--border);
                            border-radius: var(--radius-sm);
                            background: var(--bg-soft);
                            cursor: pointer;
                            transition: all 0.2s;
                            font-size: 11px;
                            font-weight: 600;
                        }

                        .delete-type-option:hover {
                            border-color: var(--accent-sky);
                            background: var(--pastel-sky);
                        }

                        .delete-type-option input {
                            display: none;
                        }

                        .delete-type-option.active {
                            border-color: var(--accent-coral);
                            background: var(--pastel-coral);
                            color: var(--accent-coral);
                        }

                        .delete-type-option.soft.active {
                            border-color: var(--accent-sky);
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                        }

                        /* ── ROLE CHANGE MODAL ── */
                        .role-change-body {
                            padding: 32px 28px 24px;
                            text-align: center;
                        }

                        .role-change-icon {
                            width: 56px;
                            height: 56px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, var(--pastel-mint), var(--pastel-sage));
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 16px;
                            font-size: 24px;
                            color: var(--accent-mint);
                        }

                        .role-change-title {
                            font-family: 'DM Sans', sans-serif;
                            font-size: 18px;
                            font-weight: 700;
                            color: var(--text-primary);
                            margin-bottom: 6px;
                        }

                        .role-change-text {
                            font-size: 12px;
                            color: var(--text-secondary);
                            margin-bottom: 20px;
                        }

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

                        .role-options-glass {
                            display: flex;
                            gap: 10px;
                            justify-content: center;
                            margin-bottom: 20px;
                            flex-wrap: wrap;
                        }

                        .role-option-glass {
                            flex: 1;
                            min-width: 120px;
                            max-width: 160px;
                        }

                        .role-option-glass input {
                            display: none;
                        }

                        .role-option-glass label {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 8px;
                            padding: 16px 12px;
                            background: var(--bg-soft);
                            border: 2px solid var(--border);
                            border-radius: var(--radius-sm);
                            cursor: pointer;
                            transition: all 0.25s ease;
                            text-align: center;
                        }

                        .role-option-glass label .role-glass-icon {
                            width: 40px;
                            height: 40px;
                            border-radius: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 18px;
                            transition: all 0.3s ease;
                        }

                        .role-option-glass.admin label .role-glass-icon {
                            background: var(--pastel-coral);
                            color: var(--accent-coral);
                        }

                        .role-option-glass.buyer label .role-glass-icon {
                            background: var(--pastel-mint);
                            color: var(--accent-mint);
                        }

                        .role-option-glass.user label .role-glass-icon {
                            background: var(--pastel-sky);
                            color: var(--accent-sky);
                        }

                        .role-option-glass label .role-glass-title {
                            font-size: 12px;
                            font-weight: 700;
                            color: var(--text-primary);
                        }

                        .role-option-glass label .role-glass-desc {
                            font-size: 10px;
                            color: var(--text-tertiary);
                            font-weight: 500;
                        }

                        .role-option-glass input:checked+label {
                            border-color: var(--accent-mint);
                            background: linear-gradient(135deg, var(--pastel-mint), rgba(56, 142, 60, 0.05));
                            box-shadow: 0 4px 16px rgba(56, 142, 60, 0.12);
                            transform: translateY(-2px);
                        }

                        .role-option-glass input:checked+label .role-glass-icon {
                            transform: scale(1.1);
                        }

                        /* ── ANIMATIONS ── */
                        @keyframes fadeUp {
                            from {
                                opacity: 0;
                                transform: translateY(14px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        /* ── RESPONSIVE ── */
                        @media (max-width: 992px) {
                            .form-layout {
                                grid-template-columns: 1fr;
                            }

                            .form-sidebar {
                                order: -1;
                            }

                            .main-content {
                                padding: 20px 24px;
                            }

                            .modal-glass-content {
                                max-width: 95%;
                            }
                        }

                        @media (max-width: 600px) {
                            .main-content {
                                padding: 16px 20px;
                            }
                            .form-card-body {
                                padding: 20px 16px;
                            }
                            .form-actions {
                                padding: 14px 16px;
                            }
                            .form-card-header {
                                padding: 14px 16px;
                            }
                            .page-header {
                                padding: 16px 20px;
                            }
                            .form-row {
                                grid-template-columns: 1fr;
                            }

                            .role-selector {
                                flex-direction: column;
                            }

                            .role-options-glass {
                                flex-direction: column;
                                align-items: center;
                            }

                            .role-option-glass {
                                max-width: 100%;
                                width: 100%;
                            }
                        }
                    </style>
                </head>

                <body>

    <!-- TOASTS -->
    <div class="toast-container" id="toastContainer">
        <c:if test="${not empty param.exito}">
            <div class="toast-item success">
                <div class="toast-icon"><span class="material-symbols-outlined"
                        style="font-size:15px;">check_circle</span></div>
                <span>${param.exito}</span>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast-item error">
                <div class="toast-icon"><span class="material-symbols-outlined"
                        style="font-size:15px;">error</span></div>
                <span>${param.error}</span>
            </div>
        </c:if>
    </div>

    <div class="layout-wrapper">
        <%@ include file="/includes/sidebar.jsp" %>

            <main class="main-content">

                <!-- Breadcrumb -->
                <nav class="breadcrumb-bar">
                    <span class="material-symbols-outlined" style="font-size:14px;">home</span>
                    <a href="<%= ctx %>/admin/usuarios">Usuarios Admin</a>
                    <span class="sep">›</span>
                    <span class="current">
                        <%= pageTitle %>
                    </span>
                </nav>

                <!-- Page Header -->
                <div class="page-header">
                    <div class="page-header-left">
                        <div class="page-header-icon <%= isNew ? " add" : isEdit ? "edit" : "view" %>">
                            <span class="material-symbols-outlined">
                                <%= pageIcon %>
                            </span>
                        </div>
                        <div class="page-header-text">
                            <h1>
                                <%= pageTitle %>
                            </h1>
                            <p>
                                <% if (isNew) { %>Completa todos los campos para crear un nuevo usuario
                                    en el sistema.
                                    <% } else if (isEdit) { %>Modifica los datos del usuario. Los campos
                                        en blanco conservan su valor actual.
                                        <% } else { %>Visualiza la información completa del usuario.
                                            <% } %>
                            </p>
                        </div>
                    </div>
                    <a href="<%= ctx %>/admin/usuarios" class="btn-back">
                        <span class="material-symbols-outlined"
                            style="font-size:14px;">arrow_back</span>
                        Volver al listado
                    </a>
                </div>

                <!-- ==================== FORMULARIO: NUEVO / EDITAR / VER ==================== -->
                <form action="<%= ctx %>/admin/usuarios" method="POST" enctype="multipart/form-data"
                    id="userForm" class="<%= isVer ? " view-mode" : "" %>">
                    <input type="hidden" name="action" value="<%= accionForm %>">
                    <c:if test="${not empty requestScope.usuario}">
                        <input type="hidden" name="id" value="${requestScope.usuario.id}">
                    </c:if>

                    <!-- ── Datos Principales ── -->
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
                                            <label>Nombre <span class="required">*</span></label>
                                            <input type="text" name="nombre" required
                                                placeholder="Ej: María"
                                                value="<c:out value='${requestScope.usuario.nombre}' default=''/>" <%=isVer
                                                ? "readonly" : "" %>>
                                        </div>
                                        <div class="form-group">
                                            <label>Apellido <span class="required">*</span></label>
                                            <input type="text" name="apellido" required
                                                placeholder="Ej: González"
                                                value="<c:out value='${requestScope.usuario.apellido}' default=''/>" <%=isVer
                                                ? "readonly" : "" %>>
                                        </div>
                                    </div>

                                    <!-- Email + Documento -->
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Email <span class="required">*</span></label>
                                            <input type="email" name="email" required
                                                placeholder="ejemplo@correo.com"
                                                value="<c:out value='${requestScope.usuario.email}' default=''/>" <%=isVer
                                                ? "readonly" : "" %>>
                                        </div>
                                        <div class="form-group">
                                            <label>Documento <span class="required">*</span></label>
                                            <input type="text" name="documento" required
                                                placeholder="Número de documento"
                                                value="<c:out value='${requestScope.usuario.documento}' default=''/>" <%=isVer
                                                ? "readonly" : "" %>>
                                        </div>
                                    </div>

                                    <!-- Username + Foto URL -->
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Nombre de usuario <span
                                                    class="required">*</span></label>
                                            <div class="input-prefix-group">
                                                <span class="prefix">@</span>
                                                <input type="text" name="username" required
                                                    placeholder="username"
                                                    value="<c:out value='${requestScope.usuario.userName}' default=''/>"
                                                    <%=isVer ? "readonly" : "" %>>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>Foto de perfil URL <span
                                                    class="optional">(opcional)</span></label>
                                            <input type="text" name="fotoperfil_url"
                                                placeholder="https://ejemplo.com/foto.jpg"
                                                value="<c:out value='${requestScope.usuario.fotoPerfil}' default=''/>" <%=isVer
                                                ? "readonly" : "" %>>
                                            <span class="input-hint">URL externa (deja vacío para subir
                                                archivo)</span>
                                        </div>
                                    </div>

                                    <% if (isNew) { %>
                                        <!-- Contraseña (solo nuevo) -->
                                        <div class="form-group">
                                            <label>Contraseña <span class="required">*</span></label>
                                            <input type="password" name="contrasena" required
                                                placeholder="Mínimo 6 caracteres">
                                        </div>
                                        <% } %>

                                            <!-- Role Selector -->
                                            <div class="form-group">
                                                <label>Rol <span class="required">*</span></label>
                                                <div class="role-selector">
                                                    <div class="role-option admin">
                                                        <input type="radio" name="idrol" id="rolAdmin"
                                                            value="1" ${requestScope.usuario.idRol==1 ? 'checked'
                                                            : '' } ${not empty requestScope.usuario &&
                                                            sessionScope.usuario.idRol !=1 ? 'disabled'
                                                            : '' } <%=isVer ? "disabled" : "" %>>
                                                        <label for="rolAdmin">
                                                            <div class="role-icon"><i
                                                                    class="fas fa-shield-alt"></i></div>
                                                            <span
                                                                class="role-title">Administrador</span>
                                                            <span class="role-desc">Control total</span>
                                                        </label>
                                                    </div>
                                                    <div class="role-option buyer">
                                                        <input type="radio" name="idrol" id="rolBuyer"
                                                            value="2" ${requestScope.usuario.idRol==2 ? 'checked'
                                                            : '' } ${not empty requestScope.usuario &&
                                                            sessionScope.usuario.idRol !=1 ? 'disabled'
                                                            : '' } <%=isVer ? "disabled" : "" %>>
                                                        <label for="rolBuyer">
                                                            <div class="role-icon"><i
                                                                    class="fas fa-shopping-bag"></i>
                                                            </div>
                                                            <span class="role-title">Comprador</span>
                                                            <span class="role-desc">Puede comprar</span>
                                                        </label>
                                                    </div>
                                                    <div class="role-option user">
                                                        <input type="radio" name="idrol" id="rolUser"
                                                            value="3" ${empty requestScope.usuario ||
                                                            requestScope.usuario.idRol==3 ? 'checked' : '' } ${not
                                                            empty requestScope.usuario && sessionScope.usuario.idRol
                                                            !=1 ? 'disabled' : '' } <%=isVer
                                                            ? "disabled" : "" %>>
                                                        <label for="rolUser">
                                                            <div class="role-icon"><i
                                                                    class="fas fa-user"></i></div>
                                                            <span class="role-title">Usuario</span>
                                                            <span class="role-desc">Acceso básico</span>
                                                        </label>
                                                    </div>
                                                </div>
                                                <c:if
                                                    test="${not empty requestScope.usuario && sessionScope.usuario.idRol != 1}">
                                                    <span class="input-hint">
                                                        <span class="material-symbols-outlined"
                                                            style="font-size:12px;vertical-align:middle;">info</span>
                                                        Solo los administradores pueden cambiar el rol.
                                                    </span>
                                                </c:if>
                                            </div>

                                </div><!-- /form-fields -->

                                <!-- ── Sidebar con avatar ── -->
                                <div class="form-sidebar">

                                    <!-- Badge del usuario (solo editar/ver) -->
                                    <c:if test="${not empty requestScope.usuario}">
                                        <div class="user-badge-card">
                                            <c:choose>
                                                <%-- URL externa --%>
                                                    <c:when
                                                        test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'http')}">
                                                        <div class="user-badge-avatar">
                                                            <img src="${requestScope.usuario.fotoPerfil}"
                                                                alt="${fn:escapeXml(requestScope.usuario.nombre)}"
                                                                onerror="this.parentElement.innerHTML='<div class=\'user-badge-avatar-default\'>${fn:substring(requestScope.usuario.nombre,0,1)}${fn:substring(requestScope.usuario.apellido,0,1)}</div>'">
                                                        </div>
                                                    </c:when>
                                                    <%-- Ruta completa uploads/perfiles/... --%>
                                                        <c:when
                                                            test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'uploads/')}">
                                                            <div class="user-badge-avatar">
                                                                <img src="${pageContext.request.contextPath}/${requestScope.usuario.fotoPerfil}"
                                                                    alt="${fn:escapeXml(requestScope.usuario.nombre)}"
                                                                    onerror="this.parentElement.innerHTML='<div class=\'user-badge-avatar-default\'>${fn:substring(requestScope.usuario.nombre,0,1)}${fn:substring(requestScope.usuario.apellido,0,1)}</div>'">
                                                            </div>
                                                        </c:when>
                                                        <%-- Ruta antigua fallback --%>
                                                            <c:when
                                                                test="${not empty requestScope.usuario.fotoPerfil}">
                                                                <div class="user-badge-avatar">
                                                                    <img src="${pageContext.request.contextPath}/uploads/perfiles/${requestScope.usuario.fotoPerfil}"
                                                                        alt="${fn:escapeXml(requestScope.usuario.nombre)}"
                                                                        onerror="this.parentElement.innerHTML='<div class=\'user-badge-avatar-default\'>${fn:substring(requestScope.usuario.nombre,0,1)}${fn:substring(requestScope.usuario.apellido,0,1)}</div>'">
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="user-badge-avatar-default">
                                                                    ${fn:substring(requestScope.usuario.nombre,0,1)}${fn:substring(requestScope.usuario.apellido,0,1)}
                                                                </div>
                                                            </c:otherwise>
                                            </c:choose>
                                            <div class="user-badge-info">
                                                <div class="badge-name">
                                                    <c:out
                                                        value="${requestScope.usuario.nombre} ${requestScope.usuario.apellido}" />
                                                </div>
                                                <div class="badge-role">
                                                    <c:choose>
                                                        <c:when test="${requestScope.usuario.idRol == 1}">
                                                            Administrador</c:when>
                                                        <c:when test="${requestScope.usuario.idRol == 2}">Comprador
                                                        </c:when>
                                                        <c:otherwise>Usuario</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="badge-email">
                                                    <c:out value="${requestScope.usuario.email}" />
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Avatar upload (solo si no es ver) -->
                                    <% if (!isVer) { %>
                                        <div class="form-group">
                                            <label>Avatar</label>
                                        </div>
                                        <div class="avatar-upload-card" id="avatarUploadCard">
                                            <div class="avatar-preview-area" id="previewArea">
                                                <c:choose>
                                                    <%-- URL externa --%>
                                                        <c:when
                                                            test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'http')}">
                                                            <img id="previewImg"
                                                                src="${requestScope.usuario.fotoPerfil}"
                                                                alt="Avatar">
                                                        </c:when>
                                                        <%-- Ruta completa uploads/perfiles/... --%>
                                                            <c:when
                                                                test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'uploads/')}">
                                                                <img id="previewImg"
                                                                    src="${pageContext.request.contextPath}/${requestScope.usuario.fotoPerfil}"
                                                                    alt="Avatar">
                                                            </c:when>
                                                            <%-- Ruta antigua fallback --%>
                                                                <c:when
                                                                    test="${not empty requestScope.usuario.fotoPerfil}">
                                                                    <img id="previewImg"
                                                                        src="${pageContext.request.contextPath}/uploads/perfiles/${requestScope.usuario.fotoPerfil}"
                                                                        alt="Avatar">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="avatar-preview-placeholder"
                                                                        id="previewPlaceholder">
                                                                        <span
                                                                            class="material-symbols-outlined icon">account_circle</span>
                                                                        <p>Vista previa aquí</p>
                                                                    </div>
                                                                    <img id="previewImg" src=""
                                                                        alt="Avatar"
                                                                        style="display:none;">
                                                                </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="avatar-upload-footer">
                                                <label for="avatarInput">
                                                    <span
                                                        class="material-symbols-outlined">upload</span>
                                                    <%= isNew ? "Seleccionar imagen" : "Cambiar imagen"
                                                        %>
                                                </label>
                                                <input type="file" id="avatarInput" name="avatar"
                                                    accept="image/jpeg,image/png,image/gif"
                                                    onchange="previewAvatar(this)">
                                            </div>
                                        </div>
                                        <p class="input-hint">JPG, PNG o GIF — máx. 5 MB</p>
                                        <% } else { %>
                                            <!-- Vista previa solo lectura -->
                                            <div class="form-group">
                                                <label>Avatar</label>
                                            </div>
                                            <div class="avatar-upload-card has-image">
                                                <div class="avatar-preview-area">
                                                    <c:choose>
                                                        <c:when
                                                            test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'http')}">
                                                            <img src="${requestScope.usuario.fotoPerfil}"
                                                                alt="Avatar">
                                                        </c:when>
                                                        <c:when
                                                            test="${fn:startsWith(requestScope.usuario.fotoPerfil, 'uploads/')}">
                                                            <img src="${pageContext.request.contextPath}/${requestScope.usuario.fotoPerfil}"
                                                                alt="Avatar">
                                                        </c:when>
                                                        <c:when test="${not empty requestScope.usuario.fotoPerfil}">
                                                            <img src="${pageContext.request.contextPath}/uploads/perfiles/${requestScope.usuario.fotoPerfil}"
                                                                alt="Avatar">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="avatar-preview-placeholder">
                                                                <span
                                                                    class="material-symbols-outlined icon"
                                                                    style="font-size:48px;">account_circle</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <% } %>

                                </div><!-- /form-sidebar -->
                            </div><!-- /form-layout -->
                        </div><!-- /form-card-body -->

                        <div class="form-actions">
                            <div>
                                <c:if test="${not empty requestScope.usuario && !isVer}">
                                    <button type="button" class="btn-form delete-btn"
                                        onclick="openDeleteModal()">
                                        <span class="material-symbols-outlined"
                                            style="font-size:14px;">delete</span>
                                        Eliminar Usuario
                                    </button>
                                </c:if>
                                <c:if test="${not empty requestScope.usuario && isVer}">
                                    <button type="button" class="btn-form delete-btn"
                                        onclick="openDeleteModal()">
                                        <span class="material-symbols-outlined"
                                            style="font-size:14px;">delete</span>
                                        Eliminar
                                    </button>
                                    <button type="button" class="btn-form"
                                        style="background:var(--pastel-mint);color:var(--accent-mint);border:1.5px solid var(--pastel-mint-dark);"
                                        onclick="openRoleModal()">
                                        <span class="material-symbols-outlined"
                                            style="font-size:14px;">sync_alt</span>
                                        Cambiar Rol
                                    </button>
                                </c:if>
                            </div>
                            <div class="form-actions-right">
                                <% if (isVer) { %>
                                    <a href="<%= ctx %>/admin/usuarios?id=${requestScope.usuario.id}&editar=true"
                                        class="btn-form save">
                                        <span class="material-symbols-outlined"
                                            style="font-size:14px;">edit</span>
                                        Editar Usuario
                                    </a>
                                    <% } %>
                                        <a href="<%= ctx %>/admin/usuarios"
                                            class="btn-form cancel">Cancelar</a>
                                        <% if (!isVer) { %>
                                            <button type="submit" class="btn-form save">
                                                <span class="material-symbols-outlined"
                                                    style="font-size:14px;">save</span>
                                                <%= isNew ? "Crear Usuario" : "Guardar Cambios" %>
                                            </button>
                                            <% } %>
                            </div>
                        </div>

                    </div><!-- /form-card -->
                </form>

            </main>
    </div>

    <!-- ==================== MODAL GLASSMORPHISM: VER USUARIO ==================== -->
    <div class="modal-glass-overlay" id="viewModal">
        <div class="modal-glass-content">
            <div class="modal-glass-header">
                <div class="modal-glass-header-bg"></div>
                <div class="modal-glass-header-pattern"></div>
                <button class="modal-glass-close" onclick="closeViewModal()"><i
                        class="fas fa-times"></i></button>
                <div class="modal-glass-avatar-wrap" id="viewAvatarContainer"></div>
            </div>
            <div class="modal-glass-body">
                <h3 class="modal-glass-name" id="viewName"></h3>
                <div class="modal-glass-username" id="viewUsername"></div>
                <div id="viewRoleBadge"></div>
                <div class="modal-glass-details">
                    <div class="modal-glass-detail-row">
                        <i class="fas fa-id-card"></i>
                        <div>
                            <div class="detail-label">Documento</div>
                            <div class="detail-value" id="viewDoc"></div>
                        </div>
                    </div>
                    <div class="modal-glass-detail-row">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <div class="detail-label">Email</div>
                            <div class="detail-value" id="viewEmail"></div>
                        </div>
                    </div>
                    <div class="modal-glass-detail-row">
                        <i class="fas fa-user-tag"></i>
                        <div>
                            <div class="detail-label">Rol</div>
                            <div class="detail-value" id="viewRole"></div>
                        </div>
                    </div>
                    <div class="modal-glass-detail-row">
                        <i class="fas fa-calendar"></i>
                        <div>
                            <div class="detail-label">ID de Usuario</div>
                            <div class="detail-value" id="viewId"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-glass-actions">
                    <a id="viewEditBtn" href="#" class="modal-glass-btn edit">
                        <i class="fas fa-pen"></i> Editar
                    </a>
                    <button type="button" class="modal-glass-btn role"
                        onclick="openRoleModalFromView()">
                        <i class="fas fa-exchange-alt"></i> Cambiar Rol
                    </button>
                    <button type="button" class="modal-glass-btn delete"
                        onclick="openDeleteModalFromView()">
                        <i class="fas fa-trash"></i> Eliminar
                    </button>
                    <button type="button" class="modal-glass-btn back" onclick="closeViewModal()">
                        <i class="fas fa-arrow-left"></i> Volver
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== MODAL GLASSMORPHISM: CAMBIAR ROL ==================== -->
    <div class="modal-glass-overlay" id="roleModal">
        <div class="modal-glass-content" style="max-width:420px;">
            <div class="modal-glass-header" style="height:80px;">
                <div class="modal-glass-header-bg"
                    style="background:linear-gradient(135deg, var(--pastel-mint), var(--pastel-sage), var(--pastel-sky));">
                </div>
                <div class="modal-glass-header-pattern"></div>
                <button class="modal-glass-close" onclick="closeRoleModal()"><i
                        class="fas fa-times"></i></button>
            </div>
            <div class="role-change-body">
                <div class="role-change-icon">
                    <span class="material-symbols-outlined" style="font-size:28px;">sync_alt</span>
                </div>
                <h3 class="role-change-title">Cambiar Rol</h3>
                <p class="role-change-text">Selecciona el nuevo rol para este usuario</p>
                <div class="role-change-current" id="roleCurrentBadge"></div>

                <form method="post" action="<%= ctx %>/admin/usuarios" id="roleForm">
                    <input type="hidden" name="action" value="cambiarRol">
                    <input type="hidden" name="id" id="roleUserId" value="${requestScope.usuario.id}">

                    <div class="role-options-glass">
                        <div class="role-option-glass admin">
                            <input type="radio" name="idrol" id="roleModalAdmin" value="1">
                            <label for="roleModalAdmin">
                                <div class="role-glass-icon"><i class="fas fa-shield-alt"></i></div>
                                <span class="role-glass-title">Administrador</span>
                                <span class="role-glass-desc">Control total</span>
                            </label>
                        </div>
                        <div class="role-option-glass buyer">
                            <input type="radio" name="idrol" id="roleModalBuyer" value="2">
                            <label for="roleModalBuyer">
                                <div class="role-glass-icon"><i class="fas fa-shopping-bag"></i></div>
                                <span class="role-glass-title">Comprador</span>
                                <span class="role-glass-desc">Puede comprar</span>
                            </label>
                        </div>
                        <div class="role-option-glass user">
                            <input type="radio" name="idrol" id="roleModalUser" value="3">
                            <label for="roleModalUser">
                                <div class="role-glass-icon"><i class="fas fa-user"></i></div>
                                <span class="role-glass-title">Usuario</span>
                                <span class="role-glass-desc">Acceso básico</span>
                            </label>
                        </div>
                    </div>

                    <div style="display:flex; gap:10px; justify-content:center;">
                        <button type="button" class="modal-glass-btn back"
                            onclick="closeRoleModal()">Cancelar</button>
                        <button type="submit" class="modal-glass-btn role" style="padding:10px 28px;">
                            <i class="fas fa-check"></i> Confirmar Cambio
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ==================== MODAL GLASSMORPHISM: ELIMINAR ==================== -->
    <div class="modal-glass-overlay" id="deleteModal">
        <div class="modal-glass-content" style="max-width:420px;">
            <div class="modal-glass-header" style="height:80px;">
                <div class="modal-glass-header-bg"
                    style="background:linear-gradient(135deg, var(--pastel-coral), #FECDD3, var(--pastel-cream));">
                </div>
                <div class="modal-glass-header-pattern"></div>
                <button class="modal-glass-close" onclick="closeDeleteModal()"><i
                        class="fas fa-times"></i></button>
            </div>
            <div class="delete-confirm-body">
                <div class="delete-confirm-icon">
                    <span class="material-symbols-outlined"
                        style="font-size:32px;">delete_forever</span>
                </div>
                <h3 class="delete-confirm-title">¿Eliminar usuario?</h3>
                <p class="delete-confirm-text">Esta acción no se puede deshacer. El usuario perderá todo
                    acceso al sistema.</p>
                <div class="delete-confirm-user" id="deleteUserName"></div>

                <form method="post" action="<%= ctx %>/admin/usuarios" id="deleteForm">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="id" id="deleteUserId" value="${requestScope.usuario.id}">

                    <div style="display:flex; gap:10px; justify-content:center;">
                        <button type="button" class="modal-glass-btn back"
                            onclick="closeDeleteModal()">Cancelar</button>
                        <button type="submit" class="modal-glass-btn delete" style="padding:10px 28px;">
                            <i class="fas fa-trash"></i> Eliminar Definitivamente
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // ── AVATAR PREVIEW ──
        function previewAvatar(input) {
            var previewImg = document.getElementById('previewImg');
            var previewPlaceholder = document.getElementById('previewPlaceholder');
            var avatarCard = document.getElementById('avatarUploadCard');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    previewImg.src = e.target.result;
                    previewImg.style.display = 'block';
                    if (previewPlaceholder) previewPlaceholder.style.display = 'none';
                    avatarCard.classList.add('has-image');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        // ── MODAL FUNCTIONS ──
        function openViewModal() {
            document.getElementById('viewModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function closeViewModal() {
            document.getElementById('viewModal').classList.remove('active');
            document.body.style.overflow = '';
        }
        function openRoleModal() {
            document.getElementById('roleModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function closeRoleModal() {
            document.getElementById('roleModal').classList.remove('active');
            document.body.style.overflow = '';
        }
        function openDeleteModal() {
            var userName = '<c:out value="${requestScope.usuario.nombre} ${requestScope.usuario.apellido}"/>';
            document.getElementById('deleteUserName').textContent = userName;
            document.getElementById('deleteModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            document.body.style.overflow = '';
        }

        function openRoleModalFromView() {
            closeViewModal();
            setTimeout(openRoleModal, 300);
        }
        function openDeleteModalFromView() {
            closeViewModal();
            setTimeout(openDeleteModal, 300);
        }

        // ── CLICK OUTSIDE TO CLOSE ──
        document.querySelectorAll('.modal-glass-overlay').forEach(function (overlay) {
            overlay.addEventListener('click', function (e) {
                if (e.target === overlay) {
                    overlay.classList.remove('active');
                    document.body.style.overflow = '';
                }
            });
        });

        // ── ESCAPE KEY ──
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal-glass-overlay.active').forEach(function (m) {
                    m.classList.remove('active');
                });
                document.body.style.overflow = '';
            }
        });

        // ── INIT ──
        document.addEventListener('DOMContentLoaded', function () {
            // Auto-dismiss toasts
            setTimeout(function () {
                document.querySelectorAll('.toast-item').forEach(function (t) {
                    t.style.transition = 'all 0.4s ease';
                    t.style.opacity = '0';
                    t.style.transform = 'translateX(120%)';
                    setTimeout(function () { if (t.parentNode) t.parentNode.removeChild(t); }, 400);
                });
            }, 4000);

            // Si viene de un click "ver" en la lista, abrir modal automáticamente
            var urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('ver') === 'modal') {
                openViewModal();
            }
        });
    </script>
</body>

                </html>