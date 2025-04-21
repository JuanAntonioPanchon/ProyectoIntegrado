/*
 * ControladorCarrito
 */
package Controladores.Carrito;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorCarrito", urlPatterns = {"/Controladores.Carrito/ControladorCarrito"})
public class ControladorCarrito extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener los parámetros enviados en la URL
        String idProducto = request.getParameter("idProducto");
        String cantidad = request.getParameter("cantidad");
        String totalPrecio = request.getParameter("totalPrecio");

        System.out.println("idProducto: " + idProducto + ", cantidad: " + cantidad + ", totalPrecio: " + totalPrecio);

        // Verificar si los parámetros están vacíos
        if (idProducto == null || cantidad == null || totalPrecio == null || idProducto.isEmpty() || cantidad.isEmpty() || totalPrecio.isEmpty()) {
            System.out.println("Error: Los parámetros no están correctamente definidos.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);  // Devolver error
            return;
        }

        // Obtener la sesión
        HttpSession session = request.getSession();

        // Obtener el carrito de la sesión (si no existe, crear uno nuevo)
        List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        // Crear un nuevo producto y añadirlo al carrito
        Map<String, String> producto = new HashMap<>();
        producto.put("idProducto", idProducto);
        producto.put("cantidad", cantidad);
        producto.put("totalPrecio", totalPrecio);

        carrito.add(producto); // Añadir el producto al carrito

        // Depuración: Mostrar el contenido del carrito
        System.out.println("Carrito actualizado: " + carrito);

        // Redirigir al carrito o devolver un mensaje de éxito
        response.sendRedirect("/TiendaPanchon/Controladores.Carrito/ControladorCarrito");  // Esto recarga la página con el carrito actualizado
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idProducto = request.getParameter("idProducto");
        String cantidad = request.getParameter("cantidad");
        String totalPrecio = request.getParameter("totalPrecio");

        System.out.println("idProducto: " + idProducto + ", cantidad: " + cantidad + ", totalPrecio: " + totalPrecio);

// Verificar si los parámetros están vacíos
        if (idProducto == null || cantidad == null || totalPrecio == null || idProducto.isEmpty() || cantidad.isEmpty() || totalPrecio.isEmpty()) {
            System.out.println("Error: Los parámetros no están correctamente definidos.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);  // Devolver error
            return;
        }

        // Obtener la sesión
        HttpSession session = request.getSession();

        // Obtener el carrito de la sesión (si no existe, crear uno nuevo)
        List<Map<String, String>> carrito = (List<Map<String, String>>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        // Crear un nuevo producto y añadirlo al carrito
        Map<String, String> producto = new HashMap<>();
        producto.put("idProducto", idProducto);
        producto.put("cantidad", cantidad);
        producto.put("totalPrecio", totalPrecio);

        carrito.add(producto); // Añadir el producto al carrito

        // Depuración: Mostrar el contenido del carrito
        System.out.println("Carrito actualizado: " + carrito);

        // Responder al cliente con un mensaje de éxito
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\", \"message\":\"Producto añadido al carrito\"}");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar el carrito de compras";
    }
}
