<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctx = request.getContextPath();
    com.quiddity.model.Usuario usuario = (com.quiddity.model.Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Finalizar Compra — Quiddity</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root {
    --ink:      #1a1209;
    --muted:    #6b5e52;
    --faint:    #c8beb6;
    --bg:       #faf8f5;
    --surface:  #ffffff;
    --border:   #e8e2db;
    --rose:     #9a3a5a;
    --rose-dark:#7a2e48;
    --rose-soft:#f7eef2;
    --mint:     #3a7a5a;
    --mint-soft:#eef7f2;
    --radius:   10px;
    --shadow:   0 2px 12px rgba(26,18,9,0.07);
}
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: var(--bg); color: var(--ink);
    font-size: 14px; line-height: 1.5;
    -webkit-font-smoothing: antialiased;
}

/* ── NAVBAR ── */
.navbar {
    background: var(--surface); border-bottom: 1px solid var(--border);
    padding: 0 40px; height: 64px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 100;
}
.navbar-brand {
    font-family: 'Cormorant Garamond', serif;
    font-size: 22px; font-weight: 600; letter-spacing: 0.15em;
    color: var(--ink); text-decoration: none; text-transform: uppercase;
}
.navbar-steps {
    display: flex; align-items: center; gap: 8px;
    font-size: 12px; font-weight: 600; letter-spacing: 0.06em; text-transform: uppercase;
}
.step { color: var(--faint); display: flex; align-items: center; gap: 6px; }
.step.active { color: var(--rose); }
.step.done { color: var(--mint); }
.step-dot {
    width: 22px; height: 22px; border-radius: 50%;
    border: 1.5px solid currentColor;
    display: flex; align-items: center; justify-content: center;
    font-size: 10px; font-weight: 700; flex-shrink: 0;
}
.step-divider { width: 24px; height: 1px; background: var(--border); }

/* ── LAYOUT ── */
.checkout-layout {
    max-width: 1100px; margin: 0 auto;
    display: grid; grid-template-columns: 1fr 380px;
    gap: 32px; padding: 40px 24px;
    align-items: start;
}
@media (max-width: 800px) {
    .checkout-layout { grid-template-columns: 1fr; padding: 20px 16px; }
}

/* ── PANEL BASE ── */
.panel {
    background: var(--surface); border: 1px solid var(--border);
    border-radius: var(--radius); box-shadow: var(--shadow);
    overflow: hidden;
}
.panel-header {
    padding: 20px 24px; border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 10px;
}
.panel-header h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 19px; font-weight: 600; color: var(--ink);
}
.panel-icon {
    width: 34px; height: 34px; border-radius: 8px;
    background: var(--rose-soft); color: var(--rose);
    display: flex; align-items: center; justify-content: center;
    font-size: 16px; flex-shrink: 0;
}
.panel-body { padding: 24px; }

/* ── SECCIONES DENTRO DEL PANEL IZQUIERDO ── */
.section-title {
    font-size: 11px; font-weight: 700; letter-spacing: 0.1em;
    text-transform: uppercase; color: var(--muted);
    margin-bottom: 14px;
}

/* ── DIRECCIÓN ── */
.dir-list { display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px; }
.dir-option { display: none; }
.dir-label {
    display: flex; align-items: flex-start; gap: 12px;
    padding: 14px 16px; border: 1.5px solid var(--border);
    border-radius: var(--radius); cursor: pointer; transition: all 0.2s;
    background: var(--bg);
}
.dir-option:checked + .dir-label {
    border-color: var(--rose); background: var(--rose-soft);
}
.dir-label:hover { border-color: var(--rose); }
.dir-radio-circle {
    width: 18px; height: 18px; border-radius: 50%;
    border: 1.5px solid var(--faint); flex-shrink: 0; margin-top: 2px;
    display: flex; align-items: center; justify-content: center;
    transition: all 0.2s;
}
.dir-option:checked + .dir-label .dir-radio-circle {
    border-color: var(--rose); background: var(--rose);
}
.dir-option:checked + .dir-label .dir-radio-circle::after {
    content: ''; width: 6px; height: 6px; border-radius: 50%; background: white;
}
.dir-info { flex: 1; }
.dir-name {
    font-size: 13px; font-weight: 600; color: var(--ink); margin-bottom: 3px;
}
.dir-text { font-size: 12px; color: var(--muted); line-height: 1.4; }
.dir-badge {
    font-size: 10px; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase;
    padding: 2px 8px; border-radius: 20px;
    background: var(--rose-soft); color: var(--rose); margin-left: auto; flex-shrink: 0;
}

