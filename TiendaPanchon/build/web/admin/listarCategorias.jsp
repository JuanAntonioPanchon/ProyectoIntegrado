<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Categorías</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo">
        <jsp:include page="/includes/header.jsp" />

        <main class="container py-4">
            <h1 class="text-center fw-bold mb-4">Gestionar Categorías y Productos</h1>

            <!-- CATEGORÍAS -->
            <div class="col-12 mb-4">
                <h4 class="mb-3 fw-bold">CATEGORÍAS:</h4>

                <div class="d-flex justify-content-start align-items-center gap-3">
                    <button class="btn btn-outline-dark d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#menuCategorias"
                            aria-expanded="false" aria-controls="menuCategorias">
                        <i class="bi bi-list"></i> Categorías
                    </button>

                    <c:if test="${not empty idCategoriaSeleccionada}">
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?id=${idCategoriaSeleccionada}"
                           class="btn btn-editar">
                            Editar Categoría
                        </a>
                    </c:if>
                </div>

                <div class="collapse d-md-block mt-3" id="menuCategorias">
                    <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="categoria" items="${categorias}">
                            <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?id_categoria=${categoria.id}"
                               class="btn-categoria ${categoria.id == param.id_categoria ? 'btn-categoria-activa' : ''}">
                                ${categoria.nombre}
                            </a>
                        </c:forEach>
                    </div>

                    <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?crear"
                       class="btn btn-crear mt-3">
                        Crear Categoría Nueva
                    </a>
                </div>
            </div>

            <!-- PRODUCTOS -->
            <div class="col-12">
                <section>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold">PRODUCTOS: ${nombreCategoria}</h4>
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?crear=true&id_categoria=${idCategoriaSeleccionada}"
                           class="btn btn-crear">
                            Añadir Producto Nuevo
                        </a>

                    </div>

                    <c:choose>
                        <c:when test="${not empty productos}">
                            <div class="table-responsive">
                                <table class="tabla-personalizada table table-bordered text-center">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Descripción</th>
                                            <th>Precio</th>
                                            <th>Stock</th>
                                            <th>Oferta</th>
                                            <th>Descuento</th>
                                            <th>Novedad</th>
                                            <th>Imágenes</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="producto" items="${productos}">
                                            <tr>
                                                <td>${producto.nombre}</td>
                                                <td>${producto.descripcion}</td>
                                                <td><fmt:formatNumber value="${producto.precio}" maxFractionDigits="2" minFractionDigits="2" /></td>
                                                <td>${producto.stock}</td>
                                                <td>${producto.oferta ? 'Sí' : 'No'}</td>
                                                <td>${producto.descuento}%</td>
                                                <td>${producto.novedad ? 'Sí' : 'No'}</td>
                                                <td>
                                                    <c:if test="${not empty producto.imagenes}">
                                                        <ul class="list-unstyled">
                                                            <c:forEach var="imagen" items="${producto.imagenes}">
                                                                <li><img src="../${imagen}" alt="Imagen de producto" width="80" height="80"></li>
                                                                </c:forEach>
                                                        </ul>
                                                    </c:if>
                                                    <c:if test="${empty producto.imagenes}">
                                                        <p class="text-muted">Sin imágenes</p>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="d-grid gap-1 d-md-flex justify-content-md-center">
                                                        <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?editar=true&id_producto=${producto.id}"
                                                           class="btn btn-editar btn-sm mb-1">Editar</a>

                                                        <form action="/TiendaPanchon/Controladores.Admin/ControladorProducto"
                                                              method="POST"
                                                              class="d-inline">
                                                            <input type="hidden" name="id" value="${producto.id}">
                                                            <input type="hidden" name="id_categoria" value="${idCategoriaSeleccionada}">
                                                            <button type="button"
                                                                    class="btn btn-eliminar btn-sm"
                                                                    onclick="confirmarEliminacion(this)"
                                                                    data-nombre="${producto.nombre}">
                                                                Eliminar
                                                            </button>
                                                        </form>


                                                        <a href="../Controladores.Admin/ControladorSubirFoto?productoId=${producto.id}"
                                                           class="btn btn-ver btn-sm">Añadir Imágenes</a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">No hay productos en la categoría: ${nombreCategoria}</p>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />


        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                                                                        function confirmarEliminacion(boton) {
                                                                            const form = boton.closest('form');
                                                                            const nombre = boton.dataset.nombre;

                                                                            Swal.fire({
                                                                                title: '¿Eliminar producto?',
                                                                                text: `¿Estás seguro de eliminar el producto? Esta acción no se puede deshacer.`,
                                                                                icon: 'warning',
                                                                                showCancelButton: true,
                                                                                confirmButtonColor: '#d33',
                                                                                cancelButtonText: 'Cancelar',
                                                                                confirmButtonText: 'Sí, eliminar'
                                                                            }).then((result) => {
                                                                                if (result.isConfirmed) {
                                                                                    // 🔁 Se inserta el campo que se pierde al usar .submit()
                                                                                    const inputEliminar = document.createElement('input');
                                                                                    inputEliminar.type = 'hidden';
                                                                                    inputEliminar.name = 'eliminar';
                                                                                    inputEliminar.value = 'Eliminar';
                                                                                    form.appendChild(inputEliminar);

                                                                                    form.submit();
                                                                                }
                                                                            });
                                                                        }
        </script>


    </body>
</html>
