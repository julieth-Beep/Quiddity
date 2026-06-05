<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Mis Rutinas · Quiddity</title>
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
        .categoria-tab.active { border-bottom: 2px solid #9a3a5a; color: #9a3a5a; }
        .rutina-card:hover .card-arrow { transform: translateX(4px); }
    </style>
</head>
<body class="flex min-h-screen">

    <%@ include file="/includes/sidebar.jsp" %>

    <main class="flex-1 px-10 py-10">

        <!-- Encabezado -->
        <div class="mb-10">
            <p class="text-label-md font-manrope tracking-widest uppercase text-on-surface-variant mb-2">
                Recomendadas para ti
            </p>
            <h1 class="font-garamond text-5xl text-on-surface">Tus rutinas</h1>
        </div>

        <!-- Mensajes de feedback -->
        <c:if test="${not empty param.success}">
            <div class="mb-6 px-5 py-3 bg-secondary/10 border border-secondary/30 text-secondary font-manrope text-sm">
                <c:out value="${param.success}"/>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="mb-6 px-5 py-3 bg-primary/10 border border-primary/30 text-primary font-manrope text-sm">
                <c:out value="${param.error}"/>
            </div>
        </c:if>

        <!-- Filtro por categoría -->
        <div class="flex gap-8 border-b border-outline/30 mb-8 overflow-x-auto">
            <a href="${pageContext.request.contextPath}/rutinas"
               class="categoria-tab pb-3 font-manrope text-sm whitespace-nowrap text-on-surface-variant hover:text-primary transition-colors
                      ${empty param.categoria ? 'active' : ''}">
                Todas
            </a>
            <c:forEach var="cat" items="${['Maquillaje','Skin care','Cuidado corporal','Cuidado capilar']}">
                <a href="${pageContext.request.contextPath}/rutinas/categoria?categoria=${cat}"
                   class="categoria-tab pb-3 font-manrope text-sm whitespace-nowrap text-on-surface-variant hover:text-primary transition-colors
                          ${param.categoria == cat ? 'active' : ''}">
                    <c:out value="${cat}"/>
                </a>
            </c:forEach>
        </div>

        <!-- Grid de rutinas -->
        <c:choose>
            <c:when test="${empty rutinas}">
                <div class="flex flex-col items-center justify-center py-24 text-center">
                    <span class="material-symbols-outlined text-5xl text-outline mb-4">auto_awesome</span>
                    <p class="font-garamond text-2xl text-on-surface mb-2">No hay rutinas disponibles</p>
                    <p class="font-manrope text-sm text-on-surface-variant">
                        Completa tu perfil de características para recibir recomendaciones personalizadas.
                    </p>
                    <a href="${pageContext.request.contextPath}/caracteristicas"
                       class="mt-6 px-6 py-3 bg-primary text-white font-manrope text-sm tracking-widest uppercase hover:bg-tertiary transition-colors">
                        Completar perfil
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    <c:forEach var="rutina" items="${rutinas}">
                        <div class="rutina-card group border border-outline/20 hover:border-primary/40 transition-colors bg-white">

                            <!-- Cabecera de la card -->
                            <div class="px-6 pt-6 pb-4 border-b border-outline/10">
                                <div class="flex items-start justify-between gap-4">
                                    <div>
                                        <span class="inline-block font-manrope text-xs tracking-widest uppercase text-primary mb-2">
                                            <c:out value="${rutina.categoria}"/>
                                        </span>
                                        <h3 class="font-garamond text-xl text-on-surface leading-snug">
                                            <c:out value="${rutina.nombre}"/>
                                        </h3>
                                    </div>
                                    <span class="material-symbols-outlined card-arrow text-outline transition-transform mt-1">
                                        arrow_forward
                                    </span>
                                </div>
                            </div>

                            <!-- Cuerpo -->
                            <div class="px-6 py-4">
                                <p class="font-manrope text-sm text-on-surface-variant leading-relaxed line-clamp-2">
                                    <c:out value="${rutina.objetivo}"/>
                                </p>
                                <c:if test="${not empty rutina.subcategoria}">
                                    <span class="inline-block mt-3 px-3 py-1 bg-surface-variant font-manrope text-xs text-on-surface-variant">
                                        <c:out value="${rutina.subcategoria}"/>
                                    </span>
                                </c:if>
                            </div>

                            <!-- Acciones -->
                            <div class="px-6 pb-6 flex items-center gap-3">
                                <form method="post" action="${pageContext.request.contextPath}/rutinas">
                                    <input type="hidden" name="action" value="guardar"/>
                                    <input type="hidden" name="nombre"       value="${rutina.nombre}"/>
                                    <input type="hidden" name="objetivo"     value="${rutina.objetivo}"/>
                                    <input type="hidden" name="categoria"    value="${rutina.categoria}"/>
                                    <input type="hidden" name="subcategoria" value="${rutina.subcategoria}"/>
                                    <button type="submit"
                                            class="flex items-center gap-2 font-manrope text-xs tracking-widest uppercase text-primary hover:text-tertiary transition-colors">
                                        <span class="material-symbols-outlined text-base">bookmark</span>
                                        Guardar
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>