<%@ page import="java.util.*, java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    Map<String, Integer> conteo = (Map<String, Integer>) request.getAttribute("conteoPorEstado");
    int totalPedidos = 0, pendientes = 0, confirmados = 0, enProceso = 0, enviados = 0, entregados = 0, cancelados = 0, devueltos = 0;
    if (conteo != null) {
        for (Map.Entry<String, Integer> e : conteo.entrySet()) {
            totalPedidos += e.getValue();
            String k = e.getKey().toUpperCase();
            if (k.equals("PENDIENTE")) pendientes = e.getValue();
            else if (k.equals("CONFIRMADO")) confirmados = e.getValue();
            else if (k.equals("EN_PROCESO")) enProceso = e.getValue();
            else if (k.equals("ENVIADO")) enviados = e.getValue();
            else if (k.equals("ENTREGADO")) entregados = e.getValue();
            else if (k.equals("CANCELADO")) cancelados = e.getValue();
            else if (k.equals("DEVUELTO")) devueltos = e.getValue();
        }
    }
    List pedidos = (List) request.getAttribute("pedidos");
    int count = pedidos != null ? pedidos.size() : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pedidos — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,300,0,0" />
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">


<style>
:root {
    --bg:#F8F9FA; --bg-soft:#FFFFFF; --surface:#FFFFFF;
    --text-primary:#1a1a2e; --text-secondary:#6c757d; --text-tertiary:#adb5bd;
    --border:#e9ecef; --border-light:#f1f3f5;
    --pastel-sky:#e3f2fd; --pastel-sky-dark:#bbdefb;
    --pastel-mint:#e8f5e9; --pastel-mint-dark:#c8e6c9;
    --pastel-lavender:#f3e5f5; --pastel-lavender-dark:#e1bee7;
    --pastel-cream:#fff3e0; --pastel-cream-dark:#ffe0b2;
    --pastel-coral:#fce4ec; --pastel-coral-dark:#f8bbd0;
    --pastel-sage:#e8f5e9; --pastel-sage-dark:#c8e6c9;
    --accent-sky:#1976d2; --accent-mint:#388e3c; --accent-lavender:#7b1fa2;
    --accent-cream:#f57c00; --accent-coral:#c2185b; --accent-sage:#2e7d32;
    --radius-sm:12px; --radius-md:14px; --radius-lg:16px;
    --shadow-sm:0 1px 3px rgba(0,0,0,0.04);
    --shadow:0 2px 8px rgba(0,0,0,0.06);
    --shadow-md:0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg:0 8px 32px rgba(0,0,0,0.12);
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family:'Plus Jakarta Sans',sans-serif;
    background:var(--bg); color:var(--text-primary);
    font-size:12px; line-height:1.4; -webkit-font-smoothing:antialiased;
}
.material-symbols-rounded { font-variation-settings:'FILL'0,'wght'400,'GRAD'0,'opsz'24; vertical-align:middle; font-size:18px; }
::-webkit-scrollbar { width:4px; }
::-webkit-scrollbar-track { background:transparent; }
::-webkit-scrollbar-thumb { background:var(--border); border-radius:2px; }

/* ══ LAYOUT ══ */
.layout-wrapper { display:flex; min-height:100vh; }
.main-content { flex:1; display:flex; flex-direction:column; min-height:100vh; overflow-x:hidden; padding: 16px 20px; gap: 12px; }

/* WELCOME */
.welcome-section {
    display:flex; align-items:center; justify-content:space-between;
    background:var(--surface); border-radius:var(--radius-lg); padding:16px 20px;
    border:1px solid var(--border); box-shadow:var(--shadow-sm);
    animation:fadeUp 0.5s ease forwards; opacity:0;
}
.welcome-title { font-family:'DM Sans',sans-serif; font-size:22px; font-weight:700; margin:0 0 3px; letter-spacing:-0.3px; }
.welcome-title span { color:var(--accent-sky); }
.welcome-subtitle { font-size:12px; color:var(--text-secondary); font-weight:500; margin:0; }

/* STATS BAR */
.stats-bar { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; }
.stat-item {
    background:var(--surface); border-radius:var(--radius-md); padding:14px 16px;
    box-shadow:var(--shadow-sm); border:1px solid var(--border-light);
    transition:all 0.3s ease; position:relative; overflow:hidden; cursor:pointer;
    display:flex; align-items:center; gap:12px;
}
.stat-item:hover { transform:translateY(-3px); box-shadow:var(--shadow); }
.stat-item::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; transform:scaleX(0); transform-origin:left; transition:transform 0.3s ease; }
.stat-item:hover::before { transform:scaleX(1); }
.stat-item.total::before { background:var(--accent-lavender); }
.stat-item.pendiente::before { background:var(--accent-cream); }
.stat-item.confirmado::before { background:var(--accent-sky); }
.stat-item.proceso::before { background:var(--accent-lavender); }
.stat-item.enviado::before { background:var(--accent-mint); }
.stat-item.entregado::before { background:var(--accent-sage); }
.stat-item.cancelado::before { background:var(--accent-coral); }
.stat-item.devuelto::before { background:var(--accent-coral); }

.stat-icon { width:40px; height:40px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:18px; flex-shrink:0; transition:all 0.3s ease; }
.stat-item:hover .stat-icon { transform:scale(1.1); }
.stat-icon.total { background:var(--pastel-lavender); color:var(--accent-lavender); }
.stat-icon.pendiente { background:var(--pastel-cream); color:var(--accent-cream); }
.stat-icon.confirmado { background:var(--pastel-sky); color:var(--accent-sky); }
.stat-icon.proceso { background:var(--pastel-lavender); color:var(--accent-lavender); }
.stat-icon.enviado { background:var(--pastel-mint); color:var(--accent-mint); }
.stat-icon.entregado { background:var(--pastel-sage); color:var(--accent-sage); }
.stat-icon.cancelado { background:var(--pastel-coral); color:var(--accent-coral); }
.stat-icon.devuelto { background:var(--pastel-coral); color:var(--accent-coral); }

