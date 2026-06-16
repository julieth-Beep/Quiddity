<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.time.LocalDate" %>
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

    Map<String, Object> resumen = (Map<String, Object>) request.getAttribute("resumen");
    double ingresosPeriodo = resumen != null && resumen.get("ingresosTotales") != null ? ((Number) resumen.get("ingresosTotales")).doubleValue() : 0;
    int pedidosPeriodo = resumen != null && resumen.get("totalPedidos") != null ? ((Number) resumen.get("totalPedidos")).intValue() : 0;
    int clientesPeriodo = resumen != null && resumen.get("totalClientes") != null ? ((Number) resumen.get("totalClientes")).intValue() : 0;
    double ticketPromedio = pedidosPeriodo > 0 ? ingresosPeriodo / pedidosPeriodo : 0;

    String desdeStr = (String) request.getAttribute("filtroDesde");
    String hastaStr = (String) request.getAttribute("filtroHasta");
    if (desdeStr == null) desdeStr = LocalDate.now().withDayOfMonth(1).toString();
    if (hastaStr == null) hastaStr = LocalDate.now().toString();

    // Arrays de colores para JSP 2.2 (Tomcat 7) — no usar sintaxis ${['a','b']}
    String[] barColors = {"sky", "mint", "lavender", "cream", "coral", "sage"};
    request.setAttribute("barColors", barColors);
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Estadísticas — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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

/* DATE FILTER BAR */
.date-bar {
    display:flex; align-items:center; gap:12px; padding:12px 16px;
    background:var(--surface); border-radius:var(--radius-md); border:1px solid var(--border-light);
    box-shadow:var(--shadow-sm); flex-wrap:wrap;
}
.date-bar form { display:flex; gap:10px; align-items:center; flex-wrap:wrap; flex:1; }
.date-bar label { font-size:10px; font-weight:700; color:var(--text-tertiary); text-transform:uppercase; letter-spacing:0.06em; }
.date-input {
    padding:8px 12px; border:1.5px solid var(--border); border-radius:var(--radius-sm);
    font-size:12px; font-weight:600; color:var(--text-primary); background:var(--bg-soft);
    font-family:'Plus Jakarta Sans',sans-serif; transition:all 0.2s;
}
.date-input:focus { outline:none; border-color:var(--accent-sky); box-shadow:0 0 0 4px rgba(25,118,210,0.08); }
.btn-action {
    display:inline-flex; align-items:center; gap:6px; padding:8px 16px;
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
.btn-action.export {
    background:var(--pastel-mint); color:var(--accent-mint); border:1px solid var(--pastel-mint-dark);
}
.btn-action.export:hover { transform:translateY(-2px); box-shadow:0 6px 16px rgba(56,142,60,0.18); }

/* KPI CARDS */
.kpi-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; }
.kpi-card {
    background:var(--surface); border-radius:var(--radius-md); padding:16px;
    box-shadow:var(--shadow-sm); border:1px solid var(--border-light);
    transition:all 0.3s ease; position:relative; overflow:hidden;
}
.kpi-card:hover { transform:translateY(-3px); box-shadow:var(--shadow); border-color:var(--pastel-sky-dark); }
.kpi-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:var(--accent-sky); transform:scaleX(0); transform-origin:left; transition:transform 0.3s ease; }
.kpi-card:hover::before { transform:scaleX(1); }
.kpi-card.mint::before { background:var(--accent-mint); }
.kpi-card.lavender::before { background:var(--accent-lavender); }
.kpi-card.cream::before { background:var(--accent-cream); }

.kpi-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
.kpi-label { font-size:10px; font-weight:700; color:var(--text-secondary); text-transform:uppercase; letter-spacing:0.06em; }
.kpi-icon { width:32px; height:32px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:16px; }
.kpi-icon.sky { background:var(--pastel-sky); color:var(--accent-sky); }
.kpi-icon.mint { background:var(--pastel-mint); color:var(--accent-mint); }
.kpi-icon.lavender { background:var(--pastel-lavender); color:var(--accent-lavender); }
.kpi-icon.cream { background:var(--pastel-cream); color:var(--accent-cream); }

.kpi-value { font-family:'DM Sans',sans-serif; font-size:26px; font-weight:700; color:var(--text-primary); line-height:1; letter-spacing:-0.5px; }
.kpi-desc { font-size:10px; color:var(--text-tertiary); font-weight:600; margin-top:4px; }

