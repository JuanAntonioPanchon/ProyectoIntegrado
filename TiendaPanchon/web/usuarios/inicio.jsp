<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Recetas</title>
        <script>
            function abrirModal(id, nombre, precio, maxCantidad) {
                if (!id || !nombre || !precio || !maxCantidad) {
                    console.error("Algunos valores están vacíos: id:", id, "nombre:", nombre, "precio:", precio, "maxCantidad:", maxCantidad);
                }
                document.getElementById("modal").style.display = "block";
                document.getElementById("productoNombre").innerText = nombre;
                document.getElementById("productoPrecio").innerText = precio + " €";
                document.getElementById("cantidad").max = maxCantidad;
                document.getElementById("cantidad").value = 1;
                document.getElementById("totalPrecio").innerText = precio + " €";
                document.getElementById("idProducto").value = id;
                document.getElementById("precioUnitario").value = precio;
            }


            function cerrarModal() {
                document.getElementById("modal").style.display = "none";
            }

            function actualizarPrecio() {
                let cantidad = parseInt(document.getElementById("cantidad").value);
                let maxCantidad = parseInt(document.getElementById("cantidad").max);
                let precioUnitario = parseFloat(document.getElementById("precioUnitario").value);

                if (cantidad > maxCantidad) {
                    cantidad = maxCantidad;
                    document.getElementById("cantidad").value = maxCantidad;
                }
                let total = cantidad * precioUnitario;
                document.getElementById("totalPrecio").innerText = total.toFixed(2) + " €";
            }

            function agregarASesion() {
                let idProducto = document.getElementById("idProducto").value;
                let cantidad = document.getElementById("cantidad").value;
                let totalPrecio = document.getElementById("totalPrecio").innerText;

                // Depurar los valores que se van a enviar
                console.log("Enviando producto con ID: " + idProducto + ", cantidad: " + cantidad + ", totalPrecio: " + totalPrecio);

                // Verificar que los valores no estén vacíos
                if (!idProducto || !cantidad || !totalPrecio) {
                    alert("Todos los campos son obligatorios");
                    return;
                }

                // Realizar la petición GET
                fetch(`/TiendaPanchon/Controladores.Carrito/ControladorCarrito?idProducto=${idProducto}&cantidad=${cantidad}&totalPrecio=${totalPrecio}`, {
                    method: 'GET'
                }).then(response => {
                    if (response.ok) {
                        alert("Producto añadido a la sesión");
                        cerrarModal();
                    } else {
                        console.error("Error al añadir el producto al carrito");
                    }
                }).catch(error => {
                    console.error("Error en la solicitud:", error);
                });
            }



        </script>
    </head>
    <body>
        <header class="cabeceraInicio" id="cabecera">
            <div class="izquierdaCabecera">
                <h1>Menu</h1>
            </div>
            <div class="centroCabecera">
                <nav class="menu-desplegable">
                    <ul>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores/ControladorInicio">Home</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores/ControladorReceta">Recetas</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores.ListaCompra/ControladorListaCompra">Lista Compra</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores.Usuarios/ControladorUsuarios?editar=true&id=${usuario.id}">Usuario</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores.Productos/ControladorListarProductos?oferta=true">Ver ofertas</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores.Productos/ControladorListarProductos?novedades=true">Ver novedades</a></li>
                        <li><a style="color:black" href="/TiendaPanchon/Controladores.Carrito/ControladorCarrito">Ver Carrito</a></li>
                    </ul>
                </nav>           
            </div>
        </header>

        <jsp:include page="/includes/headerUsuario.jsp" />             

        <main>
            <h2>Categorías de Productos</h2>
            <ul>
                <c:forEach var="categoria" items="${categorias}">
                    <li>
                        <a href="../Controladores.Productos/ControladorListarProductos?id_categoria=${categoria.id}">${categoria.nombre}</a>
                    </li>
                </c:forEach>
            </ul>
        </main>

        <c:if test="${not empty productos}">
            <section>
                <h2>Lista de Productos: ${nombreCategoria}</h2>
                <table border="1">
                    <tr>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Precio</th>
                        <th>Imagenes</th>
                        <th>Comprar</th>
                        <th>Lista</th>
                    </tr>

                    <c:forEach var="producto" items="${productos}">
                        <tr>
                            <td>${producto.nombre}</td>
                            <td>${producto.descripcion}</td>
                            <td>${producto.precio} €</td>
                            <td>
                                <c:if test="${not empty producto.imagenes}">
                                    <ul>
                                        <c:forEach var="imagen" items="${producto.imagenes}">
                                            <img src="../${imagen}" alt="Imagen de receta" width="100px" height="100px">
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${empty producto.imagenes}">
                                    <p>Este producto no contiene imágenes</p>
                                </c:if>
                            </td>
                            <td>
                                <button onclick="abrirModal('${producto.id}', '${producto.nombre}', ${producto.precio}, ${producto.stock})">Añadir al carrito</button>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra" method="post">
                                    <input type="hidden" name="accion" value="añadirProducto">
                                    <input type="hidden" name="idProducto" value="${producto.id}">
                                    <button type="submit">Añadir a la lista de la compra</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
                <br>
            </section>
        </c:if>

        <div id="modal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%); background:white; padding:20px; border:1px solid black;">
            <h2 id="productoNombre"></h2>
            <p>Precio unitario: <span id="productoPrecio"></span></p>
            <label for="cantidad">Cantidad:</label>
            <input type="number" id="cantidad" min="1" oninput="actualizarPrecio()">
            <p>Precio total: <span id="totalPrecio"></span></p>
            <input type="hidden" id="idProducto">
            <input type="hidden" id="precioUnitario">
            <button onclick="cerrarModal()">Cancelar</button>
            <button onclick="agregarASesion()">Aceptar</button>
        </div>
    </body>
</html>