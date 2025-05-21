<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lista de la Compra</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link rel="stylesheet" type="text/css" href="../estilos/paginacion.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            a.enlace-producto {
                text-decoration: none !important;
                font-weight: 500;
                color: #000 !important;
                cursor: pointer;
            }
            a.enlace-producto:hover {
                text-decoration: none !important;
                color: #000 !important;
            }
        </style>
    </head>
    <body class="colorFondo">
        <jsp:include page="/includes/headerUsuario.jsp" />

        <div class="container py-4">
            <h2 class="text-center fw-bold mb-4">LISTA DE LA COMPRA</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center fw-bold">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty productosLista}">
                    <div class="table-responsive">
                        <table class="tabla-personalizada table table-bordered text-center align-middle">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th>Categoría</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="tablaListaCompra">
                                <c:forEach var="producto" items="${productosLista}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${producto.stock > 0}">
                                                    <a class="enlace-producto"
                                                       href="${pageContext.request.contextPath}/Controladores.Productos/ControladorListarProductos?id_categoria=${producto.categoria.id}#producto_${producto.id}">
                                                        ${producto.nombre}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">${producto.nombre} (producto agotado en este momento)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${producto.categoria.nombre}</td>
                                        <td>
                                            <form method="post" action="ControladorListaCompra" class="form-eliminar-lista d-inline">
                                                <input type="hidden" name="accion" value="eliminarProducto">
                                                <input type="hidden" name="idProducto" value="${producto.id}">
                                                <input type="hidden" name="pagina" value="${paginaActual}">
                                                <button type="button"
                                                        class="btn btn-danger btn-sm btn-eliminar-lista"
                                                        data-nombre="${producto.nombre}">
                                                    Eliminar
                                                </button>
                                            </form>

                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-8">
                            <form method="post" action="ControladorListaCompra" id="formVaciarLista">
                                <input type="hidden" name="accion" value="eliminarLista">
                                <button type="button" class="btn btn-danger" id="btnVaciarLista">Vaciar Lista de la Compra</button>
                            </form>
                        </div>
                        <div class="col-md-4 text-end">
                            <p><strong>Cantidad total:</strong> <span id="cantidadTotal">${totalProductosLista}</span> productos</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center fs-5">No tienes productos en tu lista.</div>
                </c:otherwise>
            </c:choose>

            <!-- Paginación -->
            <c:if test="${totalPaginas > 1}">
                <nav aria-label="Paginación lista de compra" class="mt-4">
                    <ul class="pagination pagination-personalizada justify-content-center">
                        <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra?pagina=${paginaActual - 1}">&laquo;</a>
                        </li>

                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                            <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra?pagina=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/Controladores.ListaCompra/ControladorListaCompra?pagina=${paginaActual + 1}">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/Controladores/ControladorInicio" class="btn btn-secondary">Volver a la tienda</a>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp" />

        <script>
 
            document.addEventListener("DOMContentLoaded", function () {

                // Eliminar producto individual con SweetAlert2
                document.querySelectorAll(".btn-eliminar-lista").forEach(btn => {
                    btn.addEventListener("click", function () {
                        const form = btn.closest("form");
                        const nombre = btn.dataset.nombre;

                        Swal.fire({
                            title: '¿Eliminar producto?',
                            html: `¿Estás seguro que quieres eliminar <strong>${nombre}</strong> de la lista?`,
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            cancelButtonText: 'No, cancelar',
                            confirmButtonText: 'Sí, eliminar'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                form.submit();
                            }
                        });
                    });
                });

                // Vaciar lista completa con SweetAlert2
                const btnVaciar = document.getElementById("btnVaciarLista");
                const formVaciar = document.getElementById("formVaciarLista");

                if (btnVaciar) {
                    btnVaciar.addEventListener("click", function () {
                        Swal.fire({
                            title: '¿Vaciar lista?',
                            text: 'Se eliminarán todos los productos de tu lista. ¿Deseas continuar?',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            cancelButtonText: 'No, volver',
                            confirmButtonText: 'Sí, vaciar'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                formVaciar.submit();
                            }
                        });
                    });
                }
            });
        </script>
    </body>
</html>