.stat-data h4 { font-family:'DM Sans',sans-serif; font-size:22px; font-weight:700; line-height:1; margin-bottom:3px; letter-spacing:-0.5px; }
.stat-data p { font-size:9px; font-weight:700; color:var(--text-secondary); text-transform:uppercase; letter-spacing:0.06em; }

/* TOOLBAR */
.toolbar {
    display:flex; justify-content:space-between; align-items:center; gap:12px;
    padding:12px 16px; background:var(--surface); border-radius:var(--radius-md);
    border:1px solid var(--border-light); box-shadow:var(--shadow-sm); flex-wrap:wrap;
}
.toolbar-left { display:flex; align-items:center; gap:16px; flex:1; }
.toolbar-title-group h2 { font-family:'DM Sans',sans-serif; font-size:16px; font-weight:700; margin-bottom:2px; letter-spacing:-0.3px; }
.toolbar-title-group p { font-size:11px; color:var(--text-tertiary); font-weight:600; }
.toolbar-right { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }

.search-box { position:relative; width:220px; }
.search-box input {
    width:100%; padding:10px 14px 10px 38px; border:1.5px solid var(--border);
    border-radius:var(--radius-sm); font-size:12px; font-weight:500; color:var(--text-primary);
    background:var(--bg-soft); transition:all 0.2s; font-family:'Plus Jakarta Sans',sans-serif;
}
.search-box input:focus { outline:none; border-color:var(--accent-sky); box-shadow:0 0 0 4px rgba(25,118,210,0.08); }
.search-box input::placeholder { color:var(--text-tertiary); }
.search-box .search-icon { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:var(--text-tertiary); font-size:16px; }

.filter-select, .filter-input {
    padding:10px 14px; border:1.5px solid var(--border); border-radius:var(--radius-sm);
    font-size:11px; font-weight:600; color:var(--text-primary); background:var(--bg-soft);
    cursor:pointer; transition:all 0.2s; min-width:130px; font-family:'Plus Jakarta Sans',sans-serif;
}
.filter-select:focus, .filter-input:focus { outline:none; border-color:var(--accent-sky); box-shadow:0 0 0 4px rgba(25,118,210,0.08); }

.btn-action {
    display:inline-flex; align-items:center; gap:6px; padding:10px 20px;
    font-size:11px; font-weight:700; letter-spacing:0.06em; text-transform:uppercase;
    border:none; border-radius:var(--radius-sm); cursor:pointer;
    transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1); text-decoration:none;
    font-family:'Plus Jakarta Sans',sans-serif;
}
.btn-action.primary {
    background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));
    color:var(--accent-lavender); box-shadow:0 4px 12px rgba(123,31,162,0.15);
}
.btn-action.primary:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(123,31,162,0.25); }
.btn-action.secondary { background:var(--bg-soft); color:var(--text-primary); border:1px solid var(--border); }
.btn-action.secondary:hover { background:var(--pastel-sky); color:var(--accent-sky); border-color:var(--pastel-sky-dark); }

/* TABLE */
.table-card {
    background:var(--surface); border-radius:var(--radius-md); border:1px solid var(--border-light);
    overflow:hidden; box-shadow:var(--shadow-sm); flex:1; display:flex; flex-direction:column;
}
.table-card table { width:100%; border-collapse:collapse; }
.table-card th {
    text-align:left; padding:12px 16px; font-size:10px; font-weight:700;
    text-transform:uppercase; letter-spacing:0.06em; color:var(--text-tertiary);
    border-bottom:1.5px solid var(--border-light); background:var(--bg-soft);
    position:sticky; top:0; z-index:10;
}
.table-card td { padding:12px 16px; font-size:12px; color:var(--text-primary); border-bottom:1px solid var(--border-light); vertical-align:middle; }
.table-card tr:last-child td { border-bottom:none; }
.table-card tbody tr { transition:all 0.15s ease; cursor:pointer; }
.table-card tbody tr:hover { background:var(--bg-soft); }

/* ORDER CELL */
.order-cell { display:flex; align-items:center; gap:10px; }
.order-badge {
    width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center;
    font-family:'DM Sans',sans-serif; font-size:13px; font-weight:700; flex-shrink:0;
}
.order-badge.sky { background:var(--pastel-sky); color:var(--accent-sky); }
.order-badge.mint { background:var(--pastel-mint); color:var(--accent-mint); }
.order-badge.lavender { background:var(--pastel-lavender); color:var(--accent-lavender); }
.order-badge.cream { background:var(--pastel-cream); color:var(--accent-cream); }
.order-badge.coral { background:var(--pastel-coral); color:var(--accent-coral); }

.order-info { min-width:0; }
.order-id { font-weight:700; font-size:13px; color:var(--text-primary); }
.order-date { font-size:10px; color:var(--text-tertiary); font-weight:600; }

/* USER CELL */
.user-cell { display:flex; align-items:center; gap:8px; }
.user-avatar {
    width:28px; height:28px; border-radius:50%; background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));
    display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:11px; flex-shrink:0;
}
.user-name { font-weight:700; font-size:12px; }
.user-email { font-size:10px; color:var(--text-tertiary); }

