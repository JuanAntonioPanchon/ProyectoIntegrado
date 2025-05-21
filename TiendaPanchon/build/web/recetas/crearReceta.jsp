<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Recetas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
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
                    <input type="hidden" name="pagina" value="${paginaActual}">


                    <div class="mb-3">
                        <label class="form-label fw-bold">TÍTULO</label>
                        <input type="text" class="form-control" name="titulo" value="${titulo}" maxlength="30" required>
                        <div class="small text-danger" id="errorTitulo"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">INGREDIENTES</label>
                        <textarea class="form-control" name="ingredientes" maxlength="400" required>${ingredientes}</textarea>
                        <div class="small text-danger" id="errorIngredientes"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DESCRIPCIÓN</label>
                        <textarea class="form-control" name="descripcion" maxlength="400" required>${descripcion}</textarea>
                        <div class="small text-danger" id="errorDescripcion"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">PUBLICADA</label><br>
                        <input type="radio" name="publicada" value="1" ${publicada != null && publicada ? 'checked' : ''}> Sí
                        <input type="radio" name="publicada" value="0" ${publicada == null || !publicada ? 'checked' : ''}> No
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" id="btnCancelar" class="btn btn-volver px-4">Cancelar</button>
                        <button type="button" id="btnAceptar" class="btn btn-crear px-4">Aceptar</button>
                        <c:if test="${not empty id}">
                            <button type="button" id="btnEliminar" class="btn btn-eliminar">Eliminar</button>
                        </c:if>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                    </c:if>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('formReceta');
                const titulo = form['titulo'];
                const ingredientes = form['ingredientes'];
                const descripcion = form['descripcion'];

                const errorTitulo = document.getElementById("errorTitulo");
                const errorIngredientes = document.getElementById("errorIngredientes");
                const errorDescripcion = document.getElementById("errorDescripcion");

                function validarCampos() {
                    let valido = true;

                    const regexTitulo = /^[A-ZÁÉÍÓÚÑ][\w\sÁÉÍÓÚÑáéíóúñü]{0,29}$/;
                    const regexTextoMayuscula = /^[A-ZÁÉÍÓÚÑ][^<>]{0,399}$/;

                    if (!regexTitulo.test(titulo.value.trim())) {
                        errorTitulo.textContent = "Debe comenzar con mayúscula. Solo letras, números y espacios. Máx. 30 caracteres.";
                        valido = false;
                    } else {
                        errorTitulo.textContent = "";
                    }

                    if (!regexTextoMayuscula.test(ingredientes.value.trim())) {
                        errorIngredientes.textContent = "Debe comenzar con mayúscula. No se permiten '<' ni '>'. Máx. 400 caracteres.";
                        valido = false;
                    } else {
                        errorIngredientes.textContent = "";
                    }

                    if (!regexTextoMayuscula.test(descripcion.value.trim())) {
                        errorDescripcion.textContent = "Debe comenzar con mayúscula. No se permiten '<' ni '>'. Máx. 400 caracteres.";
                        valido = false;
                    } else {
                        errorDescripcion.textContent = "";
                    }

                    return valido;
                }

                document.getElementById('btnAceptar').addEventListener('click', function () {
                    if (!validarCampos())
                        return;

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
                            const inputEliminar = document.createElement('input');
                            inputEliminar.type = 'hidden';
                            inputEliminar.name = 'eliminar';
                            form.appendChild(inputEliminar);

                            const inputPagina = document.createElement('input');
                            inputPagina.type = 'hidden';
                            inputPagina.name = 'pagina';
                            inputPagina.value = '${paginaActual}';
                            form.appendChild(inputPagina);

                            form.submit();
                        }
                    });
                });

                document.getElementById('btnCancelar').addEventListener('click', function () {
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

                const btnEliminar = document.getElementById('btnEliminar');
                if (btnEliminar) {
                    btnEliminar.addEventListener('click', function () {
                        Swal.fire({
                            title: '¿Eliminar receta?',
                            text: '¿Estás seguro de eliminar la receta "${titulo}"?',
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
