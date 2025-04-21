function eliminarImagen(recetaId, imagen) {

    const nombreImagen = imagen.split('_').slice(1).join('_');

    if (confirm(`¿Estás seguro de que deseas eliminar la imagen "${nombreImagen}"?`)) {
        const form = document.createElement('form');
        form.action = "../Controladores.Usuarios/ControladorEliminarImagen";
        form.method = "POST";

        const inputRecetaId = document.createElement('input');
        inputRecetaId.type = 'hidden';
        inputRecetaId.name = 'recetaId';
        inputRecetaId.value = recetaId;
        form.appendChild(inputRecetaId);

        const inputImagen = document.createElement('input');
        inputImagen.type = 'hidden';
        inputImagen.name = 'imagen';
        inputImagen.value = imagen;
        form.appendChild(inputImagen);

        document.body.appendChild(form);
        form.submit();
    }
}
