<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Listado de Recetas</title>
        <!-- Bootstrap y estilos -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/recetas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="../js/filtrarRecetas.js"></script>
    </head>
    <body>
        <!-- Cabecera segun rol -->
        <c:choose>
            <c:when test="${sessionScope.usuario.rol == 'admin'}">
                <jsp:include page="/includes/header.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:otherwise>
        </c:choose>

        <main class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <a href="/TiendaPanchon/Controladores/ControladorReceta" 
                       class="btn btn btn-ver ${pageContext.request.requestURI.contains('listarRecetas') ? 'active' : ''}">
                        Mis Recetas
                    </a>
                </div>
                <div>
                    <a href="/TiendaPanchon/Controladores/ControladorListadoReceta" 
                       class="btn btn btn-ver ${pageContext.request.requestURI.contains('listarTodasLasRecetas') ? 'active' : ''}">
                        Ver Recetas de Otros Usuarios
                    </a>
                </div>
            </div>

            <h3 class="mb-4">Listado de Recetas</h3>

            <div class="mb-4">
                <label for="filtro" class="form-label">Filtrar Recetas:</label>
                <input type="text" name="filtro" id="filtro" class="form-control" onkeyup="filtrar()">
            </div>

            <div id="listado">
                <div class="row">
                    <c:forEach var="receta" items="${recetas}">
                        <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                            <div class="card tarjeta h-100 d-flex flex-column">
                                <c:choose>
                                    <c:when test="${not empty receta.imagenes}">
                                        <img src="../${receta.imagenes[0]}" class="card-img-top" alt="Imagen receta" style="width: 100%; height: 200px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="ruta/imagen-default.jpg" class="card-img-top" alt="Sin imagen" style="width: 100%; height: 200px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${receta.titulo}</h5>
                                    <p class="card-text"><strong>Publicado por:</strong> ${receta.usuario.nombre}</p>
                                    <p class="card-text"><strong>Ingredientes:</strong> ${receta.ingredientes}</p>
                                    <div class="mt-auto">
                                        <div class="d-flex">
                                            <c:if test="${sessionScope.usuario.rol == 'admin'}">
                                                <form action="ControladorReceta" method="POST" onsubmit="return confirm('¿Estás seguro de que deseas eliminar la receta ${receta.titulo} del usuario ${receta.usuario.nombre}?')">
                                                    <input type="hidden" name="id" value="${receta.id}">
                                                    <input type="submit" name="eliminar" value="Eliminar" class="btn btn-eliminar">
                                                </form>
                                            </c:if>
                                            <button type="button" class="btn btn-ver ms-auto" data-bs-toggle="modal" data-bs-target="#modalReceta${receta.id}">
                                                Ver
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Modal -->
                        <div class="modal fade" id="modalReceta${receta.id}" tabindex="-1" aria-labelledby="modalLabel${receta.id}" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content tarjeta">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="modalLabel${receta.id}">${receta.titulo}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Publicado por:</strong> ${receta.usuario.nombre}</p>
                                        <p><strong>Ingredientes:</strong> ${receta.ingredientes}</p>
                                        <p><strong>Descripción:</strong> ${receta.descripcion}</p>
                                        <div class="row">
                                            <c:forEach var="imagen" items="${receta.imagenes}">
                                                <div class="col-md-4 mb-2">
                                                    <img src="../${imagen}" alt="Imagen receta" class="img-fluid rounded" style="width: 100%; height: 200px; object-fit: cover;">
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-volver" data-bs-dismiss="modal">Cerrar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Paginación -->
                <c:if test="${totalPaginas > 1}">
                    <div class="d-flex justify-content-center mt-4">
                        <nav aria-label="Paginación">
                            <ul class="pagination pagination-personalizada">
                                <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="ControladorListadoReceta?pagina=${paginaActual - 1}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPaginas}" var="i">
                                    <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                        <a class="page-link" href="ControladorListadoReceta?pagina=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                                    <a class="page-link" href="ControladorListadoReceta?pagina=${paginaActual + 1}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>

            <div class="mt-4">
                <a href="../Controladores/ControladorReceta" class="btn btn-volver">Volver</a>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
    </body>
</html>
