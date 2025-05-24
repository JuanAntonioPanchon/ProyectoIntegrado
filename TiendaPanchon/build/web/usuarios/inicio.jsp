<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>El Rincón de Laura</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <style>
            .img-producto {
                width: 100%;
                height: auto;
                max-height: 200px;
                object-fit: contain;
                display: block;
                margin: 0 auto;
            }
        </style>

    </head>
    <body>


        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:when>
            <c:otherwise>
                <header>
                    <nav class="navbar navbar-expand-md colorVerde text-black px-4">
                        <div class="container-fluid">
                            <div class="d-flex align-items-center">
                                <img src="../imagenes/elRinconDeLaura.jpeg" alt="Logo El Rincón de Laura" class="rounded-circle me-3" style="width: 60px;">
                                <a class="navbar-brand fw-bold mb-0 text-black text-decoration-none"
                                   href="${pageContext.request.contextPath}/Controladores/ControladorInicio">
                                    EL RINCÓN DE LAURA
                                </a>
                            </div>
                            <ul class="navbar-nav ms-auto">
                                <li class="nav-item mx-1">
                                    <a class="nav-link text-black fw-bold"
                                       href="${pageContext.request.contextPath}/Controladores/ControladorLogin">
                                        <i class="bi bi-box-arrow-in-right me-1"></i>
                                        <span class="d-none d-md-inline">Iniciar Sesión</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </header>
            </c:otherwise>
        </c:choose>

        <div class="container mt-4">
            <h4 class="fw-bold">Categorías:</h4>
            <div class="d-flex justify-content-start align-items-center gap-3 mb-2">
                <button class="btn btn-outline-dark d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#menuCategorias"
                        aria-expanded="false" aria-controls="menuCategorias">
                    <i class="bi bi-list"></i> Categorías
                </button>
            </div>
            <div class="collapse d-md-block" id="menuCategorias">
                <div class="d-flex flex-wrap gap-2">
                    <c:forEach var="categoria" items="${categorias}">
                        <a href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?id_categoria=${categoria.id}"
                           class="btn-categoria ${categoria.id == param.id_categoria ? 'btn-categoria-activa' : ''}">
                            ${categoria.nombre}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="container mt-4">
            <!-- CARRUSEL -->
            <div id="carruselOfertas" class="carousel slide mb-4" data-bs-ride="carousel" data-bs-interval="15000">
                <div class="carousel-inner text-center">
                    <div class="carousel-item active">
                        <a href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?oferta=true">
                            <img src="../imagenes/oferta.jpeg" class="carrusel-img mx-auto d-block" alt="Ofertas">
                        </a>
                    </div>
                    <div class="carousel-item">
                        <a href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?novedades=true">
                            <img src="../imagenes/novedades.jpeg" class="carrusel-img mx-auto d-block" alt="Novedades">
                        </a>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carruselOfertas" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carruselOfertas" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                </button>
            </div>

            <!-- TÍTULO -->
            <h3 class="mb-3">
                <c:choose>
                    <c:when test="${param.oferta == 'true'}">Productos en oferta</c:when>
                    <c:when test="${param.novedades == 'true'}">Novedades en nuestra tienda</c:when>
                    <c:otherwise>Productos de la categoría: ${nombreCategoria}</c:otherwise>
                </c:choose>
            </h3>

            <!-- MENSAJES -->
            <c:if test="${param.mensaje == 'existe'}">
                <div class="alert alert-warning">El producto <strong>${param.nombreProducto}</strong> ya está en la lista de la compra.</div>
            </c:if>
            <c:if test="${param.mensaje == 'ok'}">
                <div class="alert alert-success">Producto <strong>${param.nombreProducto}</strong> añadido correctamente a la lista de la compra.</div>
            </c:if>

            <!-- PRODUCTOS -->
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                <c:forEach var="producto" items="${productos}">
                    <div class="col" id="producto_${producto.id}">
                        <div class="card h-100">
                            <c:choose>
                                <c:when test="${not empty producto.imagenes}">
                                    <div class="imagen-container" id="imagen_${producto.id}" onclick="toggleDescripcion(${producto.id})" style="cursor: pointer;">
                                        <img src="../${producto.imagenes[0]}" class="card-img-top img-producto" alt="Imagen producto">
                                    </div>
                                    <div class="descripcion-container d-none bg-white p-2" id="descripcion_${producto.id}" style="height: 200px; overflow-y: auto; cursor: pointer;" onclick="toggleDescripcion(${producto.id})">
                                        <p class="m-0 text-muted">${producto.descripcion}</p>
                                    </div>

                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top d-flex align-items-center justify-content-center bg-light" style="height: 200px;">
                                        <span class="text-muted">Sin imagen</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body d-flex flex-column justify-content-between">
                                <h5 class="card-title">${producto.nombre}</h5>
                                <c:choose>
                                    <c:when test="${preciosOriginales[producto.id] != null and preciosOriginales[producto.id] > producto.precio}">
                                        <div class="position-relative mb-2">
                                            <div class="text-center">
                                                <span class="text-muted text-decoration-line-through me-2">
                                                    <fmt:formatNumber value="${preciosOriginales[producto.id]}" type="currency" currencySymbol="€"/>
                                                </span>
                                                <span class="text-success fw-bold">
                                                    <fmt:formatNumber value="${producto.precio}" type="currency" currencySymbol="€"/>
                                                </span>
                                            </div>
                                            <span class="badge bg-danger position-absolute top-0 end-0">
                                                <fmt:formatNumber value="${(1 - (producto.precio / preciosOriginales[producto.id])) * 100}" maxFractionDigits="0"/>%
                                            </span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="card-text text-success fw-bold text-center">
                                            <fmt:formatNumber value="${producto.precio}" type="currency" currencySymbol="€"/>
                                        </p>
                                    </c:otherwise>
                                </c:choose>

                                <div class="d-flex justify-content-between align-items-center">
                                    <form action="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra" method="post">
                                        <input type="hidden" name="accion" value="anadirProducto">
                                        <input type="hidden" name="idProducto" value="${producto.id}">
                                        <input type="hidden" name="idCategoria" value="${producto.categoria.id}">
                                        <c:if test="${param.oferta == 'true'}"><input type="hidden" name="oferta" value="true"/></c:if>
                                        <c:if test="${param.novedades == 'true'}"><input type="hidden" name="novedades" value="true"/></c:if>
                                            <button type="submit" class="btn btn-outline-secondary">
                                                <i class="bi bi-journal-plus"></i>
                                            </button>
                                        </form>
                                        <input type="number" class="form-control w-50" min="1" max="${producto.stock}" value="1" id="cantidad_${producto.id}">
                                    <button class="btn btn-outline-primary" onclick="agregarAlCarrito('${producto.id}', '${producto.nombre}', ${producto.precio}, ${producto.stock}, 'cantidad_${producto.id}')">
                                        <i class="bi bi-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- PAGINACIÓN -->
            <c:set var="baseUrl" value="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos"/>
            <c:choose>
                <c:when test="${param.oferta == 'true'}"><c:set var="paramExtra" value="oferta=true" /></c:when>
                <c:when test="${param.novedades == 'true'}"><c:set var="paramExtra" value="novedades=true" /></c:when>
                <c:otherwise><c:set var="paramExtra" value="id_categoria=${param.id_categoria}" /></c:otherwise>
            </c:choose>

            <div class="d-flex justify-content-center mt-4">
                <nav aria-label="Paginación de productos">
                    <ul class="pagination pagination-personalizada">
                        <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${baseUrl}?${paramExtra}&pagina=${paginaActual - 1}">&laquo;</a>
                        </li>
                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                            <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                <a class="page-link" href="${baseUrl}?${paramExtra}&pagina=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                            <a class="page-link" href="${baseUrl}?${paramExtra}&pagina=${paginaActual + 1}">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/fuse.js/dist/fuse.min.js"></script>

        <script>
                                        function toggleDescripcion(id) {
                                            const img = document.getElementById('imagen_' + id);
                                            const desc = document.getElementById('descripcion_' + id);

                                            if (img.classList.contains('d-none')) {
                                                img.classList.remove('d-none');
                                                desc.classList.add('d-none');
                                            } else {
                                                img.classList.add('d-none');
                                                desc.classList.remove('d-none');
                                            }
                                        }
        </script>

        <script>
            let todosLosProductos = [];
            let fuse;
            document.getElementById("buscador").addEventListener("input", function () {
                const texto = this.value.trim();
                const contenedor = document.getElementById("contenedorResultados");
                const seccionResultados = document.getElementById("resultadosBusqueda");
                if (texto.length === 0) {
                    contenedor.innerHTML = "";
                    seccionResultados.style.display = "none";
                    return;
                }

                if (todosLosProductos.length === 0) {
                    fetch("${pageContext.request.contextPath}/Controladores.Productos/ControladorBuscarProductoAJAX")
                            .then(res => res.json())
                            .then(data => {
                                todosLosProductos = data;
                                iniciarFuse();
                                mostrarResultados(texto);
                            });
                } else {
                    mostrarResultados(texto);
                }
            });
            function iniciarFuse() {
                fuse = new Fuse(todosLosProductos, {
                    keys: ['nombre', 'categoria'],
                    threshold: 0.4
                });
            }

            function mostrarResultados(texto) {
                const resultados = fuse.search(texto).map(r => r.item);
                const contenedor = document.getElementById("contenedorResultados");
                const seccionResultados = document.getElementById("resultadosBusqueda");
                contenedor.innerHTML = "";
                resultados.forEach(p => {
                    const imagenHTML = p.imagen
                            ? `<img src="../${p.imagen}" class="card-img-top" alt="${p.nombre}" style="height: 200px; object-fit: cover;">`
                            : `<div class="card-img-top d-flex align-items-center justify-content-center bg-light" style="height: 200px;"><span class="text-muted">Sin imagen</span></div>`;
                    const tarjeta = `
                        <div class="col">
                            <div class="card h-100">
            ${imagenHTML}
                                <div class="card-body d-flex flex-column justify-content-between">
                                    <h5 class="card-title">${p.nombre}</h5>
                                    <p class="card-text text-success fw-bold">${p.precio.toFixed(2)} €</p>
                                    <span class="badge bg-secondary">${p.categoria}</span>
                                </div>
                            </div>
                        </div>`;
                    contenedor.innerHTML += tarjeta;
                });
                seccionResultados.style.display = resultados.length > 0 ? "block" : "none";
            }
        </script>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                document.querySelectorAll("input[type='number'][id^='cantidad_']").forEach(function (input) {
                    input.addEventListener("input", function () {
                        const max = parseInt(this.getAttribute("max"));
                        const value = parseInt(this.value);
                        if (value > max) {
                            this.value = max;
                        } else if (value < 1 || isNaN(value)) {
                            this.value = 1;
                        }
                    });
                });
            });
            function agregarAlCarrito(idProducto, nombre, precio, stock, idCantidad) {
                const cantidad = parseInt(document.getElementById(idCantidad).value);
                if (cantidad > stock) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Cantidad excedida',
                        text: 'La cantidad solicitada excede el stock disponible.',
                        confirmButtonText: 'Aceptar'
                    });
                    return;
                }

                const totalPrecio = (cantidad * precio).toFixed(2);
                fetch("${pageContext.request.contextPath}/Controladores.Carrito/ControladorCarrito", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "X-Requested-With": "XMLHttpRequest" // 💡 Esto activa el control AJAX del filtro para que me mande al login si le da al carrito
                    },
                    body: "idProducto=" + encodeURIComponent(idProducto) +
                            "&cantidad=" + encodeURIComponent(cantidad) +
                            "&totalPrecio=" + encodeURIComponent(totalPrecio)
                })
                        .then(response => {
                            if (response.status === 401) {
                                Swal.fire({
                                    icon: 'info',
                                    title: 'Necesitas iniciar sesión',
                                    text: 'Por favor, inicia sesión para añadir productos al carrito.',
                                    confirmButtonText: 'Ir al login'
                                }).then(() => {
                                    window.location.href = "${pageContext.request.contextPath}/Controladores/ControladorLogin";
                                });
                                return;
                            }

                            if (response.ok) {
                                Swal.fire({
                                    icon: 'success',
                                    title: '¡Añadido Correctamente!',
                                    html: `Producto añadido a la cesta correctamente`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            } else {
                                return response.text().then(text => {
                                    console.error("Error del servidor:", text);
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error del servidor',
                                        text: 'No se pudo agregar el producto al carrito.'
                                    });
                                });
                            }
                        })
                        .catch(error => {
                            console.error("Error de red:", error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error de conexión',
                                text: 'No se pudo conectar con el servidor.'
                            });
                        });
            }

        </script>
    </body>
</html> 
