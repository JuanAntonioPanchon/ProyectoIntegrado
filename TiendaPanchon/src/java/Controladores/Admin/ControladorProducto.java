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
import modelo.entidades.Producto;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorProducto", urlPatterns = {"/Controladores.Admin/ControladorProducto"})
public class ControladorProducto extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioProducto sp = new ServicioProducto(emf);
    private ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sesion = request.getSession();

        String vista = "/admin/listarCategorias.jsp";

        
        request.setAttribute("categorias", sc.findCategoriaProductoEntities());

        // Si se pasa un id de categoría, listar los productos de esa categoría
        String idCategoriaStr = request.getParameter("id_categoria");
        if (idCategoriaStr != null) {
            long idCategoria = Long.parseLong(idCategoriaStr);
            request.setAttribute("productos", sp.findProductosByCategoria(idCategoria));
            request.setAttribute("nombreCategoria", sc.findCategoriaProducto(idCategoria).getNombre());
        }

        // Editar
        String idProductoStr = request.getParameter("id_producto");
        if (idProductoStr != null) {
            try {
                long idProducto = Long.parseLong(idProductoStr);
                Producto producto = sp.findProducto(idProducto);

                if (producto != null) {
                    request.setAttribute("id", producto.getId());
                    request.setAttribute("nombre", producto.getNombre());
                    request.setAttribute("descripcion", producto.getDescripcion());
                    request.setAttribute("precio", producto.getPrecio());
                    request.setAttribute("stock", producto.getStock());
                    request.setAttribute("oferta", producto.getOferta());
                    request.setAttribute("descuento", producto.getDescuento());
                    request.setAttribute("precioVenta", producto.getPrecio());
                    request.setAttribute("id_categoria", producto.getCategoria().getId());
                }

                vista = "/admin/crearProducto.jsp";
            } catch (Exception e) {
                request.setAttribute("error", "Error al obtener el producto.");
            }
        }

        // Crear
        if (request.getParameter("crear") != null) {
            vista = "/admin/crearProducto.jsp";
        }

        // Eliminar
        String eliminarProductoStr = request.getParameter("eliminarProducto");
        if (eliminarProductoStr != null) {
            try {
                long idProducto = Long.parseLong(eliminarProductoStr);
                Producto producto = sp.findProducto(idProducto);
                if (producto != null) {
                    sp.eliminarProductoYLimpiarListas(idProducto);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error al eliminar el producto.");
            }
        }

        
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sesion = request.getSession();

        try {
            // Eliminar
            String eliminarProductoStr = request.getParameter("eliminar");
            if (eliminarProductoStr != null && eliminarProductoStr.equals("Eliminar")) {
                String idProductoStr = request.getParameter("id");
                if (idProductoStr != null) {
                    try {
                        long idProducto = Long.parseLong(idProductoStr);
                        Producto producto = sp.findProducto(idProducto);
                        if (producto != null) {
                            sp.destroy(idProducto); // Llamada para eliminar el producto
                            System.out.println("Producto eliminado: " + producto.getNombre());
                        }
                    } catch (Exception e) {
                        request.setAttribute("error", "Error al eliminar el producto.");
                        System.out.println("Error al eliminar el producto: " + e.getMessage());
                    }
                }
            }

            if (request.getParameter("crear") != null) {
                // Crear
                Producto producto = new Producto();
                producto.setNombre(request.getParameter("nombre"));
                producto.setDescripcion(request.getParameter("descripcion"));

                // Obtener y validar el precio
                String precioStr = request.getParameter("precio");
                if (precioStr != null && !precioStr.isEmpty()) {
                    double precio = Double.valueOf(precioStr);
                    producto.setPrecio(precio);
                    System.out.println("precio " + precio);
                }

                // Obtener y validar el stock
                String stockStr = request.getParameter("stock");
                if (stockStr != null && !stockStr.isEmpty()) {
                    producto.setStock(Integer.valueOf(stockStr));
                }

                // Obtener y asignar el valor de novedad
                producto.setNovedad(Boolean.valueOf(request.getParameter("novedad")));

                producto.setFechaProducto(java.time.LocalDate.now());

                // Obtener y asignar el descuento
                String descuentoStr = request.getParameter("descuento");
                if (descuentoStr != null && !descuentoStr.isEmpty()) {
                    producto.setDescuento(Double.valueOf(descuentoStr));
                }

                // Cambiar la forma en que se establece la oferta
                String ofertaStr = request.getParameter("oferta");
                boolean oferta = "true".equals(ofertaStr);
                producto.setOferta(oferta);

                // Establecer la categoría del producto
                String categoriaIdStr = request.getParameter("id_categoria");
                if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
                    producto.setCategoria(sc.findCategoriaProducto(Long.valueOf(categoriaIdStr)));
                }

                // Asignar el precioVenta a partir del frontend
                String precioVentaStr = request.getParameter("precioVenta");
                if (precioVentaStr != null && !precioVentaStr.isEmpty()) {
                    double precioFinal = Double.parseDouble(precioVentaStr);
                    System.out.println("precioFinal " + precioFinal);
                    System.out.println("precioVenta " + precioVentaStr);
                }

                
                request.setAttribute("precioVenta", precioVentaStr);

                // Si hay más de 10 productos novedosos, desmarcar el más antiguo
                if (sp.findProductosNovedades().size() == 10) {
                    // Desmarcar el producto más antiguo como novedad
                    Producto productoMasAntiguo = sp.findProductosNovedades().get(0); // Obtener el primero (más antiguo)
                    productoMasAntiguo.setNovedad(false);
                    sp.edit(productoMasAntiguo); // Actualizar el producto más antiguo
                    producto.setNovedad(true);
                } else {
                    producto.setNovedad(true);
                }

                System.out.println("precio " + producto.getPrecio());

                sp.create(producto);
            } else if (request.getParameter("editar") != null) {
                // Editar 
                Long id = Long.valueOf(request.getParameter("id"));
                Producto producto = sp.findProducto(id);

                if (producto != null) {
                    producto.setNombre(request.getParameter("nombre"));
                    producto.setDescripcion(request.getParameter("descripcion"));

                    // Obtener y validar el precio
                    String precioStr = request.getParameter("precio");
                    if (precioStr != null && !precioStr.isEmpty()) {
                        double precio = Double.parseDouble(precioStr);
                        producto.setPrecio(precio);
                        System.out.println("precio " + precio);
                    }

                    // Obtener y validar el stock
                    String stockStr = request.getParameter("stock");
                    if (stockStr != null && !stockStr.isEmpty()) {
                        producto.setStock(Integer.parseInt(stockStr));
                    }

                    // Obtener y asignar el descuento
                    String descuentoStr = request.getParameter("descuento");
                    if (descuentoStr != null && !descuentoStr.isEmpty()) {
                        producto.setDescuento(Double.parseDouble(descuentoStr));
                    }

                    // Cambiar la forma en que se establece la oferta
                    String ofertaStr = request.getParameter("oferta");
                    boolean oferta = "true".equals(ofertaStr);
                    producto.setOferta(oferta);

                    // Asignar el precioVenta a partir del frontend (como en crear)
                    String precioVentaStr = request.getParameter("precioVenta");
                    if (precioVentaStr != null && !precioVentaStr.isEmpty()) {
                        double precioFinal = Double.parseDouble(precioVentaStr);
                        System.out.println("precioFinal " + precioFinal);
                        System.out.println("precioVenta " + precioVentaStr);
                    }

                    // Asignar el precioVenta a la petición para que esté disponible en el JSP
                    request.setAttribute("precioVenta", precioVentaStr);

                    // Actualizar la categoría del producto
                    String categoriaIdStr = request.getParameter("id_categoria");
                    if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
                        producto.setCategoria(sc.findCategoriaProducto(Long.parseLong(categoriaIdStr)));
                    }

                    sp.edit(producto);
                }
            }

            // Obtener la URL de referencia (referer) desde el formulario
            String referer = request.getParameter("referer");

            // Si existe la URL de referencia, redirigir allí
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                // Si no existe, redirigir a la lista de productos
                response.sendRedirect("ControladorProducto");
            }

        } catch (Exception e) {
            sesion.setAttribute("error", "Error al procesar la solicitud.");
        }
    }
}
