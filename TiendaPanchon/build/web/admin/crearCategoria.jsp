<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>${empty id ? "Crear" : "Editar"} Categoría</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />
        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">${empty id ? "CREAR" : "EDITAR"} CATEGORÍA</h2>

                <form method="post" action="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias">
                    <input type="hidden" name="referer" value="${header.referer}">
                    <input type="hidden" name="id" value="${id}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">NOMBRE DE LA CATEGORÍA</label>
                        <input type="text" class="form-control" name="nombre" value="${nombre}" maxlength="50" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="submit" name="${empty id ? 'crear' : 'editar'}" class="btn btn-crear px-4">Aceptar</button>
                        <c:if test="${not empty id}">
                            <button type="submit" name="eliminar" class="btn btn-eliminar"
                                    onclick="return confirm('¿Estás seguro que quieres eliminar la categoría \'${nombre}\'?\nSe eliminarán todos los productos asociados a esta categoría.');">
                                Eliminar
                            </button>
                        </c:if>


                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                    </c:if>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
    </body>
</html>
