/*
 * ControladorListarPedido
 */
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
import modelo.entidades.EstadoPedidoEnum;
import modelo.entidades.Pedido;
import modelo.entidades.PedidoProducto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioPedido;
import modelo.servicio.ServicioUsuario;

@WebServlet(name = "ControladorListarPedidos", urlPatterns = {"/Controladores.Admin/ControladorListarPedidos"})
public class ControladorListarPedidos extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioPedido servicioPedido = new ServicioPedido(emf);
    private ServicioUsuario servicioUsuario = new ServicioUsuario(emf);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String vista = "/admin/listarPedidos.jsp"; // Página por defecto para listar pedidos
        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            Pedido pedido = servicioPedido.findPedido(idPedido);

            if (pedido != null) {
                // Obtener los productos asociados a este pedido
                List<PedidoProducto> productosPedidos = servicioPedido.findProductosPorPedido(idPedido); // Aquí debes tener un método que devuelva los productos del pedido
                request.setAttribute("pedido", pedido);
                request.setAttribute("productos", productosPedidos); // Pasar los productos a la vista
                vista = "/admin/verPedidos.jsp"; // Redirigir a la vista de detalle del pedido
            }
        }

        // Listar todos los pedidos
        List<Pedido> pedidos = servicioPedido.findPedidoEntities();
        for (Pedido pedido : pedidos) {
            Usuario usuario = pedido.getUsuario();
            if (usuario != null) {
                pedido.setUsuario(usuario);
            }
        }

        request.setAttribute("pedidos", pedidos);
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("eliminar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            try {
                servicioPedido.destroy(idPedido);
                response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorListarPedidos");
                return;
            } catch (Exception e) {
                request.setAttribute("error", "Error al eliminar el pedido.");
            }
        } else if ("editar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            Pedido pedido = servicioPedido.findPedido(idPedido);

            if (pedido != null) {
                // Obtener el nuevo estado
                String estado = request.getParameter("estado");
                if (estado != null && !estado.trim().isEmpty()) {
                    try {
                        pedido.setEstado(EstadoPedidoEnum.valueOf(estado.toUpperCase())); // Asegúrate de que el estado sea válido
                    } catch (IllegalArgumentException e) {
                        request.setAttribute("error", "Estado no válido.");
                    }
                }

                // Actualizar el precio si se proporciona
                String precioStr = request.getParameter("precio");
                if (precioStr != null && !precioStr.trim().isEmpty()) {
                    try {
                        double precio = Double.parseDouble(precioStr);
                        pedido.setPrecio(precio);
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "El precio no es válido.");
                    }
                }

                // Intentar guardar el pedido actualizado
                try {
                    servicioPedido.edit(pedido); // Aquí se guardan los cambios en la base de datos

                    // Redirigir de nuevo a la página de la que provenía el usuario
                    String referer = request.getHeader("Referer");
                    response.sendRedirect(referer != null ? referer : request.getContextPath() + "/Controladores.Admin/ControladorActualizarEstado");
                    return;
                } catch (Exception e) {
                    request.setAttribute("error", "Error al editar el pedido.");
                }
            }
        }

        // Si no se realiza ninguna acción válida, redirige a la lista de pedidos
        doGet(request, response);
    }
}
