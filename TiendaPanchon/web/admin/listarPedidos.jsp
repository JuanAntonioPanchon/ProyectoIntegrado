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
                                <p><strong>Fecha:</strong> ${pedido.fechaPedido}</p>
                                <p><strong>Precio:</strong> <fmt:formatNumber value="${pedido.precio}" type="currency" currencySymbol="€"/></p>
                                <p><strong>Estado:</strong> ${pedido.estado}</p>
                            </div>
                            <div class="card-footer bg-transparent border-0 d-flex justify-content-between">
                                <form action="/TiendaPanchon/Controladores.Admin/ControladorListarPedidos" method="post" onsubmit="return confirm('¿Seguro que deseas eliminar el pedido de ${pedido.usuario.nombre} ${pedido.usuario.apellidos}? con un total de ${pedido.precio} €')" class="me-2">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="idPedido" value="${pedido.id}">
                                    <button type="submit" class="btn btn-eliminar btn-sm">Cancelar Pedido</button>
                                </form>
                                <a href="/TiendaPanchon/Controladores.Admin/ControladorListarPedidos?accion=editar&idPedido=${pedido.id}" class="btn btn-editar btn-sm">Ver Pedido</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="ControladorAdmin" class="btn btn-secondary">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        
    </body>
</html>