/* STATUS BADGES */
.status-pill {
    display:inline-flex; align-items:center; gap:4px; padding:4px 10px;
    font-size:9px; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;
    border-radius:20px; white-space:nowrap;
}
.sp-pendiente { background:var(--pastel-cream); color:var(--accent-cream); }
.sp-confirmado { background:var(--pastel-sky); color:var(--accent-sky); }
.sp-en_proceso { background:var(--pastel-lavender); color:var(--accent-lavender); }
.sp-enviado { background:var(--pastel-mint); color:var(--accent-mint); }
.sp-entregado { background:var(--pastel-sage); color:var(--accent-sage); }
.sp-cancelado { background:var(--pastel-coral); color:var(--accent-coral); }
.sp-devuelto { background:var(--pastel-coral); color:var(--accent-coral); }

/* AMOUNT */
.amount { font-family:'DM Sans',sans-serif; font-size:13px; font-weight:700; color:var(--text-primary); }

/* ACTIONS */
.action-btns { display:flex; gap:6px; justify-content:flex-end; align-items:center; }
.action-btn {
    width:28px; height:28px; border-radius:8px; border:1px solid var(--border-light);
    background:var(--bg-soft); display:flex; align-items:center; justify-content:center;
    cursor:pointer; transition:all 0.2s ease; color:var(--text-tertiary); font-size:12px; text-decoration:none;
}
.action-btn:hover { background:var(--pastel-sky); color:var(--accent-sky); border-color:var(--pastel-sky-dark); transform:scale(1.1); }
.action-btn.view:hover { background:var(--pastel-sky); color:var(--accent-sky); }
.action-btn.advance:hover { background:var(--pastel-mint); color:var(--accent-mint); }
.action-btn.cancel:hover { background:var(--pastel-coral); color:var(--accent-coral); border-color:var(--pastel-coral-dark); }

/* DROPDOWN CAMBIAR ESTADO */
.status-dropdown {
    position:relative;
    display:inline-block;
}
.status-dropdown-btn {
    width:28px; height:28px; border-radius:8px; border:1px solid var(--border-light);
    background:var(--bg-soft); display:flex; align-items:center; justify-content:center;
    cursor:pointer; transition:all 0.2s ease; color:var(--text-tertiary); font-size:12px;
}
.status-dropdown-btn:hover { background:var(--pastel-lavender); color:var(--accent-lavender); border-color:var(--pastel-lavender-dark); transform:scale(1.1); }
.status-dropdown-menu {
    display:none; position:absolute; right:0; top:32px; z-index:100;
    background:rgba(255,255,255,0.85); backdrop-filter:blur(20px) saturate(180%);
    -webkit-backdrop-filter:blur(20px) saturate(180%);
    border:1px solid rgba(255,255,255,0.5); border-radius:var(--radius-md);
    box-shadow:var(--shadow-lg); min-width:180px; padding:6px;
    animation:dropdownFade 0.2s ease;
}
.status-dropdown-menu.show { display:block; }
@keyframes dropdownFade { from{opacity:0;transform:translateY(-6px);} to{opacity:1;transform:translateY(0);} }
.status-dropdown-item {
    display:flex; align-items:center; gap:8px; padding:8px 12px;
    border-radius:var(--radius-sm); cursor:pointer; font-size:11px; font-weight:600;
    color:var(--text-primary); transition:all 0.15s; border:none; background:transparent; width:100%;
    font-family:'Plus Jakarta Sans',sans-serif;
}
.status-dropdown-item:hover { background:var(--pastel-sky); }
.status-dot { width:8px; height:8px; border-radius:50%; flex-shrink:0; }
.status-dot.pendiente { background:var(--accent-cream); }
.status-dot.confirmado { background:var(--accent-sky); }
.status-dot.en_proceso { background:var(--accent-lavender); }
.status-dot.enviado { background:var(--accent-mint); }
.status-dot.entregado { background:var(--accent-sage); }
.status-dot.cancelado { background:var(--accent-coral); }
.status-dot.devuelto { background:var(--accent-coral); }

/* EMPTY */
.empty-state { text-align:center; padding:60px 40px; }
.empty-state-icon { width:64px; height:64px; margin:0 auto 16px; border-radius:50%; background:linear-gradient(135deg,var(--pastel-coral),var(--pastel-lavender)); display:flex; align-items:center; justify-content:center; color:var(--accent-coral); font-size:28px; animation:floatIcon 3s ease-in-out infinite; }
@keyframes floatIcon { 0%,100%{transform:translateY(0);} 50%{transform:translateY(-8px);} }
.empty-state h4 { font-family:'DM Sans',sans-serif; font-size:18px; font-weight:700; margin-bottom:6px; }
.empty-state p { font-size:12px; color:var(--text-secondary); }

/* TOAST */
.toast-container { position:fixed; top:24px; right:24px; z-index:9999; display:flex; flex-direction:column; gap:10px; pointer-events:none; }
.toast-item {
    background:var(--surface); border:1px solid var(--border-light); border-radius:var(--radius-md);
    padding:14px 20px; display:flex; align-items:center; gap:12px;
    box-shadow:var(--shadow-md); animation:slideInToast 0.4s cubic-bezier(0.34,1.56,0.64,1);
    font-size:12px; font-weight:600; min-width:300px; border-left:4px solid var(--accent-sky);
    font-family:'Plus Jakarta Sans',sans-serif; pointer-events:auto;
}
.toast-item.success { border-left-color:var(--accent-mint); }
.toast-item.error { border-left-color:var(--accent-coral); }
@keyframes slideInToast { from{transform:translateX(120%);opacity:0;} to{transform:translateX(0);opacity:1;} }

/* ═════════════════════════════════════════════════════════════════════════
   MODAL GLASSMORPHISM — DETALLE DE PEDIDO
   ═════════════════════════════════════════════════════════════════════════ */
