<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Biblioteca SENA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="layout-wrapper">
        <%@ include file="/includes/navbar.jsp" %>
        
        <main class="main-content">
            <div class="content-header">
                <h1><i class="fas fa-exclamation-triangle" style="color: #8B3A3A;"></i> Error del Sistema</h1>
            </div>
            
            <div class="card" style="text-align: center; padding: 3rem;">
                <div style="font-size: 6rem; color: #8B3A3A; margin-bottom: 1rem;">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                
                <h2 style="color: #8B3A3A; margin-bottom: 1rem;">Ha ocurrido un error</h2>
                
                <p style="color: #666; margin-bottom: 2rem; max-width: 500px; margin-left: auto; margin-right: auto;">
                    Se produjo un error inesperado en el sistema. Por favor intente nuevamente o contacte al administrador.
                </p>
                
                <c:if test="${not empty pageContext.exception}">
                    <div style="background: #f8f8f8; border-left: 4px solid #8B3A3A; padding: 1rem; margin: 1rem auto; max-width: 600px; text-align: left; font-family: monospace; font-size: 0.85rem; color: #666;">
                        <strong>Error técnico:</strong><br>
                        ${pageContext.exception.message}
                    </div>
                </c:if>
                
                <div style="margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">
                        <i class="fas fa-home"></i> Ir al Inicio
                    </a>
                    <a href="javascript:history.back()" class="btn btn-secondary" style="margin-left: 0.5rem;">
                        <i class="fas fa-arrow-left"></i> Volver Atrás
                    </a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>