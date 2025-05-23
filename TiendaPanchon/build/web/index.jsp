<!DOCTYPE html>
<!--
    Este es el index.html. Redirige a la pantalla de inicio de la app que sera el menu inicial.
    Este menu mostrara las categorias y los productos en la pantalla.
-->
<%
    response.sendRedirect(request.getContextPath() + "/Controladores/ControladorInicio");
%>
