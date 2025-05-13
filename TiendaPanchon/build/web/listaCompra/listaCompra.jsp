<%-- 
    Document   : listaCompra
    Created on : 31 mar 2025, 17:37:02
    Author     : juan-antonio
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lista de la Compra</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <style>
            a.enlace-producto {
                text-decoration: none !important;
                font-weight: 500;
                color: #000 !important;
                cursor: pointer;
            }
            a.enlace-producto:hover {
                text-decoration: none !important;
                color: #000 !important;
            }

        </style>
    </head>
    <body class="colorFondo">
        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">LISTA DE LA COMPRA</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center fw-bold">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty productosLista}">
                    <div class="table-responsive">
                        <table class="tabla-personalizada table table-bordered text-center align-middle">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th>Categoría</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="tablaListaCompra">
                                <c:forEach var="producto" items="${productosLista}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${producto.stock > 0}">
                                                    <a class="enlace-producto"
                                                       href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?id_categoria=${producto.categoria.id}#producto_${producto.id}">
                                                        ${producto.nombre}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">${producto.nombre} (producto agotado en este momento)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${producto.categoria.nombre}</td>
                                        <td>
                                            <form method="post" action="ControladorListaCompra" style="display:inline;"
                                                  onsubmit="return confirm('¿Estás seguro que quieres eliminar el producto ${producto.nombre}?');">
                                                <input type="hidden" name="accion" value="eliminarProducto">
                                                <input type="hidden" name="idProducto" value="${producto.id}">
                                                <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-8">
                            <form method="post" action="ControladorListaCompra"
                                  onsubmit="return confirm('¿Estás seguro que quieres vaciar la lista de la compra completa?');">
                                <input type="hidden" name="accion" value="eliminarLista">
                                <button type="submit" class="btn btn-danger">Vaciar Lista de la Compra</button>
                            </form>
                        </div>
                        <div class="col-md-4 text-end">
                            <p><strong>Cantidad total:</strong> <span id="cantidadTotal">0</span> productos</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center fs-5">No tienes productos en tu lista.</div>
                </c:otherwise>
            </c:choose>

            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/Controladores/ControladorInicio" class="btn btn-secondary">Volver a la tienda</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            function actualizarResumen() {
                const total = document.querySelectorAll("#tablaListaCompra tr").length;
                document.getElementById("cantidadTotal").textContent = total;
            }

            document.addEventListener("DOMContentLoaded", actualizarResumen);
        </script>
    </body>
</html>
