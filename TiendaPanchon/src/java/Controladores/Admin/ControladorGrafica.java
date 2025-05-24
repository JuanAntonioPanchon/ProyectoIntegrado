/*
 * ControladorGrafica
 */
package Controladores.Admin;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.CategoriaProducto;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioProducto;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorGrafica", urlPatterns = {"/Controladores.Admin/ControladorGrafica"})
public class ControladorGrafica extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String vista = "/admin/grafica.jsp";
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sp = new ServicioProducto(emf);
        ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);

        
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");
        String categoriaIdStr = request.getParameter("categoriaId");

        LocalDate fechaInicio = null;
        LocalDate fechaFin = null;
        Long categoriaId = null;

        try {
            if (fechaInicioStr != null && fechaFinStr != null && categoriaIdStr != null) {
                fechaInicio = LocalDate.parse(fechaInicioStr); // Formato yyyy-MM-dd
                fechaFin = LocalDate.parse(fechaFinStr);
                categoriaId = Long.parseLong(categoriaIdStr);

                // Validar si la fecha de inicio es posterior a la de fin
                if (fechaInicio.isAfter(fechaFin)) {
                    request.setAttribute("errorFecha", "La fecha de inicio no puede ser posterior a la fecha de fin.");
                } else {
                    // Obtener los productos más vendidos en ese rango de fechas y categoría
                    List<Object[]> productosVendidos = sp.findProductosMasVendidos(fechaInicio, fechaFin, categoriaId);
                    request.setAttribute("productos", productosVendidos);
                }
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            e.printStackTrace();
        }

        
        List<CategoriaProducto> categorias = sc.findCategoriaProductoEntities();
        request.setAttribute("categorias", categorias);

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador para mostrar productos más vendidos";
    }
}
