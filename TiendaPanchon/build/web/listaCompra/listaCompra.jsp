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
        <link href="https://fonts.googleapis.com/css2?family=Switzer:wght@400;700&display=swap" rel="stylesheet">
        <style>
            .cabecera {
                padding: 1rem;
                background-color: #f8f9fa;
            }
            .contenedorLista {
                padding: 1.5rem;
            }
            .tablaLista {
                width: 100%;
                border-collapse: collapse;
            }
            .tablaLista th, .tablaLista td {
                border: 1px solid #dee2e6;
                padding: 0.75rem;
                text-align: left;
            }
            .btnEliminar, .btnCarrito, .btnEliminarLista {
                margin: 0.25rem;
            }
            .error {
                color: red;
                font-weight: bold;
                margin-bottom: 1rem;
            }
        </style>
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
                            <td>
                                <c:choose>
                                    <c:when test="${producto.stock > 0}">
                                        <a href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?id_categoria=${producto.categoria.id}#producto_${producto.id}">
                                            ${producto.nombre}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">${producto.nombre} (producto agotado en este momento)</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form action="ControladorListaCompra" method="post" class="formAccion" 
                                      onsubmit="return confirm('¿Estás seguro que quieres eliminar el producto ${producto.nombre}?');">
                                    <input type="hidden" name="accion" value="eliminarProducto">
                                    <input type="hidden" name="idProducto" value="${producto.id}">
                                    <button type="submit" class="btnEliminar">Eliminar</button>
                                </form>

                                <button onclick="alert('Producto ${producto.nombre} añadido al carrito.')" class="btnCarrito">
                                    Añadir al carrito
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>


                <form action="ControladorListaCompra" method="post" class="formEliminarLista"
                      onsubmit="return confirm('¿Estás seguro que quieres vaciar la lista de la compra completa?');">
                    <input type="hidden" name="accion" value="eliminarLista">
                    <button type="submit" class="btnEliminarLista">Eliminar toda la lista</button>
                </form>
            </section>
        </main>

    </body>
</html>
