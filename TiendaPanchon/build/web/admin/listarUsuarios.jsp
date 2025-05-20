<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestionar Usuarios</title>

        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2"></script>
    </head>
    <body>

        <jsp:include page="/includes/header.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">Gestionar Usuarios</h2>

            <div class="mb-3 text-center">
                <input type="text" id="buscadorUsuarios" class="form-control w-50 d-inline-block" placeholder="Buscar usuario...">
            </div>

            <div class="table-responsive">
                <table class="tabla-personalizada table table-bordered text-center">
                    <thead>
                        <tr>
                            <th class="align-middle">NOMBRE</th>
                            <th class="align-middle">APELLIDOS</th>
                            <th class="align-middle">EMAIL</th>
                            <th class="align-middle">ROL</th>
                            <th class="align-middle">DIRECCIÓN</th>
                            <th class="align-middle">TELÉFONO</th>
                            <th class="align-middle">ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody id="tablaUsuarios">
                        <c:forEach var="usuario" items="${usuarios}">
                            <tr>
                                <td class="align-middle">${usuario.nombre}</td>
                                <td class="align-middle">${usuario.apellidos}</td>
                                <td class="align-middle">${usuario.email}</td>
                                <td class="align-middle">${usuario.rol}</td>
                                <td class="align-middle">${usuario.direccion}</td>
                                <td class="align-middle">${usuario.telefono}</td>
                                <td class="align-middle">
                                    <div class="d-grid gap-1 d-md-flex justify-content-md-center">
                                        <a href="ControladorGestionarUsuarios?accion=editar&idUsuario=${usuario.id}" class="btn btn-editar btn-sm">Editar</a>

                                        <form method="post" action="ControladorGestionarUsuarios?pagina=${paginaActual}"
                                              onsubmit="return confirm('¿Seguro que quieres eliminar al usuario ${usuario.nombre} ${usuario.apellidos} con email: (${usuario.email})?');"
                                              class="d-inline">
                                            <input type="hidden" name="idUsuario" value="${usuario.id}">
                                            <input type="hidden" name="accion" value="Eliminar">
                                            <input type="hidden" name="pagina" value="${paginaActual}"> <!-- 🔽 Añadido -->
                                            <button type="submit" class="btn btn-eliminar btn-sm">Eliminar</button>
                                        </form>

                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${totalPaginas > 1}">
                    <div class="d-flex justify-content-center mt-4">
                        <nav aria-label="Paginación de usuarios">
                            <ul class="pagination pagination-personalizada">
                                <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="ControladorGestionarUsuarios?pagina=${paginaActual - 1}">
                                        &laquo;
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPaginas}" var="i">
                                    <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                        <a class="page-link" href="ControladorGestionarUsuarios?pagina=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                                    <a class="page-link" href="ControladorGestionarUsuarios?pagina=${paginaActual + 1}">
                                        &raquo;
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>

            </div>            

            <div class="text-center mt-4">
                <a href="ControladorGestionarUsuarios?accion=crear" class="btn btn-crear me-2">Crear Usuario</a>
                <a href="ControladorAdmin" class="btn btn-volver">Volver</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script src="../js/filtroUsuarioFuse.js"></script>

    </body>
</html>