/* CHARTS GRID */
.charts-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
.chart-panel {
    background:var(--surface); border-radius:var(--radius-md); border:1px solid var(--border-light);
    box-shadow:var(--shadow-sm); overflow:hidden; transition:all 0.3s ease;
}
.chart-panel:hover { box-shadow:var(--shadow); border-color:var(--border); }
.chart-header { padding:14px 16px; border-bottom:1px solid var(--border-light); display:flex; align-items:center; justify-content:space-between; }
.chart-header h3 { font-family:'DM Sans',sans-serif; font-size:14px; font-weight:700; margin:0; display:flex; align-items:center; gap:8px; }
.chart-header h3::before { content:''; width:3px; height:14px; border-radius:2px; background:var(--accent-sky); }
.chart-header h3.mint::before { background:var(--accent-mint); }
.chart-header h3.lavender::before { background:var(--accent-lavender); }
.chart-header h3.coral::before { background:var(--accent-coral); }
.chart-body { padding:16px; }

/* BAR CHART CSS */
.bar-chart { display:flex; flex-direction:column; gap:10px; }
.bar-row { display:flex; align-items:center; gap:10px; }
.bar-label { width:100px; font-size:11px; font-weight:600; color:var(--text-secondary); text-align:right; flex-shrink:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.bar-track { flex:1; height:24px; background:var(--bg-soft); border-radius:6px; position:relative; overflow:hidden; }
.bar-fill { height:100%; border-radius:6px; transition:width 1s cubic-bezier(0.34,1.56,0.64,1); position:relative; }
.bar-fill.sky { background:linear-gradient(90deg,var(--pastel-sky-dark),var(--accent-sky)); }
.bar-fill.mint { background:linear-gradient(90deg,var(--pastel-mint-dark),var(--accent-mint)); }
.bar-fill.lavender { background:linear-gradient(90deg,var(--pastel-lavender-dark),var(--accent-lavender)); }
.bar-fill.cream { background:linear-gradient(90deg,var(--pastel-cream-dark),var(--accent-cream)); }
.bar-fill.coral { background:linear-gradient(90deg,var(--pastel-coral-dark),var(--accent-coral)); }
.bar-fill.sage { background:linear-gradient(90deg,var(--pastel-sage-dark),var(--accent-sage)); }
.bar-value { position:absolute; right:8px; top:50%; transform:translateY(-50%); font-size:10px; font-weight:700; color:white; text-shadow:0 1px 2px rgba(0,0,0,0.2); }
.bar-total { width:50px; font-size:11px; font-weight:700; color:var(--text-primary); text-align:right; flex-shrink:0; font-family:'DM Sans',sans-serif; }

/* TOP LIST */
.top-list { display:flex; flex-direction:column; gap:6px; }
.top-item {
    display:flex; align-items:center; gap:10px; padding:10px 12px;
    background:var(--bg-soft); border-radius:var(--radius-sm); border:1px solid var(--border-light);
    transition:all 0.2s ease;
}
.top-item:hover { background:var(--surface); box-shadow:var(--shadow-sm); transform:translateX(2px); }
.top-rank {
    width:24px; height:24px; border-radius:6px; display:flex; align-items:center; justify-content:center;
    font-family:'DM Sans',sans-serif; font-size:11px; font-weight:700; flex-shrink:0;
    background:white; color:var(--text-tertiary); border:1px solid var(--border-light);
}
.top-rank.gold { background:#fff8e1; color:#f9a825; border-color:#ffe082; }
.top-rank.silver { background:#eceff1; color:#607d8b; border-color:#cfd8dc; }
.top-rank.bronze { background:#fff3e0; color:#e65100; border-color:#ffcc80; }
.top-info { flex:1; min-width:0; }
.top-name { font-weight:700; font-size:12px; color:var(--text-primary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.top-cat { font-size:9px; color:var(--text-tertiary); text-transform:uppercase; letter-spacing:0.03em; font-weight:600; }
.top-bar-wrap { width:80px; height:4px; background:var(--border-light); border-radius:2px; overflow:hidden; }
.top-bar-fill { height:100%; border-radius:2px; transition:width 1s ease; }
.top-bar-fill.sky { background:var(--accent-sky); }
.top-bar-fill.mint { background:var(--accent-mint); }
.top-bar-fill.lavender { background:var(--accent-lavender); }
.top-bar-fill.coral { background:var(--accent-coral); }
.top-sold { font-size:11px; font-weight:700; color:var(--text-secondary); flex-shrink:0; font-family:'DM Sans',sans-serif; }

/* NO SALES LIST */
.no-sales-list { display:flex; flex-direction:column; gap:6px; max-height:280px; overflow-y:auto; }
.no-sales-item {
    display:flex; align-items:center; gap:8px; padding:8px 10px;
    background:var(--bg-soft); border-radius:var(--radius-sm); border:1px solid var(--border-light);
    font-size:11px; font-weight:600; color:var(--text-secondary);
}
.no-sales-item .material-symbols-rounded { font-size:14px; color:var(--accent-cream); }
.no-sales-name { flex:1; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.no-sales-badge { font-size:9px; font-weight:700; color:var(--accent-cream); background:var(--pastel-cream); padding:2px 8px; border-radius:10px; }

/* EMPTY */
.empty-state { text-align:center; padding:40px 20px; color:var(--text-secondary); }
.empty-state-icon { width:48px; height:48px; margin:0 auto 12px; border-radius:50%; background:var(--pastel-sky); display:flex; align-items:center; justify-content:center; color:var(--accent-sky); font-size:20px; }

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
@media (max-width:1280px) { .kpi-grid { grid-template-columns:repeat(2,1fr); } .charts-grid { grid-template-columns:1fr; } }
@media (max-width:768px) {
    .kpi-grid { grid-template-columns:1fr; } .main-content { padding:12px 16px; }
    .welcome-section { flex-direction:column; gap:12px; text-align:center; }
    .date-bar form { flex-direction:column; align-items:stretch; width:100%; }
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
                <h1 class="welcome-title">Estadísticas <span>Admin</span></h1>
                <p class="welcome-subtitle">Análisis de ventas, productos y rendimiento del negocio</p>
            </div>
        </div>

        <!-- Date Filter -->
        <div class="date-bar anim-fade-up delay-1">
            <form method="get" action="<%= ctx %>/admin/estadisticas">
                <div style="display:flex;align-items:center;gap:8px;">
                    <label>Desde</label>
                    <input type="date" name="desde" class="date-input" value="<%= desdeStr %>">
                </div>
                <div style="display:flex;align-items:center;gap:8px;">
                    <label>Hasta</label>
                    <input type="date" name="hasta" class="date-input" value="<%= hastaStr %>">
                </div>
                <button type="submit" class="btn-action primary">
                    <span class="material-symbols-rounded" style="font-size:16px;">filter_alt</span> Aplicar
                </button>
                <a href="<%= ctx %>/admin/estadisticas" class="btn-action secondary">
                    <span class="material-symbols-rounded" style="font-size:16px;">refresh</span> Este Mes
                </a>
            </form>
            <button class="btn-action export" onclick="exportarExcel()">
                <span class="material-symbols-rounded" style="font-size:16px;">download</span> Exportar Excel
            </button>
        </div>

        <!-- KPIs -->
        <div class="kpi-grid anim-fade-up delay-1">
            <div class="kpi-card">
                <div class="kpi-header">
                    <span class="kpi-label">Ingresos del Período</span>
                    <div class="kpi-icon sky"><span class="material-symbols-rounded">payments</span></div>
                </div>
                <div class="kpi-value">$<%= String.format("%,.0f", ingresosPeriodo) %></div>
                <div class="kpi-desc">Total acumulado en ventas</div>
            </div>
            <div class="kpi-card mint">
                <div class="kpi-header">
                    <span class="kpi-label">Pedidos Realizados</span>
                    <div class="kpi-icon mint"><span class="material-symbols-rounded">shopping_bag</span></div>
                </div>
                <div class="kpi-value"><%= String.format("%,d", pedidosPeriodo) %></div>
                <div class="kpi-desc">Transacciones completadas</div>
            </div>
            <div class="kpi-card lavender">
                <div class="kpi-header">
                    <span class="kpi-label">Clientes Únicos</span>
                    <div class="kpi-icon lavender"><span class="material-symbols-rounded">group</span></div>
                </div>
                <div class="kpi-value"><%= String.format("%,d", clientesPeriodo) %></div>
                <div class="kpi-desc">Compradores distintos</div>
            </div>
            <div class="kpi-card cream">
                <div class="kpi-header">
                    <span class="kpi-label">Ticket Promedio</span>
                    <div class="kpi-icon cream"><span class="material-symbols-rounded">receipt</span></div>
                </div>
                <div class="kpi-value">$<%= String.format("%,.0f", ticketPromedio) %></div>
                <div class="kpi-desc">Promedio por transacción</div>
            </div>
        </div>

        <!-- Charts Grid -->
        <div class="charts-grid">
            <!-- Top Products -->
            <div class="chart-panel anim-fade-up delay-2">
                <div class="chart-header">
                    <h3 class="mint"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-mint);">trending_up</span> Top 10 Productos Más Vendidos</h3>
                    <span style="font-size:11px;color:var(--text-tertiary);font-weight:600;">Período seleccionado</span>
                </div>
                <div class="chart-body">
                    <c:choose>
                        <c:when test="${not empty topVendidos}">
                            <div class="top-list">
                                <c:set var="maxVentas" value="0"/>
                                <c:forEach var="tv" items="${topVendidos}">
                                    <c:if test="${tv.totalVendido > maxVentas}"><c:set var="maxVentas" value="${tv.totalVendido}"/></c:if>
                                </c:forEach>
                                <c:forEach var="tv" items="${topVendidos}" varStatus="st">
                                    <c:set var="pct" value="${maxVentas > 0 ? (tv.totalVendido / maxVentas) * 100 : 0}"/>
                                    <c:set var="rankClass" value="${st.index == 0 ? 'gold' : (st.index == 1 ? 'silver' : (st.index == 2 ? 'bronze' : ''))}"/>
                                    <c:set var="colorIdx" value="${st.index % 5}"/>
                                    <div class="top-item">
                                        <div class="top-rank ${rankClass}">${st.index + 1}</div>
                                        <div class="top-info">
                                            <div class="top-name">${tv.nombre}</div>
                                            <div class="top-cat">${tv.categoria != null ? tv.categoria : 'Sin categoría'}</div>
                                        </div>
                                        <div class="top-bar-wrap">
                                            <div class="top-bar-fill ${barColors[st.index % 5]}" style="width:${pct}%"></div>
                                        </div>
                                        <span class="top-sold">${tv.totalVendido} uds.</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon"><span class="material-symbols-rounded">trending_up</span></div>
                                <p>Sin datos de ventas en este período</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Sales by Category -->
            <div class="chart-panel anim-fade-up delay-2">
                <div class="chart-header">
                    <h3 class="lavender"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-lavender);">pie_chart</span> Ventas por Categoría</h3>
                </div>
                <div class="chart-body">
                    <c:choose>
                        <c:when test="${not empty ventasPorCategoria}">
                            <c:set var="totalCatVentas" value="0"/>
                            <c:forEach var="vc" items="${ventasPorCategoria}">
                                <c:set var="totalCatVentas" value="${totalCatVentas + vc.totalVentas}"/>
                            </c:forEach>
                            <div class="bar-chart">
                                <c:forEach var="vc" items="${ventasPorCategoria}" varStatus="st">
                                    <c:set var="pct" value="${totalCatVentas > 0 ? (vc.totalVentas / totalCatVentas) * 100 : 0}"/>
                                    <div class="bar-row">
                                        <span class="bar-label">${vc.categoria}</span>
                                        <div class="bar-track">
                                            <div class="bar-fill ${barColors[st.index % 6]}" style="width:0%;" data-width="${pct}">
                                                <c:if test="${pct > 15}">
                                                    <span class="bar-value"><fmt:formatNumber value="${pct}" pattern="#" maxFractionDigits="0"/>%</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <span class="bar-total">$<fmt:formatNumber value="${vc.totalVentas}" pattern="#,##0" maxFractionDigits="0"/></span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon"><span class="material-symbols-rounded">pie_chart</span></div>
                                <p>Sin datos por categoría en este período</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Products Without Sales -->
            <div class="chart-panel anim-fade-up delay-3">
                <div class="chart-header">
                    <h3 class="coral"><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-coral);">pause_circle</span> Sin Ventas (Últimos 30 días)</h3>
                    <span style="font-size:11px;color:var(--text-tertiary);font-weight:600;">${fn:length(sinVentas)} productos</span>
                </div>
                <div class="chart-body">
                    <c:choose>
                        <c:when test="${not empty sinVentas}">
                            <div class="no-sales-list">
                                <c:forEach var="sv" items="${sinVentas}" end="9">
                                    <div class="no-sales-item">
                                        <span class="material-symbols-rounded">inventory_2</span>
                                        <span class="no-sales-name">${sv.nombre}</span>
                                        <span class="no-sales-badge">Sin ventas</span>
                                    </div>
                                </c:forEach>
                                <c:if test="${fn:length(sinVentas) > 10}">
                                    <div style="text-align:center;padding:8px;font-size:11px;color:var(--text-tertiary);font-weight:600;">
                                        +${fn:length(sinVentas) - 10} productos más...
                                    </div>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon" style="background:var(--pastel-mint);color:var(--accent-mint);"><span class="material-symbols-rounded">check_circle</span></div>
                                <p style="color:var(--accent-mint);font-weight:700;">¡Todos los productos tienen ventas!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Summary Table -->
            <div class="chart-panel anim-fade-up delay-3">
                <div class="chart-header">
                    <h3><span class="material-symbols-rounded" style="font-size:16px;color:var(--accent-sky);">table_chart</span> Resumen del Período</h3>
                </div>
                <div class="chart-body">
                    <div style="display:flex;flex-direction:column;gap:12px;">
                        <div style="display:flex;justify-content:space-between;align-items:center;padding:12px;background:var(--pastel-sky);border-radius:var(--radius-sm);">
                            <span style="font-size:12px;font-weight:700;color:var(--accent-sky);"><span class="material-symbols-rounded" style="font-size:16px;vertical-align:middle;margin-right:6px;">calendar_today</span> Período</span>
                            <span style="font-size:12px;font-weight:700;color:var(--text-primary);"><%= desdeStr %> — <%= hastaStr %></span>
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
                            <div style="padding:12px;background:var(--bg-soft);border-radius:var(--radius-sm);border:1px solid var(--border-light);text-align:center;">
                                <div style="font-size:9px;font-weight:700;color:var(--text-tertiary);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Ingresos</div>
                                <div style="font-family:'DM Sans',sans-serif;font-size:18px;font-weight:700;color:var(--accent-mint);">$<%= String.format("%,.0f", ingresosPeriodo) %></div>
                            </div>
                            <div style="padding:12px;background:var(--bg-soft);border-radius:var(--radius-sm);border:1px solid var(--border-light);text-align:center;">
                                <div style="font-size:9px;font-weight:700;color:var(--text-tertiary);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Pedidos</div>
                                <div style="font-family:'DM Sans',sans-serif;font-size:18px;font-weight:700;color:var(--accent-sky);"><%= String.format("%,d", pedidosPeriodo) %></div>
                            </div>
                            <div style="padding:12px;background:var(--bg-soft);border-radius:var(--radius-sm);border:1px solid var(--border-light);text-align:center;">
                                <div style="font-size:9px;font-weight:700;color:var(--text-tertiary);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Clientes</div>
                                <div style="font-family:'DM Sans',sans-serif;font-size:18px;font-weight:700;color:var(--accent-lavender);"><%= String.format("%,d", clientesPeriodo) %></div>
                            </div>
                            <div style="padding:12px;background:var(--bg-soft);border-radius:var(--radius-sm);border:1px solid var(--border-light);text-align:center;">
                                <div style="font-size:9px;font-weight:700;color:var(--text-tertiary);text-transform:uppercase;letter-spacing:0.06em;margin-bottom:4px;">Ticket Medio</div>
                                <div style="font-family:'DM Sans',sans-serif;font-size:18px;font-weight:700;color:var(--accent-cream);">$<%= String.format("%,.0f", ticketPromedio) %></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
// Animate bar charts on load
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.bar-fill').forEach(function(bar) {
        var targetWidth = bar.getAttribute('data-width') || bar.style.width;
        bar.style.width = '0%';
        setTimeout(function() { bar.style.width = targetWidth + '%'; }, 100);
    });
    document.querySelectorAll('.top-bar-fill').forEach(function(bar) {
        var targetWidth = bar.style.width;
        bar.style.width = '0%';
        setTimeout(function() { bar.style.width = targetWidth; }, 100);
    });
});

function exportarExcel() {
    alert('Exportación a Excel — Próximamente disponible');
}

setTimeout(function() {
    document.querySelectorAll('.toast-item').forEach(function(t) {
        t.style.transition='all 0.4s ease'; t.style.opacity='0'; t.style.transform='translateX(120%)';
        setTimeout(function(){ if(t.parentNode)t.parentNode.removeChild(t); },400);
    });
}, 4000);
</script>
</body>
</html>