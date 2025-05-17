package Controladores.Productos;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.CategoriaProducto;
import modelo.entidades.Producto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorListarProductos", urlPatterns = {"/Controladores.Productos/ControladorListarProductos"})
public class ControladorListarProductos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sp = new ServicioProducto(emf);
        ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);
        String vista = "/usuarios/inicio.jsp";

        try {
            List<CategoriaProducto> categorias = sc.findCategoriaProductoEntities();
            request.setAttribute("categorias", categorias);

            String ofertaStr = request.getParameter("oferta");
            String novedadesStr = request.getParameter("novedades");
            Map<Long, Double> preciosOriginales = new HashMap<>();

            int pagina = 1;
            int tamanio = 6; // 9 productos por página

            // Obtener página solicitada
            String paginaStr = request.getParameter("pagina");
            if (paginaStr != null) {
                try {
                    pagina = Integer.parseInt(paginaStr);
                } catch (NumberFormatException e) {
                    pagina = 1;
                }
            }

            List<Producto> productos;
            long totalProductos = 0;

            if ("true".equals(ofertaStr)) {
                productos = sp.findProductosConOferta();
                productos.removeIf(p -> p.getStock() <= 0);
                totalProductos = productos.size(); // Para ofertas tomamos el tamaño actual

                // Aplicar paginación manual ya que método paginado no implementado para oferta
                productos = productos.stream()
                        .skip((pagina - 1) * tamanio)
                        .limit(tamanio)
                        .toList();

                request.setAttribute("nombreCategoria", "Ofertas");

            } else if ("true".equals(novedadesStr)) {
                productos = sp.findProductosNovedades();
                productos.removeIf(p -> p.getStock() <= 0);
                totalProductos = productos.size(); // Para novedades, igual

                productos = productos.stream()
                        .skip((pagina - 1) * tamanio)
                        .limit(tamanio)
                        .toList();

                request.setAttribute("nombreCategoria", "Novedades");

            } else {
                String idCategoriaStr = request.getParameter("id_categoria");
                if (idCategoriaStr == null && ofertaStr == null && novedadesStr == null) {
                    if (!categorias.isEmpty()) {
                        CategoriaProducto primera = categorias.get(0);
                        idCategoriaStr = String.valueOf(primera.getId());
                    }
                }

                if (idCategoriaStr != null) {
                    long idCategoria = Long.parseLong(idCategoriaStr);

                    // Usar método paginado (tendrás que implementarlo en ServicioProducto)
                    productos = sp.findProductosByCategoriaPaginado(idCategoria, pagina, tamanio);
                    totalProductos = sp.contarProductosPorCategoria(idCategoria);

                    CategoriaProducto categoriaSeleccionada = sc.findCategoriaProducto(idCategoria);
                    request.setAttribute("nombreCategoria", categoriaSeleccionada.getNombre());
                } else {
                    productos = List.of();
                }
            }

            // Redondear precios y calcular precios originales
            for (Producto producto : productos) {
                Double precioOriginal = producto.getPrecio();
                if (producto.getOferta() != null && producto.getOferta()) {
                    Double precioConDescuento = precioOriginal * (1 - producto.getDescuento() / 100);
                    producto.setPrecio(Math.round(precioConDescuento * 100.0) / 100.0);
                    preciosOriginales.put(producto.getId(), precioOriginal);
                }
            }

            int totalPaginas = (int) Math.ceil((double) totalProductos / tamanio);

            request.setAttribute("productos", productos);
            request.setAttribute("preciosOriginales", preciosOriginales);
            request.setAttribute("paginaActual", pagina);
            request.setAttribute("totalPaginas", totalPaginas);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de categoría no válido.");
        }

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }
}
