<%-- 
    Document   : carrito.jsp
    Created on : 31 mar 2025, 18:39:21
    Author     : juan-antonio
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Carrito de Compras</title>
    </head>
    <body>
        <h1>Carrito de Compras</h1>
        <table border="1">
            <tr>
                <th>ID Producto</th>
                <th>Cantidad</th>
                <th>Precio Total</th>
            </tr>
            <c:if test="${not empty carrito}">
                <c:forEach var="producto" items="${carrito}">
                    <tr>
                        <td>${producto.idProducto}</td>
                        <td>${producto.cantidad}</td>
                        <td>${producto.totalPrecio}</td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty carrito}">
                <tr>
                    <td colspan="3">No hay productos en el carrito.</td>
                </tr>
            </c:if>
        </table>
        <br>
        <a href="index.jsp">Volver a la tienda</a>
    </body>
</html>
