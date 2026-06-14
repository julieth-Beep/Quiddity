<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>Calendario — Quiddity</title>
    <style>
      * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
      }
      body {
        font-family: "Segoe UI", sans-serif;
        background: #f8f7f5;
        color: #1a1a1a;
      }
      .navbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: #fff;
        padding: 14px 28px;
        border-bottom: 1px solid #eee;
        position: sticky;
        top: 0;
        z-index: 100;
      }
      .logo-text {
        font-size: 1.4rem;
        font-weight: 700;
        color: #1a1a1a;
        text-decoration: none;
      }
      .nav-links {
        list-style: none;
        display: flex;
        gap: 8px;
      }
      .nav-links li a {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 2px;
        padding: 8px 14px;
        border-radius: 12px;
        text-decoration: none;
        color: #666;
        font-size: 0.75rem;
        transition: 0.2s;
      }
      .nav-links li a:hover,
      .nav-links li.active a {
        background: #f0f0f0;
        color: #1a1a1a;
      }
      .btn-logout {
        padding: 6px 14px;
        border-radius: 20px;
        background: #1a1a1a;
        color: #fff;
        text-decoration: none;
        font-size: 0.8rem;
      }
      .page {
        max-width: 1000px;
        margin: 0 auto;
        padding: 28px 20px;
      }
      /* ── Header del calendario ── */
      .cal-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
      }
      .cal-title {
        font-size: 1.5rem;
        font-weight: 700;
        text-transform: capitalize;
      }
      .cal-nav {
        display: flex;
        gap: 8px;
        align-items: center;
      }
      .btn-nav {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: 1.5px solid #e0e0e0;
        background: #fff;
        cursor: pointer;
        font-size: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .btn-nav:hover {
        background: #f0f0f0;
      }
      /* ── Grid del calendario ── */
      .cal-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 8px;
      }
      .cal-day-name {
        text-align: center;
        font-size: 0.78rem;
        font-weight: 600;
        color: #888;
        padding: 8px 0;
        text-transform: uppercase;
      }
      .cal-cell {
        background: #fff;
        border-radius: 14px;
        padding: 8px;
        min-height: 100px;
        border: 1.5px solid transparent;
        transition: 0.2s;
        cursor: pointer;
        position: relative;
      }
      .cal-cell:hover {
        border-color: #e0e0e0;
        background: #fafafa;
      }
      .cal-cell.today {
        border-color: #1a1a1a;
      }
      .cal-cell.otro-mes {
        background: #f5f5f5;
        opacity: 0.5;
      }
      .day-num {
        font-size: 0.82rem;
        font-weight: 600;
        color: #888;
        margin-bottom: 6px;
      }
      .cal-cell.today .day-num {
        color: #1a1a1a;
        background: #1a1a1a;
        color: #fff;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.75rem;
      }
      .look-thumb {
        width: 100%;
        aspect-ratio: 1;
        object-fit: cover;
        border-radius: 8px;
        display: block;
        margin-bottom: 4px;
      }
      .look-thumb-more {
        text-align: center;
        font-size: 0.72rem;
        color: #888;
      }
      .add-btn {
        position: absolute;
        bottom: 6px;
        right: 6px;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: #f0f0f0;
        border: none;
        cursor: pointer;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: 0.2s;
      }
      .cal-cell:hover .add-btn {
        opacity: 1;
      }
      /* ── Modal detalle día ── */
      .modal-overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 200;
        align-items: flex-end;
        justify-content: center;
      }
      .modal-overlay.open {
        display: flex;
      }
      .modal-sheet {
        background: #fff;
        border-radius: 24px 24px 0 0;
        width: 100%;
        max-width: 600px;
        padding: 28px;
        max-height: 80vh;
        overflow-y: auto;
      }
      .modal-date {
        font-size: 1.1rem;
        font-weight: 700;
        margin-bottom: 16px;
      }
      .looks-del-dia {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 20px;
      }
      .look-dia-item {
        width: 100px;
        border-radius: 14px;
        overflow: hidden;
        position: relative;
        cursor: pointer;
      }
      .look-dia-item img {
        width: 100%;
        aspect-ratio: 3/4;
        object-fit: cover;
      }
      .look-dia-del {
        position: absolute;
        top: 4px;
        right: 4px;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: rgba(0, 0, 0, 0.6);
        color: #fff;
        border: none;
        font-size: 0.65rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .modal-actions {
        display: flex;
        gap: 10px;
      }
      .btn-modal-action {
        flex: 1;
        padding: 11px;
        border-radius: 14px;
        border: 1.5px solid #e0e0e0;
        background: #fff;
        cursor: pointer;
        font-size: 0.88rem;
        font-weight: 500;
      }
      .btn-modal-action.primary {
        background: #1a1a1a;
        color: #fff;
        border-color: #1a1a1a;
      }
      .loading-cal {
        text-align: center;
        padding: 40px;
        color: #bbb;
      }
      .toast {
        position: fixed;
        bottom: 24px;
        left: 50%;
        transform: translateX(-50%);
        background: #1a1a1a;
        color: #fff;
        padding: 12px 24px;
        border-radius: 24px;
        font-size: 0.9rem;
        opacity: 0;
        transition: 0.3s;
        pointer-events: none;
        z-index: 400;
      }
      .toast.show {
        opacity: 1;
      }
    </style>
  </head>
  <body>
  <div class="layout-with-sidebar">
    <jsp:include page="/includes/sidebar.jsp"/>
    <div class="main-content">
    <div class="page">
      <div class="cal-header">
        <h1 class="cal-title" id="calTitulo"></h1>
        <div class="cal-nav">
          <button class="btn-nav" onclick="cambiarMes(-1)">‹</button>
          <button class="btn-nav" onclick="irHoy()">Hoy</button>
          <button class="btn-nav" onclick="cambiarMes(1)">›</button>
        </div>
      </div>

      <div class="cal-grid" id="calGrid">
        <div class="cal-day-name">Dom</div>
        <div class="cal-day-name">Lun</div>
        <div class="cal-day-name">Mar</div>
        <div class="cal-day-name">Mié</div>
        <div class="cal-day-name">Jue</div>
        <div class="cal-day-name">Vie</div>
        <div class="cal-day-name">Sáb</div>
      </div>
    </div>

    <%-- Modal día --%>
    <div class="modal-overlay" id="modalOverlay">
      <div class="modal-sheet">
        <p class="modal-date" id="modalFecha"></p>
        <div class="looks-del-dia" id="looksDelDia"></div>
        <div class="modal-actions">
          <button class="btn-modal-action" onclick="cerrarModal()">
            Cerrar
          </button>
          <button class="btn-modal-action primary" onclick="irALooks()">
            + Agregar look
          </button>
        </div>
      </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
      const ctx = "${ctx}";
      const MESES = [
        "Enero",
        "Febrero",
        "Marzo",
        "Abril",
        "Mayo",
        "Junio",
        "Julio",
        "Agosto",
        "Septiembre",
        "Octubre",
        "Noviembre",
        "Diciembre",
      ];
      const HOY = new Date();

      let mesActual = HOY.getMonth();
      let anioActual = HOY.getFullYear();
      let looksMes = [];
      let fechaSeleccionada = null;

      async function cargarMes() {
        const mes = String(mesActual + 1).padStart(2, "0");
        const mesStr = anioActual + "-" + mes;
        document.getElementById("calTitulo").textContent =
          MESES[mesActual] + " " + anioActual;

        try {
          const res = await fetch(ctx + "/calendario/mes?mes=" + mesStr);
          looksMes = await res.json();
        } catch (e) {
          looksMes = [];
        }

        renderCalendario();
      }

      function renderCalendario() {
        const grid = document.getElementById("calGrid");
        // Quitar celdas anteriores (mantener los 7 headers)
        while (grid.children.length > 7) grid.removeChild(grid.lastChild);

        const primerDia = new Date(anioActual, mesActual, 1).getDay();
        const diasEnMes = new Date(anioActual, mesActual + 1, 0).getDate();
        const diasAnteriores = new Date(anioActual, mesActual, 0).getDate();

        // Celdas del mes anterior
        for (let i = primerDia - 1; i >= 0; i--) {
          const cell = crearCelda(diasAnteriores - i, true);
          grid.appendChild(cell);
        }

        // Celdas del mes actual
        for (let d = 1; d <= diasEnMes; d++) {
          const mes = String(mesActual + 1).padStart(2, "0");
          const dia = String(d).padStart(2, "0");
          const fechaStr = anioActual + "-" + mes + "-" + dia;
          const esHoy =
            d === HOY.getDate() &&
            mesActual === HOY.getMonth() &&
            anioActual === HOY.getFullYear();

          const looksDelDia = looksMes.filter(function (l) {
            if (!l.fecha) return false;
            // Normalizar: puede venir como "2026-06-08", "Jun 8, 2026", timestamp, etc.
            var fechaNorm = "";
            if (typeof l.fecha === "string") {
              // Si ya tiene formato YYYY-MM-DD
              if (l.fecha.match(/^\d{4}-\d{2}-\d{2}/)) {
                fechaNorm = l.fecha.substring(0, 10);
              } else {
                // Intentar parsear cualquier otro formato
                var d = new Date(l.fecha);
                if (!isNaN(d)) {
                  var mm = String(d.getMonth() + 1).padStart(2, "0");
                  var dd = String(d.getDate()).padStart(2, "0");
                  fechaNorm = d.getFullYear() + "-" + mm + "-" + dd;
                }
              }
            } else if (typeof l.fecha === "number") {
              var d = new Date(l.fecha);
              var mm = String(d.getMonth() + 1).padStart(2, "0");
              var dd = String(d.getDate()).padStart(2, "0");
              fechaNorm = d.getFullYear() + "-" + mm + "-" + dd;
            }
            return fechaNorm === fechaStr;
          });
          const cell = crearCelda(d, false, esHoy, fechaStr, looksDelDia);
          grid.appendChild(cell);
        }

        // Completar con días del mes siguiente
        const totalCeldas = grid.children.length - 7;
        const restantes = totalCeldas % 7 === 0 ? 0 : 7 - (totalCeldas % 7);
        for (let i = 1; i <= restantes; i++) {
          grid.appendChild(crearCelda(i, true));
        }
      }

      function crearCelda(num, otroMes, esHoy, fechaStr, looks) {
        const cell = document.createElement("div");
        cell.className =
          "cal-cell" + (otroMes ? " otro-mes" : "") + (esHoy ? " today" : "");

        const dayNum = document.createElement("div");
        dayNum.className = "day-num";
        dayNum.textContent = num;
        cell.appendChild(dayNum);

        if (looks && looks.length > 0) {
          const maxShow = Math.min(looks.length, 2);
          for (let i = 0; i < maxShow; i++) {
            const img = document.createElement("img");
            img.className = "look-thumb";
            img.src = ctx + "/" + looks[i].imagenGenerada;
            img.onerror = () => (img.style.display = "none");
            cell.appendChild(img);
          }
          if (looks.length > 2) {
            const more = document.createElement("div");
            more.className = "look-thumb-more";
            more.textContent = "+" + (looks.length - 2) + " más";
            cell.appendChild(more);
          }
        }

        if (!otroMes && fechaStr) {
          const addBtn = document.createElement("button");
          addBtn.className = "add-btn";
          addBtn.textContent = "+";
          addBtn.onclick = (e) => {
            e.stopPropagation();
            irALooks();
          };
          cell.appendChild(addBtn);

          cell.onclick = () => abrirDia(fechaStr, looks || []);
        }

        return cell;
      }

      function abrirDia(fechaStr, looks) {
        fechaSeleccionada = fechaStr;
        const [y, m, d] = fechaStr.split("-");
        document.getElementById("modalFecha").textContent =
          d + " de " + MESES[parseInt(m) - 1] + " de " + y;

        const contenedor = document.getElementById("looksDelDia");
        contenedor.innerHTML = "";
        if (looks.length === 0) {
          contenedor.innerHTML =
            '<p style="color:#bbb;font-size:.9rem">Sin outfits asignados</p>';
        } else {
          looks.forEach(function (l) {
            var item = document.createElement("div");
            item.className = "look-dia-item";
            var img = document.createElement("img");
            img.src = ctx + "/" + l.imagenGenerada;
            img.alt = "look";
            img.onerror = function () {
              this.src = ctx + "/img/placeholder.png";
            };
            var btn = document.createElement("button");
            btn.className = "look-dia-del";
            btn.textContent = "✕";
            (function (lid) {
              btn.onclick = function () {
                quitarDelDia(lid);
              };
            })(l.id);
            item.appendChild(img);
            item.appendChild(btn);
            contenedor.appendChild(item);
          });
        }

        document.getElementById("modalOverlay").classList.add("open");
      }

      async function quitarDelDia(id) {
        if (!confirm("¿Quitar este look del día?")) return;
        const res = await fetch(ctx + "/calendario/" + id, {
          method: "DELETE",
        });
        if (res.ok) {
          mostrarToast("Look quitado");
          cerrarModal();
          cargarMes();
        }
      }

      function cerrarModal() {
        document.getElementById("modalOverlay").classList.remove("open");
      }
      function irALooks() {
        window.location.href = ctx + "/look";
      }
      function cambiarMes(d) {
        mesActual += d;
        if (mesActual > 11) {
          mesActual = 0;
          anioActual++;
        } else if (mesActual < 0) {
          mesActual = 11;
          anioActual--;
        }
        cargarMes();
      }
      function irHoy() {
        mesActual = HOY.getMonth();
        anioActual = HOY.getFullYear();
        cargarMes();
      }

      function mostrarToast(msg) {
        const t = document.getElementById("toast");
        t.textContent = msg;
        t.classList.add("show");
        setTimeout(() => t.classList.remove("show"), 3000);
      }

      cargarMes();
    </script>
    </div>
  </div>
  </body>
</html>