/* ── NUEVA DIRECCIÓN ── */
.new-dir-toggle {
    display: flex; align-items: center; gap: 8px;
    font-size: 13px; font-weight: 600; color: var(--rose);
    cursor: pointer; padding: 10px 0; transition: opacity 0.2s;
    background: none; border: none; font-family: inherit;
}
.new-dir-toggle:hover { opacity: 0.75; }
.new-dir-form {
    display: none; margin-top: 16px;
    padding: 20px; background: var(--bg);
    border: 1px dashed var(--border); border-radius: var(--radius);
}
.new-dir-form.open { display: block; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.form-group { display: flex; flex-direction: column; gap: 5px; margin-bottom: 12px; }
.form-group.full { grid-column: 1 / -1; }
.form-group label {
    font-size: 11px; font-weight: 700; color: var(--muted);
    text-transform: uppercase; letter-spacing: 0.06em;
}
.form-group input, .form-group select, .form-group textarea {
    padding: 10px 12px; border: 1.5px solid var(--border);
    border-radius: 8px; font-size: 13px; color: var(--ink);
    background: var(--surface); font-family: inherit;
    transition: border-color 0.2s;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
    outline: none; border-color: var(--rose);
    box-shadow: 0 0 0 3px rgba(154,58,90,0.08);
}
.checkbox-row {
    display: flex; align-items: center; gap: 8px;
    font-size: 13px; color: var(--muted); cursor: pointer; margin-top: 4px;
}
.checkbox-row input { accent-color: var(--rose); width: 15px; height: 15px; }

/* ── SEPARADOR ── */
.section-sep {
    border: none; border-top: 1px solid var(--border);
    margin: 24px 0;
}

/* ── MÉTODO DE PAGO ── */
.pago-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
.pago-radio { display: none; }
.pago-label {
    display: flex; flex-direction: column; align-items: center; gap: 8px;
    padding: 16px 10px; border: 1.5px solid var(--border);
    border-radius: var(--radius); cursor: pointer; transition: all 0.2s;
    background: var(--bg); text-align: center;
}
.pago-radio:checked + .pago-label {
    border-color: var(--rose); background: var(--rose-soft);
}
.pago-label:hover { border-color: var(--rose); }
.pago-icon { font-size: 24px; }
.pago-name { font-size: 12px; font-weight: 700; color: var(--ink); }
.pago-desc { font-size: 11px; color: var(--muted); }

/* ── NOTAS ── */
.notes-area {
    width: 100%; padding: 12px; border: 1.5px solid var(--border);
    border-radius: 8px; font-size: 13px; color: var(--ink);
    background: var(--bg); font-family: inherit; resize: vertical;
    min-height: 80px; transition: border-color 0.2s;
}
.notes-area:focus { outline: none; border-color: var(--rose); box-shadow: 0 0 0 3px rgba(154,58,90,0.08); }

/* ── RESUMEN (columna derecha) ── */
.summary-panel { position: sticky; top: 80px; }
.summary-items { display: flex; flex-direction: column; gap: 14px; margin-bottom: 20px; }
.summary-item { display: flex; align-items: center; gap: 12px; }
.summary-img {
    width: 52px; height: 52px; border-radius: 8px;
    object-fit: cover; border: 1px solid var(--border); flex-shrink: 0;
    background: var(--bg);
}
.summary-img-placeholder {
    width: 52px; height: 52px; border-radius: 8px;
    background: var(--bg); border: 1px solid var(--border);
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; color: var(--faint); flex-shrink: 0;
}
.summary-item-info { flex: 1; min-width: 0; }
.summary-item-name {
    font-size: 13px; font-weight: 600; color: var(--ink);
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.summary-item-qty { font-size: 12px; color: var(--muted); }
.summary-item-price { font-size: 13px; font-weight: 700; color: var(--ink); flex-shrink: 0; }

.summary-sep { border: none; border-top: 1px solid var(--border); margin: 16px 0; }
.summary-line {
    display: flex; justify-content: space-between; align-items: center;
    font-size: 13px; color: var(--muted); margin-bottom: 8px;
}
.summary-total {
    display: flex; justify-content: space-between; align-items: center;
    padding: 14px 0; border-top: 2px solid var(--ink); margin-top: 8px;
}
.summary-total span:first-child {
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px; font-weight: 600; color: var(--ink);
}
.summary-total span:last-child {
    font-size: 20px; font-weight: 700; color: var(--rose);
}

/* ── BOTÓN CONFIRMAR ── */
.btn-confirm {
    width: 100%; padding: 16px; margin-top: 20px;
    background: var(--rose); color: white;
    border: none; border-radius: var(--radius);
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 14px; font-weight: 700; letter-spacing: 0.06em;
    text-transform: uppercase; cursor: pointer; transition: all 0.3s;
    box-shadow: 0 4px 16px rgba(154,58,90,0.25);
}
.btn-confirm:hover { background: var(--rose-dark); transform: translateY(-1px); box-shadow: 0 8px 24px rgba(154,58,90,0.3); }
.btn-confirm:active { transform: translateY(0); }

.btn-back {
    display: flex; align-items: center; gap: 6px;
    color: var(--muted); font-size: 13px; font-weight: 600;
    text-decoration: none; margin-top: 14px; justify-content: center;
    transition: color 0.2s;
}
.btn-back:hover { color: var(--ink); }

/* ── TOAST ERROR ── */
.toast-error {
    background: #fff0f3; border: 1px solid #ffb3c1;
    border-left: 4px solid var(--rose); border-radius: var(--radius);
    padding: 14px 18px; margin-bottom: 20px;
    font-size: 13px; font-weight: 600; color: var(--rose);
    display: flex; align-items: center; gap: 10px;
}

/* ── ESTADO VACÍO ── */
.empty-dir {
    text-align: center; padding: 24px;
    color: var(--muted); font-size: 13px;
    background: var(--bg); border: 1px dashed var(--border);
    border-radius: var(--radius); margin-bottom: 16px;
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="<%=ctx%>/comprador/catalogo.jsp" class="navbar-brand">Quiddity</a>
    <div class="navbar-steps">
        <div class="step done">
            <div class="step-dot">✓</div>
            <span>Carrito</span>
        </div>
        <div class="step-divider"></div>
        <div class="step active">
            <div class="step-dot">2</div>
            <span>Envío &amp; Pago</span>
        </div>
        <div class="step-divider"></div>
        <div class="step">
            <div class="step-dot">3</div>
            <span>Confirmación</span>
        </div>
    </div>
</nav>

<form action="<%=ctx%>/checkout" method="POST">
<div class="checkout-layout">

    <!-- ── COLUMNA IZQUIERDA ── -->
    <div>

        <!-- Error -->
        <c:if test="${not empty param.error}">
            <div class="toast-error">⚠ ${param.error}</div>
        </c:if>

        <!-- Dirección de envío -->
        <div class="panel" style="margin-bottom:24px;">
            <div class="panel-header">
                <div class="panel-icon">📍</div>
                <h2>Dirección de envío</h2>
            </div>
            <div class="panel-body">
                <p class="section-title">Mis direcciones guardadas</p>

                <c:choose>
                    <c:when test="${empty direcciones}">
                        <div class="empty-dir">No tienes direcciones guardadas aún.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="dir-list">
                            <c:forEach var="d" items="${direcciones}" varStatus="s">
                                <input type="radio" class="dir-option"
                                       name="direccionId" id="dir${d.id}"
                                       value="${d.id}"
                                       ${(s.first || d.predeterminada) ? 'checked' : ''}>
                                <label class="dir-label" for="dir${d.id}">
                                    <div class="dir-radio-circle"></div>
                                    <div class="dir-info">
                                        <p class="dir-name">${d.ciudad}, ${d.departamento}</p>
                                        <p class="dir-text">${d.getDireccionCompleta()}</p>
                                    </div>
                                    <c:if test="${d.predeterminada}">
                                        <span class="dir-badge">Principal</span>
                                    </c:if>
                                </label>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Nueva dirección -->
                <button type="button" class="new-dir-toggle" onclick="toggleNuevaDireccion()">
                    <span>＋</span> Agregar nueva dirección
                </button>

                <div class="new-dir-form" id="nuevaDirForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Departamento *</label>
                            <input type="text" name="departamento" placeholder="Ej: Boyacá">
                        </div>
                        <div class="form-group">
                            <label>Ciudad *</label>
                            <input type="text" name="ciudad" placeholder="Ej: Tunja">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Dirección *</label>
                        <input type="text" name="nuevaDireccion" placeholder="Ej: Cra 10 #15-30">
                    </div>
                    <div class="form-group">
                        <label>Barrio</label>
                        <input type="text" name="barrio" placeholder="Ej: Centro">
                    </div>
                    <label class="checkbox-row">
                        <input type="checkbox" name="guardarDireccion" value="true">
                        Guardar como dirección principal
                    </label>
                </div>
            </div>
        </div>

        <!-- Método de pago -->
        <div class="panel" style="margin-bottom:24px;">
            <div class="panel-header">
                <div class="panel-icon">💳</div>
                <h2>Método de pago</h2>
            </div>
            <div class="panel-body">
                <div class="pago-grid">
                    <input type="radio" class="pago-radio" name="metodoPago" id="pagoEfectivo" value="Efectivo contra entrega" checked>
                    <label class="pago-label" for="pagoEfectivo">
                        <span class="pago-icon">💵</span>
                        <span class="pago-name">Efectivo</span>
                        <span class="pago-desc">Contra entrega</span>
                    </label>

                    <input type="radio" class="pago-radio" name="metodoPago" id="pagoTransferencia" value="Transferencia bancaria">
                    <label class="pago-label" for="pagoTransferencia">
                        <span class="pago-icon">🏦</span>
                        <span class="pago-name">Transferencia</span>
                        <span class="pago-desc">Bancaria</span>
                    </label>

                    <input type="radio" class="pago-radio" name="metodoPago" id="pagoNequi" value="Nequi / Daviplata">
                    <label class="pago-label" for="pagoNequi">
                        <span class="pago-icon">📱</span>
                        <span class="pago-name">Nequi</span>
                        <span class="pago-desc">/ Daviplata</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Notas opcionales -->
        <div class="panel">
            <div class="panel-header">
                <div class="panel-icon">📝</div>
                <h2>Notas del pedido</h2>
            </div>
            <div class="panel-body">
                <textarea class="notes-area" name="notas"
                    placeholder="Instrucciones especiales para la entrega (opcional)…"></textarea>
            </div>
        </div>

    </div>

    <!-- ── COLUMNA DERECHA: RESUMEN ── -->
    <div class="summary-panel">
        <div class="panel">
            <div class="panel-header">
                <div class="panel-icon">🛍</div>
                <h2>Tu pedido</h2>
            </div>
            <div class="panel-body">

                <div class="summary-items">
                    <c:forEach var="item" items="${items}">
                        <div class="summary-item">
                            <c:choose>
                                <c:when test="${not empty item.producto.imagen}">
                                    <img class="summary-img"
                                         src="<%=ctx%>/${item.producto.imagen}"
                                         alt="${fn:escapeXml(item.producto.nombre)}"
                                         onerror="this.style.display='none'">
                                </c:when>
                                <c:otherwise>
                                    <div class="summary-img-placeholder">🌿</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="summary-item-info">
                                <p class="summary-item-name">${item.producto.nombre}</p>
                                <p class="summary-item-qty">Cantidad: ${item.cantidad}</p>
                            </div>
                            <span class="summary-item-price">
                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </span>
                        </div>
                    </c:forEach>
                </div>

                <hr class="summary-sep">

                <div class="summary-line">
                    <span>Subtotal</span>
                    <span><fmt:formatNumber value="${total}" type="currency" currencySymbol="$" maxFractionDigits="0"/></span>
                </div>
                <div class="summary-line">
                    <span>Envío</span>
                    <span style="color:var(--mint);font-weight:700;">Gratis</span>
                </div>

                <div class="summary-total">
                    <span>Total</span>
                    <span><fmt:formatNumber value="${total}" type="currency" currencySymbol="$" maxFractionDigits="0"/></span>
                </div>

                <button type="submit" class="btn-confirm">
                    Confirmar pedido →
                </button>
                <a href="<%=ctx%>/carrito" class="btn-back">← Volver al carrito</a>

            </div>
        </div>
    </div>

</div>
</form>

<script>
function toggleNuevaDireccion() {
    const form = document.getElementById('nuevaDirForm');
    form.classList.toggle('open');
    // Si se abre la nueva dirección, deseleccionar las existentes
    if (form.classList.contains('open')) {
        document.querySelectorAll('.dir-option').forEach(r => r.checked = false);
    }
}

// Al seleccionar una dirección guardada, cerrar el formulario de nueva
document.querySelectorAll('.dir-option').forEach(radio => {
    radio.addEventListener('change', function() {
        document.getElementById('nuevaDirForm').classList.remove('open');
    });
});
</script>

</body>
</html>
