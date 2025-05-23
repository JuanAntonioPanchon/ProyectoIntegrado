<%-- 
    Document   : inicioAdmin.jsp
    Created on : 1 abr 2025, 16:59:39
    Author     : juan-antonio
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pagina Administrador</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/includes/header.jsp" />

        <main class="container my-4">
            <div class="row">
                <!-- Columna izquierda: Tabla de productos con stock bajo -->
                <div class="col-lg-7 mb-4">
                    <c:if test="${not empty productosStockBajo}">
                        <h2 class="text-danger fw-bold text-center mb-3">STOCK A REPONER URGENTE!!!</h2>
                        <div class="table-responsive">
                            <table class="tabla-personalizada table table-bordered table-striped align-middle">
                                <thead class="table-danger">
                                    <tr class="text-center">
                                        <th>Categoria</th>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="producto" items="${productosStockBajo}">
                                        <tr class="fila-clicable" data-href="${pageContext.request.contextPath}/Controladores.Admin/ControladorProducto?id_producto=${producto.id}">
                                            <td>${producto.categoria.nombre}</td>
                                            <td>${producto.nombre}</td>
                                            <td>${producto.stock}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>

                <!-- Columna derecha: Tarjetas de administración -->
                <div class="col-lg-5">
                    <h3 class="text-center text-primary fw-bold mb-3">ADMINISTRACIÓN</h3>
                    <div class="row row-cols-1 row-cols-md-2 g-3">

                        <div class="col mb-3">
                            <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarCategorias" class="text-decoration-none text-dark">
                                <div class="card text-bg-light border-dark h-100 tarjeta-admin">
                                    <div class="card-body colorVerde">
                                        <h5 class="card-title">GESTIONAR PRODUCTOS Y CATEGORÍAS</h5>
                                        <p class="card-text">
                                            En esta ventana podrás crear, editar o eliminar categorías. 
                                            Además, podrás crear, editar o eliminar productos.
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col mb-3">
                            <a href="${pageContext.request.contextPath}/Controladores/ControladorReceta" class="text-decoration-none text-dark">
                                <div class="card text-bg-light border-dark h-100 tarjeta-admin">
                                    <div class="card-body colorVerde">
                                        <h5 class="card-title">GESTIONAR RECETAS</h5>
                                        <p class="card-text">
                                            En esta ventana, podrás crear, editar o eliminar recetas como cualquier usuario. 
                                            También podrás buscar recetas y eliminar alguna si quisieras.
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col mb-3">
                            <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorGestionarUsuarios" class="text-decoration-none text-dark">
                                <div class="card text-bg-light border-dark h-100 tarjeta-admin">
                                    <div class="card-body colorVerde">
                                        <h5 class="card-title">GESTIONAR USUARIOS</h5>
                                        <p class="card-text">
                                            En esta ventana tendrás todo el listado de usuarios que podrás gestionar. 
                                            Puedes editar o eliminar. Incluso hacerlo administrador.
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col mb-3">
                            <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos" class="text-decoration-none text-dark">
                                <div class="card text-bg-light border-dark h-100 tarjeta-admin">
                                    <div class="card-body colorVerde">
                                        <h5 class="card-title">GESTIONAR PEDIDOS</h5>
                                        <p class="card-text">
                                            En esta ventana, tendrás todos los listados de pedidos que aún no se han realizado ordenado por antigüedad. 
                                            Podrás cambiar el estado de éstos al realizarlo.
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col mb-3">
                            <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorGrafica" class="text-decoration-none text-dark">
                                <div class="card text-bg-light border-dark h-100 tarjeta-admin">
                                    <div class="card-body colorVerde">
                                        <h5 class="card-title">VER GRÁFICA VENTAS</h5>
                                        <p class="card-text">
                                            En esta ventana, podrás filtrar por fechas y categoría y se mostrará una gráfica 
                                            con los 10 productos más vendidos y sus cantidades entre esas dos fechas.
                                        </p>
                                    </div>
                                </div>
                            </a>
                        </div>

                    </div>
                </div>

            </div> 
        </main>


        <jsp:include page="/includes/footer.jsp" />

    </body>
</html>


