<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lista de Recetas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" type="text/css" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/recetas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <style>
            .imagen-eliminar:hover {
                cursor: pointer;
                opacity: 0.7;
            }
        </style>
    </head>
    <body>

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

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3> Mis Recetas</h3>
                <form action="ControladorReceta" method="GET">
                    <input type="hidden" name="pagina" value="${paginaActual}">
                    <input type="submit" name="crear" value="Crear Receta" class="btn btn-success">
                </form>
            </div>

            <c:if test="${empty recetas}">
                <p>No hay recetas registradas. ¡Anímate a compartir tus recetas!</p>
            </c:if>

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
                                <p class="card-text"><strong>Visibilidad:</strong> ${receta.publicada ? "Pública" : "Privada"}</p>
                                <p class="card-text"><strong>Ingredientes:</strong> ${receta.ingredientes}</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto flex-wrap gap-2">
                                    <a href="ControladorReceta?id=${receta.id}&pagina=${paginaActual}" class="btn btn-editar">Editar</a>

                                    <a href="../Controladores.Usuarios/ControladorSubirFichero?recetaId=${receta.id}&pagina=${paginaActual}" class="btn btn-crear">
                                        Añadir Imágenes
                                    </a>

                                    <button type="button" class="btn btn-ver" data-bs-toggle="modal" data-bs-target="#modalReceta${receta.id}">
                                        Ver
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ventana Modal -->
                    <div class="modal fade" id="modalReceta${receta.id}" tabindex="-1" aria-labelledby="modalLabel${receta.id}" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content tarjeta">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalLabel${receta.id}">${receta.titulo}</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>Ingredientes:</strong> ${receta.ingredientes}</p>
                                    <p><strong>Visibilidad:</strong> ${receta.publicada ? "Pública" : "Privada"}</p>
                                    <p><strong>Descripción:</strong> ${receta.descripcion}</p>
                                    <div class="row">
                                        <c:forEach var="imagen" items="${receta.imagenes}">
                                            <div class="col-md-4 mb-2 d-flex justify-content-center align-items-center">
                                                <img src="../${imagen}" alt="Imagen receta" class="img-fluid rounded h-100 object-fit-cover imagen-eliminar" onclick="confirmarEliminarImagen('${receta.id}', '${imagen}')">
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="modal-footer d-flex justify-content-between">
                                    <button type="button" class="btn btn-volver" data-bs-dismiss="modal">Cerrar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPaginas > 1}">
                <div class="d-flex justify-content-center mt-4">
                    <nav aria-label="Paginación de recetas">
                        <ul class="pagination pagination-personalizada">
                            <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/Controladores/ControladorReceta?pagina=${paginaActual - 1}">&laquo;</a>
                            </li>

                            <c:forEach begin="1" end="${totalPaginas}" var="i">
                                <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/Controladores/ControladorReceta?pagina=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/Controladores/ControladorReceta?pagina=${paginaActual + 1}">&raquo;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>

            <div class="mt-4">
                <c:choose>
                    <c:when test="${sessionScope.usuario.rol == 'admin'}">
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorAdmin" class="btn btn-volver">Volver</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/TiendaPanchon/Controladores/ControladorInicio" class="btn btn-volver">Volver</a>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>

        <jsp:include page="/includes/footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                                                    function confirmarEliminarImagen(idReceta, imagen) {
                                                        Swal.fire({
                                                            title: '¿Eliminar imagen?',
                                                            text: 'Esta acción no se puede deshacer.',
                                                            icon: 'warning',
                                                            showCancelButton: true,
                                                            confirmButtonColor: '#d33',
                                                            cancelButtonColor: '#3085d6',
                                                            confirmButtonText: 'Sí, eliminar',
                                                            cancelButtonText: 'Cancelar'
                                                        }).then((result) => {
                                                            if (result.isConfirmed) {
                                                                eliminarImagen(idReceta, imagen);
                                                            }
                                                        });
                                                    }

                                                    function eliminarImagen(idReceta, imagen) {
                                                        const form = document.createElement("form");
                                                        form.method = "POST";
                                                        form.action = "../Controladores.Usuarios/ControladorEliminarImagen";

                                                        const inputReceta = document.createElement("input");
                                                        inputReceta.type = "hidden";
                                                        inputReceta.name = "recetaId";
                                                        inputReceta.value = idReceta;

                                                        const inputImagen = document.createElement("input");
                                                        inputImagen.type = "hidden";
                                                        inputImagen.name = "imagen";
                                                        inputImagen.value = imagen;

                                                        const inputPagina = document.createElement("input");
                                                        inputPagina.type = "hidden";
                                                        inputPagina.name = "pagina";
                                                        inputPagina.value = "${paginaActual}";

                                                        form.appendChild(inputReceta);
                                                        form.appendChild(inputImagen);
                                                        form.appendChild(inputPagina);

                                                        document.body.appendChild(form);
                                                        form.submit();
                                                    }

        </script>

    </body>
</html>
