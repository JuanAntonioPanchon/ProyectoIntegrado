<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>${empty id ? "Crear" : "Editar"} Categor�a</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />

        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">${empty id ? "CREAR" : "EDITAR"} CATEGOR�A</h2>

                <form method="post" action="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias">
                    <input type="hidden" name="referer" value="${header.referer}">
                    <input type="hidden" name="id" value="${id}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">NOMBRE DE LA CATEGOR�A</label>
                        <input type="text" class="form-control" name="nombre" value="${nombre}" maxlength="50" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="button" class="btn btn-crear px-4" id="btnAceptar">Aceptar</button>
                        <c:if test="${not empty id}">
                            <button type="button" class="btn btn-eliminar" id="btnEliminar">Eliminar</button>
                        </c:if>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                    </c:if>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.querySelector("form[action*='ControladorListarCategorias']");
                const inputNombre = form.querySelector("input[name='nombre']");
                const btnAceptar = document.getElementById("btnAceptar");
                const btnEliminar = document.getElementById("btnEliminar");
                form.addEventListener("keydown", function (event) {
                    if (event.key === "Enter" && event.target.tagName !== "TEXTAREA") {
                        event.preventDefault();
                    }
                });

                const regex = /^[A-Z������][a-zA-Z������������ ]{0,14}$/;
                const mensaje = "Debe comenzar con may�scula, solo letras y espacios. M�x. 15 caracteres.";

                function mostrarError(input, mensaje) {
                    eliminarError(input);
                    const div = document.createElement("div");
                    div.className = "text-danger mt-1 small";
                    div.textContent = mensaje;
                    input.parentElement.appendChild(div);
                }

                function eliminarError(input) {
                    const error = input.parentElement.querySelector(".text-danger");
                    if (error)
                        error.remove();
                }

                function validarNombreCategoria() {
                    const valor = inputNombre.value.trim();
                    if (!regex.test(valor)) {
                        mostrarError(inputNombre, mensaje);
                        return false;
                    } else {
                        eliminarError(inputNombre);
                        return true;
                    }
                }

                inputNombre.addEventListener("input", validarNombreCategoria);
                validarNombreCategoria();

                //SweetAlert2 Confirmar
                btnAceptar.addEventListener("click", function (e) {
                    e.preventDefault();
                    if (!validarNombreCategoria())
                        return;

                    const accion = '${empty id ? "crear" : "editar"}';
                    Swal.fire({
                        title: accion === 'crear' ? '�Crear categor�a?' : '�Guardar cambios?',
                        text: accion === 'crear'
                                ? 'Se a�adir� una nueva categor�a con este nombre.'
                                : 'Se modificar�n los datos de la categor�a.',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#336b30',
                        confirmButtonText: 'S�, continuar',
                        cancelButtonText: 'No, volver'
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

                // SweetAlert2 Eliminar
                if (btnEliminar) {
                    btnEliminar.addEventListener("click", function (e) {
                        e.preventDefault();
                        Swal.fire({
                            title: '�Eliminar categor�a?',
                            text: '�Est�s seguro de eliminar la categor�a "${nombre}"?\nSe eliminar�n todos los productos asociados.',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'S�, eliminar',
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
