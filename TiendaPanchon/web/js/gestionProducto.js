/* 
 * Scripts de Producto
 */


function calcularPrecioVenta() {
    var precio = parseFloat(document.getElementsByName("precio")[0].value);
    var descuento = parseFloat(document.getElementsByName("descuento")[0].value);
    var ofertaSi = document.querySelector('input[name="oferta"][value="true"]').checked;

    var precioConDescuento = precio - (precio * (descuento / 100));

    var precioVenta = ofertaSi ? precioConDescuento : precio;

    document.getElementsByName("precioVenta")[0].value = precioVenta.toFixed(2);
}

function calcularDescuento() {
    var precio = parseFloat(document.getElementsByName("precio")[0].value);
    var precioVenta = parseFloat(document.getElementsByName("precioVenta")[0].value);

    if (!isNaN(precio) && !isNaN(precioVenta) && precio > 0 && precioVenta > 0) {
        var descuento = ((precio - precioVenta) / precio) * 100;
        document.getElementsByName("descuento")[0].value = descuento.toFixed(2);
    }
}

window.onload = function () {
    document.getElementsByName("precio")[0].addEventListener("input", function () {
        calcularPrecioVenta();
        calcularDescuento();
    });
    document.getElementsByName("descuento")[0].addEventListener("input", function () {
        calcularPrecioVenta();
    });
    document.querySelectorAll('input[name="oferta"]').forEach(function (radio) {
        radio.addEventListener("change", calcularPrecioVenta);
    });

    document.getElementsByName("precioVenta")[0].addEventListener("input", function () {
        calcularDescuento();
    });

    calcularPrecioVenta();
    calcularDescuento();
};