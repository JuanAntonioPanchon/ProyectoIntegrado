/*
 * ControladorPedidosUsuario
 */
package Controladores.Pedidos;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.Pedido;
import modelo.entidades.PedidoProducto;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioPedido;

/**
 *
 * @author juan-antonio
 */

@WebServlet(name = "ControladorPedidosUsuario", urlPatterns = {"/Controladores.Pedidos/ControladorPedidosUsuario"})
public class ControladorPedidosUsuario extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioPedido servicioPedido = new ServicioPedido(emf);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String vista = "/pedido/listarPedidos.jsp";
        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            Pedido pedido = servicioPedido.findPedido(idPedido);

            if (pedido != null && pedido.getUsuario().getId().equals(usuario.getId())) {
                List<PedidoProducto> productosPedidos = servicioPedido.findProductosPorPedido(idPedido);
                request.setAttribute("pedido", pedido);
                request.setAttribute("productos", productosPedidos);
                vista = "/pedido/verPedido.jsp";
            }
        }

        List<Pedido> pedidosUsuario = servicioPedido.findPedidosPorUsuario(usuario.getId());

        pedidosUsuario.sort(Comparator.comparing(Pedido::getFechaPedido).reversed());

        request.setAttribute("pedidos", pedidosUsuario);
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("eliminar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            Pedido pedido = servicioPedido.findPedido(idPedido);
            if (pedido != null && pedido.getUsuario().getId().equals(usuario.getId())) {
                try {
                    servicioPedido.destroy(idPedido);
                    response.sendRedirect(request.getContextPath() + "/Controladores.Pedidos/ControladorPedidosUsuario");
                    return;
                } catch (Exception e) {
                    request.setAttribute("error", "Error al eliminar el pedido.");
                }
            }
        }

        doGet(request, response);
    }
}
