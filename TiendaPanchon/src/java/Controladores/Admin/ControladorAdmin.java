/*
 * ControladorAdmin
 */
package Controladores.Admin;

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

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorAdmin", urlPatterns = {"/Controladores.Admin/ControladorAdmin"})
public class ControladorAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto servicioProducto = new ServicioProducto(emf);
        List<Producto> productosStockBajo = servicioProducto.findProductosConStockBajo();

        request.setAttribute("productosStockBajo", productosStockBajo);

        emf.close();

        getServletContext().getRequestDispatcher("/admin/inicioAdmin.jsp").forward(request, response);
    }
}
