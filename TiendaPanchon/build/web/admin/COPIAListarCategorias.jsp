<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Categorías</title>
        <link rel="stylesheet" type="text/css" href="../estilos/estilos.css">

    </head>
    <body>
        <jsp:include page="/includes/header.jsp" />
        <main>
            <h1>Administrar Categorías y Productos</h1>

            <c:if test="${not empty categorias}">
                <h2>Categorías</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Editar</th>
                            <th>Eliminar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="categoria" items="${categorias}">
                            <tr>
                                <td><a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?id_categoria=${categoria.id}">${categoria.nombre}</a></td>
                                <td><a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?id=${categoria.id}" class="boton-editar">Editar</a></td>
                                <td>
                                    <form action="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias" method="POST" onsubmit="return confirmarEliminacion('${categoria.nombre}');" style="display:inline;">
                                        <input type="hidden" name="id" value="${categoria.id}">
                                        <input type="submit" name="eliminar" value="Eliminar" class="boton-eliminar">
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${not empty productos}">
                <h2>Productos de la categoría: ${nombreCategoria}</h2>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Novedad</th>
                            <th>Fecha de Creación</th>
                            <th>Oferta</th>
                            <th>Descuento</th>
                            <th>Precio Final</th>
                            <th>Imagen</th>
                            <th>Editar</th>
                            <th>Eliminar</th>
                            <th>Añadir Foto</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="producto" items="${productos}">
                            <tr>
                                <td>${producto.nombre}</td>
                                <td>${producto.descripcion}</td>
                                <td><fmt:formatNumber value="${producto.precio}" maxFractionDigits="2" minFractionDigits="2" /></td>
                                <td>${producto.stock}</td>
                                <td>${producto.novedad ? 'Sí' : 'No'}</td>
                                <td>${producto.fechaProducto}</td>
                                <td>${producto.oferta ? 'Sí' : 'No'}</td>
                                <td>${producto.descuento}%</td>
                                <td><fmt:formatNumber value="${producto.oferta ? (producto.precio - (producto.precio * producto.descuento / 100)) : producto.precio}" maxFractionDigits="2" minFractionDigits="2" /></td>
                                <td>
                                    <c:if test="${not empty producto.imagenes}">
                                        <ul>
                                            <c:forEach var="imagen" items="${producto.imagenes}">
                                                <li>
                                                    <img src="../${imagen}" alt="Imagen de receta" width="100px" height="100px">
                                                    <form action="../Controladores.Admin/ControladorEliminarFoto" method="POST" style="display:inline;">
                                                        <input type="hidden" name="productoId" value="${producto.id}">
                                                        <input type="hidden" name="imagen" value="${imagen}">
                                                        <input type="submit" value="Eliminar" 
                                                               onclick="return confirm('¿Estás seguro de que deseas eliminar la foto: ${imagen.substring(imagen.lastIndexOf('/') + 1)}?')">
                                                    </form>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                    <c:if test="${empty producto.imagenes}">
                                        <p>Este producto no contiene imágenes</p>
                                    </c:if>
                                </td>
                                <td><a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?editar=true&id_producto=${producto.id}" class="boton-editar">Editar</a></td>
                                <td>
                                    <form action="/TiendaPanchon/Controladores.Admin/ControladorProducto" method="POST" style="display:inline;">
                                        <input type="hidden" name="id" value="${producto.id}">
                                        <input type="submit" name="eliminar" value="Eliminar" class="boton-eliminar" 
                                               onclick="return confirm('¿Estás seguro que quieres eliminar el producto? ${producto.nombre} con precio ${producto.precio}');">
                                    </form>
                                </td>

                                <td>
                                    <a href="../Controladores.Admin/ControladorSubirFoto?productoId=${producto.id}">
                                        <button class="botonCrearActividad">Añadir Imágenes</button>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty productos}">
                <h2>No hay productos en la categoría: ${nombreCategoria}</h2>
                <p>Aún no hay ningún producto disponible para esta categoría. Por favor, añada productos para que aparezcan aquí.</p>
            </c:if>


            <br><br>
            <div class="botones-categorias">
                <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias?crear=true" class="boton-crear">Crear Nueva Categoría</a>
                <br><br>
                <a href="/TiendaPanchon/Controladores.Admin/ControladorProducto?crear=true" class="boton-crear">Añadir Producto a la Tienda</a>
                <br><br>
                <a href="ControladorAdmin" class="boton-ver-todas">Volver</a>
            </div>
        </main>
        <jsp:include page="/includes/footer.jsp" />

        <script type="text/javascript" src="../js/gestionCategoria.js"></script>
    </body>


</html>
