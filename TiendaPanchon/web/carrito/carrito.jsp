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
        <link rel="stylesheet" href="../estilos/paginacion.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="colorFondo">

        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">CESTA DE LA COMPRA</h2>

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
                                <c:forEach var="producto" items="${carrito}" varStatus="status">
                                    <tr data-id="${producto.idProducto}" data-precio="${producto.totalPrecio}" data-index="${status.index}">
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

                            <form method="post" action="${pageContext.request.contextPath}/Controladores.Pedidos/ControladorPedidosUsuario" id="formTramitarPedido">
                                <input type="hidden" name="accion" value="tramitar">
                                <button type="button" class="btn btn-success" id="btnTramitarPedido">Tramitar Pedido</button>
                            </form>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center mt-4">
                        <nav>
                            <ul class="pagination pagination-personalizada" id="paginacionCarrito"></ul>
                        </nav>
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
                    body: new URLSearchParams({accion: "modificar", idProducto: id, delta: delta})
                }).then(res => res.ok && location.reload());
            }

            function eliminarProducto(id) {
                Swal.fire({
                    title: '¿Eliminar producto?',
                    text: '¿Seguro que deseas eliminar este producto del carrito?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonText: 'No, volver',
                    confirmButtonText: 'Sí, eliminar'
                }).then(result => {
                    if (result.isConfirmed) {
                        fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: new URLSearchParams({accion: "eliminar", idProducto: id})
                        }).then(res => res.ok && location.reload());
                    }
                });
            }

            function vaciarCarrito() {
                Swal.fire({
                    title: '¿Vaciar carrito?',
                    text: 'Todos los productos serán eliminados de la cesta. ¿Desea continuar?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonText: 'No, cancelar',
                    confirmButtonText: 'Sí, vaciar'
                }).then(result => {
                    if (result.isConfirmed) {
                        fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "accion=vaciar"
                        }).then(res => res.ok && location.reload());
                    }
                });
            }

            function actualizarResumen() {
                let cantidadTotal = 0;
                let precioTotal = 0;
                document.querySelectorAll("#tablaCarrito tr[data-id]:not([style*='display: none'])").forEach(fila => {
                    const cantidad = parseInt(fila.querySelector("span[id^='cantidad_']").textContent);
                    const precio = parseFloat(fila.dataset.precio);
                    cantidadTotal += cantidad;
                    precioTotal += precio;
                });
                document.getElementById("cantidadTotal").textContent = cantidadTotal;
                document.getElementById("precioTotalCesta").textContent = precioTotal.toFixed(2) + " €";
            }

            const filas = Array.from(document.querySelectorAll("#tablaCarrito tr[data-index]"));
            const porPagina = 10;
            const totalPaginas = Math.ceil(filas.length / porPagina);
            const paginacion = document.getElementById("paginacionCarrito");

            let currentPage = 1;

            function mostrarPagina(n) {
                filas.forEach((fila, i) => {
                    fila.style.display = (Math.floor(i / porPagina) + 1 === n) ? "" : "none";
                });
                actualizarResumen();
                currentPage = n;
                btnAnterior.classList.toggle("disabled", currentPage === 1);
                btnSiguiente.classList.toggle("disabled", currentPage === totalPaginas);
            }

            paginacion.innerHTML = "";

            const btnAnterior = document.createElement("li");
            btnAnterior.className = "page-item disabled";
            btnAnterior.innerHTML = `<a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a>`;
            paginacion.appendChild(btnAnterior);

            for (let i = 1; i <= totalPaginas; i++) {
                const li = document.createElement("li");
                li.className = "page-item" + (i === 1 ? " active" : "");
                const a = document.createElement("a");
                a.className = "page-link";
                a.href = "#";
                a.textContent = i;
                a.addEventListener("click", function (e) {
                    e.preventDefault();
                    document.querySelectorAll("#paginacionCarrito .page-item").forEach(el => el.classList.remove("active"));
                    li.classList.add("active");
                    mostrarPagina(i);
                    btnAnterior.classList.toggle("disabled", i === 1);
                    btnSiguiente.classList.toggle("disabled", i === totalPaginas);
                    currentPage = i;
                });
                li.appendChild(a);
                paginacion.appendChild(li);
            }

            const btnSiguiente = document.createElement("li");
            btnSiguiente.className = "page-item" + (totalPaginas <= 1 ? " disabled" : "");
            btnSiguiente.innerHTML = `<a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>`;
            paginacion.appendChild(btnSiguiente);

            btnAnterior.addEventListener("click", e => {
                e.preventDefault();
                if (currentPage > 1) {
                    mostrarPagina(currentPage - 1);
                    actualizarClasesPaginacion();
                }
            });

            btnSiguiente.addEventListener("click", e => {
                e.preventDefault();
                if (currentPage < totalPaginas) {
                    mostrarPagina(currentPage + 1);
                    actualizarClasesPaginacion();
                }
            });

            function actualizarClasesPaginacion() {
                document.querySelectorAll("#paginacionCarrito .page-item").forEach((el, index) => {
                    el.classList.remove("active");
                    if (index === currentPage)
                        el.classList.add("active");
                });
            }

            document.addEventListener("DOMContentLoaded", () => {
                actualizarResumen();
                aplicarPaginacion();
            });

            function aplicarPaginacion() {
                mostrarPagina(1);
            }

            // SWEET ALERT2: Confirmar Tramitar Pedido
            document.addEventListener("DOMContentLoaded", function () {
                const btnTramitar = document.getElementById("btnTramitarPedido");
                const form = document.getElementById("formTramitarPedido");

                btnTramitar.addEventListener("click", function () {
                    const cantidad = document.getElementById("cantidadTotal").textContent.trim();
                    const precio = document.getElementById("precioTotalCesta").textContent.trim();

                    if (cantidad === "0") {
                        Swal.fire({
                            icon: 'warning',
                            title: 'Carrito vacío',
                            text: 'No puedes tramitar un pedido sin productos.'
                        });
                        return;
                    }

                    Swal.fire({
                        title: '¿Tramitar pedido?',
                        html: `¿Deseas realizar el pedido?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#198754',
                        cancelButtonText: 'No, volver',
                        confirmButtonText: 'Sí, confirmar'
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
