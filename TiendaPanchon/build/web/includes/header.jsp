<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Menu Administración</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
</head>
<header>
    <nav class="navbar navbar-expand-md colorVerde text-black px-4">
        <div class="container-fluid">
            <!-- Logo y título -->
            <div class="d-flex align-items-center">
                <img src="../imagenes/elRinconDeLaura.jpeg" alt="Logo El Rincón de Laura" class="rounded-circle me-3" style="width: 60px;">
                <a class="navbar-brand fw-bold mb-0 text-black text-decoration-none" href="/TiendaPanchon/Controladores.Admin/ControladorAdmin">
                    EL RINCÓN DE LAURA
                </a>
            </div>

            <!-- Botón hamburguesa -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuNav" aria-controls="menuNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Menu -->
            <div class="collapse navbar-collapse" id="menuNav">
                <ul class="navbar-nav ms-auto ">
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Admin/ControladorListarCategorias">
                            <i class="bi bi-box-seam me-1"></i> Productos y Categorías
                        </a>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Admin/ControladorGestionarUsuarios">
                            <i class="bi bi-people-fill me-1"></i> Usuarios
                        </a>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores/ControladorReceta">
                            <i class="bi bi-book me-1"></i> Recetas
                        </a>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Admin/ControladorListarPedidos">
                            <i class="bi bi-basket me-1"></i> Pedidos
                        </a>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link text-black" href="/TiendaPanchon/Controladores.Admin/ControladorGrafica">
                            <i class="bi bi-bar-chart-line me-1"></i> Gráfica
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

