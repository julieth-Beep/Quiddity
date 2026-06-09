<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctx = request.getContextPath();
    Object usuario = session.getAttribute("usuario");
    String nombreUsuario = "Administrador";
    if (usuario != null) {
        try { nombreUsuario = (String) usuario.getClass().getMethod("getNombre").invoke(usuario); } catch (Exception e) { }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cat&aacute;logo Admin &mdash; Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
:root {
    --bg: #F8F9FA; --bg-soft: #FFFFFF; --surface: #FFFFFF;
    --text-primary: #1a1a2e; --text-secondary: #6c757d; --text-tertiary: #adb5bd;
    --border: #e9ecef; --border-light: #f1f3f5;
    --pastel-sky: #e3f2fd; --pastel-sky-dark: #bbdefb;
    --pastel-mint: #e8f5e9; --pastel-mint-dark: #c8e6c9;
    --pastel-lavender: #f3e5f5; --pastel-lavender-dark: #e1bee7;
    --pastel-cream: #fff3e0; --pastel-cream-dark: #ffe0b2;
    --pastel-coral: #fce4ec; --pastel-coral-dark: #f8bbd0;
    --accent-sky: #1976d2; --accent-mint: #388e3c; --accent-lavender: #7b1fa2;
    --accent-cream: #f57c00; --accent-coral: #c2185b;
    --radius-sm: 10px; --radius-md: 12px; --radius-lg: 14px;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.04);
    --shadow: 0 2px 8px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
    --primary:#9a3a5a; --primary-dark:#7a2e48;
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: var(--bg); color: var(--text-primary);
    -webkit-font-smoothing: antialiased; font-size: 13px; line-height: 1.4;
}
.material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 24; font-size: 18px; }

.layout-wrapper { display:flex; min-height:100vh; }
.main-content { flex:1; display:flex; flex-direction:column; min-height:100vh; overflow-x:hidden; padding: 20px 24px; }

/* ===== WELCOME ===== */
.welcome-section {
    margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;
    background: var(--surface); border-radius: var(--radius-lg); padding: 18px 24px;
    border: 1px solid var(--border); box-shadow: var(--shadow-sm);
}
.welcome-title { font-family: 'DM Sans', sans-serif; font-size: 24px; font-weight: 700; color: var(--text-primary); margin: 0 0 4px 0; }
.welcome-title span { color: var(--accent-sky); }
.welcome-subtitle { font-size: 13px; color: var(--text-secondary); font-weight: 500; margin: 0; }
.btn-new-user {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky)); border: none;
    color: var(--accent-lavender); padding: 12px 22px; border-radius: var(--radius-md);
    font-family: 'Plus Jakarta Sans', sans-serif; font-size: 13px; font-weight: 700;
    display: inline-flex; align-items: center; gap: 8px; cursor: pointer;
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.15); transition: all 0.3s;
}
.btn-new-user:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(139, 92, 246, 0.25); }

/* ===== STATS BAR ===== */
.stats-bar { display: grid; grid-template-columns: repeat(5, 1fr); gap: 14px; margin-bottom: 20px; }
.stat-item {
    background: var(--surface); border-radius: var(--radius-md); padding: 16px 18px;
    box-shadow: var(--shadow-sm); border: 1px solid var(--border-light);
    display: flex; align-items: center; gap: 12px; transition: all 0.3s;
}
.stat-item:hover { transform: translateY(-2px); box-shadow: var(--shadow); }
.stat-icon {
    width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center;
    font-size: 20px; flex-shrink: 0;
}
.stat-icon.primary { background: var(--pastel-coral); color: var(--accent-coral); }
.stat-icon.mint { background: var(--pastel-mint); color: var(--accent-mint); }
.stat-icon.cream { background: var(--pastel-cream); color: var(--accent-cream); }
.stat-icon.coral { background: var(--pastel-coral); color: var(--accent-coral); }
.stat-icon.lavender { background: var(--pastel-lavender); color: var(--accent-lavender); }
.stat-data h4 { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--text-primary); line-height: 1; margin-bottom: 4px; }
.stat-data p { font-size: 11px; font-weight: 600; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.05em; }

/* ===== CHIPS ===== */
.chips-section {
    background: var(--surface); border: 1px solid var(--border-light);
    border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 20px;
}
.chips-container { padding: 12px 16px; }
.chips-row { display: flex; gap: 8px; overflow-x: auto; scrollbar-width: none; }
.chips-row::-webkit-scrollbar { display: none; }
.cat-chip {
    display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px;
    border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 12px; font-weight: 600; letter-spacing: 0.04em; text-transform: uppercase;
    color: var(--text-secondary); cursor: pointer; transition: all 0.2s;
    background: var(--surface); white-space: nowrap; font-family: 'Plus Jakarta Sans', sans-serif;
}
.cat-chip:hover { border-color: var(--primary); color: var(--primary); background: var(--pastel-coral); }
.cat-chip.active {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    border-color: transparent; color: var(--accent-lavender);
    box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}

