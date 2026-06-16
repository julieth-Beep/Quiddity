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
<title>Detalle Pedido #${pedido.id} — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
    --pastel-sage:#f1f8e9; --pastel-sage-dark:#dcedc8;
    --accent-sky:#1976d2; --accent-mint:#388e3c; --accent-lavender:#7b1fa2;
    --accent-cream:#f57c00; --accent-coral:#c2185b; --accent-sage:#689f38;
    --radius-sm:12px; --radius-md:14px; --radius-lg:16px;
    --shadow-sm:0 1px 3px rgba(0,0,0,0.04);
    --shadow:0 2px 8px rgba(0,0,0,0.06);
    --shadow-md:0 4px 16px rgba(0,0,0,0.08);
    --shadow-lg:0 12px 32px rgba(0,0,0,0.12);
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

.layout-wrapper { display:flex; min-height:100vh; }
.main-content { flex:1; display:flex; flex-direction:column; min-height:100vh; padding:16px 20px; gap:12px; overflow-x:hidden; }

/* WELCOME */
.welcome-section {
    display:flex; align-items:center; justify-content:space-between;
    background:var(--surface); border-radius:var(--radius-lg); padding:16px 20px;
    border:1px solid var(--border); box-shadow:var(--shadow-sm);
    animation:fadeUp 0.5s ease forwards; opacity:0;
}
.welcome-content { flex:1; }
.welcome-title { font-family:'DM Sans',sans-serif; font-size:22px; font-weight:700; margin:0 0 3px; letter-spacing:-0.3px; }
.welcome-title span { color:var(--accent-sky); }
.welcome-subtitle { font-size:12px; color:var(--text-secondary); font-weight:500; margin:0; }

.back-btn {
    display:inline-flex; align-items:center; gap:6px; padding:8px 16px;
    background:var(--bg-soft); border:1px solid var(--border); border-radius:var(--radius-sm);
    font-size:12px; font-weight:600; color:var(--text-secondary); text-decoration:none;
    transition:all 0.2s; font-family:'Plus Jakarta Sans',sans-serif;
}
.back-btn:hover { background:var(--pastel-sky); color:var(--accent-sky); border-color:var(--pastel-sky-dark); transform:translateY(-1px); }

/* DETAIL GRID */
.detail-grid { display:grid; grid-template-columns:1.2fr 0.8fr; gap:16px; }
.detail-left { display:flex; flex-direction:column; gap:12px; }
.detail-right { display:flex; flex-direction:column; gap:12px; }

/* PANELS */
.panel {
    background:var(--surface); border-radius:var(--radius-md); border:1px solid var(--border-light);
    box-shadow:var(--shadow-sm); overflow:hidden; transition:all 0.3s ease;
}
.panel:hover { box-shadow:var(--shadow); border-color:var(--border); }
.panel-header {
    padding:14px 16px; border-bottom:1px solid var(--border-light);
    display:flex; align-items:center; justify-content:space-between;
}
.panel-header h3 {
    font-family:'DM Sans',sans-serif; font-size:14px; font-weight:700;
    display:flex; align-items:center; gap:8px; margin:0;
}
.panel-header h3::before { content:''; width:3px; height:14px; border-radius:2px; background:var(--accent-sky); }
.panel-header h3.mint::before { background:var(--accent-mint); }
.panel-header h3.lavender::before { background:var(--accent-lavender); }
.panel-header h3.coral::before { background:var(--accent-coral); }
.panel-body { padding:16px; }

/* ORDER HEADER INFO */
.order-header-info { display:flex; gap:16px; flex-wrap:wrap; }
.order-header-block { flex:1; min-width:140px; }
.order-header-block label { font-size:9px; font-weight:700; color:var(--text-tertiary); text-transform:uppercase; letter-spacing:0.08em; display:block; margin-bottom:4px; }
.order-header-block .value { font-size:14px; font-weight:700; color:var(--text-primary); font-family:'DM Sans',sans-serif; }
.order-header-block .value.id { color:var(--accent-sky); font-size:18px; }

/* STATUS BADGE LARGE */
.status-badge-lg {
    display:inline-flex; align-items:center; gap:6px; padding:6px 14px;
    font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;
    border-radius:20px;
}
.status-badge-lg.pendiente { background:var(--pastel-cream); color:var(--accent-cream); }
.status-badge-lg.confirmado { background:var(--pastel-sky); color:var(--accent-sky); }
.status-badge-lg.en_preparacion { background:var(--pastel-lavender); color:var(--accent-lavender); }
.status-badge-lg.enviado { background:var(--pastel-mint); color:var(--accent-mint); }
.status-badge-lg.entregado { background:var(--pastel-sage); color:var(--accent-sage); }
.status-badge-lg.cancelado { background:var(--pastel-coral); color:var(--accent-coral); }

