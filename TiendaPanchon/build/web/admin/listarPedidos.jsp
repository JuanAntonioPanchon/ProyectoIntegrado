<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Listado de Pedidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="colorFondo">

        <jsp:include page="/includes/header.jsp" />

        <div class="container my-5">
            <h1 class="text-center fw-bold mb-4">Gestionar Pedidos</h1>

            <c:if test="${not empty sessionScope.mensajeExito}">
                <div class="alert alert-success text-center fw-bold">${sessionScope.mensajeExito}</div>
                <c:remove var="mensajeExito" scope="session" />
            </c:if>

            <div class="row g-4">
                <c:forEach var="pedido" items="${pedidos}">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card tarjeta h-100 border-dark shadow">
                            <div class="card-body">
                                <p><strong>Nombre:</strong> ${pedido.usuario.nombre} ${pedido.usuario.apellidos}</p>
                                <p><strong>Email:</strong> ${pedido.usuario.email}</p>
                                <p><strong>Fecha:</strong> ${pedido.fechaPedido}</p>
                                <p><strong>Precio:</strong> <fmt:formatNumber value="${pedido.precio}" type="currency" currencySymbol="€"/></p>
                                <p><strong>Estado:</strong> ${pedido.estado}</p>
                            </div>
                            <div class="card-footer bg-transparent border-0 d-flex justify-content-between">
                                <form action="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos"
                                      method="post" class="form-cancelar-pedido me-2">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="idPedido" value="${pedido.id}">
                                    <button type="button"
                                            class="btn btn-eliminar btn-sm btn-cancelar-pedido"
                                            data-nombre="${pedido.usuario.nombre} ${pedido.usuario.apellidos}"
                                            data-precio="${pedido.precio}">
                                        Cancelar Pedido
                                    </button>
                                </form>
                                <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos?accion=editar&idPedido=${pedido.id}"
                                   class="btn btn-editar btn-sm">Ver Pedido</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Paginación -->
            <c:if test="${totalPaginas > 1}">
                <nav aria-label="Paginación de pedidos" class="mt-4">
                    <ul class="pagination pagination-personalizada justify-content-center">
                        <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos?pagina=${paginaActual - 1}">&laquo;</a>
                        </li>

                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                            <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos?pagina=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos?pagina=${paginaActual + 1}">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <div class="text-center mt-5">
                <a href="ControladorAdmin" class="btn btn-secondary">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const botones = document.querySelectorAll(".btn-cancelar-pedido");

                botones.forEach(boton => {
                    boton.addEventListener("click", function () {
                        const form = boton.closest("form");
                        const nombre = boton.dataset.nombre;
                        const precio = parseFloat(boton.dataset.precio).toFixed(2);

                        Swal.fire({
                            title: '¿Cancelar pedido?',
                            html: `¿Seguro que deseas cancelar el pedido?`,
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            cancelButtonText: 'No, volver',
                            confirmButtonText: 'Sí, cancelar'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                form.submit();
                            }
                        });
                    });
                });
            });
        </script>

    </body>
</html>
