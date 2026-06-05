<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Gestión de Rutinas · Quiddity Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500&family=Manrope:wght@400;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        "primary": "#9a3a5a",
                        "secondary": "#516617",
                        "tertiary": "#88495a",
                        "surface-variant": "#f1ecef",
                        "on-surface": "#1c1b1d",
                        "on-surface-variant": "#544246",
                        "outline": "#877276"
                    },
                    fontFamily: {
                        "garamond": ["EB Garamond"],
                        "manrope": ["Manrope"]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24; }
        body { font-family: 'Manrope', sans-serif; background: #fff; color: #1c1b1d; }
        .sort-th { cursor: pointer; user-select: none; }
        .sort-th:hover { color: #9a3a5a; }
    </style>
</head>
<body class="flex min-h-screen">

    <%@ include file="/includes/sidebar.jsp" %>

    <main class="flex-1 px-10 py-10">

        <!-- Encabezado -->
        <div class="flex items-end justify-between mb-10">
            <div>
                <p class="font-manrope text-xs tracking-widest uppercase text-on-surface-variant mb-2">
                    Panel de administración
                </p>
                <h1 class="font-garamond text-5xl text-on-surface">Rutinas</h1>
            </div>
            <div class="flex items-center gap-3">
                <!-- Buscador -->
                <div class="flex items-center border border-outline/30 px-4 py-2 gap-2 bg-white">
                    <span class="material-symbols-outlined text-base text-outline">search</span>
                    <input id="buscador" type="text" placeholder="Buscar rutina..."
                           class="font-manrope text-sm outline-none w-52 text-on-surface placeholder:text-outline"/>
                </div>
            </div>
        </div>

        <!-- Feedback -->
        <c:if test="${not empty param.success}">
            <div class="mb-6 px-5 py-3 bg-secondary/10 border border-secondary/30 text-secondary font-manrope text-sm">
                <c:out value="${param.success}"/>
            </div>
        </c:if>

        <!-- Resumen rápido -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
            <c:set var="totalRutinas" value="${rutinas.size()}"/>
            <div class="border border-outline/20 px-5 py-4">
                <p class="font-manrope text-xs text-on-surface-variant uppercase tracking-widest mb-1">Total</p>
                <p class="font-garamond text-3xl text-on-surface">${totalRutinas}</p>
            </div>
            <c:forEach var="cat" items="${['Maquillaje','Skin care','Cuidado corporal','Cuidado capilar']}">
                <div class="border border-outline/20 px-5 py-4">
                    <p class="font-manrope text-xs text-on-surface-variant uppercase tracking-widest mb-1 truncate">
                        <c:out value="${cat}"/>
                    </p>
                    <p class="font-garamond text-3xl text-on-surface">
                        <%-- conteo por categoría --%>
                        <c:set var="count" value="0"/>
                        <c:forEach var="r" items="${rutinas}">
                            <c:if test="${r.categoria == cat}">
                                <c:set var="count" value="${count + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${count}
                    </p>
                </div>
            </c:forEach>
        </div>

        <!-- Filtro por categoría -->
        <div class="flex gap-8 border-b border-outline/30 mb-6 overflow-x-auto">
            <button onclick="filtrarCategoria('')"
                    class="categoria-tab pb-3 font-manrope text-sm whitespace-nowrap text-on-surface-variant hover:text-primary transition-colors active"
                    data-cat="">
                Todas
            </button>
            <c:forEach var="cat" items="${['Maquillaje','Skin care','Cuidado corporal','Cuidado capilar']}">
                <button onclick="filtrarCategoria('${cat}')"
                        class="categoria-tab pb-3 font-manrope text-sm whitespace-nowrap text-on-surface-variant hover:text-primary transition-colors"
                        data-cat="${cat}">
                    <c:out value="${cat}"/>
                </button>
            </c:forEach>
        </div>

        <!-- Tabla -->
        <div class="overflow-x-auto">
            <table class="w-full text-sm font-manrope" id="tablaRutinas">
                <thead>
                    <tr class="border-b border-outline/30 text-on-surface-variant">
                        <th class="sort-th text-left py-3 pr-6 font-semibold tracking-wide">Nombre</th>
                        <th class="sort-th text-left py-3 pr-6 font-semibold tracking-wide">Categoría</th>
                        <th class="sort-th text-left py-3 pr-6 font-semibold tracking-wide">Subcategoría</th>
                        <th class="text-left py-3 pr-6 font-semibold tracking-wide">Tipo piel</th>
                        <th class="text-left py-3 pr-6 font-semibold tracking-wide">Tipo cabello</th>
                        <th class="text-left py-3 pr-6 font-semibold tracking-wide">Usuario</th>
                        <th class="py-3"></th>
                    </tr>
                </thead>
                <tbody id="tbody">
                    <c:forEach var="rutina" items="${rutinas}">
                        <tr class="fila-rutina border-b border-outline/10 hover:bg-surface-variant/40 transition-colors"
                            data-cat="${rutina.categoria}">
                            <td class="py-4 pr-6 text-on-surface font-medium">
                                <c:out value="${rutina.nombre}"/>
                            </td>
                            <td class="py-4 pr-6">
                                <span class="px-3 py-1 bg-primary/10 text-primary text-xs tracking-wide">
                                    <c:out value="${rutina.categoria}"/>
                                </span>
                            </td>
                            <td class="py-4 pr-6 text-on-surface-variant">
                                <c:out value="${rutina.subcategoria}" default="—"/>
                            </td>
                            <td class="py-4 pr-6 text-on-surface-variant">
                                <c:out value="${rutina.tipoPiel}" default="—"/>
                            </td>
                            <td class="py-4 pr-6 text-on-surface-variant">
                                <c:out value="${rutina.tipoCabello}" default="—"/>
                            </td>
                            <td class="py-4 pr-6 text-on-surface-variant">
                                <c:choose>
                                    <c:when test="${rutina.idUsuario == 0}">—</c:when>
                                    <c:otherwise>#${rutina.idUsuario}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="py-4 text-right">
                                <form method="post" action="${pageContext.request.contextPath}/rutinas"
                                      onsubmit="return confirm('¿Eliminar esta rutina?')">
                                    <input type="hidden" name="action" value="eliminar"/>
                                    <input type="hidden" name="id"     value="${rutina.id}"/>
                                    <button type="submit"
                                            class="flex items-center gap-1 ml-auto font-manrope text-xs text-outline hover:text-primary transition-colors">
                                        <span class="material-symbols-outlined text-base">delete</span>
                                        Eliminar
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty rutinas}">
                        <tr>
                            <td colspan="7" class="py-16 text-center text-on-surface-variant font-manrope text-sm">
                                No hay rutinas registradas.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        // Filtro por categoría (cliente)
        function filtrarCategoria(cat) {
            document.querySelectorAll('.categoria-tab').forEach(t => {
                t.classList.toggle('active', t.dataset.cat === cat);
                t.style.borderBottom = t.dataset.cat === cat ? '2px solid #9a3a5a' : '';
                t.style.color = t.dataset.cat === cat ? '#9a3a5a' : '';
            });
            document.querySelectorAll('.fila-rutina').forEach(fila => {
                fila.style.display = (!cat || fila.dataset.cat === cat) ? '' : 'none';
            });
        }

        // Buscador en tiempo real
        document.getElementById('buscador').addEventListener('input', function () {
            const q = this.value.toLowerCase();
            document.querySelectorAll('.fila-rutina').forEach(fila => {
                fila.style.display = fila.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });
    </script>
</body>
</html>