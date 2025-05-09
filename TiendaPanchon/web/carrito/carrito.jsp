<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Carrito de Compras</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo">
        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">CESTA DE LA COMPRA</h2>

            <!-- Mostrar mensaje de error si no hay stock suficiente -->
            <c:if test="${not empty sessionScope.mensajeError}">
                <div class="alert alert-danger text-center fw-bold">${sessionScope.mensajeError}</div>
                <c:remove var="mensajeError" scope="session" />
            </c:if>

            <c:choose>
                <c:when test="${not empty carrito}">
                    <div class="table-responsive">
                        <table class="tabla-personalizada table table-bordered text-center align-middle">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th>Categoría</th>
                                    <th>Cantidad</th>
                                    <th>Precio total</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="tablaCarrito">
                                <c:forEach var="producto" items="${carrito}">
                                    <tr data-id="${producto.idProducto}" data-precio="${producto.totalPrecio}">
                                        <td>${producto.nombre}</td>
                                        <td>${producto.categoria}</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary" onclick="modificarCantidad('${producto.idProducto}', -1)">-</button>
                                            <span id="cantidad_${producto.idProducto}">${producto.cantidad}</span>
                                        </td>
                                        <td id="total_${producto.idProducto}">${producto.totalPrecio} €</td>
                                        <td>
                                            <button class="btn btn-danger btn-sm" onclick="eliminarProducto('${producto.idProducto}')">Eliminar</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-8">
                            <button class="btn btn-danger" onclick="vaciarCarrito()">Vaciar Carrito</button>
                        </div>
                        <div class="col-md-4 text-end">
                            <p><strong>Cantidad total:</strong> <span id="cantidadTotal">0</span> productos</p>
                            <p><strong>Total cesta:</strong> <span id="precioTotalCesta">0.00 €</span></p>
                            
                            <!-- NO SE PUEDE QUITAR EL SCRIPT ESE DE LINEA PORQUE SI NO NO FUNCIONA  
                                YA QUE SALE EL MENSAJE DE ALERT SIN LA CANTIDAD DE PRODUCTO NI PRECIO TOTAL DE LA CESTA
                            -->
                            
                            <form method="post"
                                  action="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario"
                                  onsubmit="return confirm(
                      '¿Deseas realizar el pedido con ' +
                      document.getElementById('cantidadTotal').textContent.trim() +
                      ' productos por un total de ' +
                      document.getElementById('precioTotalCesta').textContent.trim() +
                      '?'
                      );">
                                <input type="hidden" name="accion" value="tramitar">
                                <button type="submit" class="btn btn-success">Tramitar Pedido</button>
                            </form>

                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center fs-5">No tienes productos en tu cesta.</div>
                </c:otherwise>
            </c:choose>

            <div class="text-center mt-4">
                <a href="/TiendaPanchon/Controladores/ControladorInicio" class="btn btn-secondary">Volver a la tienda</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            function modificarCantidad(id, delta) {
                fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: new URLSearchParams({
                        accion: "modificar",
                        idProducto: id,
                        delta: delta
                    })
                }).then(res => res.ok && location.reload());
            }

            function eliminarProducto(id) {
                fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: new URLSearchParams({
                        accion: "eliminar",
                        idProducto: id
                    })
                }).then(res => res.ok && location.reload());
            }

            function vaciarCarrito() {
                fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "accion=vaciar"
                }).then(res => res.ok && location.reload());
            }

            function actualizarResumen() {
                let cantidadTotal = 0;
                let precioTotal = 0;
                document.querySelectorAll("#tablaCarrito tr[data-id]").forEach(fila => {
                    const cantidad = parseInt(fila.querySelector("span[id^='cantidad_']").textContent);
                    const precio = parseFloat(fila.dataset.precio);
                    cantidadTotal += cantidad;
                    precioTotal += precio;
                });
                document.getElementById("cantidadTotal").textContent = cantidadTotal;
                document.getElementById("precioTotalCesta").textContent = precioTotal.toFixed(2) + " €";
            }

            

            document.addEventListener("DOMContentLoaded", actualizarResumen);
        </script>
    </body>
</html>
