package Controladores.Usuarios;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import modelo.entidades.Receta;
import modelo.servicio.ServicioReceta;

@WebServlet(name = "ControladorSubirFichero", urlPatterns = {"/Controladores.Usuarios/ControladorSubirFichero"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ControladorSubirFichero extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recetaIdStr = request.getParameter("recetaId");
        String pagina = request.getParameter("pagina"); // <-- AÑADIR

        if (recetaIdStr != null) {
            try {
                long recetaId = Long.parseLong(recetaIdStr);
                request.setAttribute("recetaId", recetaId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de receta no válido.");
            }
        } else {
            request.setAttribute("error", "Falta el parámetro recetaId.");
        }

        // Añadir la página como atributo para el JSP
        if (pagina != null) {
            request.setAttribute("pagina", pagina);
        }

        getServletContext().getRequestDispatcher("/recetas/subirFichero.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = getServletContext().getRealPath("recetas/imagenes");
        Part fichero = request.getPart("fichero");
        String nombreOriginal = fichero.getSubmittedFileName();
        String recetaIdStr = request.getParameter("recetaId");
        String pagina = request.getParameter("pagina");

        Long recetaId = Long.parseLong(recetaIdStr);
        String nuevoNombreFichero = recetaId + "_" + nombreOriginal;
        String rutaCompleta = path + "/" + nuevoNombreFichero;

        // Guardar fichero
        try (InputStream contenido = fichero.getInputStream(); FileOutputStream ficheroSalida = new FileOutputStream(rutaCompleta)) {
            byte[] buffer = new byte[8192];
            int bytesLeidos;
            while ((bytesLeidos = contenido.read(buffer)) != -1) {
                ficheroSalida.write(buffer, 0, bytesLeidos);
            }
        }

        // Guardar la imagen en la receta
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioReceta sr = new ServicioReceta(emf);
        Receta receta = sr.findReceta(recetaId);

        if (receta != null) {
            List<String> imagenes = receta.getImagenes();
            if (imagenes == null) {
                imagenes = new ArrayList<>();
            }
            imagenes.add("recetas/imagenes/" + nuevoNombreFichero);
            receta.setImagenes(imagenes);
            try {
                sr.edit(receta);
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Error al actualizar la receta con la imagen.");
            }
        }

        // Mensaje de éxito y redirección a página original
        request.getSession().setAttribute("imagenSubida", true);
        String redireccion = request.getContextPath() + "/Controladores/ControladorReceta";
        if (pagina != null && !pagina.isBlank()) {
            redireccion += "?pagina=" + pagina;
        }
        response.sendRedirect(redireccion);
    }

}
