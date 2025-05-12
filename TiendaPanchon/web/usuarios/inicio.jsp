<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>El Rincón de Laura</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:when>
            <c:otherwise>
                <header class="bg-light py-2">
                    <div class="container d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <img src="../imagenes/elRinconDeLaura.jpeg" alt="Logo" class="rounded-circle me-2" style="width: 60px;">
                            <h1 class="h4 mb-0">EL RINCÓN DE LAURA</h1>
                        </div>
                        <!-- para local <a class="btn btn-outline-dark" href="/TiendaPanchon/Controladores/ControladorLogin">Iniciar Sesión</a> -->
                        <a class="btn btn-outline-dark" href="/Controladores/ControladorLogin">Iniciar Sesión</a>
                    </div>
                </header>
            </c:otherwise>
        </c:choose>

        <!-- CATEGORÍAS + MENÚ -->
        <div class="container my-4">
            <div class="row">
                <div class="col-md-3">
                    <h4>Categorías</h4>
                    <button class="btn btn-outline-secondary w-100 d-md-none mb-2" type="button" data-bs-toggle="collapse" data-bs-target="#menuCategorias">
                        Menú
                    </button>
                    <div class="collapse d-md-block" id="menuCategorias">
                        <ul class="list-group">
                            <c:forEach var="categoria" items="${categorias}">
                                <li class="list-group-item">
                                    <a class="text-decoration-none" href="../Controladores.Productos/ControladorListarProductos?id_categoria=${categoria.id}">
                                        ${categoria.nombre}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- CARRUSEL + PRODUCTOS -->
                <div class="col-md-9">
                    <!-- CARRUSEL -->
                    <div id="carruselOfertas" class="carousel slide mb-4" data-bs-ride="carousel" data-bs-interval="15000">
                        <div class="carousel-inner rounded">
                            <div class="carousel-item active">
                                <img src="../imagenes/ofertas.png" class="d-block w-100" alt="Ofertas">
                            </div>
                            <div class="carousel-item">
                                <img src="../imagenes/novedades.png" class="d-block w-100" alt="Novedades">
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#carruselOfertas" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#carruselOfertas" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        </button>
                    </div>

                    <!-- PRODUCTOS -->
                    <h3 class="mb-3">Productos de la categoría: ${nombreCategoria}</h3>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                        <c:forEach var="producto" items="${productos}">
                            <div class="col">
                                <div class="card h-100">
                                    <c:choose>
                                        <c:when test="${not empty producto.imagenes}">
                                            <img src="../${producto.imagenes[0]}" class="card-img-top" alt="Imagen producto" style="height: 200px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top d-flex align-items-center justify-content-center bg-light" style="height: 200px;">
                                                <span class="text-muted">Sin imagen</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body d-flex flex-column justify-content-between">
                                        <h5 class="card-title">${producto.nombre}</h5>
                                        <p class="card-text text-success fw-bold">${producto.precio} €</p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <form action="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra" method="post">
                                                <input type="hidden" name="accion" value="añadirProducto">
                                                <input type="hidden" name="idProducto" value="${producto.id}">
                                                <button type="submit" class="btn btn-outline-secondary">
                                                    <i class="bi bi-journal-plus"></i>
                                                </button>
                                            </form>
                                            <!-- Muestra el campo de cantidad en lugar de la modal -->
                                            <input type="number" class="form-control w-25" min="1" max="${producto.stock}" value="1" id="cantidad_${producto.id}">
                                            <button class="btn btn-outline-primary" onclick="agregarAlCarrito('${producto.id}', '${producto.nombre}', ${producto.precio}, ${producto.stock}, 'cantidad_${producto.id}')">
                                                <i class="bi bi-cart-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <!-- SCRIPT PARA AGREGAR AL CARRITO -->
        <script>
            function agregarAlCarrito(idProducto, nombre, precio, stock, idCantidad) {
                const cantidad = document.getElementById(idCantidad).value;

                // Verificar que la cantidad no exceda el stock disponible
                if (parseInt(cantidad) > stock) {
                    alert('La cantidad solicitada excede el stock disponible.');
                    return;
                }

                const totalPrecio = (parseInt(cantidad) * precio).toFixed(2);

                // Enviar el producto al carrito
                fetch("/TiendaPanchon/Controladores.Carrito/ControladorCarrito", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "idProducto=" + encodeURIComponent(idProducto) +
                            "&cantidad=" + encodeURIComponent(cantidad) +
                            "&totalPrecio=" + encodeURIComponent(totalPrecio)
                })
                        .then(response => {
                            if (response.ok) {
                                alert("Producto agregado al carrito.");
                            } else {
                                return response.text().then(text => {
                                    console.error("Error del servidor:", text);
                                    alert("Error al agregar al carrito.");
                                });
                            }
                        })
                        .catch(error => {
                            console.error("Error de red:", error);
                            alert("No se pudo conectar con el servidor.");
                        });
            }
        </script>

    </body>
</html>
