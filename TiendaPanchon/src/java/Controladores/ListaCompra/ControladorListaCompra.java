package Controladores.ListaCompra;

import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.Producto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioListaCompra;

@WebServlet(name = "ControladorListaCompra", urlPatterns = {"/Controladores.ListaCompra/ControladorListaCompra"})
public class ControladorListaCompra extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioListaCompra servicioLista = new ServicioListaCompra(emf);

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        String vista = "/listaCompra/listaCompra.jsp";

        if (usuario != null) {
            int pagina = 1;
            int tamanio = 10;

            if (request.getParameter("pagina") != null) {
                try {
                    pagina = Integer.parseInt(request.getParameter("pagina"));
                    if (pagina < 1) {
                        pagina = 1;
                    }
                } catch (NumberFormatException e) {
                    pagina = 1;
                }
            }

            
            List<Producto> productosLista = servicioLista.obtenerListaPorUsuarioPaginado(usuario.getId(), pagina, tamanio);

           
            long total = servicioLista.contarProductosPorUsuario(usuario.getId());
            int totalPaginas = (int) Math.ceil((double) total / tamanio);

            request.setAttribute("productosLista", productosLista);
            request.setAttribute("paginaActual", pagina);
            request.setAttribute("totalPaginas", totalPaginas);
            request.setAttribute("totalProductosLista", total);

        } else {
            request.setAttribute("error", "Usuario no autenticado.");
        }

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioListaCompra servicioLista = new ServicioListaCompra(emf);

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            String accion = request.getParameter("accion");
            String idProductoStr = request.getParameter("idProducto");

            try {
                if ("eliminarProducto".equals(accion) && idProductoStr != null) {
                    Long idProducto = Long.parseLong(idProductoStr);
                    servicioLista.eliminarProductoDeLista(usuario.getId(), idProducto);

                } else if ("eliminarLista".equals(accion)) {
                    servicioLista.vaciarListaCompra(usuario.getId());

                } else if ("anadirProducto".equals(accion) && idProductoStr != null) {
                    Long idProducto = Long.parseLong(idProductoStr);
                    String idCategoria = request.getParameter("idCategoria");

                    
                    String nombreProducto = servicioLista.obtenerNombreProducto(idProducto);

                    
                    boolean yaExiste = servicioLista.productoYaEnLista(usuario.getId(), idProducto);

                    
                    if (!yaExiste) {
                        servicioLista.agregarProductoALista(usuario.getId(), idProducto);
                    }

                    
                    String mensaje = yaExiste ? "existe" : "ok";

                    
                    response.sendRedirect(request.getContextPath()
                            + "/Controladores.Productos/ControladorListarProductos?id_categoria=" + idCategoria
                            + "&mensaje=" + mensaje
                            + "&nombreProducto=" + java.net.URLEncoder.encode(nombreProducto, "UTF-8"));

                    emf.close();
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de producto no válido.");
                e.printStackTrace();
            }
        } else {
            request.setAttribute("error", "Usuario no autenticado.");

        }

        emf.close();
        String pagina = request.getParameter("pagina");
        if (pagina == null || !pagina.matches("\\d+")) {
            pagina = "1";
        }
        response.sendRedirect(request.getContextPath() + "/Controladores.ListaCompra/ControladorListaCompra?pagina=" + pagina);

    }
}
