<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Experiencias de Viaje</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/registroUsuarios.css">
        <link rel="stylesheet" href="../estilos/tablas.css">

    </head>
    <body>

        <jsp:include page="/includes/headerUsuario.jsp" /> 

        <main>
            <section>
                <div class="form-container mx-auto p-3 shadow rounded-4 my-4">

                    <div class="d-flex align-items-center mb-3">
                        <img src="../imagenes/elRinconDeLaura.jpeg" alt="Laura" 
                             class="me-3 rounded-circle logoTienda">

                        <c:if test="${not empty idUsuario}">
                            <h1 class="h4 fw-bold mb-0">Editar Usuario</h1>
                        </c:if>
                        <c:if test="${empty idUsuario}">
                            <h1 class="h4 fw-bold mb-0">Registrar Usuario</h1>
                        </c:if>
                    </div>

                    <form method="post">
                        <c:if test="${not empty idUsuario}">
                            <input type="hidden" name="idUsuario" value="${idUsuario}">
                        </c:if>

                        <input type="hidden" name="tipo" value="usuario">

                        <div class="mb-2">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control form-control-sm" name="nombre" value="${nombre}" maxlength="20" required>
                        </div>

                        <div class="mb-2">
                            <label for="apellidos" class="form-label">Apellidos</label>
                            <input type="text" class="form-control form-control-sm" name="apellidos" value="${apellidos}" maxlength="20" required>
                        </div>

                        <div class="mb-2">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control form-control-sm" name="direccion" value="${direccion}" maxlength="100" required>
                        </div>

                        <div class="mb-2">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control form-control-sm" name="telefono" value="${telefono}" maxlength="9" required>
                        </div>

                        <div class="mb-2">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control form-control-sm" name="email" value="${email}" maxlength="50" required>
                        </div>

                        <div class="mb-2">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="password" class="form-control form-control-sm" name="password" value="${password}" maxlength="30" required>
                        </div>

                        <div class="mb-2">
                            <label for="password2" class="form-label">Repetir Contraseña</label>
                            <input type="password" class="form-control form-control-sm" name="password2" value="${password}" maxlength="30" required>
                        </div>


                        <div class="mb-2">
                            <input type="hidden" name="rol" value="normal">
                        </div>



                        <div class="d-flex justify-content-between mt-3">
                            <div class="d-flex justify-content-between contenedorAceptar">
                                <a href="/TiendaPanchon/Controladores/ControladorInicio" class="btn btn-volver btn-sm botones">Cancelar</a>
                                <input type="submit" name="${empty idUsuario ? 'crear' : 'editar'}" value="Aceptar" class="btn btn-crear btn-sm me-3 botones">
                            </div>
                    </form>

                    <c:if test="${not empty idUsuario}">
                        <form method="post" action="ControladorUsuarios?eliminar=true" class="d-flex justify-content-center align-items-center">
                            <input type="hidden" name="idUsuario" value="${usuario.id != null ? usuario.id : ''}">
                            <input type="submit" name="eliminar" value="Eliminar" 
                                   class="btn btn-eliminar btn-sm botones"
                                   onclick="return confirm('¿Estás seguro de que deseas darte de baja ${usuario.nombre} ${usuario.apellidos}? Tus datos se eliminarán.');">
                        </form>
                    </c:if>
                </div>


                <c:if test="${not empty error}">
                    <div class="text-danger text-center mt-2">${error}</div>
                </c:if>
                </div>
            </section>
        </main>

        <jsp:include page="/includes/footer.jsp" /> 
    </body>
</html>
