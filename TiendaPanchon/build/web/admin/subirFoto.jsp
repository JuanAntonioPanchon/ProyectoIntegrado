<%@ page contentType="text/html" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Subir Foto Producto</title>
        <link rel="stylesheet" type="text/css" href="../estilos/subirFichero.css">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>

        <jsp:include page="../includes/header.jsp" />

        <main>
            <div class="subirFichero">
                <h1>Subir Foto Producto</h1>

                <c:if test="${not empty error}">
                    <div style="color: red;">${error}</div>
                </c:if>

                <form method="post" enctype="multipart/form-data" id="formSubirImagen">
                    <input type="file" name="fichero" id="ficheroInput" required>
                    <input type="hidden" name="productoId" value="${productoId}">
                    <button type="button" class="boton" id="btnSubirFoto">Subir Foto</button>
                </form>

                <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorProducto?id_categoria=${producto.categoria.id}">
                    <button class="boton">Volver a Productos</button>
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
                const extensionesTexto = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];

                botonSubir.addEventListener("click", function () {
                    const nuevo = inputFile.files[0];

                    if (!nuevo) {
                        Swal.fire({
                            icon: 'warning',
                            title: 'Selecciona una imagen',
                            text: 'Debes elegir una imagen antes de subirla.'
                        });
                        return;
                    }

                    if (!extensionesPermitidas.includes(nuevo.type)) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Archivo no permitido',
                            text: `Solo se permiten archivos jpg, jpeg, png, gif y webp.`
                        });
                        return;
                    }

                    const maxSizeMB = 2;
                    if (nuevo.size > maxSizeMB * 1024 * 1024) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Archivo demasiado grande',
                            text: `El archivo no debe superar los ${maxSizeMB}MB.`
                        });
                        return;
                    }


                    Swal.fire({
                        title: '¿Subir Imagen?',
                        html: `Se va a sustituir la imagen anterior por esta
                       ¿Deseas continuar?`,
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
