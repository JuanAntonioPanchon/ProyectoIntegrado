<%-- 
    Document   : header
    Created on : 8 abr 2025, 19:19:52
    Author     : juan-antonio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<header class="cabeceraInicio" id="cabecera">
    <img src="../imagenes/elRinconDeLaura.jpeg" alt="Logo Tienda"/>
    <div class="izquierdaCabecera">
        <h1>El Rincón de Laura</h1>
    </div>
    <div class="centroCabecera">
        <nav class="menu-desplegable">
            <ul>
                <li><a style="color:black" href="/TiendaPanchon/Controladores.Admin/ControladorGrafica">Ver graficas</a></li>
                <li><a style="color:black" href="/TiendaPanchon/Controladores/ControladorReceta">Gestionar Recetas</a></li>
                <li><a style="color:black" href="/TiendaPanchon/Controladores.Admin/ControladorGestionarUsuarios">Gestionar Usuarios</a></li>
                <li><a style="color:black" href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias">Gestionar Productos y Categorias</a></li>
                <li><a style="color:black" href="/TiendaPanchon/Controladores.Admin/ControladorListarPedidos">Gestionar Pedidos</a></li>
                <br> <br> 
                <a href="/TiendaPanchon/Controladores/ControladorLogin?accion=logout" class="boton-cerrar-sesion">Cerrar Sesión</a>
            </ul>
        </nav>           
    </div>
</header>
