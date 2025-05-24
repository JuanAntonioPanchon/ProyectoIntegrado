<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${empty id ? "Crear" : "Editar"} Producto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />

        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">${empty id ? "CREAR" : "EDITAR"} PRODUCTO</h2>

                <form method="post" action="${pageContext.request.contextPath}/Controladores.Admin/ControladorProducto">
                    <input type="hidden" name="referer" value="${header.referer}">
                    <input type="hidden" name="id" value="${id}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">NOMBRE</label>
                        <input type="text" class="form-control" name="nombre" value="${nombre}" maxlength="100" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">CATEGORÍA</label>
                        <select class="form-select" name="id_categoria" required>
                            <option value="" disabled ${empty id_categoria ? 'selected' : ''}>Seleccione una categoría</option>
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
                        <input type="text" class="form-control" name="precio" value="${precio}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">STOCK</label>
                        <input type="text" class="form-control" name="stock" value="${stock}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold d-block">NOVEDAD</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="novedad" value="true" <c:if test="${empty id or novedad == 'true'}">checked</c:if>>
                                <label class="form-check-label">Sí</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="novedad" value="false" <c:if test="${novedad == 'false'}">checked</c:if> <c:if test="${empty id}">disabled</c:if>>
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
                        <input type="text" class="form-control" name="descuento" value="${empty descuento ? '0.00' : descuento}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">PRECIO FINAL (calculado o introducido)</label>
                        <input type="text" class="form-control" name="precioVenta" required>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="button" class="btn btn-crear px-4" id="btnAceptar">Aceptar</button>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                        <c:remove var="error" scope="session"/>
                    </c:if>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            function calcularPrecioVenta() {
                const precio = parseFloat(document.getElementsByName("precio")[0].value.replace(",", ".")) || 0;
                const descuentoInput = document.getElementsByName("descuento")[0];
                const descuento = parseFloat(descuentoInput.value.replace(",", ".")) || 0;
                const ofertaSi = document.querySelector('input[name="oferta"][value="true"]').checked;
                const precioVentaInput = document.getElementsByName("precioVenta")[0];

                if (ofertaSi) {
                    const precioConDescuento = precio - (precio * (descuento / 100));
                    precioVentaInput.value = precioConDescuento.toFixed(2);
                    precioVentaInput.removeAttribute("disabled");
                    descuentoInput.removeAttribute("disabled");
                } else {
                    precioVentaInput.value = precio.toFixed(2);
                    precioVentaInput.setAttribute("disabled", "true");
                    descuentoInput.value = "0.00";
                    descuentoInput.setAttribute("disabled", "true");
                }
            }

            function calcularDescuento() {
                const precio = parseFloat(document.getElementsByName("precio")[0].value.replace(",", "."));
                const precioVenta = parseFloat(document.getElementsByName("precioVenta")[0].value.replace(",", "."));
                const descuentoInput = document.getElementsByName("descuento")[0];

                if (!isNaN(precio) && !isNaN(precioVenta) && precio > 0 && precioVenta > 0) {
                    const descuento = ((precio - precioVenta) / precio) * 100;
                    descuentoInput.value = descuento.toFixed(2);
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                const form = document.querySelector("form[action*='ControladorProducto']");
                const campos = {
                    nombre: {
                        regex: /^[A-ZÁÉÍÓÚÑ][a-zA-ZÁÉÍÓÚÑáéíóúñü ]{0,99}$/,
                        mensaje: "Debe empezar con mayúscula. Solo letras y espacios. Máx. 100 caracteres."
                    },
                    descripcion: {
                        regex: /^[A-ZÁÉÍÓÚÑ][a-zA-ZÁÉÍÓÚÑáéíóúñü0-9 ,\.\-()!?¡¿%$\"]{0,199}$/,
                        mensaje: "Debe empezar con mayúscula. Puede contener letras, números y símbolos comunes. Máx. 200 caracteres."
                    },
                    precio: {
                        regex: /^\d+([.,]\d{1,2})?$/,
                        mensaje: "El precio debe ser un número positivo."
                    },
                    stock: {
                        regex: /^(\d{1,4}|10000)$/,
                        mensaje: "Stock debe ser un número entre 0 y 10000."
                    },
                    descuento: {
                        regex: /^\d+([.,]\d{1,2})?$/,
                        mensaje: "El descuento debe ser un número positivo."
                    },
                    precioVenta: {
                        regex: /^\d+([.,]\d{1,2})?$/,
                        mensaje: "El precio final debe ser un número positivo."
                    }
                };

                // SweetAlert2 Confirmar
                const btnAceptar = form.querySelector("button.btn-crear");
                btnAceptar.addEventListener("click", function (e) {
                    e.preventDefault();

                    let valido = true;
                    Object.keys(campos).forEach(nombreCampo => {
                        if (!validarCampo(nombreCampo))
                            valido = false;
                    });

                    if (!valido)
                        return;

                    document.getElementsByName("descuento")[0].removeAttribute("disabled");
                    document.getElementsByName("precioVenta")[0].removeAttribute("disabled");

                    const nombreProducto = form["nombre"].value.trim();
                    const accion = '${empty id ? "crear" : "editar"}';

                    Swal.fire({
                        title: accion === 'crear' ? '¿Crear producto?' : '¿Guardar cambios?',
                        text: accion === 'crear'
                                ? `¿Estás seguro de que quieres crear el producto?`
                                : `Se modificarán los datos del producto. ¿Estas seguro de continuar?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#336b30',
                        cancelButtonText: 'No, volver',
                        confirmButtonText: 'Sí, continuar'
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

                function validarCampo(nombreCampo) {
                    const input = form[nombreCampo];
                    const {regex, mensaje} = campos[nombreCampo];
                    let valor = input.value.trim().replace(",", ".");

                    if (!regex.test(valor)) {
                        mostrarError(input, mensaje);
                        return false;
                    }

                    const valorNumerico = parseFloat(valor);
                    if (!isNaN(valorNumerico) && valorNumerico < 0) {
                        mostrarError(input, mensaje);
                        return false;
                    }

                    eliminarError(input);
                    return true;
                }

                // Este bloque valida los campos desde el principio solo si deben hacerlo
                Object.keys(campos).forEach(nombreCampo => {
                    const input = form[nombreCampo];
                    if (input) {
                        // Mostrar errores desde el principio excepto para precioVenta
                        if (nombreCampo !== "precioVenta") {
                            validarCampo(nombreCampo); // Esto lanza errores iniciales visibles
                        }

                        // Validación dinámica al escribir
                        input.addEventListener("input", () => {
                            input.value = input.value.replace(",", ".");
                            validarCampo(nombreCampo);
                        });
                    }
                });


                form.addEventListener("submit", function (e) {
                    let valido = true;
                    Object.keys(campos).forEach(nombreCampo => {
                        if (!validarCampo(nombreCampo))
                            valido = false;
                    });

                    // Habilitar campos deshabilitados antes de enviar
                    document.getElementsByName("descuento")[0].removeAttribute("disabled");
                    document.getElementsByName("precioVenta")[0].removeAttribute("disabled");

                    if (!valido)
                        e.preventDefault();
                });

                calcularPrecioVenta();
                calcularDescuento();

                const precioInput = document.getElementsByName("precio")[0];
                const descuentoInput = document.getElementsByName("descuento")[0];
                const precioVentaInput = document.getElementsByName("precioVenta")[0];
                const ofertaRadios = document.querySelectorAll('input[name="oferta"]');

                if (precioInput) {
                    precioInput.addEventListener("input", function () {
                        calcularPrecioVenta();
                        calcularDescuento();
                    });
                }

                if (descuentoInput) {
                    descuentoInput.addEventListener("input", function () {
                        calcularPrecioVenta();
                    });
                }

                ofertaRadios.forEach(function (radio) {
                    radio.addEventListener("change", function () {
                        calcularPrecioVenta();
                        calcularDescuento();
                    });
                });

                if (precioVentaInput) {
                    precioVentaInput.addEventListener("input", function () {
                        calcularDescuento();
                    });
                }
            });


        </script>

    </body>
</html>
