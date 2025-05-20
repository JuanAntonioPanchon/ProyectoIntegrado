package Controladores.Admin;

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
import modelo.entidades.CategoriaProducto;
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

        String idCategoriaStr = request.getParameter("id_categoria");
        if (idCategoriaStr != null) {
            long idCategoria = Long.parseLong(idCategoriaStr);
            CategoriaProducto categoria = sc.findCategoriaProducto(idCategoria);
            request.setAttribute("productos", sp.findProductosByCategoria(idCategoria));
            request.setAttribute("nombreCategoria", categoria.getNombre());
            request.setAttribute("idCategoriaSeleccionada", categoria.getId());
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
                    request.setAttribute("novedad", producto.getNovedad());
                    request.setAttribute("precioVenta", producto.getPrecio());
                    request.setAttribute("id_categoria", producto.getCategoria().getId());
                }

                request.setAttribute("categorias", sc.findCategoriaProductoEntities());
                vista = "/admin/crearProducto.jsp";
            } catch (Exception e) {
                request.setAttribute("error", "Error al obtener el producto.");
            }
        }

        // Crear
        if (request.getParameter("crear") != null) {
            request.setAttribute("categorias", sc.findCategoriaProductoEntities());
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
                String idCategoriaStr = request.getParameter("id_categoria"); // 🔁 capturamos id de categoría

                if (idProductoStr != null) {
                    try {
                        long idProducto = Long.parseLong(idProductoStr);
                        Producto producto = sp.findProducto(idProducto);
                        if (producto != null) {
                            sp.destroy(idProducto);
                        }
                    } catch (Exception e) {
                        request.setAttribute("error", "Error al eliminar el producto.");
                    }
                }

                // 🔁 Redirigir manteniendo la categoría seleccionada
                if (idCategoriaStr != null && !idCategoriaStr.isEmpty()) {
                    response.sendRedirect("ControladorProducto?id_categoria=" + idCategoriaStr);
                } else {
                    response.sendRedirect("ControladorProducto");
                }
                return;
            }

            // CREAR o EDITAR
            boolean esEditar = request.getParameter("editar") != null;
            Long id = esEditar ? Long.valueOf(request.getParameter("id")) : null;
            String nombre = request.getParameter("nombre").trim();
            Producto duplicado = sp.findProductoByNombre(nombre);
            Producto producto = esEditar ? sp.findProducto(id) : new Producto();

            if (duplicado != null && (!esEditar || !duplicado.getId().equals(producto.getId()))) {
                request.setAttribute("error", "El producto \"" + nombre + "\" ya existe.");
                request.setAttribute("id", request.getParameter("id"));
                request.setAttribute("nombre", nombre);
                request.setAttribute("descripcion", request.getParameter("descripcion"));
                request.setAttribute("precio", request.getParameter("precio"));
                request.setAttribute("stock", request.getParameter("stock"));
                request.setAttribute("descuento", request.getParameter("descuento"));
                request.setAttribute("oferta", request.getParameter("oferta"));
                request.setAttribute("novedad", request.getParameter("novedad"));
                request.setAttribute("precioVenta", request.getParameter("precioVenta"));
                request.setAttribute("id_categoria", request.getParameter("id_categoria"));
                request.setAttribute("categorias", sc.findCategoriaProductoEntities());
                request.getRequestDispatcher("/admin/crearProducto.jsp").forward(request, response);
                return;
            }

            producto.setNombre(nombre);
            producto.setDescripcion(request.getParameter("descripcion"));

            String precioStr = request.getParameter("precio");
            if (precioStr != null && !precioStr.isEmpty()) {
                producto.setPrecio(Double.parseDouble(precioStr));
            }

            String stockStr = request.getParameter("stock");
            if (stockStr != null && !stockStr.isEmpty()) {
                producto.setStock(Integer.parseInt(stockStr));
            }

            producto.setNovedad(Boolean.parseBoolean(request.getParameter("novedad")));
            producto.setFechaProducto(java.time.LocalDate.now());

            String descuentoStr = request.getParameter("descuento");
            if (descuentoStr != null && !descuentoStr.isEmpty()) {
                producto.setDescuento(Double.parseDouble(descuentoStr));
            }

            String ofertaStr = request.getParameter("oferta");
            boolean oferta = "true".equals(ofertaStr);
            producto.setOferta(oferta);

            String categoriaIdStr = request.getParameter("id_categoria");
            if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
                producto.setCategoria(sc.findCategoriaProducto(Long.valueOf(categoriaIdStr)));
            }

            String precioVentaStr = request.getParameter("precioVenta");
            request.setAttribute("precioVenta", precioVentaStr);

            // Lógica de novedad
            if (!esEditar) {
                List<Producto> novedades = sp.findProductosNovedades();

                if (novedades.size() >= 10) {
                    // Desmarcar los más antiguos hasta tener solo 9
                    int exceso = novedades.size() - 9;
                    for (int i = 0; i < exceso; i++) {
                        Producto antiguo = novedades.get(i);
                        antiguo.setNovedad(false);
                        sp.edit(antiguo);
                    }
                }

                // Marcar este nuevo producto como novedad
                producto.setNovedad(true);
            }

            if (esEditar) {
                sp.edit(producto);
            } else {
                sp.create(producto);
            }

            // Redirigir a la categoría
            if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
                response.sendRedirect("ControladorProducto?id_categoria=" + categoriaIdStr);
            } else {
                response.sendRedirect("ControladorProducto");
            }

        } catch (Exception e) {
            sesion.setAttribute("error", "Error al procesar la solicitud.");
            response.sendRedirect("ControladorProducto");
        }
    }
}
