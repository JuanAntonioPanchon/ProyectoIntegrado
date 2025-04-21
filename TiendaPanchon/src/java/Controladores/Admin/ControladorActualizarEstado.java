/*
 * ControladorActualizarEstado
 * Cambiara el estado del pedido
 */
package Controladores.Admin;

import java.io.IOException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.EstadoPedidoEnum;
import modelo.entidades.Pedido;
import modelo.servicio.ServicioPedido;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorActualizarEstado", urlPatterns = {"/Controladores.Admin/ControladorActualizarEstado"})
public class ControladorActualizarEstado extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioPedido servicioPedido = new ServicioPedido(emf);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            String nuevoEstado = request.getParameter("estado");

            Pedido pedido = servicioPedido.findPedido(idPedido);
            if (pedido != null && nuevoEstado != null) {
                try {

                    pedido.setEstado(EstadoPedidoEnum.valueOf(nuevoEstado));

                    servicioPedido.edit(pedido);
                } catch (IllegalArgumentException e) {

                    request.setAttribute("error", "El estado proporcionado no es válido.");
                    request.getRequestDispatcher("/admin/listarPedidos.jsp").forward(request, response);
                    return;
                }
            }
            request.getSession().setAttribute("mensajeExito", "El pedido de " + pedido.getUsuario().getNombre() 
                    + " " + pedido.getUsuario().getApellidos() 
                    + " con email " + pedido.getUsuario().getEmail() 
                    + " ha cambiado su estado a " + pedido.getEstado() 
                    + " correctamente.");

            response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorListarPedidos");

        } catch (Exception e) {
            request.setAttribute("error", "Error al actualizar el estado del pedido.");
            request.getRequestDispatcher("/Controladores.Admin/ControladorListarPedidos").forward(request, response);
        }
    }
}