.modal-overlay {
    display:none; position:fixed; inset:0; z-index:10000;
    background:rgba(26,26,46,0.25); backdrop-filter:blur(8px);
    -webkit-backdrop-filter:blur(8px);
    align-items:center; justify-content:center; padding:20px;
    animation:modalFadeIn 0.3s ease;
}
.modal-overlay.show { display:flex; }
@keyframes modalFadeIn { from{opacity:0;} to{opacity:1;} }

.modal-glass {
    background:rgba(255,255,255,0.72); backdrop-filter:blur(40px) saturate(180%);
    -webkit-backdrop-filter:blur(40px) saturate(180%);
    border:1px solid rgba(255,255,255,0.6);
    border-radius:var(--radius-lg); box-shadow:0 25px 50px -12px rgba(0,0,0,0.15), 0 0 0 1px rgba(255,255,255,0.4) inset;
    width:100%; max-width:720px; max-height:90vh; overflow:hidden;
    display:flex; flex-direction:column;
    animation:modalSlideUp 0.4s cubic-bezier(0.34,1.56,0.64,1);
}
@keyframes modalSlideUp { from{opacity:0;transform:translateY(40px) scale(0.96);} to{opacity:1;transform:translateY(0) scale(1);} }

.modal-header {
    display:flex; align-items:center; justify-content:space-between;
    padding:20px 24px 16px; border-bottom:1px solid rgba(0,0,0,0.06);
}
.modal-header-left { display:flex; align-items:center; gap:14px; }
.modal-order-icon {
    width:48px; height:48px; border-radius:14px;
    background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));
    display:flex; align-items:center; justify-content:center;
    color:var(--accent-lavender); font-size:22px;
    box-shadow:0 4px 12px rgba(123,31,162,0.12);
}
.modal-header-info h3 { font-family:'DM Sans',sans-serif; font-size:18px; font-weight:700; margin:0 0 2px; letter-spacing:-0.3px; }
.modal-header-info p { font-size:11px; color:var(--text-secondary); font-weight:600; margin:0; }
.modal-close {
    width:32px; height:32px; border-radius:10px; border:none;
    background:rgba(0,0,0,0.04); color:var(--text-secondary);
    display:flex; align-items:center; justify-content:center;
    cursor:pointer; transition:all 0.2s; font-size:16px;
}
.modal-close:hover { background:rgba(0,0,0,0.08); color:var(--text-primary); transform:rotate(90deg); }

.modal-body { padding:20px 24px; overflow-y:auto; flex:1; }
.modal-body::-webkit-scrollbar { width:3px; }
.modal-body::-webkit-scrollbar-thumb { background:rgba(0,0,0,0.1); border-radius:2px; }

/* Secciones del modal */
.modal-section { margin-bottom:20px; }
.modal-section:last-child { margin-bottom:0; }
.modal-section-title {
    font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em;
    color:var(--text-tertiary); margin-bottom:10px; display:flex; align-items:center; gap:6px;
}

/* Info grid */
.info-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:10px; }
.info-item {
    background:rgba(255,255,255,0.5); border:1px solid rgba(0,0,0,0.04);
    border-radius:var(--radius-sm); padding:12px 14px;
}
.info-item.full { grid-column:1 / -1; }
.info-item label { font-size:9px; font-weight:700; text-transform:uppercase; letter-spacing:0.06em; color:var(--text-tertiary); display:block; margin-bottom:4px; }
.info-item value { font-size:13px; font-weight:600; color:var(--text-primary); display:block; }
.info-item value.amount { font-family:'DM Sans',sans-serif; font-size:16px; font-weight:700; }

