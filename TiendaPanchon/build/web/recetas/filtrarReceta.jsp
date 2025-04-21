<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
