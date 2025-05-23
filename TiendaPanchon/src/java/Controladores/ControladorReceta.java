/*
 * ControladorReceta 
 */
package Controladores;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.Receta;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioReceta;
import modelo.servicio.exceptions.NonexistentEntityException;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorReceta", urlPatterns = {"/Controladores/ControladorReceta"})
public class ControladorReceta extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioReceta srec = new ServicioReceta(emf);
        String vista = "/recetas/listarRecetas.jsp";

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            long idUsuario = usuario.getId();

            // listar las recetas
            if (request.getParameter("id") == null && request.getParameter("crear") == null) {
                int pagina = 1;
                int tamanio = 6;

                if (request.getParameter("pagina") != null) {
                    try {
                        pagina = Integer.parseInt(request.getParameter("pagina"));
                    } catch (NumberFormatException e) {
                        pagina = 1;
                    }
                }

                List<Receta> recetas = srec.findRecetasPorUsuarioPaginado(idUsuario, pagina, tamanio);
                long total = srec.contarRecetasPorUsuario(idUsuario);
                int totalPaginas = (int) Math.ceil((double) total / tamanio);

                request.setAttribute("idUsuario", idUsuario);
                request.setAttribute("recetas", recetas);
                request.setAttribute("paginaActual", pagina);
                request.setAttribute("totalPaginas", totalPaginas);
            } // crear una nueva receta
            else if (request.getParameter("crear") != null) {
                vista = "/recetas/crearReceta.jsp";
            } //editar una receta
            else if (request.getParameter("id") != null) {
                try {
                    long id = Long.parseLong(request.getParameter("id"));
                    Receta receta = srec.findReceta(id);
                    request.setAttribute("id", receta.getId());
                    request.setAttribute("titulo", receta.getTitulo());
                    request.setAttribute("ingredientes", receta.getIngredientes());
                    request.setAttribute("descripcion", receta.getDescripcion());
                    request.setAttribute("publicada", receta.isPublicada());
                    request.setAttribute("imagenes", receta.getImagenes());

                    if (request.getParameter("pagina") != null) {
                        request.setAttribute("paginaActual", request.getParameter("pagina"));
                    }
                    vista = "/recetas/crearReceta.jsp";

                } catch (Exception e) {
                    request.setAttribute("error", "Error al obtener la receta.");
                }
            }
        }
        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String publicada = request.getParameter("publicada");
        String ingredientes = request.getParameter("ingredientes");

        String error = "";
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioReceta srec = new ServicioReceta(emf);
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            try {
                if (request.getParameter("crear") != null) {
                    Receta receta = new Receta();
                    receta.setTitulo(titulo);
                    receta.setDescripcion(descripcion);
                    receta.setPublicada("1".equals(publicada));
                    receta.setUsuario(usuario);
                    receta.setIngredientes(ingredientes);
                    receta.setImagenes(new ArrayList<>());
                    srec.create(receta);
                } else if (request.getParameter("editar") != null && idStr != null && !idStr.isBlank()) {
                    long id = Long.parseLong(idStr);
                    Receta receta = srec.findReceta(id);
                    receta.setTitulo(titulo);
                    receta.setDescripcion(descripcion);
                    receta.setPublicada("1".equals(publicada));
                    receta.setIngredientes(ingredientes);
                    srec.edit(receta);
                } else if (request.getParameter("eliminar") != null && idStr != null && !idStr.isBlank()) {
                    long id = Long.parseLong(idStr);
                    srec.destroy(id);
                }
            } catch (NonexistentEntityException e) {
                error = "La receta con ID " + idStr + " no existe.";
            } catch (Exception e) {
                error = "Error al procesar la receta.";
                e.printStackTrace();
            }
        } else {
            error = "Usuario no autenticado.";
        }

        emf.close();

        if (!error.isEmpty()) {
            sesion.setAttribute("error", error);
        }

        String pagina = request.getParameter("pagina");
        String origen = request.getParameter("origen");
        if ("listadoPublico".equals(origen)) {
            // Vuelve al listado público
            if (pagina != null && !pagina.isBlank()) {
                response.sendRedirect("ControladorListadoReceta?pagina=" + pagina);
            } else {
                response.sendRedirect("ControladorListadoReceta");
            }
        } else {
            // Vuelve al listado de recetas propias
            if (pagina != null && !pagina.isBlank()) {
                response.sendRedirect("ControladorReceta?pagina=" + pagina);
            } else {
                response.sendRedirect("ControladorReceta");
            }
        }

    }

}
