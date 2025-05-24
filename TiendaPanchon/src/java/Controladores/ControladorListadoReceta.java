package Controladores;

import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.Receta;
import modelo.servicio.ServicioReceta;

@WebServlet(name = "ControladorListadoReceta", urlPatterns = {"/Controladores/ControladorListadoReceta"})
public class ControladorListadoReceta extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int pagina = 1;
        int tamanio = 6;

        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioReceta srec = new ServicioReceta(emf);

        List<Receta> recetas = srec.findRecetasPublicadasPaginado(pagina, tamanio);
        long total = srec.contarRecetasPublicadas();
        int totalPaginas = (int) Math.ceil((double) total / tamanio);

        emf.close();

        request.setAttribute("recetas", recetas);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        getServletContext().getRequestDispatcher("/recetas/listarTodasLasRecetas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
