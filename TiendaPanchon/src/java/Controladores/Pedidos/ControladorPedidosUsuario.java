package Controladores.Pedidos;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.entidades.*;
import modelo.servicio.ServicioPedido;
import modelo.servicio.ServicioProducto;

@WebServlet(name = "ControladorPedidosUsuario", urlPatterns = {"/Controladores.Pedidos/ControladorPedidosUsuario"})
public class ControladorPedidosUsuario extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioPedido servicioPedido = new ServicioPedido(emf);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
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

       
        int pagina = 1;
        int tamanio = 8;

        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        
        List<Pedido> pedidosUsuario = servicioPedido.findPedidosPorUsuarioOrdenadosDesc(usuario.getId(), pagina, tamanio);

        
        long total = servicioPedido.contarPedidosPorUsuario(usuario.getId());
        int totalPaginas = (int) Math.ceil((double) total / tamanio);

        
        request.setAttribute("pedidos", pedidosUsuario);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("eliminar".equals(accion)) {
            Long idPedido = Long.parseLong(request.getParameter("idPedido"));
            ServicioProducto servicioProducto = new ServicioProducto(emf);
            boolean exito = servicioPedido.cancelarPedidoConRestauracionStock(idPedido, servicioProducto);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Pedido cancelado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No puedes cancelar un pedido que ya está tramitado");
            }

            response.sendRedirect(request.getContextPath() + "/Controladores.Pedidos/ControladorPedidosUsuario");
            return;
        }

        if ("tramitar".equals(accion)) {
            List<Map<String, String>> carrito = (List<Map<String, String>>) request.getSession().getAttribute("carrito");

            if (carrito == null || carrito.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/carrito/carrito.jsp");
                return;
            }

            StringBuilder mensajeErrorStock = new StringBuilder();
            boolean stockSuficiente = true;
            ServicioProducto servicioProducto = new ServicioProducto(emf);

            for (Map<String, String> item : carrito) {
                Long idProducto = Long.parseLong(item.get("idProducto"));
                int cantidad = Integer.parseInt(item.get("cantidad"));

                Producto producto = servicioProducto.findProducto(idProducto);
                if (producto.getStock() < cantidad) {
                    stockSuficiente = false;
                    mensajeErrorStock.append("<li>'")
                            .append(producto.getNombre())
                            .append("' Stock disponible: ")
                            .append(producto.getStock())
                            .append(", cantidad solicitada: ")
                            .append(cantidad)
                            .append(".</li>");

                }
            }

            if (!stockSuficiente) {
                request.getSession().setAttribute("mensajeError",
                        "No se puede tramitar el pedido debido a la falta de stock de los siguientes productos: " + mensajeErrorStock);
                response.sendRedirect(request.getContextPath() + "/carrito/carrito.jsp");
                return;
            }

            
            Pedido pedido = new Pedido();
            pedido.setUsuario(usuario);
            pedido.setFechaPedido(LocalDate.now());
            pedido.setEstado(EstadoPedidoEnum.proceso);

            double totalPedido = 0.0;
            List<PedidoProducto> productosPedido = new ArrayList<>();

            for (Map<String, String> item : carrito) {
                Long idProducto = Long.parseLong(item.get("idProducto"));
                int cantidad = Integer.parseInt(item.get("cantidad"));
                double total = Double.parseDouble(item.get("totalPrecio"));
                totalPedido += total;

                Producto producto = servicioProducto.findProducto(idProducto);
                producto.setStock(Math.max(0, producto.getStock() - cantidad));
                try {
                    servicioProducto.edit(producto);
                } catch (Exception ex) {
                    Logger.getLogger(ControladorPedidosUsuario.class.getName()).log(Level.SEVERE, null, ex);
                }

                PedidoProducto pp = new PedidoProducto();
                pp.setProducto(producto);
                pp.setCantidad(cantidad);
                pp.setPedido(pedido);
                productosPedido.add(pp);
            }

            pedido.setProductos(productosPedido);
            pedido.setPrecio(totalPedido);
            servicioPedido.create(pedido);

            request.getSession().removeAttribute("carrito");
            request.getSession().setAttribute("mensajeExito", "Pedido realizado correctamente.");
            response.sendRedirect(request.getContextPath() + "/Controladores.Pedidos/ControladorPedidosUsuario");
            return;
        }

        doGet(request, response);
    }
}