/* Items table in modal */
.modal-items-table { width:100%; border-collapse:collapse; }
.modal-items-table th {
    text-align:left; padding:8px 10px; font-size:9px; font-weight:700;
    text-transform:uppercase; letter-spacing:0.06em; color:var(--text-tertiary);
    border-bottom:1px solid rgba(0,0,0,0.06); background:rgba(255,255,255,0.3);
}
.modal-items-table td { padding:10px; font-size:12px; border-bottom:1px solid rgba(0,0,0,0.04); vertical-align:middle; }
.modal-items-table tr:last-child td { border-bottom:none; }
.item-product { display:flex; align-items:center; gap:10px; }
.item-product-img {
    width:40px; height:40px; border-radius:8px; object-fit:cover;
    background:var(--bg); border:1px solid var(--border-light);
}
.item-product-info { min-width:0; }
.item-product-name { font-weight:700; font-size:12px; color:var(--text-primary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.item-product-meta { font-size:10px; color:var(--text-tertiary); }
.item-qty { font-weight:600; color:var(--text-secondary); text-align:center; }
.item-price { font-family:'DM Sans',sans-serif; font-weight:700; font-size:12px; }
.item-subtotal { font-family:'DM Sans',sans-serif; font-weight:700; font-size:12px; color:var(--accent-lavender); }

/* Modal footer */
.modal-footer {
    display:flex; align-items:center; justify-content:space-between;
    padding:16px 24px 20px; border-top:1px solid rgba(0,0,0,0.06);
    background:rgba(255,255,255,0.4);
}
.modal-total-label { font-size:11px; font-weight:600; color:var(--text-secondary); }
.modal-total-value { font-family:'DM Sans',sans-serif; font-size:22px; font-weight:700; color:var(--text-primary); }

/* Status selector in modal */
.modal-status-selector {
    display:flex; gap:6px; flex-wrap:wrap;
}
.status-option {
    padding:6px 12px; border-radius:20px; border:1.5px solid var(--border-light);
    background:rgba(255,255,255,0.6); font-size:10px; font-weight:700;
    cursor:pointer; transition:all 0.2s; font-family:'Plus Jakarta Sans',sans-serif;
    color:var(--text-secondary);
}
.status-option:hover { transform:translateY(-1px); box-shadow:var(--shadow-sm); }
.status-option.active {
    border-color:transparent; color:white;
    box-shadow:0 2px 8px rgba(0,0,0,0.12);
}
.status-option.pendiente.active { background:var(--accent-cream); }
.status-option.confirmado.active { background:var(--accent-sky); }
.status-option.en_proceso.active { background:var(--accent-lavender); }
.status-option.enviado.active { background:var(--accent-mint); }
.status-option.entregado.active { background:var(--accent-sage); }
.status-option.cancelado.active { background:var(--accent-coral); }
.status-option.devuelto.active { background:var(--accent-coral); }

/* ANIMATIONS */
@keyframes fadeUp { from{opacity:0;transform:translateY(12px);} to{opacity:1;transform:translateY(0);} }
.anim-fade-up { animation:fadeUp 0.5s ease forwards; opacity:0; }
.delay-1 { animation-delay:0.06s; } .delay-2 { animation-delay:0.12s; } .delay-3 { animation-delay:0.18s; }

/* RESPONSIVE */
@media (max-width:1280px) { .stats-bar { grid-template-columns:repeat(4,1fr); } }
@media (max-width:1024px) { .stats-bar { grid-template-columns:repeat(2,1fr); } .main-content { padding:12px 16px; } }
@media (max-width:768px) {
    .stats-bar { grid-template-columns:1fr; } .toolbar { flex-direction:column; align-items:stretch; }
    .search-box { width:100%; } .welcome-section { flex-direction:column; gap:12px; text-align:center; }
    .table-card { overflow-x:auto; } .table-card table { min-width:700px; }
    .modal-glass { max-width:100%; margin:10px; }
    .info-grid { grid-template-columns:1fr; }
}
</style>
</head>
<body>

<!-- TOASTS -->
<div class="toast-container" id="toastContainer">
    <c:if test="${not empty param.exito}">
        <div class="toast-item success"><span class="material-symbols-rounded" style="color:var(--accent-mint);">check_circle</span><span>${param.exito}</span></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast-item error"><span class="material-symbols-rounded" style="color:var(--accent-coral);">error</span><span>${param.error}</span></div>
    </c:if>
</div>

<!-- ═════════════════════════════════════════════════════════════════════════
     MODAL GLASSMORPHISM — DETALLE DE PEDIDO
     ═════════════════════════════════════════════════════════════════════════ -->
<div class="modal-overlay" id="pedidoModal">
    <div class="modal-glass">
        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-order-icon"><span class="material-symbols-rounded">receipt_long</span></div>
                <div class="modal-header-info">
                    <h3 id="modalTitulo">Pedido #<span id="modalPedidoId">—</span></h3>
                    <p id="modalFecha">—</p>
                </div>
            </div>
            <button class="modal-close" onclick="cerrarModal()" title="Cerrar"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="modal-body">
            <!-- Estado actual + selector -->
            <div class="modal-section">
                <div class="modal-section-title"><span class="material-symbols-rounded" style="font-size:14px;">flag</span> Estado del pedido</div>
                <div class="modal-status-selector" id="modalStatusSelector">
                    <button class="status-option pendiente" data-estado="PENDIENTE" onclick="cambiarEstadoModal('PENDIENTE')">Pendiente</button>
                    <button class="status-option confirmado" data-estado="CONFIRMADO" onclick="cambiarEstadoModal('CONFIRMADO')">Confirmado</button>
                    <button class="status-option en_proceso" data-estado="EN_PROCESO" onclick="cambiarEstadoModal('EN_PROCESO')">En Proceso</button>
                    <button class="status-option enviado" data-estado="ENVIADO" onclick="cambiarEstadoModal('ENVIADO')">Enviado</button>
                    <button class="status-option entregado" data-estado="ENTREGADO" onclick="cambiarEstadoModal('ENTREGADO')">Entregado</button>
                    <button class="status-option cancelado" data-estado="CANCELADO" onclick="cambiarEstadoModal('CANCELADO')">Cancelado</button>
                    <button class="status-option devuelto" data-estado="DEVUELTO" onclick="cambiarEstadoModal('DEVUELTO')">Devuelto</button>
                </div>
            </div>

            <!-- Info general -->
            <div class="modal-section">
                <div class="modal-section-title"><span class="material-symbols-rounded" style="font-size:14px;">person</span> Cliente</div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>Nombre</label>
                        <value id="modalClienteNombre">—</value>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <value id="modalClienteEmail">—</value>
                    </div>
                    <div class="info-item full">
                        <label>Dirección de envío</label>
                        <value id="modalDireccion">—</value>
                    </div>
                </div>
            </div>

            <!-- Productos -->
            <div class="modal-section">
                <div class="modal-section-title"><span class="material-symbols-rounded" style="font-size:14px;">shopping_bag</span> Productos</div>
                <table class="modal-items-table">
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th style="text-align:center">Cant.</th>
                            <th style="text-align:right">Precio</th>
                            <th style="text-align:right">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody id="modalItemsBody">
                        <!-- Se llena por JS -->
                    </tbody>
                </table>
            </div>

            <!-- Pago -->
            <div class="modal-section">
                <div class="modal-section-title"><span class="material-symbols-rounded" style="font-size:14px;">payments</span> Información de pago</div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>Método de pago</label>
                        <value id="modalMetodoPago">—</value>
                    </div>
                    <div class="info-item">
                        <label>Notas</label>
                        <value id="modalNotas">—</value>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <div>
                <div class="modal-total-label">Total del pedido</div>
            </div>
            <div class="modal-total-value" id="modalTotal">$0</div>
        </div>
    </div>
</div>

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content">

        <!-- Welcome -->
        <div class="welcome-section">
            <div class="welcome-content">
                <h1 class="welcome-title">Pedidos <span>Admin</span></h1>
                <p class="welcome-subtitle">Gestiona y da seguimiento a todos los pedidos del sistema</p>
            </div>
        </div>

        <!-- Stats Bar -->
        <div class="stats-bar anim-fade-up delay-1">
            <div class="stat-item total" onclick="filterByStatus('')">
                <div class="stat-icon total"><span class="material-symbols-rounded">receipt_long</span></div>
                <div class="stat-data"><h4><%= totalPedidos %></h4><p>Total Pedidos</p></div>
            </div>
            <div class="stat-item pendiente" onclick="filterByStatus('PENDIENTE')">
                <div class="stat-icon pendiente"><span class="material-symbols-rounded">schedule</span></div>
                <div class="stat-data"><h4><%= pendientes %></h4><p>Pendientes</p></div>
            </div>
            <div class="stat-item confirmado" onclick="filterByStatus('CONFIRMADO')">
                <div class="stat-icon confirmado"><span class="material-symbols-rounded">check_circle</span></div>
                <div class="stat-data"><h4><%= confirmados %></h4><p>Confirmados</p></div>
            </div>
            <div class="stat-item proceso" onclick="filterByStatus('EN_PROCESO')">
                <div class="stat-icon proceso"><span class="material-symbols-rounded">package_2</span></div>
                <div class="stat-data"><h4><%= enProceso %></h4><p>En Proceso</p></div>
            </div>
            <div class="stat-item enviado" onclick="filterByStatus('ENVIADO')">
                <div class="stat-icon enviado"><span class="material-symbols-rounded">local_shipping</span></div>
                <div class="stat-data"><h4><%= enviados %></h4><p>Enviados</p></div>
            </div>
            <div class="stat-item entregado" onclick="filterByStatus('ENTREGADO')">
                <div class="stat-icon entregado"><span class="material-symbols-rounded">done_all</span></div>
                <div class="stat-data"><h4><%= entregados %></h4><p>Entregados</p></div>
            </div>
            <div class="stat-item cancelado" onclick="filterByStatus('CANCELADO')">
                <div class="stat-icon cancelado"><span class="material-symbols-rounded">cancel</span></div>
                <div class="stat-data"><h4><%= cancelados %></h4><p>Cancelados</p></div>
            </div>
            <div class="stat-item devuelto" onclick="filterByStatus('DEVUELTO')">
                <div class="stat-icon devuelto"><span class="material-symbols-rounded">assignment_return</span></div>
                <div class="stat-data"><h4><%= devueltos %></h4><p>Devueltos</p></div>
            </div>
        </div>

        <!-- Toolbar -->
        <div class="toolbar anim-fade-up delay-2">
            <div class="toolbar-left">
                <div class="toolbar-title-group">
                    <h2 id="sectionTitle">Todos los Pedidos</h2>
                    <p id="orderCount"><%= count %> pedidos</p>
                </div>
            </div>
            <div class="toolbar-right">
                <form method="get" action="<%= ctx %>/admin/pedidos" id="filterForm" style="display:flex;gap:10px;flex-wrap:wrap;align-items:center;">
                    <div class="search-box">
                        <span class="material-symbols-rounded search-icon">search</span>
                        <input type="text" name="usuario" placeholder="Buscar cliente..." value="${fn:escapeXml(param.usuario)}" id="searchInput">
                    </div>
                    <select name="estado" class="filter-select" id="statusFilter" onchange="this.form.submit()">
                        <option value="">Todos los estados</option>
                        <option value="PENDIENTE" ${param.estado == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                        <option value="CONFIRMADO" ${param.estado == 'CONFIRMADO' ? 'selected' : ''}>Confirmado</option>
                        <option value="EN_PROCESO" ${param.estado == 'EN_PROCESO' ? 'selected' : ''}>En Proceso</option>
                        <option value="ENVIADO" ${param.estado == 'ENVIADO' ? 'selected' : ''}>Enviado</option>
                        <option value="ENTREGADO" ${param.estado == 'ENTREGADO' ? 'selected' : ''}>Entregado</option>
                        <option value="CANCELADO" ${param.estado == 'CANCELADO' ? 'selected' : ''}>Cancelado</option>
                        <option value="DEVUELTO" ${param.estado == 'DEVUELTO' ? 'selected' : ''}>Devuelto</option>
                    </select>
                    <input type="date" name="desde" class="filter-input" value="${param.desde}" placeholder="Desde">
                    <input type="date" name="hasta" class="filter-input" value="${param.hasta}" placeholder="Hasta">
                    <button type="submit" class="btn-action primary" style="padding:10px 16px;">
                        <span class="material-symbols-rounded" style="font-size:16px;">filter_alt</span> Filtrar
                    </button>
                    <a href="<%= ctx %>/admin/pedidos" class="btn-action secondary">
                        <span class="material-symbols-rounded" style="font-size:16px;">refresh</span> Limpiar
                    </a>
                </form>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="table-card anim-fade-up delay-3">
            <table>
                <thead>
                    <tr>
                        <th>Pedido</th>
                        <th>Cliente</th>
                        <th>Fecha</th>
                        <th>Total</th>
                        <th>Estado</th>
                        <th style="text-align:right">Acciones</th>
                    </tr>
                </thead>
                <tbody id="ordersTableBody">
                    <c:choose>
                        <c:when test="${empty pedidos}">
                            <tr><td colspan="6">
                                <div class="empty-state">
                                    <div class="empty-state-icon"><span class="material-symbols-rounded" style="font-size:32px;">receipt_long</span></div>
                                    <h4>No hay pedidos registrados</h4>
                                    <p>Los pedidos aparecerán aquí cuando los clientes realicen compras.</p>
                                </div>
                            </td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${pedidos}" varStatus="st">
                                <c:set var="estadoStr" value="${p.estado.name()}" />
                                <c:set var="estadoLower" value="${fn:toLowerCase(estadoStr)}" />
                                <tr data-estado="${estadoLower}" data-cliente="${fn:toLowerCase(p.nombreUsuario)} ${fn:toLowerCase(p.emailUsuario)}">
                                    <td>
                                        <div class="order-cell">
                                            <div class="order-badge ${st.index % 5 == 0 ? 'sky' : (st.index % 5 == 1 ? 'mint' : (st.index % 5 == 2 ? 'lavender' : (st.index % 5 == 3 ? 'cream' : 'coral')))}">
                                                #${p.id}
                                            </div>
                                            <div class="order-info">
                                                <div class="order-id">Pedido #${p.id}</div>
                                                <div class="order-date">
                                                    <fmt:parseDate value="${p.creadoEn}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy, HH:mm" />
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar">${fn:substring(p.nombreUsuario,0,1)}</div>
                                            <div>
                                                <div class="user-name">${p.nombreUsuario}</div>
                                                <div class="user-email">${p.emailUsuario}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-secondary);font-weight:600;">
                                        <fmt:parseDate value="${p.creadoEn}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate2" type="both" />
                                        <fmt:formatDate value="${parsedDate2}" pattern="dd MMM yyyy" />
                                    </td>
                                    <td><span class="amount">$<fmt:formatNumber value="${p.total}" pattern="#,##0" maxFractionDigits="0"/></span></td>
                                    <td>
                                        <c:set var="estadoClass" value="sp-pendiente"/>
                                        <c:set var="estadoIcon" value="schedule"/>
                                        <c:choose>
                                            <c:when test="${estadoStr == 'CONFIRMADO'}"><c:set var="estadoClass" value="sp-confirmado"/><c:set var="estadoIcon" value="check_circle"/></c:when>
                                            <c:when test="${estadoStr == 'EN_PROCESO'}"><c:set var="estadoClass" value="sp-en_proceso"/><c:set var="estadoIcon" value="package_2"/></c:when>
                                            <c:when test="${estadoStr == 'ENVIADO'}"><c:set var="estadoClass" value="sp-enviado"/><c:set var="estadoIcon" value="local_shipping"/></c:when>
                                            <c:when test="${estadoStr == 'ENTREGADO'}"><c:set var="estadoClass" value="sp-entregado"/><c:set var="estadoIcon" value="done_all"/></c:when>
                                            <c:when test="${estadoStr == 'CANCELADO'}"><c:set var="estadoClass" value="sp-cancelado"/><c:set var="estadoIcon" value="cancel"/></c:when>
                                            <c:when test="${estadoStr == 'DEVUELTO'}"><c:set var="estadoClass" value="sp-devuelto"/><c:set var="estadoIcon" value="assignment_return"/></c:when>
                                        </c:choose>
                                        <span class="status-pill ${estadoClass}"><span class="material-symbols-rounded" style="font-size:12px;">${estadoIcon}</span> ${p.estado}</span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <!-- Ver detalle (modal) -->
                                            <button type="button" class="action-btn view" title="Ver detalle" onclick="verDetalle(${p.id}, '${estadoStr}', '${fn:escapeXml(p.nombreUsuario)}', '${fn:escapeXml(p.emailUsuario)}', '${p.total}', '${fn:escapeXml(p.metodo_pago)}', '${fn:escapeXml(p.notas)}')">
                                                <span class="material-symbols-rounded" style="font-size:14px;">visibility</span>
                                            </button>

                                            <!-- Cambiar estado (dropdown) -->
                                            <div class="status-dropdown" id="dropdown-${p.id}">
                                                <button type="button" class="status-dropdown-btn" title="Cambiar estado" onclick="toggleDropdown(${p.id})">
                                                    <span class="material-symbols-rounded" style="font-size:14px;">edit</span>
                                                </button>
                                                <div class="status-dropdown-menu" id="menu-${p.id}">
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'PENDIENTE')">
                                                        <span class="status-dot pendiente"></span> Pendiente
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'CONFIRMADO')">
                                                        <span class="status-dot confirmado"></span> Confirmado
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'EN_PROCESO')">
                                                        <span class="status-dot en_proceso"></span> En Proceso
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'ENVIADO')">
                                                        <span class="status-dot enviado"></span> Enviado
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'ENTREGADO')">
                                                        <span class="status-dot entregado"></span> Entregado
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'CANCELADO')">
                                                        <span class="status-dot cancelado"></span> Cancelado
                                                    </button>
                                                    <button class="status-dropdown-item" onclick="cambiarEstado(${p.id}, 'DEVUELTO')">
                                                        <span class="status-dot devuelto"></span> Devuelto
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Avanzar estado (siguiente en cadena) -->
                                            <c:if test="${estadoStr != 'ENTREGADO' && estadoStr != 'CANCELADO' && estadoStr != 'DEVUELTO'}">
                                                <form method="post" action="<%= ctx %>/admin/pedidos" style="display:inline;margin:0;" onsubmit="return confirm('¿Avanzar estado de este pedido?');">
                                                    <input type="hidden" name="accion" value="avanzarEstado">
                                                    <input type="hidden" name="id" value="${p.id}">
                                                    <button type="submit" class="action-btn advance" title="Avanzar estado"><span class="material-symbols-rounded" style="font-size:14px;">arrow_forward</span></button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </main>
