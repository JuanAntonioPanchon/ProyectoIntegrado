/*
 * ControladorInicio
 * Este controlador ademas de mandarte al inicio.jsp donde mostrara las CategoriaProductos que hay
 * y los Productos de cada CategoriaProducto cuando se vayan seleccionando.
 */
package Controladores;

import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.CategoriaProducto;
import modelo.servicio.ServicioCategoriaProducto;

@WebServlet(name = "ControladorInicio", urlPatterns = {"/Controladores/ControladorInicio"})
public class ControladorInicio extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);

        List<CategoriaProducto> categorias = sc.findCategoriaProductoEntities();
        emf.close();

        if (categorias != null && !categorias.isEmpty()) {

            Long idPrimeraCategoria = categorias.get(0).getId();
            response.sendRedirect(request.getContextPath() + "/Controladores.Productos/ControladorListarProductos?id_categoria=" + idPrimeraCategoria);
        } else {
            
            response.sendRedirect(request.getContextPath() + "/Controladores.Productos/ControladorListarProductos");
        }
    }
}
