<%-- 
    Document   : listarPedidos.jsp
    Created on : 29 abr 2025, 17:07:58
    Author     : juan-antonio
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    </head>
    <body>

        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">
               Fecha Pedido: ${pedido.fechaPedido}
            </h2>

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

            <div class="mt-5 text-end">
                <h5 class="fw-bold">Precio Total: 
                    <fmt:formatNumber value="${pedido.precio}" type="currency" currencySymbol="€"/>
                </h5>
            </div>

            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario" class="btn btn-secondary">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

    </body>
</html>
