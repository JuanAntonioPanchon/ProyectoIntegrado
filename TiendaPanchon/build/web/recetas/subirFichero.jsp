<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Subir Foto Imagen</title>
        <link rel="stylesheet" type="text/css" href="../estilos/subirFichero.css">
        <link rel="stylesheet" type="text/css" href="../estilos/coloresPersonalizados.css">
        <link href="https://fonts.googleapis.com/css2?family=Switzer:wght@400;700&display=swap" rel="stylesheet">
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

    <main>
        <div class="subirFichero">
            <h1>Subir Foto Imagen</h1>

            <!-- Mostrar error si existe -->
            <c:if test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:if>

            <!-- Formulario imagen-->
            <form method="post" enctype="multipart/form-data">
                <input type="file" name="fichero" required multiple="">
                <input type="hidden" name="recetaId" value="${recetaId}">
                <input type="submit" value="Subir Foto" class="boton">
            </form>

            
            <a href="/TiendaPanchon/Controladores/ControladorReceta">
                <button class="boton">Volver a Recetas</button>
            </a>
        </div>
    </main>

    <jsp:include page="/includes/footer.jsp" />

   
    
</body>
</html>