</div>

<script>
// ─── FILTROS ──────────────────────────────────────────────────────────────
function filterByStatus(status) {
    document.getElementById('statusFilter').value = status;
    document.getElementById('filterForm').submit();
}

// ─── DROPDOWN CAMBIAR ESTADO ─────────────────────────────────────────────
let dropdownAbierto = null;

function toggleDropdown(pedidoId) {
    const menu = document.getElementById('menu-' + pedidoId);
    if (dropdownAbierto && dropdownAbierto !== menu) {
        dropdownAbierto.classList.remove('show');
    }
    menu.classList.toggle('show');
    dropdownAbierto = menu.classList.contains('show') ? menu : null;
}

// Cerrar dropdown al hacer click fuera
document.addEventListener('click', function(e) {
    if (!e.target.closest('.status-dropdown')) {
        document.querySelectorAll('.status-dropdown-menu.show').forEach(function(m) {
            m.classList.remove('show');
        });
        dropdownAbierto = null;
    }
});

// Cambiar estado vía POST directo
function cambiarEstado(pedidoId, nuevoEstado) {
    if (!confirm('¿Cambiar estado del pedido #' + pedidoId + ' a "' + nuevoEstado + '"?')) return;

    const form = document.createElement('form');
    form.method = 'post';
    form.action = '<%= ctx %>/admin/pedidos';
    form.style.display = 'none';

    const inputAccion = document.createElement('input');
    inputAccion.type = 'hidden';
    inputAccion.name = 'accion';
    inputAccion.value = 'cambiarEstado';
    form.appendChild(inputAccion);

    const inputId = document.createElement('input');
    inputId.type = 'hidden';
    inputId.name = 'id';
    inputId.value = pedidoId;
    form.appendChild(inputId);

    const inputEstado = document.createElement('input');
    inputEstado.type = 'hidden';
    inputEstado.name = 'estado';
    inputEstado.value = nuevoEstado;
    form.appendChild(inputEstado);

    document.body.appendChild(form);
    form.submit();
}

