<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Detalle del Pedido</title>
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>

        <jsp:include page="/includes/header.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">
                Pedido de ${pedido.usuario.nombre} ${pedido.usuario.apellidos}
            </h2>

            <div class="mb-4 text-center">
                <p><strong>Fecha:</strong> ${pedido.fechaPedido}</p>
                <p><strong>Email:</strong> ${pedido.usuario.email}</p>
            </div>

            <h4 class="fw-semibold">Productos del Pedido</h4>
            <div class="table-responsive">
                <table class="tabla-personalizada table table-bordered text-center">
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th>Categoría</th>
                            <th>Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="producto" items="${productos}">
                            <tr>
                                <td>${producto.producto.nombre}</td>
                                <td>${producto.producto.categoria.nombre}</td>
                                <td>${producto.cantidad}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <h4 class="fw-semibold mt-5">Estado del Pedido</h4>
            <form action="/TiendaPanchon/Controladores.Admin/ControladorActualizarEstado" method="post" class="row g-3 mt-2" id="formActualizarEstado">
                <input type="hidden" name="accion" value="actualizarEstado">
                <input type="hidden" name="idPedido" value="${pedido.id}">

                <div class="col-md-4">
                    <label for="estado" class="form-label">Estado:</label>
                    <select name="estado" id="estado" class="form-select">
                        <option value="proceso" <c:if test="${pedido.estado == 'proceso'}">selected</c:if>>En Proceso</option>
                        <option value="enviado" <c:if test="${pedido.estado == 'enviado'}">selected</c:if>>Enviado</option>
                        <option value="finalizado" <c:if test="${pedido.estado == 'finalizado'}">selected</c:if>>Finalizado</option>
                        </select>
                    </div>

                    <div class="col-md-4 align-self-end">
                        <button type="button" class="btn btn-crear" id="btnActualizarEstado">Actualizar Estado</button>
                    </div>

                    <div class="col-md-4 align-self-end text-end">
                        <h5 class="fw-bold">Precio Total: <fmt:formatNumber value="${pedido.precio}" type="currency" currencySymbol="€"/></h5>
                </div>
            </form>

            <div class="text-center mt-5">
                <a href="ControladorListarPedidos" class="btn btn-secondary">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("formActualizarEstado");
                const btn = document.getElementById("btnActualizarEstado");
                const selectEstado = document.getElementById("estado");

                btn.addEventListener("click", function () {
                    const estadoSeleccionado = selectEstado.options[selectEstado.selectedIndex].text;

                    Swal.fire({
                        title: '¿Actualizar estado?',
                        html: `Se actualizará el estado del pedido ¿Deseas continuar?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#336b30',
                        cancelButtonText: 'No, volver',
                        confirmButtonText: 'Sí, actualizar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                });
            });
        </script>

    </body>
</html>
