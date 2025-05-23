document.addEventListener("DOMContentLoaded", function () {
    const filas = document.querySelectorAll(".fila-clicable");
    filas.forEach(fila => {
        fila.style.cursor = "pointer";
        fila.addEventListener("click", () => {
            const destino = fila.getAttribute("data-href");
            if (destino) {
                window.location.href = destino;
            }
        });
    });
});

document.querySelectorAll('.tarjeta-admin').forEach(card => {
    card.style.cursor = 'pointer';

    card.addEventListener('click', () => {
        const titulo = card.querySelector('.card-title')?.textContent?.toUpperCase();

        switch (true) {
            case titulo.includes('PRODUCTOS Y CATEGORÍAS'):
                window.location.href = '${pageContext.request.contextPath}/Controladores.Admin/ControladorListarCategorias';
                break;
            case titulo.includes('RECETAS'):
                window.location.href = '${pageContext.request.contextPath}/Controladores/ControladorReceta';
                break;
            case titulo.includes('USUARIOS'):
                window.location.href = '${pageContext.request.contextPath}/Controladores.Admin/ControladorGestionarUsuarios';
                break;
            case titulo.includes('PEDIDOS'):
                window.location.href = '${pageContext.request.contextPath}/Controladores.Admin/ControladorListarPedidos';
                break;
            case titulo.includes('GRÁFICA VENTAS'):
                window.location.href = '${pageContext.request.contextPath}/Controladores.Admin/ControladorGrafica';
                break;
            default:
                console.warn('Ruta no definida para:', titulo);
        }
    });
});