/* ===== TOOLBAR ===== */
.toolbar {
    display: flex; justify-content: space-between; align-items: center;
    padding: 14px 18px; background: var(--surface); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); box-shadow: var(--shadow-sm); margin-bottom: 20px;
}
.toolbar-left h2 { font-family: 'DM Sans', sans-serif; font-size: 16px; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; }
.toolbar-left p { font-size: 12px; color: var(--text-tertiary); font-weight: 600; }
.toolbar-right { display: flex; align-items: center; gap: 10px; }
.btn-action {
    display: inline-flex; align-items: center; gap: 6px; padding: 10px 18px;
    font-size: 12px; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.3s; text-decoration: none;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.btn-action.primary {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    color: var(--accent-lavender); box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}
.btn-action.primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(123, 31, 162, 0.25); }
.search-box { position: relative; width: 240px; }
.search-box input {
    width: 100%; padding: 10px 14px 10px 38px; border: 1.5px solid var(--border);
    border-radius: var(--radius-sm); font-size: 13px; font-weight: 500; color: var(--text-primary);
    background: var(--bg-soft); transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
}
.search-box input:focus { outline: none; border-color: var(--accent-sky); box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08); }
.search-box .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-tertiary); font-size: 16px; }
.filter-select {
    padding: 10px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 12px; font-weight: 600; color: var(--text-primary); background: var(--bg-soft);
    cursor: pointer; transition: all 0.2s; min-width: 140px; font-family: 'Plus Jakarta Sans', sans-serif;
}

/* ===== PRODUCT GRID - CARDS MAS PEQUEÑAS ===== */
.product-grid { 
    display: grid; 
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); 
    gap: 16px; 
}
.product-card {
    position: relative;
    background: var(--surface); border-radius: var(--radius-md);
    border: 1px solid var(--border-light); box-shadow: var(--shadow-sm);
    overflow: hidden; transition: all 0.3s ease;
    display: flex; flex-direction: column;
}
.product-card:hover { 
    transform: translateY(-4px); 
    box-shadow: var(--shadow-md); 
    border-color: var(--border); 
}

