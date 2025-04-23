
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Subir Foto Producto</title>
        <link rel="stylesheet" type="text/css" href="../estilos/subirFichero.css">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link href="https://fonts.googleapis.com/css2?family=Switzer:wght@400;700&display=swap" rel="stylesheet">
    </head>
    <body>

        <jsp:include page="../includes/header.jsp" />

        <main>
            <div class="subirFichero">
                <h1>Subir Foto Producto</h1>


                <c:if test="${not empty error}">
                    <div style="color: red;">${error}</div>
                </c:if>


                <form method="post" enctype="multipart/form-data">
                    <input type="file" name="fichero" required="" multiple="">
                    <input type="hidden" name="productoId" value="${productoId}">
                    <input type="submit" value="Subir Foto" class="boton">
                </form>



                <a href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias">
                    <button class="boton">Volver a Productos</button>
                </a>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />
        
    </body>
</html>