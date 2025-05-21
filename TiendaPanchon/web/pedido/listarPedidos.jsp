<%-- 
    Document   : listarPedidos.jsp
    Created on : 29 abr 2025, 17:07:58
    Author     : juan-antonio
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Mis Pedidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="colorFondo">

        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container my-5">
            <h1 class="text-center fw-bold mb-4">Mis Pedidos</h1>

            <c:if test="${not empty sessionScope.mensajeError}">
                <div class="alert alert-danger text-center fw-bold">${sessionScope.mensajeError}</div>
                <c:remove var="mensajeError" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.mensajeExito}">
                <div class="alert alert-success text-center fw-bold">${sessionScope.mensajeExito}</div>
                <c:remove var="mensajeExito" scope="session" />
            </c:if>

            <div class="row g-4">
                <c:forEach var="pedido" items="${pedidos}">
                    <fmt:formatNumber value="${pedido.precio}" type="currency" currencySymbol="€" var="precioFormateado" />
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card tarjeta h-100 border-dark shadow">
                            <div class="card-body">
                                <p><strong>Fecha:</strong> ${pedido.fechaPedido}</p>
                                <p><strong>Precio:</strong> ${precioFormateado}</p>
                                <p><strong>Estado:</strong> ${pedido.estado}</p>
                            </div>
                            <div class="card-footer bg-transparent border-0 d-flex justify-content-between">
                                <form action="/TiendaPanchon/Controladores.Pedidos/ControladorPedidosUsuario" method="post" class="form-cancelar-pedido me-2">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="idPedido" value="${pedido.id}">
                                    <button type="button"
                                            class="btn btn-eliminar btn-sm btn-cancelar-pedido"
                                            data-precio="${precioFormateado}">
                                        Cancelar Pedido
                                    </button>
                                </form>
                                <a href="/TiendaPanchon/Controladores.Pedidos/ControladorPedidosUsuario?accion=editar&idPedido=${pedido.id}" class="btn btn-editar btn-sm">Ver Pedido</a>
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
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario?pagina=${paginaActual - 1}">&laquo;</a>
                        </li>

                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                            <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario?pagina=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario?pagina=${paginaActual + 1}">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <div class="text-center mt-5">
                <a href="/TiendaPanchon/Controladores/ControladorInicio" class="btn btn-secondary">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <!-- SWEETALERT2: Confirmar cancelar pedido -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const botonesCancelar = document.querySelectorAll(".btn-cancelar-pedido");

                botonesCancelar.forEach(btn => {
                    btn.addEventListener("click", function () {
                        const form = btn.closest("form");
                        const precio = btn.dataset.precio;

                        Swal.fire({
                            title: '¿Cancelar pedido?',
                            html: `¿Seguro que deseas cancelar este pedido?`,
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
