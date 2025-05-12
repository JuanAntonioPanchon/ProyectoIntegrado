<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Gestión de Recetas</title>
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

                <form method="post" action="${pageContext.request.contextPath}/Controladores/ControladorReceta" id="formReceta">
                    <input type="hidden" name="id" value="${id}">
                    <input type="hidden" name="idUsuario" value="${idUsuario}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">TÍTULO</label>
                        <input type="text" class="form-control" name="titulo" value="${titulo}" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">INGREDIENTES</label>
                        <textarea class="form-control" name="ingredientes" maxlength="500" required>${ingredientes}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DESCRIPCIÓN</label>
                        <textarea class="form-control" name="descripcion" maxlength="500" required>${descripcion}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">PUBLICADA</label><br>
                        <input type="radio" name="publicada" value="1" ${publicada != null && publicada ? 'checked' : ''}> Sí
                        <input type="radio" name="publicada" value="0" ${publicada == null || !publicada ? 'checked' : ''}> No
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" id="btnCancelar" class="btn btn-volver px-4">Cancelar</button>

                        <button type="button" id="btnAceptar" class="btn btn-crear px-4">
                            Aceptar
                        </button>

                        <c:if test="${not empty id}">
                            <button type="button" id="btnEliminar" class="btn btn-eliminar">
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

        <!-- Librerías necesarias -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script type="text/javascript" src="../js/gestionReceta.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const btnCancelar = document.getElementById('btnCancelar');
                const btnAceptar = document.getElementById('btnAceptar');
                const btnEliminar = document.getElementById('btnEliminar');
                const form = document.getElementById('formReceta');

                if (btnCancelar) {
                    btnCancelar.addEventListener('click', function () {
                        Swal.fire({
                            title: '¿Cancelar cambios?',
                            text: 'Perderás la información que no hayas guardado.',
                            icon: 'warning',
                            confirmButtonColor: '#336b30',
                            showCancelButton: true,
                            confirmButtonText: 'Sí, cancelar',
                            cancelButtonText: 'No, volver'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.history.back();
                            }
                        });
                    });
                }

                if (btnAceptar) {
                    btnAceptar.addEventListener('click', function () {
                        const accion = '${empty id ? 'crear' : 'editar'}';
                        Swal.fire({
                            title: '¿Confirmar?',
                            text: accion === 'crear' ? '¿Deseas crear esta receta?' : '¿Deseas guardar los cambios?',
                            icon: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#336b30',
                            confirmButtonText: 'Sí, continuar',
                            cancelButtonText: 'No, revisar'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                const inputAccion = document.createElement('input');
                                inputAccion.type = 'hidden';
                                inputAccion.name = accion;
                                form.appendChild(inputAccion);
                                form.submit();
                            }
                        });
                    });
                }

                if (btnEliminar) {
                    btnEliminar.addEventListener('click', function () {
                        Swal.fire({
                            title: '¿Eliminar receta?',
                            text: '¿Estás seguro de eliminar la receta \"${titulo}\"?',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Sí, eliminar',
                            cancelButtonText: 'Cancelar'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                const inputEliminar = document.createElement('input');
                                inputEliminar.type = 'hidden';
                                inputEliminar.name = 'eliminar';
                                form.appendChild(inputEliminar);
                                form.submit();
                            }
                        });
                    });
                }
            });
        </script>

    </body>
</html>
