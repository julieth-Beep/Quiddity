<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <c:set var="ctx" value="${pageContext.request.contextPath}" />
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
      <title>Mi Closet — Quiddity</title>
      <style>
        * {
          box-sizing: border-box;
          margin: 0;
          padding: 0
        }

        body {
          font-family: 'Segoe UI', sans-serif;
          background: #f8f7f5;
          color: #1a1a1a
        }

        /* ── Navbar ── */
        .navbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          background: #fff;
          padding: 14px 28px;
          border-bottom: 1px solid #eee;
          position: sticky;
          top: 0;
          z-index: 100
        }

        .logo-text {
          font-size: 1.4rem;
          font-weight: 700;
          letter-spacing: -0.5px;
          color: #1a1a1a;
          text-decoration: none
        }

        .nav-links {
          list-style: none;
          display: flex;
          gap: 8px
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
          font-size: .75rem;
          transition: .2s
        }

        .nav-links li a:hover,
        .nav-links li.active a {
          background: #f0f0f0;
          color: #1a1a1a
        }

        .nav-links .icon {
          font-size: 1.1rem
        }

        .btn-logout {
          padding: 6px 14px;
          border-radius: 20px;
          background: #1a1a1a;
          color: #fff;
          text-decoration: none;
          font-size: .8rem
        }

        /* ── Layout ── */
        .page {
          max-width: 1100px;
          margin: 0 auto;
          padding: 28px 20px
        }

        .page-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 24px
        }

        .page-title {
          font-size: 1.6rem;
          font-weight: 700
        }

        .btn-add {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 10px 20px;
          background: #1a1a1a;
          color: #fff;
          border: none;
          border-radius: 24px;
          cursor: pointer;
          font-size: .9rem;
          font-weight: 500
        }

        /* ── Tabs ── */
        .tabs {
          display: flex;
          gap: 8px;
          margin-bottom: 24px;
          flex-wrap: wrap
        }

        .tab {
          padding: 8px 18px;
          border-radius: 24px;
          border: 1.5px solid #e0e0e0;
          background: #fff;
          cursor: pointer;
          font-size: .85rem;
          font-weight: 500;
          transition: .2s
        }

        .tab.active {
          background: #1a1a1a;
          color: #fff;
          border-color: #1a1a1a
        }

        .tab:hover:not(.active) {
          background: #f5f5f5
        }

        /* ── Grid de prendas ── */
        .prendas-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
          gap: 16px
        }

        .prenda-card {
          background: #fff;
          border-radius: 16px;
          overflow: hidden;
          box-shadow: 0 1px 6px rgba(0, 0, 0, .06);
          cursor: pointer;
          transition: .2s;
          position: relative
        }

        .prenda-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 6px 20px rgba(0, 0, 0, .1)
        }

        .prenda-img {
          width: 100%;
          aspect-ratio: 1;
          object-fit: cover;
          background: #f5f5f5
        }

        .prenda-info {
          padding: 10px 12px
        }

        .prenda-tipo {
          font-size: .8rem;
          color: #888;
          text-transform: capitalize
        }

        .prenda-color {
          font-size: .85rem;
          font-weight: 500;
          text-transform: capitalize
        }

        .prenda-actions {
          position: absolute;
          top: 8px;
          right: 8px;
          display: none;
          gap: 6px
        }

        .prenda-card:hover .prenda-actions {
          display: flex
        }

        .btn-icon {
          width: 30px;
          height: 30px;
          border-radius: 50%;
          border: none;
          background: rgba(255, 255, 255, .9);
          cursor: pointer;
          font-size: .9rem;
          display: flex;
          align-items: center;
          justify-content: center;
          backdrop-filter: blur(4px)
        }

        .btn-prettify {
          background: #fff700;
          font-size: .75rem;
          font-weight: 600;
          width: auto;
          padding: 4px 8px;
          border-radius: 12px;
          white-space: nowrap
        }

        .empty-state {
          text-align: center;
          padding: 60px 20px;
          color: #aaa
        }

        .empty-state .empty-icon {
          font-size: 3rem;
          margin-bottom: 12px
        }

        /* ── Modal agregar prenda ── */
        .modal-overlay {
          display: none;
          position: fixed;
          inset: 0;
          background: rgba(0, 0, 0, .5);
          z-index: 200;
          align-items: center;
          justify-content: center
        }

        .modal-overlay.open {
          display: flex
        }

        .modal {
          background: #fff;
          border-radius: 24px;
          padding: 32px;
          width: 100%;
          max-width: 480px;
          max-height: 90vh;
          overflow-y: auto
        }

        .modal-title {
          font-size: 1.2rem;
          font-weight: 700;
          margin-bottom: 24px
        }

        .form-group {
          margin-bottom: 16px
        }

        .form-group label {
          display: block;
          font-size: .85rem;
          font-weight: 500;
          margin-bottom: 6px;
          color: #555
        }

        .form-group input,
        .form-group select {
          width: 100%;
          padding: 10px 14px;
          border: 1.5px solid #e0e0e0;
          border-radius: 12px;
          font-size: .9rem;
          outline: none;
          transition: .2s
        }

        .form-group input:focus,
        .form-group select:focus {
          border-color: #1a1a1a
        }

        .img-preview {
          width: 100%;
          aspect-ratio: 1;
          object-fit: cover;
          border-radius: 12px;
          background: #f5f5f5;
          display: none;
          margin-bottom: 8px
        }

        .modal-actions {
          display: flex;
          gap: 10px;
          margin-top: 24px
        }

        .btn-primary {
          flex: 1;
          padding: 12px;
          background: #1a1a1a;
          color: #fff;
          border: none;
          border-radius: 16px;
          font-size: .95rem;
          font-weight: 600;
          cursor: pointer
        }

        .btn-secondary {
          flex: 1;
          padding: 12px;
          background: #f0f0f0;
          color: #1a1a1a;
          border: none;
          border-radius: 16px;
          font-size: .95rem;
          cursor: pointer
        }

        /* ── Subcategoría accesorio ── */
        .subcategoria-group {
          display: none
        }

        .subcategoria-group.visible {
          display: block
        }

        /* ── Toast ── */
        .toast {
          position: fixed;
          bottom: 24px;
          left: 50%;
          transform: translateX(-50%);
          background: #1a1a1a;
          color: #fff;
          padding: 12px 24px;
          border-radius: 24px;
          font-size: .9rem;
          opacity: 0;
          transition: .3s;
          pointer-events: none;
          z-index: 300
        }

        .toast.show {
          opacity: 1
        }
      </style>
    </head>

    <body>
    <div class="layout-with-sidebar">
      <jsp:include page="/includes/sidebar.jsp"/>
      <div class="main-content">
        <div class="page">
          <div class="page-header">
            <div>
              <h1 class="page-title">Mi Closet</h1>
              <p style="color:#888;font-size:.9rem;margin-top:4px">${totalPrendas} prendas</p>
            </div>
            <button class="btn-add" onclick="abrirModal()">+ Agregar prenda</button>
          </div>

          <%-- Tabs por tipo --%>
            <div class="tabs">
              <button class="tab active" onclick="filtrar('todos',this)">Todas (${totalPrendas})</button>
              <button class="tab" onclick="filtrar('tops',this)">Tops (${countTops})</button>
              <button class="tab" onclick="filtrar('bottoms',this)">Pantalones y faldas (${countBottoms})</button>
              <button class="tab" onclick="filtrar('dresses',this)">Vestidos (${countDresses})</button>
              <button class="tab" onclick="filtrar('outerwear',this)">Outerwear (${countOuterwear})</button>
              <button class="tab" onclick="filtrar('shoes',this)">Zapatos (${countShoes})</button>
              <button class="tab" onclick="filtrar('accessories',this)">Accesorios (${countAccesorios})</button>
            </div>

            <%-- Grid de prendas --%>
              <div class="prendas-grid" id="gridPrendas">
                <c:choose>
                  <c:when test="${empty prendas}">
                    <div class="empty-state" style="grid-column:1/-1">
                      <div class="empty-icon">👗</div>
                      <p style="font-size:1.1rem;font-weight:600;margin-bottom:8px">Tu closet está vacío</p>
                      <p>Agrega tu primera prenda para empezar</p>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="p" items="${prendas}">
                      <div class="prenda-card" data-tipo="${p.tipo}" data-id="${p.id}">
                        <img class="prenda-img" src="${ctx}/${p.imagen}" alt="${p.tipo}"
                          onerror="this.src='${ctx}/img/placeholder.png'" />
                        <div class="prenda-actions">
                          <button class="btn-icon btn-prettify" onclick="prettify(${p.id},event)"
                            title="Prettify">✨</button>
                          <button class="btn-icon" onclick="eliminarPrenda(${p.id},event)" title="Eliminar">🗑️</button>
                        </div>
                        <div class="prenda-info">
                          <div class="prenda-tipo">${p.tipo}</div>
                          <div class="prenda-color">${p.color}</div>
                        </div>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
        </div>

        <%-- Modal agregar prenda --%>
          <div class="modal-overlay" id="modalOverlay">
            <div class="modal">
              <h2 class="modal-title">Agregar prenda</h2>
              <form id="formPrenda" enctype="multipart/form-data">

                <div class="form-group">
                  <label>Foto de la prenda *</label>
                  <img id="imgPreview" class="img-preview" alt="preview" />
                  <input type="file" name="imagen" id="inputImagen" accept="image/*" required
                    onchange="previewImagen(this)" />
                  <small style="color:#999;font-size:.78rem;margin-top:4px;display:block">
                    Se aplicará Prettify automáticamente ✨
                  </small>
                </div>

                <div class="form-group">
                  <label>Tipo *</label>
                  <select name="tipo" id="selectTipo" required onchange="toggleSubcategoria(this)">
                    <option value="">Selecciona...</option>
                    <option value="tops">Top</option>
                    <option value="bottoms">Pantalón / Falda</option>
                    <option value="dresses">Vestido</option>
                    <option value="outerwear">Outerwear</option>
                    <option value="shoes">Zapatos</option>
                    <option value="accessories">Accesorio</option>
                  </select>
                </div>

                <%-- Subcategoría: solo visible cuando tipo=accessories --%>
                  <div class="form-group subcategoria-group" id="subcategoriaGroup">
                    <label>Tipo de accesorio *</label>
                    <select name="subcategoria" id="selectSubcategoria">
                      <option value="">Selecciona...</option>
                      <option value="collar">Collar / Cadena</option>
                      <option value="aretes">Aretes / Pendientes</option>
                      <option value="bolso">Bolso / Cartera / Clutch</option>
                      <option value="cinturon">Cinturón / Belt</option>
                      <option value="gafas">Gafas / Lentes</option>
                      <option value="anillo">Anillo / Ring</option>
                      <option value="pulsera">Pulsera / Brazalete</option>
                      <option value="sombrero">Sombrero / Gorra</option>
                      <option value="otro">Otro accesorio</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label>Color *</label>
                    <input type="text" name="color" placeholder="ej: negro, beige, floral" required />
                  </div>

                  <div class="form-group">
                    <label>Estilo</label>
                    <select name="estilo">
                      <option value="casual">Casual</option>
                      <option value="formal">Formal</option>
                      <option value="deportivo">Deportivo</option>
                      <option value="elegante">Elegante</option>
                      <option value="bohemio">Bohemio</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label>Temporada</label>
                    <select name="temporada">
                      <option value="todas">Todas</option>
                      <option value="primavera">Primavera</option>
                      <option value="verano">Verano</option>
                      <option value="otono">Otoño</option>
                      <option value="invierno">Invierno</option>
                    </select>
                  </div>

                  <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="cerrarModal()">Cancelar</button>
                    <button type="submit" class="btn-primary" id="btnGuardar">Guardar prenda</button>
                  </div>
              </form>
            </div>
          </div>

          <div class="toast" id="toast"></div>

          <script>
            const ctx = '${ctx}';

            // ── Filtrar por tab ─────────────────────────────────
            function filtrar(tipo, btn) {
              document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
              btn.classList.add('active');
              document.querySelectorAll('.prenda-card').forEach(card => {
                card.style.display = (tipo === 'todos' || card.dataset.tipo === tipo) ? '' : 'none';
              });
            }

            // ── Preview imagen ──────────────────────────────────
            function previewImagen(input) {
              if (input.files && input.files[0]) {
                const img = document.getElementById('imgPreview');
                img.src = URL.createObjectURL(input.files[0]);
                img.style.display = 'block';
              }
            }

            // ── Mostrar/ocultar subcategoría ────────────────────
            function toggleSubcategoria(sel) {
              const grupo = document.getElementById('subcategoriaGroup');
              const subSel = document.getElementById('selectSubcategoria');
              if (sel.value === 'accessories') {
                grupo.classList.add('visible');
                subSel.required = true;
              } else {
                grupo.classList.remove('visible');
                subSel.required = false;
                subSel.value = '';
              }
            }

            // ── Modal ───────────────────────────────────────────
            function abrirModal() {
              document.getElementById('modalOverlay').classList.add('open');
            }
            function cerrarModal() {
              document.getElementById('modalOverlay').classList.remove('open');
              document.getElementById('formPrenda').reset();
              document.getElementById('imgPreview').style.display = 'none';
              // Resetear subcategoría
              document.getElementById('subcategoriaGroup').classList.remove('visible');
              document.getElementById('selectSubcategoria').required = false;
            }
            document.getElementById('modalOverlay').addEventListener('click', e => {
              if (e.target === e.currentTarget) cerrarModal();
            });

            // ── Guardar prenda ──────────────────────────────────
            document.getElementById('formPrenda').addEventListener('submit', async e => {
              e.preventDefault();
              const btn = document.getElementById('btnGuardar');
              btn.textContent = 'Guardando y procesando...';
              btn.disabled = true;

              const fd = new FormData(e.target);
              try {
                const res = await fetch(ctx + '/closet/prenda', { method: 'POST', body: fd });
                const data = await res.json();
                if (res.ok) {
                  mostrarToast('✨ Prenda agregada con Prettify aplicado');
                  cerrarModal();
                  setTimeout(() => location.reload(), 1200);
                } else {
                  mostrarToast('❌ ' + data.error);
                }
              } catch (err) {
                mostrarToast('❌ Error al guardar');
              } finally {
                btn.textContent = 'Guardar prenda';
                btn.disabled = false;
              }
            });

            // ── Prettify manual ─────────────────────────────────
            async function prettify(id, e) {
              e.stopPropagation();
              mostrarToast('✨ Aplicando Prettify...');
              try {
                const res = await fetch(ctx + '/closet/prenda/' + id + '/prettify', { method: 'POST' });
                const data = await res.json();
                if (res.ok) {
                  mostrarToast('✨ Prettify aplicado');
                  setTimeout(() => location.reload(), 1000);
                } else {
                  mostrarToast('❌ ' + data.error);
                }
              } catch (err) {
                mostrarToast('❌ Error');
              }
            }

            // ── Eliminar prenda ─────────────────────────────────
            async function eliminarPrenda(id, e) {
              e.stopPropagation();
              if (!confirm('¿Eliminar esta prenda?')) return;
              try {
                const res = await fetch(ctx + '/closet/prenda/' + id, { method: 'DELETE' });
                const data = await res.json();
                if (res.ok) {
                  document.querySelector('[data-id="' + id + '"]').remove();
                  mostrarToast('Prenda eliminada');
                } else {
                  mostrarToast('❌ ' + data.error);
                }
              } catch (err) {
                mostrarToast('❌ Error');
              }
            }

            // ── Toast ───────────────────────────────────────────
            function mostrarToast(msg) {
              const t = document.getElementById('toast');
              t.textContent = msg;
              t.classList.add('show');
              setTimeout(() => t.classList.remove('show'), 3000);
            }
          </script>
      </div>
    </div>
    </body>

    </html>