/* ===== IMAGEN - TAMAÑO FIJO PARA EVITAR CARGA INFINITA ===== */
.product-image { 
    width: 100%; 
    height: 220px; 
    min-height: 220px;
    max-height: 220px;
    overflow: hidden; 
    background: linear-gradient(135deg, #f5f5f5, #e8e8e8); 
    position: relative;
    flex-shrink: 0;
}
.product-image img { 
    width: 100%; 
    height: 100%; 
    object-fit: cover; 
    transition: transform 0.6s ease; 
    display: block;
}
.product-card:hover .product-image img { transform: scale(1.05); }

/* Placeholder cuando no hay imagen */
.product-image.no-image {
    display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
}
.product-image.no-image::after {
    content: 'image';
    font-family: 'Material Symbols Outlined';
    font-size: 48px;
    color: #ccc;
}

/* ===== BADGES ===== */
.product-badge {
    position: absolute; top: 8px; left: 8px; padding: 3px 8px;
    font-size: 9px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase;
    z-index: 2; border-radius: 6px;
}
.badge-low { background: var(--pastel-coral); color: var(--accent-coral); }
.badge-out { background: var(--text-primary); color: white; }
.badge-inactive { background: #6c757d; color: white; }

/* ===== STOCK INDICATOR ===== */
.stock-indicator {
    position: absolute; bottom: 8px; left: 8px; right: 8px;
    display: flex; align-items: center; gap: 6px; padding: 5px 8px;
    background: rgba(255,255,255,0.95); backdrop-filter: blur(8px);
    font-size: 10px; font-weight: 700; z-index: 2;
    border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
.stock-bar { flex: 1; height: 3px; background: var(--border-light); position: relative; border-radius: 2px; }
.stock-bar-fill { position: absolute; left: 0; top: 0; height: 100%; border-radius: 2px; }
.stock-bar-fill.high { background: var(--accent-mint); }
.stock-bar-fill.medium { background: var(--accent-cream); }
.stock-bar-fill.low { background: var(--accent-coral); }
.stock-bar-fill.out { background: var(--text-primary); width: 100% !important; }

/* ===== OVERLAY CRUD ===== */
.product-overlay {
    position: absolute; inset: 0; background: rgba(26, 26, 46, 0.85); backdrop-filter: blur(6px);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 10px; opacity: 0; transition: opacity 0.25s ease; z-index: 5;
    padding: 16px;
}
.product-card:hover .product-overlay { opacity: 1; }

.overlay-btn {
    display: flex; align-items: center; gap: 8px; padding: 10px 18px;
    font-size: 12px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase;
    border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease;
    width: 100%; max-width: 180px; justify-content: center;
    font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap;
}
.overlay-btn.edit { background: var(--surface); color: var(--text-primary); }
.overlay-btn.edit:hover { background: var(--pastel-sky); color: var(--accent-sky); }
.overlay-btn.stock-btn { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.25); }
.overlay-btn.stock-btn:hover { background: var(--surface); color: var(--text-primary); border-color: var(--surface); }
.overlay-btn.toggle-btn { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.25); }
.overlay-btn.toggle-btn:hover { background: var(--pastel-cream); color: var(--accent-cream); border-color: var(--pastel-cream); }
.overlay-btn.delete { background: rgba(255,255,255,0.15); color: var(--pastel-coral-dark); border: 1px solid var(--pastel-coral-dark); }
.overlay-btn.delete:hover { background: var(--accent-coral); color: white; border-color: var(--accent-coral); }

/* ===== INFO ===== */
.product-info { 
    display: flex; 
    justify-content: space-between; 
    align-items: flex-start; 
    padding: 14px; 
    flex: 1;
    min-height: 0;
}
.product-info-left { flex: 1; min-width: 0; }
.product-category { 
    font-size: 10px; 
    font-weight: 700; 
    color: var(--text-tertiary); 
    text-transform: uppercase; 
    letter-spacing: 0.08em; 
    margin-bottom: 4px; 
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.product-name { 
    font-family: 'DM Sans', sans-serif; 
    font-size: 14px; 
    font-weight: 700; 
    color: var(--text-primary); 
    line-height: 1.3; 
    margin-bottom: 4px; 
    white-space: nowrap; 
    overflow: hidden; 
    text-overflow: ellipsis; 
}
.product-marca { 
    font-size: 11px; 
    color: var(--text-tertiary); 
    margin-bottom: 6px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.product-price { 
    font-size: 15px; 
    font-weight: 800; 
    color: var(--accent-coral); 
}

/* ===== ACTIONS LATERALES ===== */
.product-actions { 
    display: flex; 
    flex-direction: column; 
    gap: 4px; 
    margin-left: 8px;
    flex-shrink: 0;
}
.action-btn-sm {
    width: 28px; height: 28px; border-radius: 7px; border: 1px solid var(--border-light);
    background: var(--bg-soft); display: flex; align-items: center; justify-content: center;
    cursor: pointer; transition: all 0.2s ease; color: var(--text-tertiary); font-size: 14px;
    padding: 0;
}
.action-btn-sm:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--pastel-sky-dark); transform: scale(1.1); }
.action-btn-sm.delete:hover { background: var(--pastel-coral); color: var(--accent-coral); border-color: var(--pastel-coral-dark); }
.action-btn-sm.toggle:hover { background: var(--pastel-cream); color: var(--accent-cream); border-color: var(--pastel-cream-dark); }

/* ===== MODALS ===== */
.modal-overlay {
    position: fixed; inset: 0; background: rgba(26, 26, 46, 0.6); backdrop-filter: blur(8px);
    z-index: 9998; display: none; align-items: center; justify-content: center;
    padding: 20px;
}
.modal-overlay.active { display: flex; }
.modal-content {
    background: var(--surface); max-width: 600px; width: 100%; max-height: 90vh; overflow-y: auto;
    box-shadow: var(--shadow-md); border-radius: var(--radius-lg);
    position: relative; border: 1px solid var(--border-light);
}
.modal-header { padding: 16px 20px; border-bottom: 1px solid var(--border-light); display: flex; justify-content: space-between; align-items: center; }
.modal-header h3 { font-family: 'DM Sans', sans-serif; font-size: 16px; font-weight: 700; color: var(--text-primary); }
.modal-close {
    width: 32px; height: 32px; border-radius: 8px; border: 1px solid var(--border-light);
    background: var(--bg-soft); cursor: pointer; display: flex; align-items: center; justify-content: center;
    transition: all 0.2s; color: var(--text-tertiary);
}
.modal-close:hover { background: var(--pastel-coral); color: var(--accent-coral); transform: rotate(90deg); }
.modal-body { padding: 20px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.form-group { display: flex; flex-direction: column; gap: 5px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-group label { font-size: 11px; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; }
.form-group input, .form-group select, .form-group textarea {
    padding: 10px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm);
    font-size: 13px; font-weight: 500; color: var(--text-primary); background: var(--bg-soft);
    transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
    outline: none; border-color: var(--accent-sky); box-shadow: 0 0 0 4px rgba(25, 118, 210, 0.08);
}
.form-group textarea { resize: vertical; min-height: 80px; }
.image-preview {
    width: 100%; height: 160px; background: var(--bg); display: flex; align-items: center; justify-content: center;
    color: var(--text-tertiary); font-size: 13px; overflow: hidden; margin-top: 6px;
    border-radius: var(--radius-sm); border: 1px dashed var(--border);
}
.image-preview img { width: 100%; height: 100%; object-fit: cover; }
.modal-footer { padding: 14px 20px; border-top: 1px solid var(--border-light); display: flex; justify-content: flex-end; gap: 10px; }
.btn-modal {
    padding: 10px 20px; font-size: 12px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase;
    border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.3s;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.btn-modal.cancel { background: var(--bg-soft); color: var(--text-primary); border: 1px solid var(--border); }
.btn-modal.save {
    background: linear-gradient(135deg, var(--pastel-lavender), var(--pastel-sky));
    color: var(--accent-lavender); box-shadow: 0 4px 12px rgba(123, 31, 162, 0.15);
}
.btn-modal.danger {
    background: linear-gradient(135deg, var(--pastel-coral), #ffab91);
    color: var(--accent-coral);
}

/* ===== STOCK MODAL ===== */
.stock-edit { display: flex; align-items: center; gap: 10px; justify-content: center; }
.stock-edit input {
    width: 80px; padding: 12px; border: 2px solid var(--accent-sky); border-radius: var(--radius-sm);
    font-size: 18px; font-weight: 700; text-align: center; color: var(--accent-sky); background: var(--bg-soft);
    font-family: 'DM Sans', sans-serif;
}
.stock-adjust-btn {
    width: 40px; height: 40px; border-radius: 50%; border: 1.5px solid var(--border);
    background: var(--bg-soft); cursor: pointer; display: flex; align-items: center; justify-content: center;
    transition: all 0.2s; color: var(--text-secondary);
}
.stock-adjust-btn:hover { background: var(--pastel-sky); color: var(--accent-sky); border-color: var(--accent-sky); }

/* ===== TOAST ===== */
.toast-container { position: fixed; top: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; }
.toast-item {
    background: var(--surface); border: 1px solid var(--border-light); border-radius: var(--radius-md);
    padding: 14px 18px; display: flex; align-items: center; gap: 12px;
    box-shadow: var(--shadow-md); font-size: 13px; font-weight: 600; min-width: 300px;
    border-left: 4px solid var(--accent-sky); font-family: 'Plus Jakarta Sans', sans-serif;
    animation: slideInToast 0.4s ease;
}
.toast-item.success { border-left-color: var(--accent-mint); color: var(--accent-mint); }
.toast-item.error { border-left-color: var(--accent-coral); color: var(--accent-coral); }
@keyframes slideInToast { from{transform:translateX(120%); opacity:0;} to{transform:translateX(0); opacity:1;} }
.toast-icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; }
.toast-item.success .toast-icon { background: var(--pastel-mint); }
.toast-item.error .toast-icon { background: var(--pastel-coral); }

/* ===== EMPTY STATE ===== */
.empty-state {
    text-align: center; padding: 60px 40px; grid-column: 1 / -1;
    background: var(--surface); border-radius: var(--radius-md); border: 1px dashed var(--border);
}
.empty-state-icon {
    width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%;
    background: linear-gradient(135deg, var(--pastel-coral), var(--pastel-lavender));
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-coral); font-size: 28px;
}
.empty-state h4 { font-family: 'DM Sans', sans-serif; font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 6px; }
.empty-state p { font-size: 13px; color: var(--text-secondary); margin-bottom: 16px; }

/* ===== RESPONSIVE ===== */
@media (max-width:1200px) { .product-grid { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); } .stats-bar { grid-template-columns: repeat(3, 1fr); } }
@media (max-width:768px) { 
    .product-grid { grid-template-columns: repeat(2, 1fr); } 
    .stats-bar { grid-template-columns: repeat(2, 1fr); } 
    .main-content { padding: 12px 16px; }
    .toolbar { flex-direction: column; gap: 12px; align-items: stretch; }
    .search-box { width: 100%; }
}
@media (max-width:480px) { .product-grid { grid-template-columns: 1fr; } .stats-bar { grid-template-columns: 1fr; } }
</style>
</head>
<body>

<!-- TOASTS -->
<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.exito}">
        <div class="toast-item success">
            <div class="toast-icon"><i class="fas fa-check"></i></div>
            <span>${param.exito}</span>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error">
            <div class="toast-icon"><i class="fas fa-exclamation"></i></div>
            <span>${param.error}</span>
        </div>
    </c:if>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content">

        <!-- Welcome -->
        <div class="welcome-section">
            <div>
                <h1 class="welcome-title">Cat&aacute;logo <span>Admin</span></h1>
                <p class="welcome-subtitle">Administra todos los productos del sistema Quiddity</p>
            </div>
            <button class="btn-new-user" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Nuevo Producto
            </button>
        </div>

        <!-- Stats -->
        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-icon primary"><span class="material-symbols-outlined">inventory_2</span></div>
                <div class="stat-data">
                    <h4>${totalProductos != null ? totalProductos : '0'}</h4>
                    <p>Total Productos</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon mint"><span class="material-symbols-outlined">trending_up</span></div>
                <div class="stat-data">
                    <h4>${productosActivos != null ? productosActivos : '0'}</h4>
                    <p>Activos</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon cream"><span class="material-symbols-outlined">warning</span></div>
                <div class="stat-data">
                    <h4>${productosBajoStock != null ? productosBajoStock : '0'}</h4>
                    <p>Bajo Stock</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon coral"><span class="material-symbols-outlined">block</span></div>
                <div class="stat-data">
                    <h4>${productosSinStock != null ? productosSinStock : '0'}</h4>
                    <p>Sin Stock</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon lavender"><span class="material-symbols-outlined">payments</span></div>
                <div class="stat-data">
                    <h4><fmt:formatNumber value="${ingresosTotales != null ? ingresosTotales : 0}" type="currency" currencySymbol="$" maxFractionDigits="0"/></h4>
                    <p>Ingresos Totales</p>
                </div>
            </div>
        </div>

        <!-- Chips -->
        <div class="chips-section">
            <div class="chips-container">
                <div class="chips-row" id="catRow">
                    <button class="cat-chip active" data-cat="all" onclick="filterByCategory('all')">
                        <span class="material-symbols-outlined" style="font-size:16px;">auto_awesome</span> Todos
                    </button>
                    <button class="cat-chip" data-cat="belleza" onclick="filterByCategory('belleza')">
                        <span class="material-symbols-outlined" style="font-size:16px;">face_retouching_natural</span> Belleza
                    </button>
                    <button class="cat-chip" data-cat="cuidado" onclick="filterByCategory('cuidado')">
                        <span class="material-symbols-outlined" style="font-size:16px;">spa</span> Cuidado
                    </button>
                    <button class="cat-chip" data-cat="perfumes" onclick="filterByCategory('perfumes')">
                        <span class="material-symbols-outlined" style="font-size:16px;">water_drop</span> Perfumes
                    </button>
                    <button class="cat-chip" data-cat="cabello" onclick="filterByCategory('cabello')">
                        <span class="material-symbols-outlined" style="font-size:16px;">self_improvement</span> Cabello
                    </button>
                </div>
            </div>
        </div>

        <!-- Toolbar -->
        <div class="toolbar">
            <div class="toolbar-left">
                <h2 id="sectionTitle">Todos los Productos</h2>
                <p id="productCount">${productos != null ? productos.size() : '0'} productos</p>
            </div>
            <div class="toolbar-right">
                <div class="search-box">
                    <span class="material-symbols-outlined search-icon">search</span>
                    <input type="text" id="searchInput" placeholder="Buscar producto..." onkeyup="searchProducts()">
                </div>
                <select class="filter-select" id="statusFilter" onchange="filterByStatus()">
                    <option value="">Todos los estados</option>
                    <option value="activo">Activo</option>
                    <option value="inactivo">Inactivo</option>
                    <option value="bajo_stock">Bajo Stock</option>
                    <option value="sin_stock">Sin Stock</option>
                </select>
                <select class="filter-select" id="sortFilter" onchange="sortProducts()">
                    <option value="nombre">Ordenar por</option>
                    <option value="nombre_asc">Nombre A-Z</option>
                    <option value="nombre_desc">Nombre Z-A</option>
                    <option value="precio_asc">Precio &uarr;</option>
                    <option value="precio_desc">Precio &darr;</option>
                    <option value="stock_asc">Stock &uarr;</option>
                    <option value="stock_desc">Stock &darr;</option>
                </select>
                <button class="btn-action primary" onclick="openAddModal()">
                    <span class="material-symbols-outlined" style="font-size:18px;">add</span> Nuevo
                </button>
            </div>
        </div>

        <!-- Product Grid -->
        <div class="product-grid" id="productGrid">
            <c:choose>
                <c:when test="${empty productos}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <span class="material-symbols-outlined" style="font-size:32px;">inventory_2</span>
                        </div>
                        <h4>No hay productos registrados</h4>
                        <p>Comienza agregando tu primer producto al cat&aacute;logo.</p>
                        <button class="btn-action primary" onclick="openAddModal()" style="margin-top:12px;">
                            <span class="material-symbols-outlined" style="font-size:18px;">add</span> Agregar Producto
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${productos}" varStatus="status">
                        <div class="product-card"
                             data-id="${p.id}"
                             data-categoria="${p.categoria}"
                             data-marca="${p.marca}"
                             data-nombre="${p.nombre}"
                             data-descripcion="${p.descripcion}"
                             data-componentes="${p.componentes}"
                             data-precio="${p.precio}"
                             data-stock="${p.stock}"
                             data-activo="${p.activo}">

                            <div class="product-image">
                                <!-- IMAGEN DESDE RUTA COMPLETA DE BD -->
                                <c:choose>
                                    <c:when test="${not empty p.imagen}">
                                        <img src="${ctx}/${p.imagen}" 
                                             alt="${fn:escapeXml(p.nombre)}" 
                                             onerror="this.parentElement.classList.add('no-image'); this.style.display='none';">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#f0f0f0,#e0e0e0);">
                                            <span class="material-symbols-outlined" style="font-size:40px;color:#ccc;">image</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${!p.activo}"><span class="product-badge badge-inactive">Inactivo</span></c:if>
                                <c:if test="${p.activo && p.stock == 0}"><span class="product-badge badge-out">Sin Stock</span></c:if>
                                <c:if test="${p.activo && p.stock > 0 && p.stock < 10}"><span class="product-badge badge-low">Stock Bajo</span></c:if>

                                <div class="stock-indicator">
                                    <span style="font-size:10px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:0.04em;">Stock: ${p.stock}</span>
                                    <div class="stock-bar">
                                        <div class="stock-bar-fill ${p.stock == 0 ? 'out' : (p.stock < 10 ? 'low' : (p.stock < 50 ? 'medium' : 'high'))}"
                                             style="width: ${p.stock > 100 ? 100 : p.stock}%"></div>
                                    </div>
                                </div>

                                <!-- OVERLAY CRUD -->
                                <div class="product-overlay">
                                    <button class="overlay-btn edit" onclick="event.stopPropagation(); openEditModal(${p.id})">
                                        <span class="material-symbols-outlined" style="font-size:16px;">edit</span> Editar
                                    </button>
                                    <button class="overlay-btn stock-btn" onclick="event.stopPropagation(); openStockModal(${p.id}, ${p.stock})">
                                        <span class="material-symbols-outlined" style="font-size:16px;">inventory</span> Stock
                                    </button>
                                    <button class="overlay-btn toggle-btn" onclick="event.stopPropagation(); toggleActivo(${p.id})">
                                        <span class="material-symbols-outlined" style="font-size:16px;">${p.activo ? 'visibility_off' : 'visibility'}</span> ${p.activo ? 'Desactivar' : 'Activar'}
                                    </button>
                                    <button class="overlay-btn delete" onclick="event.stopPropagation(); confirmDelete(${p.id}, '${fn:escapeXml(p.nombre)}')">
                                        <span class="material-symbols-outlined" style="font-size:16px;">delete</span> Eliminar
                                    </button>
                                </div>
                            </div>

                            <div class="product-info">
                                <div class="product-info-left">
                                    <p class="product-category">${p.categoria}${not empty p.marca ? ' &mdash; '.concat(p.marca) : ''}</p>
                                    <h4 class="product-name">${p.nombre}</h4>
                                    <p class="product-marca">${not empty p.marca ? p.marca : '&nbsp;'}</p>
                                    <p class="product-price"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- MODAL: Agregar Producto -->
        <div class="modal-overlay" id="addModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Nuevo Producto</h3>
                    <button class="modal-close" onclick="closeModal('addModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <form action="${ctx}/admin/catalogo" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="accion" value="agregar">
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label>Nombre *</label>
                                <input type="text" name="nombre" required placeholder="Ej: Serum Vitamina C">
                            </div>
                            <div class="form-group full-width">
                                <label>Descripci&oacute;n</label>
                                <textarea name="descripcion" rows="3" placeholder="Descripci&oacute;n detallada..."></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label>Componentes</label>
                                <textarea name="componentes" rows="2" placeholder="Ingredientes..."></textarea>
                            </div>
                            <div class="form-group">
                                <label>Categor&iacute;a *</label>
                                <select name="categoria" required>
                                    <option value="">Seleccionar...</option>
                                    <option value="Belleza">Belleza</option>
                                    <option value="Cuidado Facial">Cuidado Facial</option>
                                    <option value="Cuidado Corporal">Cuidado Corporal</option>
                                    <option value="Perfumes">Perfumes</option>
                                    <option value="Cabello">Cabello</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Marca</label>
                                <input type="text" name="marca" placeholder="Ej: Quiddity">
                            </div>
                            <div class="form-group">
                                <label>Precio *</label>
                                <input type="number" name="precio" required min="0" step="0.01" placeholder="0.00">
                            </div>
                            <div class="form-group">
                                <label>Stock Inicial *</label>
                                <input type="number" name="stock" required min="0" placeholder="0">
                            </div>
                            <div class="form-group full-width">
                                <label>Imagen *</label>
                                <input type="file" name="imagen" accept="image/jpeg,image/png,image/gif" required onchange="previewImage(this, 'addPreview')">
                                <div class="image-preview" id="addPreview">
                                    <span style="display:flex;align-items:center;gap:6px;">
                                        <span class="material-symbols-outlined" style="font-size:24px;">image</span>
                                        Vista previa
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('addModal')">Cancelar</button>
                        <button type="submit" class="btn-modal save">Guardar Producto</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL: Editar Producto -->
        <div class="modal-overlay" id="editModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Editar Producto</h3>
                    <button class="modal-close" onclick="closeModal('editModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <form action="${ctx}/admin/catalogo" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="id" id="editId">
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label>Nombre *</label>
                                <input type="text" name="nombre" id="editNombre" required>
                            </div>
                            <div class="form-group full-width">
                                <label>Descripci&oacute;n</label>
                                <textarea name="descripcion" id="editDescripcion" rows="3"></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label>Componentes</label>
                                <textarea name="componentes" id="editComponentes" rows="2"></textarea>
                            </div>
                            <div class="form-group">
                                <label>Categor&iacute;a *</label>
                                <select name="categoria" id="editCategoria" required>
                                    <option value="">Seleccionar...</option>
                                    <option value="Belleza">Belleza</option>
                                    <option value="Cuidado Facial">Cuidado Facial</option>
                                    <option value="Cuidado Corporal">Cuidado Corporal</option>
                                    <option value="Perfumes">Perfumes</option>
                                    <option value="Cabello">Cabello</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Marca</label>
                                <input type="text" name="marca" id="editMarca">
                            </div>
                            <div class="form-group">
                                <label>Precio *</label>
                                <input type="number" name="precio" id="editPrecio" required min="0" step="0.01">
                            </div>
                            <div class="form-group">
                                <label>Stock *</label>
                                <input type="number" name="stock" id="editStock" required min="0">
                            </div>
                            <div class="form-group full-width">
                                <label>Cambiar Imagen (opcional)</label>
                                <input type="file" name="imagen" accept="image/jpeg,image/png,image/gif" onchange="previewImage(this, 'editPreview')">
                                <div class="image-preview" id="editPreview">
                                    <span style="display:flex;align-items:center;gap:6px;">
                                        <span class="material-symbols-outlined" style="font-size:24px;">image</span>
                                        Imagen actual se mantendr&aacute;
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('editModal')">Cancelar</button>
                        <button type="submit" class="btn-modal save">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL: Stock -->
        <div class="modal-overlay" id="stockModal">
            <div class="modal-content" style="max-width:380px;">
                <div class="modal-header">
                    <h3>Gestionar Stock</h3>
                    <button class="modal-close" onclick="closeModal('stockModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <form action="${ctx}/admin/catalogo" method="POST">
                    <input type="hidden" name="accion" value="stock">
                    <input type="hidden" name="id" id="stockId">
                    <input type="hidden" name="operacion" value="set">
                    <div class="modal-body" style="text-align:center;padding:30px 20px;">
                        <p style="font-size:13px;color:var(--text-secondary);margin-bottom:20px;">Ajusta la cantidad de stock</p>
                        <div class="stock-edit">
                            <button type="button" class="stock-adjust-btn" onclick="adjustStock(-1)">
                                <span class="material-symbols-outlined">remove</span>
                            </button>
                            <input type="number" name="stock" id="stockInput" required min="0" value="0">
                            <button type="button" class="stock-adjust-btn" onclick="adjustStock(1)">
                                <span class="material-symbols-outlined">add</span>
                            </button>
                        </div>
                        <p id="stockMessage" style="font-size:12px;margin-top:16px;font-weight:600;"></p>
                    </div>
                    <div class="modal-footer" style="justify-content:center;">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('stockModal')">Cancelar</button>
                        <button type="submit" class="btn-modal save">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL: Eliminar -->
        <div class="modal-overlay" id="deleteModal">
            <div class="modal-content" style="max-width:400px;">
                <div class="modal-header">
                    <h3>Confirmar Eliminaci&oacute;n</h3>
                    <button class="modal-close" onclick="closeModal('deleteModal')"><span class="material-symbols-outlined">close</span></button>
                </div>
                <div class="modal-body" style="text-align:center;padding:24px;">
                    <div style="width:56px;height:56px;border-radius:50%;background:var(--pastel-coral);display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                        <span class="material-symbols-outlined" style="font-size:26px;color:var(--accent-coral);">delete_forever</span>
                    </div>
                    <p style="font-size:13px;color:var(--text-secondary);margin-bottom:6px;">&iquest;Eliminar este producto?</p>
                    <p id="deleteProductName" style="font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;color:var(--text-primary);margin-bottom:16px;"></p>
                    <div style="display:flex;gap:10px;justify-content:center;">
                        <label style="display:flex;align-items:center;gap:6px;font-size:12px;cursor:pointer;padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);background:var(--bg-soft);font-weight:600;">
                            <input type="radio" name="deleteTypeRadio" value="soft" checked style="accent-color:var(--accent-sky);">
                            <span>Desactivar</span>
                        </label>
                        <label style="display:flex;align-items:center;gap:6px;font-size:12px;cursor:pointer;padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);background:var(--bg-soft);font-weight:600;">
                            <input type="radio" name="deleteTypeRadio" value="hard" style="accent-color:var(--accent-coral);">
                            <span style="color:var(--accent-coral);">Eliminar</span>
                        </label>
                    </div>
                </div>
                <form action="${ctx}/admin/catalogo" method="POST" id="deleteForm" style="margin:0;">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="id" id="deleteId">
                    <input type="hidden" name="deleteType" id="deleteTypeInput" value="soft">
                    <div class="modal-footer" style="justify-content:center;padding-bottom:20px;">
                        <button type="button" class="btn-modal cancel" onclick="closeModal('deleteModal')">Cancelar</button>
                        <button type="submit" class="btn-modal danger">Confirmar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Form Toggle Activo -->
        <form id="toggleForm" action="${ctx}/admin/catalogo" method="POST" style="display:none;">
            <input type="hidden" name="accion" value="toggleActivo">
            <input type="hidden" name="id" id="toggleId">
        </form>

    </main>
