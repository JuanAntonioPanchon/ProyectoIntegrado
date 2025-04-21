package Controladores.Admin;

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
import modelo.entidades.Producto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorSubirFoto", urlPatterns = {"/Controladores.Admin/ControladorSubirFoto"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ControladorSubirFoto extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recoger los parámetros de la URL
        String productoIdStr = request.getParameter("productoId");

        if (productoIdStr != null) {
            try {
                long productoId = Long.parseLong(productoIdStr);
                request.setAttribute("productoId", productoId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de receta no válido.");
            }
        } else {
            request.setAttribute("error", "Falta el parámetro recetaId.");
        }

        // Redirigir a la vista de subida de archivos
        String vista = "/admin/subirFoto.jsp";
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = getServletContext().getRealPath("/imagenesProductos");
        System.out.println("Path de subida: " + path);

        Part fichero = request.getPart("fichero");
        String nombreOriginal = fichero.getSubmittedFileName();

        
        String productoIdStr = request.getParameter("productoId");
        Long productoId = Long.parseLong(productoIdStr);

        // Crear un nombre de archivo único con ID de receta y nombre original
        String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf("."));
        String nuevoNombreFichero = productoId + "_" + nombreOriginal;
        String rutaCompleta = path + "/" + nuevoNombreFichero;

        // Guardar el archivo en la carpeta
        InputStream contenido = fichero.getInputStream();
        FileOutputStream ficheroSalida = new FileOutputStream(rutaCompleta);
        byte[] buffer = new byte[8192];
        int bytesLeidos;
        while ((bytesLeidos = contenido.read(buffer)) != -1) {
            ficheroSalida.write(buffer, 0, bytesLeidos);
        }
        ficheroSalida.close();
        contenido.close();

        // Guardar la imagen
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sr = new ServicioProducto(emf);
        Producto producto = sr.findProducto(productoId);

        if (producto != null) {
            List<String> imagenes = producto.getImagenes();
            if (imagenes == null) {
                imagenes = new ArrayList<>();
            }
            imagenes.add("imagenesProductos/" + nuevoNombreFichero);
            producto.setImagenes(imagenes);

            try {
                sr.edit(producto);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error al actualizar la receta con la imagen.");
            }
        }

        
        response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorProducto");
    }

}
