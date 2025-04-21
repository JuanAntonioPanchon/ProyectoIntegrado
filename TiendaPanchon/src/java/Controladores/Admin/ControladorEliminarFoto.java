/*
 * ControladorEliminarFoto
 */
package Controladores.Admin;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.Producto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorEliminarFoto", urlPatterns = {"/Controladores.Admin/ControladorEliminarFoto"})
public class ControladorEliminarFoto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener los parámetros
        String productoIdStr = request.getParameter("productoId");
        String imagen = request.getParameter("imagen");

        if (productoIdStr != null && imagen != null) {
            Long productoId = Long.parseLong(productoIdStr);

            // Ruta completa de la imagen en el servidor
            String path = getServletContext().getRealPath("imagenesProductos");
            String rutaImagen = path + "/" + imagen;

            // Eliminar la imagen del sistema de archivos
            File archivoImagen = new File(rutaImagen);
            if (archivoImagen.exists()) {
                archivoImagen.delete();  // Eliminar archivo físico
            }

            // Eliminar la imagen de la base de datos
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
            ServicioProducto sr = new ServicioProducto(emf);
            Producto producto = sr.findProducto(productoId);

            if (producto != null) {
                List<String> imagenes = producto.getImagenes();
                if (imagenes != null && imagenes.contains(imagen)) {
                    imagenes.remove(imagen);  // Eliminar la imagen de la lista
                    producto.setImagenes(imagenes);

                    try {
                        sr.edit(producto);  // Guardar los cambios en la base de datos
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Error al eliminar la imagen del producto.");
                    }
                }
            }

            // Redirigir a la lista de productos
            response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorProducto");
        } else {
            // Si no hay parámetros válidos
            response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorProducto");
        }
    }
}
