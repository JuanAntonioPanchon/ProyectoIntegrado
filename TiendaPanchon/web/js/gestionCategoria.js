/* 
 * Scripts referentes a la gestion de categorias
 */


function confirmarEliminacion(categoriaNombre) {
    var mensaje = "¿Estás seguro que quieres eliminar la categoría '" + categoriaNombre + "'?\nSe eliminarán todos los productos asociados a esta categoría.";
    return confirm(mensaje);
}