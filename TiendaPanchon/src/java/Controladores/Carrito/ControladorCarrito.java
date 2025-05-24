package Controladores.Carrito;

import java.io.IOException;
import java.util.*;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.Producto;
import modelo.entidades.CategoriaProducto;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorCarrito", urlPatterns = {"/Controladores.Carrito/ControladorCarrito"})
public class ControladorCarrito extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String idProducto = request.getParameter("idProducto");
        String cantidadStr = request.getParameter("cantidad");
        String totalPrecioStr = request.getParameter("totalPrecio");

        System.out.println("[GET] idProducto=" + idProducto + ", cantidad=" + cantidadStr + ", totalPrecio=" + totalPrecioStr);

        if (idProducto == null && cantidadStr == null && totalPrecioStr == null) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                System.out.println("[GET] Usuario no autenticado. Redirigiendo a login.");
                response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
                return;
            }

            List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");
            request.setAttribute("carrito", carrito);
            request.getRequestDispatcher("/carrito/carrito.jsp").forward(request, response);
            return;
        }

        if (idProducto.isEmpty() || cantidadStr.isEmpty() || totalPrecioStr.isEmpty()) {
            System.out.println("[GET] Parámetros incompletos");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean exito = agregarOActualizarProductoEnCarrito(request, idProducto, cantidadStr, totalPrecioStr);
        if (!exito) {
            System.out.println("[GET] Usuario no autenticado en intento de agregar al carrito.");
            response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/Controladores.Carrito/ControladorCarrito");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            System.out.println("[POST] Usuario no autenticado");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("No autorizado");
            return;
        }

        System.out.println("[POST] Acción recibida: " + accion);

        if ("vaciar".equals(accion)) {
            session.removeAttribute("carrito");
            System.out.println("[POST] Carrito vaciado");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if ("eliminar".equals(accion)) {
            String idProducto = request.getParameter("idProducto");
            List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");
            if (carrito != null && idProducto != null) {
                carrito.removeIf(p -> p.get("idProducto").equals(idProducto));
                System.out.println("[POST] Producto eliminado del carrito: " + idProducto);
            }
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if ("modificar".equals(accion)) {
            String idProducto = request.getParameter("idProducto");
            String deltaStr = request.getParameter("delta");

            if (idProducto == null || deltaStr == null || idProducto.isEmpty() || deltaStr.isEmpty()) {
                System.out.println("[POST] Parámetros inválidos para modificar");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int delta;
            try {
                delta = Integer.parseInt(deltaStr);
            } catch (NumberFormatException e) {
                System.out.println("[POST] Delta no es número válido: " + deltaStr);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");

            if (carrito != null) {
                for (Iterator<Map<String, String>> it = carrito.iterator(); it.hasNext();) {
                    Map<String, String> item = it.next();
                    if (item.get("idProducto").equals(idProducto)) {
                        int cantidad = Integer.parseInt(item.get("cantidad")) + delta;
                        if (cantidad <= 0) {
                            it.remove();
                            System.out.println("[POST] Producto eliminado por cantidad <= 0: " + idProducto);
                        } else {
                            double precio = Double.parseDouble(item.get("totalPrecio")) / Integer.parseInt(item.get("cantidad"));
                            item.put("cantidad", String.valueOf(cantidad));
                            item.put("totalPrecio", String.format("%.2f", cantidad * precio).replace(",", "."));
                            System.out.println("[POST] Producto modificado: " + idProducto + ", nueva cantidad=" + cantidad);
                        }
                        break;
                    }
                }
            }

            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // Añadir producto
        String idProducto = request.getParameter("idProducto");
        String cantidadStr = request.getParameter("cantidad");
        String totalPrecioStr = request.getParameter("totalPrecio");

        if (idProducto == null || cantidadStr == null || totalPrecioStr == null
                || idProducto.isEmpty() || cantidadStr.isEmpty() || totalPrecioStr.isEmpty()) {
            System.out.println("[POST] Parámetros incompletos para añadir producto");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean exito = agregarOActualizarProductoEnCarrito(request, idProducto, cantidadStr, totalPrecioStr);
        if (!exito) {
            System.out.println("[POST] Fallo al agregar producto. Usuario no autenticado.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("No autorizado");
            return;
        }

        System.out.println("[POST] Producto añadido correctamente al carrito: " + idProducto);
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\", \"message\":\"Producto actualizado en el carrito\"}");
    }

    private boolean agregarOActualizarProductoEnCarrito(HttpServletRequest request, String idProducto, String cantidadStr, String totalPrecioStr) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            System.out.println("[AGREGAR] Usuario no autenticado");
            return false;
        }

        List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioProducto sp = new ServicioProducto(emf);
        Producto prod = sp.findProducto(Long.parseLong(idProducto));
        CategoriaProducto cat = prod.getCategoria();

        int cantidadNueva = Integer.parseInt(cantidadStr);
        double precioUnidad = prod.getPrecio();

        boolean encontrado = false;
        for (Map<String, String> item : carrito) {
            if (item.get("idProducto").equals(idProducto)) {
                int cantidadActual = Integer.parseInt(item.get("cantidad"));
                int nuevaCantidad = cantidadActual + cantidadNueva;
                item.put("cantidad", String.valueOf(nuevaCantidad));
                item.put("totalPrecio", String.format("%.2f", nuevaCantidad * precioUnidad).replace(",", "."));
                System.out.println("[AGREGAR] Actualizando cantidad de producto existente: " + idProducto);
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            Map<String, String> producto = new HashMap<>();
            producto.put("idProducto", idProducto);
            producto.put("nombre", prod.getNombre());
            producto.put("categoria", cat.getNombre());
            producto.put("cantidad", cantidadStr);
            producto.put("totalPrecio", totalPrecioStr);
            carrito.add(producto);
            System.out.println("[AGREGAR] Producto nuevo añadido al carrito: " + idProducto);
        }

        emf.close();
        return true;
    }
}