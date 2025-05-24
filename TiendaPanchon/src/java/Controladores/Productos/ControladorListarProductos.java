package Controladores.Productos;

import java.io.IOException;
import java.util.ArrayList;
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
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorListarProductos", urlPatterns = {"/Controladores.Productos/ControladorListarProductos"})
public class ControladorListarProductos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sp = new ServicioProducto(emf);
        ServicioCategoriaProducto sc = new ServicioCategoriaProducto(emf);
        String vista = "/usuarios/inicio.jsp";

        try {
          
            List<CategoriaProducto> todasCategorias = sc.findCategoriaProductoEntities();

            // Filtrar categorías que tienen productos con stock > 0
            List<CategoriaProducto> categoriasConProductos = new ArrayList<>();
            for (CategoriaProducto categoria : todasCategorias) {
                long countProductos = sp.contarProductosPorCategoriaConStock(categoria.getId());
                if (countProductos > 0) {
                    categoriasConProductos.add(categoria);
                }
            }

            // Pasar solo categorías con productos al JSP
            request.setAttribute("categorias", categoriasConProductos);

            String ofertaStr = request.getParameter("oferta");
            String novedadesStr = request.getParameter("novedades");
            Map<Long, Double> preciosOriginales = new HashMap<>();

            int pagina = 1;
            int tamanio = 6;

           
            String paginaStr = request.getParameter("pagina");
            if (paginaStr != null) {
                try {
                    pagina = Integer.parseInt(paginaStr);
                    if (pagina < 1) {
                        pagina = 1;
                    }
                } catch (NumberFormatException e) {
                    pagina = 1;
                }
            }

            List<Producto> productos;
            long totalProductos = 0;

            String idCategoriaStr = request.getParameter("id_categoria");
            Long idCategoriaLong = null;
            boolean redireccionar = false;

            
            if (idCategoriaStr != null) {
                try {
                    idCategoriaLong = Long.parseLong(idCategoriaStr);
                } catch (NumberFormatException e) {
                    idCategoriaLong = null;
                }
            }

            // Si no hay filtros y:
            // - id_categoria es null o no tiene productos con stock, redirigir a la primera con productos
            if (idCategoriaLong == null && ofertaStr == null && novedadesStr == null) {
                if (!categoriasConProductos.isEmpty()) {
                    redireccionar = true;
                    idCategoriaLong = categoriasConProductos.get(0).getId();
                }
            } else if (idCategoriaLong != null) {
                
                boolean categoriaValida = false;
                for (CategoriaProducto c : categoriasConProductos) {
                    if (c.getId().equals(idCategoriaLong)) {
                        categoriaValida = true;
                        break;
                    }
                }

                if (!categoriaValida) {
                    if (!categoriasConProductos.isEmpty()) {
                        redireccionar = true;
                        idCategoriaLong = categoriasConProductos.get(0).getId();
                    } else {
                        
                        idCategoriaLong = null;
                    }
                }
            }

            if (redireccionar) {
                String url = request.getContextPath() + "/Controladores.Productos/ControladorListarProductos?id_categoria=" + idCategoriaLong;
                response.sendRedirect(url);
               
                return;
            }

            if ("true".equals(ofertaStr)) {
                productos = sp.findProductosConOferta();
                productos.removeIf(p -> p.getStock() <= 0);
                totalProductos = productos.size();

                productos = productos.stream()
                        .skip((pagina - 1) * tamanio)
                        .limit(tamanio)
                        .toList();

                request.setAttribute("nombreCategoria", "Ofertas");

            } else if ("true".equals(novedadesStr)) {
                productos = sp.findProductosNovedades();
                productos.removeIf(p -> p.getStock() <= 0);
                totalProductos = productos.size();

                productos = productos.stream()
                        .skip((pagina - 1) * tamanio)
                        .limit(tamanio)
                        .toList();

                request.setAttribute("nombreCategoria", "Novedades");

            } else {
                if (idCategoriaLong != null) {
                    productos = sp.findProductosByCategoriaPaginado(idCategoriaLong, pagina, tamanio);
                    totalProductos = sp.contarProductosPorCategoria(idCategoriaLong);

                    CategoriaProducto categoriaSeleccionada = sc.findCategoriaProducto(idCategoriaLong);
                    request.setAttribute("nombreCategoria", categoriaSeleccionada.getNombre());
                } else {
                    productos = List.of();
                }
            }

            // Ajustar precios con descuento y guardar precios originales
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
        } finally {
            emf.close();
        }

        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }
}
