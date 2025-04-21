<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Gráfica de Productos Más Vendidos</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Estilos personalizados -->
        <link rel="stylesheet" type="text/css" href="/TiendaPanchon/estilos/grafica.css">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">

        <!-- Highcharts -->
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/highcharts-3d.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/modules/export-data.js"></script>
        <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    </head>
    <body class="color">
        <jsp:include page="/includes/header.jsp"/>

        <div class="container text-center py-4">
            <h1 class="fw-bold mb-4" style="font-family: 'Comic Sans MS', cursive;">Gráfica Productos más vendidos entre 2 fechas</h1>

            <form method="get" action="${pageContext.request.contextPath}/Controladores.Admin/ControladorGrafica" class="row align-items-end gx-5 gy-3 mb-4">

                <div class="col-md-3">
                    <label for="fecha_inicio" class="form-label fw-bold">Fecha inicio</label>
                    <input id="fecha_inicio" type="date" class="form-control colorVerde text-center" name="fechaInicio"
                           value="${param.fechaInicio}" max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" required />
                </div>

                <div class="col-md-3">
                    <label for="fecha_fin" class="form-label fw-bold">Fecha fin</label>
                    <input id="fecha_fin" type="date" class="form-control colorVerde text-center" name="fechaFin"
                           value="${param.fechaFin}" max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" required />
                </div>

                <div class="col-md-3">
                    <label for="categoria_grafica" class="form-label fw-bold">Categoría</label>
                    <select id="categoria_grafica" name="categoriaId" class="form-select colorVerde text-center" required>
                        <c:forEach var="categoria" items="${categorias}">
                            <option value="${categoria.id}" ${param.categoriaId == categoria.id ? 'selected' : ''}>
                                ${categoria.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn colorVerde w-100">Generar Gráfica</button>
                </div>

                <div class="col-md-1">
                    <a href="ControladorAdmin" class="btn btn-secondary   text-wrap">Volver</a>

                </div>


            </form>



            <!-- Mensaje de error -->
            <c:if test="${not empty errorFecha}">
                <div class="alert alert-danger">
                    <strong>${errorFecha}</strong>
                </div>
            </c:if>

            <!-- Validaciones -->
            <c:choose>
                <c:when test="${empty param.fechaInicio || empty param.fechaFin || empty param.categoriaId}">
                    <div class="alert alert-warning">
                        Por favor, inserte <strong>dos fechas</strong> y una <strong>categoría</strong> para ver la cantidad de productos vendidos.
                    </div>
                </c:when>

                <c:when test="${empty productos && empty errorFecha}">
                    <c:set var="categoriaSeleccionada" value="${param.categoriaId}" />
                    <c:set var="nombreCategoria" value="" />
                    <c:forEach var="categoria" items="${categorias}">
                        <c:if test="${categoria.id == categoriaSeleccionada}">
                            <c:set var="nombreCategoria" value="${categoria.nombre}" />
                        </c:if>
                    </c:forEach>
                    <div class="alert alert-info">
                        No hay productos de la categoría <strong>${nombreCategoria}</strong> que se hayan vendido entre las fechas <strong>${param.fechaInicio}</strong> y <strong>${param.fechaFin}</strong>.
                    </div>
                </c:when>
            </c:choose>

            <!-- Gráfica -->
            <figure class="highcharts-figure mx-auto" style="max-width: 1000px;">
                <div id="container" style="height: 400px;"></div>
            </figure>

        </div>

        <jsp:include page="/includes/footer.jsp" />

        <!-- Script para cargar la gráfica -->
        <script src="${pageContext.request.contextPath}/js/grafica.js"></script>
        <c:if test="${not empty productos}">
            <script>
                var productos = [
                <c:forEach var="producto" items="${productos}" varStatus="status">
                ['${fn:escapeXml(producto[0])}', ${producto[1]}]<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                ];
                crearGraficaProductos(productos);
            </script>
        </c:if>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
