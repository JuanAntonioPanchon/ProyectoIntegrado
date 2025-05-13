/*
 * ControladorListaCompra
 * El usuario listara, eliminara productos de la lista de la compra
 */
package Controladores.ListaCompra;

import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.ListaCompra;
import modelo.entidades.Producto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioListaCompra;

@WebServlet(name = "ControladorListaCompra", urlPatterns = {"/Controladores.ListaCompra/ControladorListaCompra"})
public class ControladorListaCompra extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioListaCompra servicioLista = new ServicioListaCompra(emf);

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            List<Producto> productosLista = servicioLista.obtenerListaPorUsuario(usuario.getId());
            request.setAttribute("productosLista", productosLista);
        } else {
            request.setAttribute("error", "Usuario no autenticado.");
        }

        emf.close();
        getServletContext().getRequestDispatcher("/listaCompra/listaCompra.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

                    // Obtener nombre del producto
                    String nombreProducto = servicioLista.obtenerNombreProducto(idProducto);

                    // Comprobar si ya está en la lista
                    boolean yaExiste = servicioLista.productoYaEnLista(usuario.getId(), idProducto);

                    // Si no está, lo añadimos
                    if (!yaExiste) {
                        servicioLista.agregarProductoALista(usuario.getId(), idProducto);
                    }

                    // Construimos mensaje
                    String mensaje = yaExiste ? "existe" : "ok";

                    // Redirigir con mensaje y nombre del producto
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
        response.sendRedirect(request.getContextPath() + "/Controladores.ListaCompra/ControladorListaCompra");
    }

}
