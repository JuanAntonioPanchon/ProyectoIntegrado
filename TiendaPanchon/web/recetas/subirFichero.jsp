<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Subir Foto Imagen</title>
        <link rel="stylesheet" type="text/css" href="../estilos/subirFichero.css">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link href="https://fonts.googleapis.com/css2?family=Switzer:wght@400;700&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>

        <!-- Cabecera según el rol -->
        <c:choose>
            <c:when test="${sessionScope.usuario.rol == 'admin'}">
                <jsp:include page="/includes/header.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="/includes/headerUsuario.jsp" />
            </c:otherwise>
        </c:choose>

        <main>
            <div class="subirFichero">
                <h1>Subir Foto Imagen</h1>

                <c:if test="${not empty error}">
                    <div style="color: red;">${error}</div>
                </c:if>

                <form method="post" enctype="multipart/form-data" id="formSubirImagen">
                    <input type="file" name="fichero" id="ficheroInput" required multiple>
                    <input type="hidden" name="recetaId" value="${recetaId}">
                    <input type="hidden" name="pagina" value="${pagina}">
                    <button type="button" class="boton" id="btnSubirFoto">Subir Foto</button>
                </form>

                <a href="${pageContext.request.contextPath}/Controladores/ControladorReceta?pagina=${pagina}">
                    <button class="boton">Volver a Recetas</button>
                </a>

            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("formSubirImagen");
                const inputFile = document.getElementById("ficheroInput");
                const botonSubir = document.getElementById("btnSubirFoto");

                const extensionesPermitidas = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                const maxSizeMB = 2;

                botonSubir.addEventListener("click", function () {
                    const archivos = inputFile.files;

                    if (!archivos || archivos.length === 0) {
                        Swal.fire({
                            icon: 'warning',
                            title: 'Selecciona al menos una imagen',
                            text: 'Debes elegir al menos una imagen antes de subir.'
                        });
                        return;
                    }

                    for (let archivo of archivos) {
                        if (!extensionesPermitidas.includes(archivo.type)) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Archivo no permitido',
                                text: 'Solo se permiten archivos JPG, PNG, GIF y WEBP.'
                            });
                            return;
                        }
                        if (archivo.size > maxSizeMB * 1024 * 1024) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Archivo demasiado grande',
                                text: `Cada imagen no debe superar los ${maxSizeMB}MB.`
                            });
                            return;
                        }
                    }

                    Swal.fire({
                        title: '¿Subir Imagen?',
                        html: `Se van a añadir a la receta.<br>¿Deseas continuar?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#336b30',
                        cancelButtonText: 'No, volver',
                        confirmButtonText: 'Sí, subir'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                });
            });
        </script>
    </body>
</html>
