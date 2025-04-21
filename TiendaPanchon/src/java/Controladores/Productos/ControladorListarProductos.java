package Controladores.Productos;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.CategoriaProducto;
import modelo.entidades.Producto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioProducto;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorListarProductos", urlPatterns = {"/Controladores.Productos/ControladorListarProductos"})
public class ControladorListarProductos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sp = new ServicioProducto(emf);
        ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);
        String vista = "/usuarios/inicio.jsp";

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (usuario != null) {
            try {
                List<CategoriaProducto> categorias = sc.findCategoriaProductoEntities();
                request.setAttribute("categorias", categorias);

                String ofertaStr = request.getParameter("oferta");
                String novedadesStr = request.getParameter("novedades");

                Map<Long, Double> preciosOriginales = new HashMap<>();

                if (ofertaStr != null && ofertaStr.equals("true")) { // productos de oferta
                    List<Producto> productosConOferta = sp.findProductosConOferta();

                    for (Producto producto : productosConOferta) {
                        Double precioOriginal = producto.getPrecio();
                        Double precioConDescuento = precioOriginal; // Inicializamos precio con descuento con el precio original
                        Double precioInicial = null; // Para almacenar el precio original si tiene descuento

                        if (producto.getOferta() != null && producto.getOferta()) {
                            // Si tiene oferta, aplicamos el descuento
                            precioConDescuento = precioOriginal * (1 - producto.getDescuento() / 100);
                            precioConDescuento = Math.round(precioConDescuento * 100.0) / 100.0;
                            precioInicial = precioOriginal; // Guardamos el precio original para la vista
                        }

                        producto.setPrecio(precioConDescuento); // Este es el precio con descuento

                        // Guardamos el precio original en el Map
                        preciosOriginales.put(producto.getId(), precioOriginal);
                    }

                    request.setAttribute("productos", productosConOferta);
                    request.setAttribute("nombreCategoria", "Ofertas");
                    request.setAttribute("precioInicial", true);
                } else if (novedadesStr != null && novedadesStr.equals("true")) {
                    List<Producto> productosNovedades = sp.findProductosNovedades();

                    for (Producto producto : productosNovedades) {
                        Double precioOriginal = producto.getPrecio();

                        if (producto.getOferta() != null && producto.getOferta()) {
                            Double precioConDescuento = precioOriginal * (1 - producto.getDescuento() / 100);
                            precioConDescuento = Math.round(precioConDescuento * 100.0) / 100.0;
                            producto.setPrecio(precioConDescuento);

                            // Guardamos el precio original en el Map
                            preciosOriginales.put(producto.getId(), precioOriginal);
                        }
                    }

                    request.setAttribute("productos", productosNovedades);
                    request.setAttribute("nombreCategoria", "Novedades");
                    request.setAttribute("precioInicial", false);
                } else {
                    String idCategoriaStr = request.getParameter("id_categoria");
                    if (idCategoriaStr != null) {
                        long idCategoria = Long.parseLong(idCategoriaStr);
                        List<Producto> productos = sp.findProductosByCategoria(idCategoria);

                        CategoriaProducto categoriaSeleccionada = sc.findCategoriaProducto(idCategoria);
                        request.setAttribute("nombreCategoria", categoriaSeleccionada.getNombre());

                        for (Producto producto : productos) {
                            Double precioOriginal = producto.getPrecio();

                            if (producto.getOferta() != null && producto.getOferta()) {
                                Double precioConDescuento = precioOriginal * (1 - producto.getDescuento() / 100);
                                precioConDescuento = Math.round(precioConDescuento * 100.0) / 100.0;
                                producto.setPrecio(precioConDescuento);

                                // Guardamos el precio original en el Map
                                preciosOriginales.put(producto.getId(), precioOriginal);
                            }
                        }

                        request.setAttribute("productos", productos);
                    }
                }

                
                request.setAttribute("preciosOriginales", preciosOriginales);

            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de categoría no válido.");
            }
        } else {
            request.setAttribute("error", "Usuario no autenticado.");
        }

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }
}
