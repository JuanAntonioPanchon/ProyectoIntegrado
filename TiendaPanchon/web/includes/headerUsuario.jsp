<%-- 
    Document   : headerUsuario.jsp
    Created on : 8 abr 2025, 19:27:01
    Author     : juan-antonio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<header>
    <nav class="navbar navbar-expand-md colorVerde text-black px-4">
        <div class="container-fluid">

            <!-- Logo y Título -->
            <div class="d-flex align-items-center">
                <img src="../imagenes/elRinconDeLaura.jpeg" alt="Logo El Rincón de Laura"
                     class="rounded-circle me-3" style="width: 60px;">
                <a class="navbar-brand fw-bold mb-0 text-black text-decoration-none" 
                   href="/TiendaPanchon/Controladores/ControladorInicio">
                    EL RINCÓN DE LAURA
                </a>
            </div>

            <!-- Botón hamburguesa -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuUsuario"
                    aria-controls="menuUsuario" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Menú de navegación -->
            <div class="collapse navbar-collapse" id="menuUsuario">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item mx-3">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores/ControladorReceta">
                            <i class="bi bi-book me-1"></i> Recetas
                        </a>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.ListaCompra/ControladorListaCompra">
                            <i class="bi bi-card-checklist me-1"></i> Lista Compra
                        </a>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Usuarios/ControladorUsuarios?editar=true&id=${usuario.id}">
                            <i class="bi bi-person-circle me-1"></i> Perfil
                        </a>
                    </li>

                    <li class="nav-item mx-3">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Pedidos/ControladorPedidosUsuario">
                            <i class="bi bi-basket me-1"></i> Pedidos
                        </a>
                    </li>

                    <li class="nav-item mx-3">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Carrito/ControladorCarrito">
                            <i class="bi bi-cart4 me-1"></i> Cesta
                        </a>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black fw-bold" href="/TiendaPanchon/Controladores/ControladorLogin?accion=logout">
                            <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>



