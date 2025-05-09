/*
 * ControladorInicio
 * Este controlador ademas de mandarte al inicio.jsp donde mostrara las CategoriaProductos que hay
 * y los Productos de cada CategoriaProducto cuando se vayan seleccionando.
 */
package Controladores;

import java.io.IOException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.CategoriaProducto;
import modelo.servicio.ServicioCategoriaProducto;
import java.util.List;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorInicio", urlPatterns = {"/Controladores/ControladorInicio"})
public class ControladorInicio extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir directamente al controlador de productos
        response.sendRedirect(request.getContextPath() + "/Controladores.Productos/ControladorListarProductos");
    }
}