// ─── MODAL GLASSMORPHISM ──────────────────────────────────────────────────
let pedidoActualId = null;
let pedidoActualEstado = null;

function verDetalle(id, estado, nombre, email, total, metodoPago, notas) {
    pedidoActualId = id;
    pedidoActualEstado = estado;

    document.getElementById('modalPedidoId').textContent = id;
    document.getElementById('modalClienteNombre').textContent = nombre || '—';
    document.getElementById('modalClienteEmail').textContent = email || '—';
    document.getElementById('modalTotal').textContent = '$' + Number(total).toLocaleString('es-CO');
    document.getElementById('modalMetodoPago').textContent = metodoPago || '—';
    document.getElementById('modalNotas').textContent = notas || 'Sin notas';

    // Marcar estado activo en el selector del modal
    document.querySelectorAll('.status-option').forEach(function(btn) {
        btn.classList.remove('active');
        if (btn.dataset.estado === estado) {
            btn.classList.add('active');
        }
    });

    // Cargar items del pedido vía fetch (o mostrar placeholder si no hay endpoint)
    cargarItemsPedido(id);

    document.getElementById('pedidoModal').classList.add('show');
    document.body.style.overflow = 'hidden';
}

function cerrarModal() {
    document.getElementById('pedidoModal').classList.remove('show');
    document.body.style.overflow = '';
    pedidoActualId = null;
    pedidoActualEstado = null;
}

