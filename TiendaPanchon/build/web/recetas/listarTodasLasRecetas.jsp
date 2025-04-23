<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Listado de Recetas</title>
        <!-- Bootstrap y estilos -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/recetas.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="../js/filtrarRecetas.js"></script>
    </head>
    <body>
        <!-- Cabecera segun rol -->
        <c:choose>
            <c:when test="${sessionScope.usuario.rol == 'admin'}">
                <jsp:include page="/includes/header.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:otherwise>
        </c:choose>

        <main class="container py-4">

            <!-- Botones Mis Recetas y Ver Recetas de Otros Usuarios -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <a href="/TiendaPanchon/Controladores/ControladorReceta" 
                       class="btn btn btn-ver ${pageContext.request.requestURI.contains('listarRecetas') ? 'active' : ''}">
                        Mis Recetas
                    </a>
                </div>
                <div>
                    <a href="/TiendaPanchon/Controladores/ControladorListadoReceta" 
                       class="btn btn btn-ver ${pageContext.request.requestURI.contains('listarTodasLasRecetas') ? 'active' : ''}">
                        Ver Recetas de Otros Usuarios
                    </a>
                </div>
            </div>

            <h3 class="mb-4">Listado de Recetas</h3>

            <div class="mb-4">
                <label for="filtro" class="form-label">Filtrar Recetas:</label>
                <input type="text" name="filtro" id="filtro" class="form-control" onkeyup="filtrar()">
            </div>

            <div id="listado">
                <c:import url="../Controladores/ControladorFiltrarRecetas">
                    <c:param name="filtro" value=""/>
                </c:import> 
            </div>

            <div class="mt-4">
                <a href="../Controladores/ControladorReceta" class="btn btn-volver">Volver</a>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
        
    </body>
</html>
