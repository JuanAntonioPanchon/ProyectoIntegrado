/*
 * ControladoresFiltrarRecetas
 */
package Controladores;

import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet(name = "ControladorFiltrarRecetas", urlPatterns = {"/Controladores/ControladorFiltrarRecetas"})
public class ControladorFiltrarRecetas extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String filtro = request.getParameter("filtro");
        if (filtro == null) {
            filtro = "";
        }

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioReceta srec = new ServicioReceta(emf);

        List<Receta> recetas = srec.findRecetasPublicadas();
        emf.close();

        filtro = filtro.toLowerCase().trim();
        List<Receta> filtradas = new ArrayList<>();

        for (Receta receta : recetas) {
            if (receta.getTitulo().toLowerCase().contains(filtro)
                    || receta.getIngredientes().toLowerCase().contains(filtro)
                    || receta.getUsuario().getNombre().toLowerCase().contains(filtro)) {
                filtradas.add(receta);
            }
        }
        recetas = filtradas; // Asignar las recetas filtradas

        request.setAttribute("recetas", filtradas);
        getServletContext().getRequestDispatcher("/recetas/filtrarReceta.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Controlador para filtrar recetas según criterios de búsqueda";
    }// </editor-fold>
}
