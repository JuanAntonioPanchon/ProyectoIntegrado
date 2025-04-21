/* 
 * Filtrar Recetas con ajax
 */

function filtrar() {
    filtro = document.getElementById("filtro").value;
    $.ajax({
        url: "ControladorFiltrarRecetas",
        method: 'POST',
        data: {filtro : filtro}        
    }).done(function(datos) {
        $("#listado").html(datos);
    });
}