/* TIMELINE */
.timeline { display:flex; flex-direction:column; gap:0; position:relative; padding-left:20px; }
.timeline::before { content:''; position:absolute; left:7px; top:8px; bottom:8px; width:2px; background:var(--border-light); }
.timeline-step { display:flex; align-items:flex-start; gap:12px; padding:10px 0; position:relative; }
.timeline-dot {
    width:16px; height:16px; border-radius:50%; background:var(--border-light);
    border:3px solid var(--surface); position:absolute; left:-20px; top:12px;
    z-index:2; transition:all 0.3s ease;
}
.timeline-step.active .timeline-dot { background:var(--accent-sky); box-shadow:0 0 0 4px var(--pastel-sky); }
.timeline-step.completed .timeline-dot { background:var(--accent-mint); box-shadow:0 0 0 4px var(--pastel-mint); }
.timeline-step.cancelled .timeline-dot { background:var(--accent-coral); box-shadow:0 0 0 4px var(--pastel-coral); }
.timeline-content { flex:1; }
.timeline-title { font-weight:700; font-size:12px; color:var(--text-primary); }
.timeline-desc { font-size:11px; color:var(--text-secondary); margin-top:2px; }
.timeline-date { font-size:10px; color:var(--text-tertiary); font-weight:600; margin-top:2px; }

