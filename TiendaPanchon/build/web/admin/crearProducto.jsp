<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>${empty id ? "Crear" : "Editar"} Producto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />
        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">${empty id ? "CREAR" : "EDITAR"} PRODUCTO</h2>

                <form method="post" action="/TiendaPanchon/Controladores.Admin/ControladorProducto">
                    <input type="hidden" name="referer" value="${header.referer}">
                    <input type="hidden" name="id" value="${id}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">NOMBRE</label>
                        <input type="text" class="form-control" name="nombre" value="${nombre}" maxlength="100" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">CATEGORÍA</label>
                        <select class="form-select" name="id_categoria" required>
                            <option value="" disabled selected>Seleccione una categoría</option>
                            <c:forEach var="categoria" items="${categorias}">
                                <option value="${categoria.id}" ${categoria.id == id_categoria ? 'selected' : ''}>
                                    ${categoria.nombre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DESCRIPCIÓN</label>
                        <textarea class="form-control" name="descripcion" required>${descripcion}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">PRECIO</label>
                        <input type="number" class="form-control" step="0.01" name="precio" value="${precio}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">STOCK</label>
                        <input type="number" class="form-control" name="stock" value="${stock}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold d-block">NOVEDAD</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="novedad" value="true">
                            <label class="form-check-label">Sí</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="novedad" value="false" checked>
                            <label class="form-check-label">No</label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold d-block">OFERTA</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="oferta" value="true" ${oferta == 'true' ? 'checked' : ''}>
                            <label class="form-check-label">Sí</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="oferta" value="false" ${oferta == 'false' || oferta == null ? 'checked' : ''}>
                            <label class="form-check-label">No</label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DESCUENTO %</label>
                        <input type="number" class="form-control" step="0.01" name="descuento" value="${descuento}">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="submit" name="${empty id ? 'crear' : 'editar'}" class="btn btn-crear px-4">Aceptar</button>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                    </c:if>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />


        <script type="text/javascript" src="../js/gestionProducto.js"></script>
    </body>
</html>
