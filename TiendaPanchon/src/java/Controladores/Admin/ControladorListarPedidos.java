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

        request.setCharacterEncoding("UTF-8");
        String vista = "/admin/listarPedidos.jsp";
        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            Pedido pedido = servicioPedido.findPedido(idPedido);

            if (pedido != null) {
                List<PedidoProducto> productosPedidos = servicioPedido.findProductosPorPedido(idPedido);
                request.setAttribute("pedido", pedido);
                request.setAttribute("productos", productosPedidos);
                vista = "/admin/verPedidos.jsp";
            }
        }

        
        int pagina = 1;
        int tamanio = 8;

        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        
        List<Pedido> pedidos = servicioPedido.findPedidoEntities(tamanio, (pagina - 1) * tamanio);

        
        int total = servicioPedido.getPedidoCount();
        int totalPaginas = (int) Math.ceil((double) total / tamanio);

        request.setAttribute("pedidos", pedidos);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
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

                String estado = request.getParameter("estado");
                if (estado != null && !estado.trim().isEmpty()) {
                    try {
                        pedido.setEstado(EstadoPedidoEnum.valueOf(estado.toUpperCase()));
                    } catch (IllegalArgumentException e) {
                        request.setAttribute("error", "Estado no válido.");
                    }
                }

                String precioStr = request.getParameter("precio");
                if (precioStr != null && !precioStr.trim().isEmpty()) {
                    try {
                        double precio = Double.parseDouble(precioStr);
                        pedido.setPrecio(precio);
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "El precio no es válido.");
                    }
                }

                try {
                    servicioPedido.edit(pedido);

                    String referer = request.getHeader("Referer");
                    response.sendRedirect(referer != null ? referer : request.getContextPath() + "/Controladores.Admin/ControladorActualizarEstado");
                    return;
                } catch (Exception e) {
                    request.setAttribute("error", "Error al editar el pedido.");
                }
            }
        }

        doGet(request, response);
    }
}
