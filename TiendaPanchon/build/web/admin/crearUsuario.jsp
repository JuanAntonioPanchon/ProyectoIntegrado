<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${empty usuario.id ? "Crear" : "Editar"} Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />

        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">
                    ${empty usuario.id ? "CREAR" : "EDITAR"} USUARIO
                </h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 text-center fw-bold">${error}</div>
                </c:if>

                <form method="post" action="/TiendaPanchon/Controladores.Admin/ControladorGestionarUsuarios">
                    <c:if test="${usuario != null}">
                        <input type="hidden" name="idUsuario" value="${usuario.id}">
                    </c:if>

                    <input type="hidden" name="tipo" value="usuario">

                    <div class="mb-3">
                        <label class="form-label fw-bold">NOMBRE</label>
                        <input type="text" class="form-control" name="nombre" value="${usuario != null ? usuario.nombre : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">APELLIDOS</label>
                        <input type="text" class="form-control" name="apellidos" value="${usuario != null ? usuario.apellidos : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">DIRECCIÓN</label>
                        <input type="text" class="form-control" name="direccion" value="${usuario != null ? usuario.direccion : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">TELÉFONO</label>
                        <input type="text" class="form-control" name="telefono" value="${usuario != null ? usuario.telefono : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">EMAIL</label>
                        <input type="email" class="form-control" name="email" value="${usuario != null ? usuario.email : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">CONTRASEÑA</label>
                        <input type="password" class="form-control" name="password" value="${usuario != null ? usuario.password : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">REPETIR CONTRASEÑA</label>
                        <input type="password" class="form-control" name="password2" value="${usuario != null ? usuario.password : ''}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">ROL</label>
                        <select class="form-select" name="rol">
                            <option value="normal" ${usuario != null && usuario.rol == 'normal' ? 'selected' : ''}>Normal</option>
                            <option value="admin" ${usuario != null && usuario.rol == 'admin' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="/TiendaPanchon/Controladores.Admin/ControladorGestionarUsuarios" class="btn btn-volver px-4">Cancelar</a>
                        <button type="submit" name="${empty usuario.id ? 'crear' : 'editar'}" class="btn btn-crear px-4">Aceptar</button>
                    </div>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="../js/gestionUsuario.js"></script>
    </body>
</html>
