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
    </head>
    <body>
        <jsp:include page="/includes/header.jsp" />

        <main class="container my-5">
            <h1 class="text-center mb-4">Gestionar Categorías y Productos</h1>

            <!-- CATEGORÍAS -->
            <div class="col-12 mb-4">
                <h2 class="mb-3">Categorías:</h2>

                <!-- Botón hamburguesa + botón Editar Categoría -->
                <div class="d-flex justify-content-start align-items-center gap-3">
                    <button class="btn btn-outline-secondary d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#menuCategorias"
                            aria-expanded="false" aria-controls="menuCategorias">
                        <i class="bi bi-list"></i> Categorías
                    </button>

                    <c:if test="${not empty idCategoriaSeleccionada}">
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?id=${idCategoriaSeleccionada}"
                           class="btn btn-warning">
                            Editar Categoría
                        </a>
                    </c:if>
                </div>

                <!-- Lista de Categorías -->
                <div class="collapse d-md-block mt-3" id="menuCategorias">
                    <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="categoria" items="${categorias}">
                            <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?id_categoria=${categoria.id}"
                               class="btn btn-outline-success">
                                ${categoria.nombre}
                            </a>
                        </c:forEach>
                    </div>

                    <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?crear"
                       class="btn btn-sm btn-success mt-3">
                        Crear Categoría Nueva
                    </a>
                </div>
            </div>

            <!-- PRODUCTOS -->
            <div class="col-12">
                <section>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3>PRODUCTOS: ${nombreCategoria}</h3>
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?crear=true"
                           class="btn btn-primary">
                            Añadir Producto Nuevo
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty productos}">
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped">
                                    <thead class="table-success text-center">
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
                                                <td>
                                                    <fmt:formatNumber value="${producto.precio}" maxFractionDigits="2" minFractionDigits="2" />
                                                </td>
                                                <td>${producto.stock}</td>
                                                <td>${producto.oferta ? 'Sí' : 'No'}</td>
                                                <td>${producto.descuento}%</td>
                                                <td>${producto.novedad ? 'Sí' : 'No'}</td>
                                                <td>
                                                    <c:if test="${not empty producto.imagenes}">
                                                        <ul class="list-unstyled">
                                                            <c:forEach var="imagen" items="${producto.imagenes}">
                                                                <li>
                                                                    <img src="../${imagen}" alt="Imagen de producto" width="80" height="80">
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:if>
                                                    <c:if test="${empty producto.imagenes}">
                                                        <p class="text-muted">Sin imágenes</p>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?editar=true&id_producto=${producto.id}"
                                                       class="btn btn-sm btn-warning mb-1">Editar</a>
                                                    <form action="/TiendaPanchon/Controladores.Admin/ControladorProducto"
                                                          method="POST" style="display:inline;">
                                                        <input type="hidden" name="id" value="${producto.id}">
                                                        <button type="submit" name="eliminar" value="Eliminar"
                                                                class="btn btn-sm btn-danger mb-1"
                                                                onclick="return confirm('¿Eliminar ${producto.nombre}?');">Eliminar</button>
                                                    </form>
                                                    <a href="../Controladores.Admin/ControladorSubirFoto?productoId=${producto.id}"
                                                       class="btn btn-sm btn-info">Añadir Imágenes</a>
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
        <script type="text/javascript" src="../js/gestionCategoria.js"></script>
    </body>
</html>
