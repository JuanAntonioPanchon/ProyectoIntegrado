<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Categorías</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
    </head>
    <body>
        <jsp:include page="/includes/header.jsp" />
        <main class="container my-5">
            <h1 class="text-center mb-4">Administrar Categorías y Productos</h1>

            <div class="row">
                <!-- Columna de Categorías (izquierda) -->
                <div class="col-12 col-sm-12 col-md-3 mb-4">
                    <c:if test="${not empty categorias}">
                        <h2 class="text-center mb-3">Categorías</h2>
                        <table class="table table-bordered table-striped">
                            <thead class="table-success text-center">
                                <tr>
                                    <th colspan="3">Nombre</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="categoria" items="${categorias}">
                                    <tr>
                                        <td colspan="3">
                                            <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?id_categoria=${categoria.id}"
                                               class="btn btn-outline-success w-100 mb-1">
                                                ${categoria.nombre}
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?crear"
                       class="btn btn-sm btn-success w-100 mb-3">
                        Crear Categoría Nueva
                    </a>

                    <c:if test="${not empty idCategoriaSeleccionada}">
                        <div class="border rounded bg-light p-2">
                            <p class="text-center fw-bold mb-2">
                                Categoría seleccionada: 
                                <span class="text-primary">${nombreCategoria}</span>
                            </p>
                            <div class="d-grid gap-2">
                                <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?id=${idCategoriaSeleccionada}"
                                   class="btn btn-warning">
                                    Editar Categoría
                                </a>
                            </div>
                        </div>
                    </c:if>



                </div>

                <!-- Columna de Productos (derecha) -->
                <div class="col-12 col-sm-12 col-md-9">
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
                                                    <td><fmt:formatNumber value="${producto.precio}" maxFractionDigits="2" minFractionDigits="2" /></td>
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
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
        <script type="text/javascript" src="../js/gestionCategoria.js"></script>
    </body>
</html>