/* PRODUCT LIST */
.product-list { display:flex; flex-direction:column; gap:8px; }
.product-row {
    display:flex; align-items:center; gap:12px; padding:10px 12px;
    background:var(--bg-soft); border-radius:var(--radius-sm); border:1px solid var(--border-light);
    transition:all 0.2s ease;
}
.product-row:hover { background:var(--surface); box-shadow:var(--shadow-sm); transform:translateX(2px); }
.product-img {
    width:48px; height:48px; border-radius:10px; background:linear-gradient(135deg,#f5f5f5,#e8e8e8);
    display:flex; align-items:center; justify-content:center; flex-shrink:0; overflow:hidden;
}
.product-img img { width:100%; height:100%; object-fit:cover; }
.product-img .material-symbols-rounded { color:#ccc; font-size:24px; }
.product-details { flex:1; min-width:0; }
.product-name { font-weight:700; font-size:13px; color:var(--text-primary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.product-meta { font-size:10px; color:var(--text-tertiary); font-weight:600; margin-top:2px; }
.product-price { font-family:'DM Sans',sans-serif; font-size:13px; font-weight:700; color:var(--accent-coral); }
.product-qty { font-size:11px; color:var(--text-secondary); font-weight:600; background:var(--pastel-sky); padding:2px 8px; border-radius:6px; }

/* SUMMARY BOX */
.summary-row { display:flex; justify-content:space-between; padding:8px 0; font-size:12px; border-bottom:1px solid var(--border-light); }
.summary-row:last-child { border-bottom:none; }
.summary-row.total { padding:12px 0; margin-top:4px; border-top:2px solid var(--border); border-bottom:none; }
.summary-label { color:var(--text-secondary); font-weight:600; }
.summary-value { font-weight:700; color:var(--text-primary); }
.summary-row.total .summary-value { font-family:'DM Sans',sans-serif; font-size:18px; color:var(--accent-coral); }

/* INFO BOXES */
.info-box { display:flex; align-items:flex-start; gap:10px; padding:12px; background:var(--bg-soft); border-radius:var(--radius-sm); margin-bottom:8px; border:1px solid var(--border-light); }
.info-box:last-child { margin-bottom:0; }
.info-box-icon { width:32px; height:32px; border-radius:8px; display:flex; align-items:center; justify-content:center; flex-shrink:0; font-size:14px; }
.info-box-icon.sky { background:var(--pastel-sky); color:var(--accent-sky); }
.info-box-icon.mint { background:var(--pastel-mint); color:var(--accent-mint); }
.info-box-icon.lavender { background:var(--pastel-lavender); color:var(--accent-lavender); }
.info-box-content { flex:1; }
.info-box-label { font-size:9px; font-weight:700; color:var(--text-tertiary); text-transform:uppercase; letter-spacing:0.06em; margin-bottom:2px; }
.info-box-value { font-size:12px; font-weight:700; color:var(--text-primary); }

/* ACTION BUTTONS */
.action-group { display:flex; gap:10px; margin-top:12px; }
.btn-action {
    display:inline-flex; align-items:center; gap:6px; padding:10px 20px;
    font-size:11px; font-weight:700; letter-spacing:0.06em; text-transform:uppercase;
    border:none; border-radius:var(--radius-sm); cursor:pointer;
    transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1); text-decoration:none;
    font-family:'Plus Jakarta Sans',sans-serif; justify-content:center; flex:1;
}
.btn-action.primary {
    background:linear-gradient(135deg,var(--pastel-lavender),var(--pastel-sky));
    color:var(--accent-lavender); box-shadow:0 4px 12px rgba(123,31,162,0.15);
}
.btn-action.primary:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(123,31,162,0.25); }
.btn-action.mint {
    background:var(--pastel-mint); color:var(--accent-mint); border:1px solid var(--pastel-mint-dark);
}
.btn-action.mint:hover { transform:translateY(-2px); box-shadow:0 6px 16px rgba(56,142,60,0.18); }
.btn-action.coral {
    background:var(--pastel-coral); color:var(--accent-coral); border:1px solid var(--pastel-coral-dark);
}
.btn-action.coral:hover { transform:translateY(-2px); box-shadow:0 6px 16px rgba(194,24,89,0.18); }
.btn-action:disabled { opacity:0.5; cursor:not-allowed; transform:none !important; box-shadow:none !important; }

/* TOAST */
.toast-container { position:fixed; top:24px; right:24px; z-index:9999; display:flex; flex-direction:column; gap:10px; pointer-events:none; }
.toast-item {
    background:var(--surface); border:1px solid var(--border-light); border-radius:var(--radius-md);
    padding:14px 20px; display:flex; align-items:center; gap:12px;
    box-shadow:var(--shadow-lg); animation:slideInToast 0.4s cubic-bezier(0.34,1.56,0.64,1);
    font-size:12px; font-weight:600; min-width:300px; border-left:4px solid var(--accent-sky);
    font-family:'Plus Jakarta Sans',sans-serif; pointer-events:auto;
}
.toast-item.success { border-left-color:var(--accent-mint); }
.toast-item.error { border-left-color:var(--accent-coral); }
@keyframes slideInToast { from{transform:translateX(120%);opacity:0;} to{transform:translateX(0);opacity:1;} }

/* ANIMATIONS */
@keyframes fadeUp { from{opacity:0;transform:translateY(12px);} to{opacity:1;transform:translateY(0);} }
.anim-fade-up { animation:fadeUp 0.5s ease forwards; opacity:0; }
.delay-1 { animation-delay:0.06s; } .delay-2 { animation-delay:0.12s; } .delay-3 { animation-delay:0.18s; }

/* RESPONSIVE */
@media (max-width:1024px) { .detail-grid { grid-template-columns:1fr; } }
@media (max-width:768px) {
    .main-content { padding:12px 16px; }
    .welcome-section { flex-direction:column; gap:12px; text-align:center; }
    .order-header-info { flex-direction:column; gap:8px; }
    .action-group { flex-direction:column; }
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

<div class="layout-wrapper">
    <%@ include file="/includes/sidebar.jsp" %>
    <main class="main-content">

        <!-- Welcome -->
        <div class="welcome-section">
            <div class="welcome-content">
                <h1 class="welcome-title">Detalle del Pedido <span>#${pedido.id}</span></h1>
                <p class="welcome-subtitle">Información completa del pedido y seguimiento de estado</p>
            </div>
            <a href="<%= ctx %>/admin/pedidos" class="back-btn">
                <span class="material-symbols-rounded" style="font-size:16px;">arrow_back</span> Volver a pedidos
            </a>
        </div>

        <div class="detail-grid">
            <!-- LEFT COLUMN -->
            <div class="detail-left">
                <!-- Order Info -->
                <div class="panel anim-fade-up delay-1">
                    <div class="panel-header">
                        <h3><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-sky);">receipt_long</span> Información del Pedido</h3>
                        <c:set var="estadoClass" value="pendiente"/>
                        <c:choose>
                            <c:when test="${fn:contains(fn:toLowerCase(pedido.estado),'confirmado')}"><c:set var="estadoClass" value="confirmado"/></c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(pedido.estado),'preparacion')}"><c:set var="estadoClass" value="en_preparacion"/></c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(pedido.estado),'enviad')}"><c:set var="estadoClass" value="enviado"/></c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(pedido.estado),'entregad')}"><c:set var="estadoClass" value="entregado"/></c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(pedido.estado),'cancel')}"><c:set var="estadoClass" value="cancelado"/></c:when>
                        </c:choose>
                        <span class="status-badge-lg ${estadoClass}"><span class="material-symbols-rounded" style="font-size:14px;">
                            <c:choose>
                                <c:when test="${estadoClass == 'entregado'}">check_circle</c:when>
                                <c:when test="${estadoClass == 'enviado'}">local_shipping</c:when>
                                <c:when test="${estadoClass == 'en_preparacion'}">package_2</c:when>
                                <c:when test="${estadoClass == 'cancelado'}">cancel</c:when>
                                <c:otherwise>schedule</c:otherwise>
                            </c:choose>
                        </span> ${pedido.estado}</span>
                    </div>
                    <div class="panel-body">
                        <div class="order-header-info">
                            <div class="order-header-block">
                                <label>Número de Pedido</label>
                                <div class="value id">#${pedido.id}</div>
                            </div>
                            <div class="order-header-block">
                                <label>Fecha</label>
                                <div class="value">${pedido.fechaFormateada != null ? pedido.fechaFormateada : pedido.fecha}</div>
                            </div>
                            <div class="order-header-block">
                                <label>Cliente</label>
                                <div class="value">${pedido.usuarioNombre} ${pedido.usuarioApellido}</div>
                            </div>
                            <div class="order-header-block">
                                <label>Total</label>
                                <div class="value" style="color:var(--accent-coral);">$<fmt:formatNumber value="${pedido.total}" pattern="#,##0" maxFractionDigits="0"/></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Products -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <h3 class="mint"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-mint);">shopping_bag</span> Productos</h3>
                        <span style="font-size:11px;color:var(--text-tertiary);font-weight:600;">${fn:length(pedido.detalles)} productos</span>
                    </div>
                    <div class="panel-body">
                        <div class="product-list">
                            <c:choose>
                                <c:when test="${not empty pedido.detalles}">
                                    <c:forEach var="d" items="${pedido.detalles}">
                                        <div class="product-row">
                                            <div class="product-img">
                                                <c:choose>
                                                    <c:when test="${not empty d.productoImagen}">
                                                        <img src="<%= ctx %>/${d.productoImagen}" alt="${d.productoNombre}" onerror="this.style.display='none'; this.parentElement.innerHTML='<span class=\\'material-symbols-rounded\\'>image</span>';">
                                                    </c:when>
                                                    <c:otherwise><span class="material-symbols-rounded">image</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <div class="product-name">${d.productoNombre}</div>
                                                <div class="product-meta">${d.productoCategoria} ${not empty d.productoMarca ? '— '.concat(d.productoMarca) : ''}</div>
                                            </div>
                                            <span class="product-qty">x${d.cantidad}</span>
                                            <span class="product-price">$<fmt:formatNumber value="${d.subtotal}" pattern="#,##0" maxFractionDigits="0"/></span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align:center;padding:20px;color:var(--text-tertiary);">No hay detalles de productos</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Timeline -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <h3 class="lavender"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-lavender);">timeline</span> Seguimiento del Pedido</h3>
                    </div>
                    <div class="panel-body">
                        <div class="timeline">
                            <c:set var="estadoActual" value="${fn:toLowerCase(pedido.estado)}"/>
                            <c:set var="pasos" value="${['Pendiente','Confirmado','En Preparación','Enviado','Entregado']}"/>
                            <c:set var="iconos" value="${['schedule','check_circle','package_2','local_shipping','check_circle']}"/>
                            <c:set var="descs" value="${['Pedido recibido','Pago confirmado','Empacando productos','En ruta de entrega','Entrega completada']}"/>
                            
                            <c:forEach var="paso" items="${pasos}" varStatus="st">
                                <c:set var="pasoLower" value="${fn:replace(fn:toLowerCase(paso),' ','_')}"/>
                                <c:set var="isActive" value="${fn:contains(estadoActual, pasoLower)}"/>
                                <c:set var="isCompleted" value="${false}"/>
                                <c:set var="isCancelled" value="${fn:contains(estadoActual,'cancel') && st.index > 0}"/>
                                
                                <div class="timeline-step ${isActive ? 'active' : ''} ${isCompleted ? 'completed' : ''} ${isCancelled ? 'cancelled' : ''}">
                                    <div class="timeline-dot"></div>
                                    <div class="timeline-content">
                                        <div class="timeline-title">${paso}</div>
                                        <div class="timeline-desc">${descs[st.index]}</div>
                                        <c:if test="${isActive}">
                                            <div class="timeline-date">Estado actual — ${pedido.fechaFormateada != null ? pedido.fechaFormateada : pedido.fecha}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN -->
            <div class="detail-right">
                <!-- Customer Info -->
                <div class="panel anim-fade-up delay-1">
                    <div class="panel-header">
                        <h3 class="sky"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-sky);">person</span> Cliente</h3>
                    </div>
                    <div class="panel-body">
                        <div class="info-box">
                            <div class="info-box-icon sky"><span class="material-symbols-rounded">person</span></div>
                            <div class="info-box-content">
                                <div class="info-box-label">Nombre</div>
                                <div class="info-box-value">${pedido.usuarioNombre} ${pedido.usuarioApellido}</div>
                            </div>
                        </div>
                        <div class="info-box">
                            <div class="info-box-icon lavender"><span class="material-symbols-rounded">email</span></div>
                            <div class="info-box-content">
                                <div class="info-box-label">Correo</div>
                                <div class="info-box-value">${pedido.usuarioEmail}</div>
                            </div>
                        </div>
                        <div class="info-box">
                            <div class="info-box-icon mint"><span class="material-symbols-rounded">badge</span></div>
                            <div class="info-box-content">
                                <div class="info-box-label">Documento</div>
                                <div class="info-box-value">${pedido.usuarioDocumento}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Shipping Info -->
                <div class="panel anim-fade-up delay-2">
                    <div class="panel-header">
                        <h3 class="mint"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-mint);">local_shipping</span> Envío</h3>
                    </div>
                    <div class="panel-body">
                        <div class="info-box">
                            <div class="info-box-icon mint"><span class="material-symbols-rounded">location_on</span></div>
                            <div class="info-box-content">
                                <div class="info-box-label">Dirección</div>
                                <div class="info-box-value">${not empty pedido.direccionEnvio ? pedido.direccionEnvio : 'No especificada'}</div>
                            </div>
                        </div>
                        <div class="info-box">
                            <div class="info-box-icon sky"><span class="material-symbols-rounded">payments</span></div>
                            <div class="info-box-content">
                                <div class="info-box-label">Método de Pago</div>
                                <div class="info-box-value">${not empty pedido.metodoPago ? pedido.metodoPago : 'No especificado'}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Summary -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <h3 class="coral"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-coral);">payments</span> Resumen</h3>
                    </div>
                    <div class="panel-body">
                        <div class="summary-row">
                            <span class="summary-label">Subtotal</span>
                            <span class="summary-value">$<fmt:formatNumber value="${pedido.subtotal != null ? pedido.subtotal : pedido.total * 0.9}" pattern="#,##0" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Envío</span>
                            <span class="summary-value">$<fmt:formatNumber value="${pedido.costoEnvio != null ? pedido.costoEnvio : 0}" pattern="#,##0" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Impuestos</span>
                            <span class="summary-value">$<fmt:formatNumber value="${pedido.impuestos != null ? pedido.impuestos : pedido.total * 0.1}" pattern="#,##0" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">Total</span>
                            <span class="summary-value">$<fmt:formatNumber value="${pedido.total}" pattern="#,##0" maxFractionDigits="0"/></span>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="panel anim-fade-up delay-3">
                    <div class="panel-header">
                        <h3><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-sky);">settings</span> Acciones</h3>
                    </div>
                    <div class="panel-body">
                        <div class="action-group">
                            <c:if test="${!fn:contains(fn:toLowerCase(pedido.estado),'entregad') && !fn:contains(fn:toLowerCase(pedido.estado),'cancel')}">
                                <form method="post" action="<%= ctx %>/admin/pedidos" style="flex:1;display:flex;">
                                    <input type="hidden" name="accion" value="avanzarEstado">
                                    <input type="hidden" name="id" value="${pedido.id}">
                                    <button type="submit" class="btn-action mint" onclick="return confirm('¿Avanzar el estado de este pedido?');">
                                        <span class="material-symbols-rounded" style="font-size:16px;">arrow_forward</span> Avanzar Estado
                                    </button>
                                </form>
                            </c:if>
                            <c:if test="${fn:contains(fn:toLowerCase(pedido.estado),'entregad') || fn:contains(fn:toLowerCase(pedido.estado),'cancel')}">
                                <button class="btn-action mint" disabled>
                                    <span class="material-symbols-rounded" style="font-size:16px;">check</span> Pedido Finalizado
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
setTimeout(function() {
    document.querySelectorAll('.toast-item').forEach(function(t) {
        t.style.transition='all 0.4s ease'; t.style.opacity='0'; t.style.transform='translateX(120%)';
        setTimeout(function(){ if(t.parentNode)t.parentNode.removeChild(t); },400);
    });
}, 4000);
</script>
</body>
</html>
