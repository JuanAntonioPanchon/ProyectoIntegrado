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
        String recetaIdStr = request.getParameter("recetaId");
        String imagen = request.getParameter("imagen");
        String pagina = request.getParameter("pagina");

        if (recetaIdStr != null && imagen != null) {
            Long recetaId = Long.parseLong(recetaIdStr);
            String path = getServletContext().getRealPath("recetas/imagenes");
            String rutaImagen = path + "/" + imagen;

            File archivoImagen = new File(rutaImagen);
            if (archivoImagen.exists()) {
                archivoImagen.delete();
            }

            EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
            ServicioReceta sr = new ServicioReceta(emf);
            Receta receta = sr.findReceta(recetaId);

            if (receta != null) {
                List<String> imagenes = receta.getImagenes();
                if (imagenes != null && imagenes.contains(imagen)) {
                    imagenes.remove(imagen);
                    receta.setImagenes(imagenes);
                    try {
                        sr.edit(receta);
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Error al eliminar la imagen de la receta.");
                    }
                }
            }
        }

        // Redirigir con la página actual si está presente
        String redirectURL = request.getContextPath() + "/Controladores/ControladorReceta";
        if (pagina != null && !pagina.isBlank()) {
            redirectURL += "?pagina=" + pagina;
        }
        response.sendRedirect(redirectURL);
    }

}