</div>

<script>
let activeCat = 'all', activeStatus = '', activeSort = 'nombre', searchTerm = '';

function filterByCategory(cat) {
    activeCat = cat;
    document.querySelectorAll('.cat-chip').forEach(c => c.classList.remove('active'));
    document.querySelector(`[data-cat="${cat}"]`).classList.add('active');
    const titles = { 'all': 'Todos los Productos', 'belleza': 'Belleza', 'cuidado': 'Cuidado', 'perfumes': 'Perfumes', 'cabello': 'Cabello' };
    document.getElementById('sectionTitle').textContent = titles[cat] || 'Productos';
    applyFilters();
}

function filterByStatus() { activeStatus = document.getElementById('statusFilter').value; applyFilters(); }
function sortProducts() { activeSort = document.getElementById('sortFilter').value; applyFilters(); }
function searchProducts() { searchTerm = document.getElementById('searchInput').value.toLowerCase().trim(); applyFilters(); }

function applyFilters() {
    const cards = document.querySelectorAll('.product-card');
    let visible = 0;
    cards.forEach(card => {
        const cat = (card.dataset.categoria || '').toLowerCase();
        const nombre = (card.dataset.nombre || '').toLowerCase();
        const stock = parseInt(card.dataset.stock) || 0;
        const activo = card.dataset.activo === 'true';

        let show = true;
        if (activeCat !== 'all' && !cat.includes(activeCat)) show = false;

        if (activeStatus && show) {
            if (activeStatus === 'bajo_stock' && (stock >= 10 || stock === 0)) show = false;
            else if (activeStatus === 'sin_stock' && stock > 0) show = false;
            else if (activeStatus === 'activo' && !activo) show = false;
            else if (activeStatus === 'inactivo' && activo) show = false;
        }
        if (searchTerm && show) show = nombre.includes(searchTerm);
        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    document.getElementById('productCount').textContent = visible + ' producto' + (visible !== 1 ? 's' : '');
    sortVisibleCards();
}

function sortVisibleCards() {
    const grid = document.getElementById('productGrid');
    const cards = Array.from(grid.querySelectorAll('.product-card')).filter(c => c.style.display !== 'none');
    cards.sort((a, b) => {
        switch(activeSort) {
            case 'nombre_asc': return (a.dataset.nombre || '').localeCompare(b.dataset.nombre || '');
            case 'nombre_desc': return (b.dataset.nombre || '').localeCompare(a.dataset.nombre || '');
            case 'precio_asc': return parseFloat(a.dataset.precio || 0) - parseFloat(b.dataset.precio || 0);
            case 'precio_desc': return parseFloat(b.dataset.precio || 0) - parseFloat(a.dataset.precio || 0);
            case 'stock_asc': return parseInt(a.dataset.stock || 0) - parseInt(b.dataset.stock || 0);
            case 'stock_desc': return parseInt(b.dataset.stock || 0) - parseInt(a.dataset.stock || 0);
            default: return 0;
        }
    });
    cards.forEach(card => grid.appendChild(card));
}

// MODALS
function openAddModal() { 
    document.getElementById('addModal').classList.add('active'); 
    document.body.style.overflow = 'hidden'; 
}

function openEditModal(id) {
    const card = document.querySelector(`[data-id="${id}"]`);
    if (!card) return;
    document.getElementById('editId').value = id;
    document.getElementById('editNombre').value = card.dataset.nombre || '';
    document.getElementById('editDescripcion').value = card.dataset.descripcion || '';
    document.getElementById('editComponentes').value = card.dataset.componentes || '';
    document.getElementById('editPrecio').value = card.dataset.precio || '';
    document.getElementById('editStock').value = card.dataset.stock || '';
    document.getElementById('editCategoria').value = card.dataset.categoria || '';
    document.getElementById('editMarca').value = card.dataset.marca || '';

    const editPreview = document.getElementById('editPreview');
    const img = card.querySelector('.product-image img');
    if (img && img.src && !img.src.includes('undefined')) {
        editPreview.innerHTML = `<img src="${img.src}" alt="Preview">`;
    } else {
        editPreview.innerHTML = '<span style="display:flex;align-items:center;gap:6px;"><span class="material-symbols-outlined" style="font-size:24px;">image</span>Imagen actual se mantendr&aacute;</span>';
    }

    document.getElementById('editModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function openStockModal(id, currentStock) {
    document.getElementById('stockId').value = id;
    document.getElementById('stockInput').value = currentStock;
    updateStockMessage(currentStock);
    document.getElementById('stockModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function adjustStock(delta) {
    const input = document.getElementById('stockInput');
    let val = parseInt(input.value || 0) + delta;
    if (val < 0) val = 0;
    input.value = val;
    updateStockMessage(val);
}

function updateStockMessage(stock) {
    const msg = document.getElementById('stockMessage');
    if (stock == 0) { msg.textContent = '⚠️ Sin stock'; msg.style.color = 'var(--accent-coral)'; }
    else if (stock < 10) { msg.textContent = '⚠️ Stock bajo'; msg.style.color = 'var(--accent-cream)'; }
    else { msg.textContent = '✓ Stock OK'; msg.style.color = 'var(--accent-mint)'; }
}

function confirmDelete(id, name) {
    document.getElementById('deleteId').value = id;
    document.getElementById('deleteProductName').textContent = name;
    document.getElementById('deleteModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function toggleActivo(id) {
    if (confirm('¿Cambiar estado de este producto?')) {
        document.getElementById('toggleId').value = id;
        document.getElementById('toggleForm').submit();
    }
}

// Delete type radio
const deleteRadios = document.querySelectorAll('input[name="deleteTypeRadio"]');
deleteRadios.forEach(radio => {
    radio.addEventListener('change', function() { 
        document.getElementById('deleteTypeInput').value = this.value; 
    });
});

function closeModal(modalId) { 
    document.getElementById(modalId).classList.remove('active'); 
    document.body.style.overflow = ''; 
}

document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', (e) => { if (e.target === overlay) closeModal(overlay.id); });
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') document.querySelectorAll('.modal-overlay.active').forEach(m => closeModal(m.id));
});

// Image preview
function previewImage(input, previewId) {
    const preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) { preview.innerHTML = `<img src="${e.target.result}" alt="Preview">`; };
        reader.readAsDataURL(input.files[0]);
    }
}

// Toast auto-hide
setTimeout(() => {
    document.querySelectorAll('.toast-item').forEach(t => {
        t.style.transition = 'all 0.4s ease';
        t.style.opacity = '0'; t.style.transform = 'translateX(120%)';
        setTimeout(() => t.remove(), 400);
    });
}, 4000);

// Init
document.addEventListener('DOMContentLoaded', function() {
    applyFilters();
});
</script>
</body>
</html>