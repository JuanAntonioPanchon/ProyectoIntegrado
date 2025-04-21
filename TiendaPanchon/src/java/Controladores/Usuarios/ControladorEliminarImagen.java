/*
 * ControladorEliminarImagen
 */
package Controladores.Usuarios;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.Receta;
import modelo.servicio.ServicioReceta;

/**
 *
 * @author juan-antonio
 */

@WebServlet(name = "ControladorEliminarImagen", urlPatterns = {"/Controladores.Usuarios/ControladorEliminarImagen"})
public class ControladorEliminarImagen extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener los parámetros
        String recetaIdStr = request.getParameter("recetaId");
        String imagen = request.getParameter("imagen");

        if (recetaIdStr != null && imagen != null) {
            Long recetaId = Long.parseLong(recetaIdStr);

            // Ruta completa de la imagen en el servidor
            String path = getServletContext().getRealPath("recetas/imagenes");
            String rutaImagen = path + "/" + imagen;

            // Eliminar la imagen del sistema de archivos
            File archivoImagen = new File(rutaImagen);
            if (archivoImagen.exists()) {
                archivoImagen.delete();  // Eliminar archivo físico
            }

            // Eliminar la imagen de la base de datos
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
            ServicioReceta sr = new ServicioReceta(emf);
            Receta receta = sr.findReceta(recetaId);

            if (receta != null) {
                List<String> imagenes = receta.getImagenes();
                if (imagenes != null && imagenes.contains(imagen)) {
                    imagenes.remove(imagen);  // Eliminar la imagen de la lista
                    receta.setImagenes(imagenes);

                    try {
                        sr.edit(receta);  // Guardar los cambios en la base de datos
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Error al eliminar la imagen de la receta.");
                    }
                }
            }

            
            response.sendRedirect(request.getContextPath() + "/Controladores/ControladorReceta");
        } else {
            
            response.sendRedirect(request.getContextPath() + "/Controladores/ControladorReceta");
        }
    }
}

