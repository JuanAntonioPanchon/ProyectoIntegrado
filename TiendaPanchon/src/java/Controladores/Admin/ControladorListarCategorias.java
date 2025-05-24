/*
 * ControladorListarCategorias
 * Este controlador servira para que el admin pueda listar las categorias
 * crear nuevas, editar las que tiene o eliminarla
 */
package Controladores.Admin;

import java.io.IOException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.CategoriaProducto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.exceptions.NonexistentEntityException;
import java.util.List;
import modelo.entidades.Producto;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorListarCategorias", urlPatterns = {"/Controladores.Admin/ControladorListarCategorias"})
public class ControladorListarCategorias extends HttpServlet {

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
        ServicioCategoriaProducto scp = new ServicioCategoriaProducto(emf);
        String vista = "/admin/crearCategoria.jsp"; 

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            // Listar todas las categorías
            if (request.getParameter("id") == null && request.getParameter("crear") == null) {
                List<CategoriaProducto> categorias = scp.findCategoriaProductoEntities();
                request.setAttribute("categorias", categorias);

                if (!categorias.isEmpty()) {
                    CategoriaProducto primeraCategoria = categorias.get(0);
                    List<Producto> productos = scp.cargarProductosDeCategoria(primeraCategoria.getId());
                    request.setAttribute("productos", productos);
                    request.setAttribute("nombreCategoria", primeraCategoria.getNombre());
                    request.setAttribute("idCategoriaSeleccionada", primeraCategoria.getId());
                }

                vista = "/admin/listarCategorias.jsp";
            } // Crear una nueva categoría
            else if (request.getParameter("crear") != null) {
                vista = "/admin/crearCategoria.jsp";

            } // Editar una categoría
            else if (request.getParameter("id") != null) {
                try {
                    long id = Long.parseLong(request.getParameter("id"));
                    CategoriaProducto categoria = scp.findCategoriaProducto(id);
                    request.setAttribute("id", categoria.getId());
                    request.setAttribute("nombre", categoria.getNombre());
                    vista = "/admin/crearCategoria.jsp";
                } catch (Exception e) {
                    request.setAttribute("error", "Error al obtener la categoría.");
                    vista = "/admin/crearCategoria.jsp";
                }
            } // Eliminar una categoría
            else if (request.getParameter("eliminar") != null) {
                try {
                    long id = Long.parseLong(request.getParameter("eliminar"));
                    scp.destroy(id);
                } catch (NonexistentEntityException e) {
                    request.setAttribute("error", "La categoría con ID " + request.getParameter("eliminar") + " no existe.");
                }
            }

            // Limpiar el error de la sesión después de pasarlo a la vista
            String error = (String) sesion.getAttribute("error");
            if (error != null) {
                request.setAttribute("error", error);
                sesion.removeAttribute("error"); 
            }
        }

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String error = "";
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioCategoriaProducto scp = new ServicioCategoriaProducto(emf);
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            try {
                // CREAR
                if (request.getParameter("crear") != null) {
                    if (scp.findCategoriaProductoByName(nombre) != null) {
                        error = "La categoría \"" + nombre + "\" ya existe.";
                        request.setAttribute("nombre", nombre);
                        request.setAttribute("error", error);
                        emf.close();
                        request.getRequestDispatcher("/admin/crearCategoria.jsp").forward(request, response);
                        return;
                    } else {
                        CategoriaProducto categoria = new CategoriaProducto();
                        categoria.setNombre(nombre);
                        scp.create(categoria);
                        CategoriaProducto creada = scp.findCategoriaProductoByName(nombre);
                        emf.close();
                        
                        response.sendRedirect("ControladorProducto?id_categoria=" + creada.getId());
                        return;
                    }
                } // EDITAR
                else if (request.getParameter("editar") != null) {
                    long id = Long.parseLong(idStr);
                    CategoriaProducto categoria = scp.findCategoriaProducto(id);

                    CategoriaProducto duplicada = scp.findCategoriaProductoByName(nombre);
                    if (duplicada != null && duplicada.getId() != id) {
                        error = "La categoría \"" + nombre + "\" ya existe.";
                        request.setAttribute("id", id);
                        request.setAttribute("nombre", nombre);
                        request.setAttribute("error", error);
                        emf.close();
                        request.getRequestDispatcher("/admin/crearCategoria.jsp").forward(request, response);
                        return;
                    }

                    categoria.setNombre(nombre);
                    scp.edit(categoria);
                    emf.close();
                    
                    response.sendRedirect("ControladorProducto?id_categoria=" + id);
                    return;
                } // ELIMINAR
                else if (request.getParameter("eliminar") != null) {
                    long id = Long.parseLong(request.getParameter("id"));
                    try {
                        scp.destroy(id);
                    } catch (NonexistentEntityException e) {
                        error = "La categoría con ID " + idStr + " no existe.";
                    }
                }

            } catch (Exception e) {
                error = "Error al procesar la categoría.";
            }
        } else {
            error = "Usuario no autenticado.";
        }

        emf.close();

        if (!error.isEmpty()) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/admin/crearCategoria.jsp").forward(request, response);
            return;
        }

        
        response.sendRedirect("ControladorListarCategorias");
    }

}
