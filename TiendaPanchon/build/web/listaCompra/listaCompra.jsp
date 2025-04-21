<%-- 
    Document   : listaCompra
    Created on : 31 mar 2025, 17:37:02
    Author     : juan-antonio
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de la Compra</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/estiloListaCompra.css">
        <link href="https://fonts.googleapis.com/css2?family=Switzer:wght@400;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <header class="cabecera">
            <div class="izquierdaCabecera">
                <h1>Lista de la Compra</h1>
            </div>
        </header>
        <main>
            <section class="contenedorLista">
                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>
                
                <table class="tablaLista">
                    <tr>
                        <th>Categoría</th>
                        <th>Producto</th>
                        <th>Acciones</th>
                    </tr>
                    <c:forEach var="producto" items="${productosLista}">
                        <tr>
                            <td>${producto.categoria.nombre}</td>
                            <td>${producto.nombre}</td>
                            <td>
                                <form action="ControladorListaCompra" method="post" class="formAccion">
                                    <input type="hidden" name="accion" value="eliminarProducto">
                                    <input type="hidden" name="idProducto" value="${producto.id}">
                                    <button type="submit" class="btnEliminar">Eliminar</button>
                                </form>
                                <button onclick="añadirAlCarrito(${producto.id})" class="btnCarrito">Añadir al carrito</button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>

                <form action="ControladorListaCompra" method="post" class="formEliminarLista">
                    <input type="hidden" name="accion" value="eliminarLista">
                    <button type="submit" class="btnEliminarLista">Eliminar toda la lista</button>
                </form>
            </section>
        </main>
        
        <script>
            function añadirAlCarrito(idProducto) {
                alert("Producto " + idProducto + " añadido al carrito.");
            }
        </script>
    </body>
</html>