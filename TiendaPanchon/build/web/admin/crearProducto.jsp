<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
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
                        <input type="number" class="form-control" step="0.01" name="precio" value="${precio}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">STOCK</label>
                        <input type="number" class="form-control" name="stock" value="${stock}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold d-block">NOVEDAD</label>

                        <!-- Sí -->
                        <div class="form-check form-check-inline">
                            <input class="form-check-input"
                                   type="radio"
                                   name="novedad"
                                   value="true"
                                   <c:if test="${empty id or novedad == 'true'}">checked</c:if>>
                                   <label class="form-check-label">Sí</label>
                            </div>

                            <!-- No -->
                            <div class="form-check form-check-inline">
                                <input class="form-check-input"
                                       type="radio"
                                       name="novedad"
                                       value="false"
                                <c:if test="${novedad == 'false'}">checked</c:if>
                                <c:if test="${empty id}">disabled</c:if>>
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

                    <!-- Campo editable para que el usuario pueda introducir el precio final -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">PRECIO FINAL (calculado o introducido)</label>
                        <input type="number" class="form-control" step="0.01" name="precioVenta">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${header.referer}" class="btn btn-volver px-4">Cancelar</a>
                        <button type="submit" name="${empty id ? 'crear' : 'editar'}" class="btn btn-crear px-4">Aceptar</button>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3">${error}</div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            function calcularPrecioVenta() {
                const precio = parseFloat(document.getElementsByName("precio")[0].value) || 0;
                const descuentoInput = document.getElementsByName("descuento")[0];
                const descuento = parseFloat(descuentoInput.value) || 0;
                const ofertaSi = document.querySelector('input[name="oferta"][value="true"]').checked;
                const precioVentaInput = document.getElementsByName("precioVenta")[0];

                if (ofertaSi) {
                    const precioConDescuento = precio - (precio * (descuento / 100));
                    precioVentaInput.value = precioConDescuento.toFixed(2);
                    precioVentaInput.removeAttribute("disabled");
                    descuentoInput.removeAttribute("disabled"); // ✅ Habilitar si hay oferta
                } else {
                    precioVentaInput.value = precio.toFixed(2);
                    precioVentaInput.setAttribute("disabled", "true");
                    descuentoInput.value = "0.00"; // ✅ Reiniciar si no hay oferta
                    descuentoInput.setAttribute("disabled", "true");
                }
            }

            function calcularDescuento() {
                const precio = parseFloat(document.getElementsByName("precio")[0].value);
                const precioVenta = parseFloat(document.getElementsByName("precioVenta")[0].value);
                const descuentoInput = document.getElementsByName("descuento")[0];

                if (!isNaN(precio) && !isNaN(precioVenta) && precio > 0 && precioVenta > 0) {
                    const descuento = ((precio - precioVenta) / precio) * 100;
                    descuentoInput.value = descuento.toFixed(2);
                }
            }

            window.onload = function () {
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

                calcularPrecioVenta();
                calcularDescuento();
            };
        </script>



    </body>
</html>
