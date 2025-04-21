<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Gesti�n de Recetas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo text-dark">

        <c:choose>
            <c:when test="${sessionScope.usuario.rol == 'admin'}">
                <jsp:include page="/includes/header.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:otherwise>
        </c:choose>

        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 600px;">
                <h2 class="text-center fw-bold text-uppercase">${empty id ? "CREAR" : "EDITAR"} RECETA</h2>

                <form method="post" action="/TiendaPanchon/Controladores/ControladorReceta">
                    <input type="hidden" name="id" value="${id}">
                    <input type="hidden" name="idUsuario" value="${idUsuario}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">T�TULO</label>
                        <input type="text" class="form-control" name="titulo" value="${titulo}" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">INGREDIENTES</label>
                        <textarea class="form-control" name="ingredientes" maxlength="500" required>${ingredientes}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DESCRIPCI�N</label>
                        <textarea class="form-control" name="descripcion" maxlength="500" required>${descripcion}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">PUBLICADA</label><br>
                        <input type="radio" name="publicada" value="1" ${publicada != null && publicada ? 'checked' : ''}> S�
                        <input type="radio" name="publicada" value="0" ${publicada == null || !publicada ? 'checked' : ''}> No
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="submit" name="${empty id ? 'crear' : 'editar'}" class="btn btn-crear px-4">Aceptar</button>
                        <c:if test="${not empty id}">
                            <button type="submit" name="eliminar" class="btn btn-eliminar" onclick="return confirm('�Est�s seguro de que deseas eliminar la receta ${titulo}?');">
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="../js/gestionReceta.js"></script>
    </body>
</html>
