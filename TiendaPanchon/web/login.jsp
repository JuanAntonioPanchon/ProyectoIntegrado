<%-- 
    Document   : loga
    Created on : 18 mar 2025, 13:05:43
    Author     : juan-antonio
--%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Inicio de Sesión</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/login.css">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <style>
            * {
                font-family: 'Dancing Script';
            }

        </style>
    </head>
    <body>


        <div class="text-center py-4">
            <h1 class="fw-bold">Bienvenido al Rincón de Laura</h1>
        </div>

        <div class="container-fluid">
            <div class="row w-100 pt-4">
                <!-- Login Form -->
                <div class="col-md-6 d-flex justify-content-center">
                    <div class="form-container p-5 rounded-3 shadow-lg text-center mt-4">
                        <h2 class="mb-3 fw-bold">Inicio de Sesión</h2>
                        <form method="POST" action="${pageContext.request.contextPath}/Controladores/ControladorLogin">
                            <div class="mb-3">
                                <label for="email" class="fw-bold">
                                    <i class="bi bi-person-circle fs-4"></i> USUARIO
                                </label>
                                <input type="email" class="form-control text-center" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="fw-bold">
                                    CONTRASEÑA
                                </label>
                                <input type="password" class="form-control text-center" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-dark w-100">Aceptar</button>

                            <c:if test="${not empty error}">
                                <div class="text-danger fw-bold">${error}</div>
                                <% session.removeAttribute("error");%>
                            </c:if>

                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/Controladores.Usuarios/ControladorUsuarios?crear=true" class="text-dark text-decoration-none">¿Aun no tienes cuenta? Regístrate</a>
                            </div>
                        </form>
                    </div>
                </div>


                <div class="col-md-6 d-none d-md-flex justify-content-center pt-4">
                    <img src="../imagenes/elRinconDeLaura.jpeg" alt="Laura" class="img-fluid rounded-4">
                </div>
            </div>
        </div>


        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    </body>
</html>