// Cerrar modal al hacer click en el overlay
document.getElementById('pedidoModal').addEventListener('click', function(e) {
    if (e.target === this) cerrarModal();
});

// Cerrar con ESC
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') cerrarModal();
});

// Cambiar estado desde el modal
function cambiarEstadoModal(nuevoEstado) {
    if (!pedidoActualId) return;
    cambiarEstado(pedidoActualId, nuevoEstado);
}

// Cargar items del pedido (simulado — reemplazar con fetch real si tienes endpoint JSON)
function cargarItemsPedido(pedidoId) {
    const tbody = document.getElementById('modalItemsBody');
    // Placeholder: muestra mensaje de carga. En producción, haz fetch a un endpoint que devuelva JSON
    tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:var(--text-tertiary);"><span class="material-symbols-rounded" style="font-size:20px;vertical-align:middle;margin-right:6px;">hourglass_empty</span>Cargando productos...</td></tr>';

    // Ejemplo de cómo sería con fetch (descomenta cuando tengas el endpoint):
    /*
    fetch('<%= ctx %>/admin/pedidos/detalle?id=' + pedidoId + '&json=1')
        .then(r => r.json())
        .then(data => {
            let html = '';
            data.items.forEach(item => {
                html += '<tr>' +
                    '<td><div class="item-product"><div class="item-product-info"><div class="item-product-name">' + item.nombre + '</div><div class="item-product-meta">' + item.categoria + '</div></div></div></td>' +
                    '<td class="item-qty">' + item.cantidad + '</td>' +
                    '<td class="item-price" style="text-align:right">$' + item.precioUnitario.toLocaleString('es-CO') + '</td>' +
                    '<td class="item-subtotal" style="text-align:right">$' + (item.cantidad * item.precioUnitario).toLocaleString('es-CO') + '</td>' +
                '</tr>';
            });
            tbody.innerHTML = html;
        })
        .catch(() => {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:var(--text-tertiary);">No se pudieron cargar los productos</td></tr>';
        });
    */
}

// ─── TOASTS ───────────────────────────────────────────────────────────────
setTimeout(function() {
    document.querySelectorAll('.toast-item').forEach(function(t) {
        t.style.transition='all 0.4s ease'; t.style.opacity='0'; t.style.transform='translateX(120%)';
        setTimeout(function(){ if(t.parentNode)t.parentNode.removeChild(t); },400);
    });
}, 4000);
</script>
</body>
</html>