
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Date;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.CategoriaProducto;
import modelo.entidades.EstadoPedidoEnum;
import modelo.entidades.ListaCompra;
import modelo.entidades.Pedido;
import modelo.entidades.PedidoProducto;
import modelo.entidades.Producto;
import modelo.entidades.Receta;
import modelo.entidades.RolEnum;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioCategoriaProducto;
import modelo.servicio.ServicioListaCompra;
import modelo.servicio.ServicioPedido;
import modelo.servicio.ServicioPedidoProducto;
import modelo.servicio.ServicioProducto;
import modelo.servicio.ServicioReceta;
import modelo.servicio.ServicioUsuario;

@WebServlet(name = "CrearDatos", urlPatterns = {"/CrearDatos"})
public class CrearDatos extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");

        ServicioUsuario su = new ServicioUsuario(emf);
        ServicioProducto spr = new ServicioProducto(emf);
        ServicioCategoriaProducto scp = new ServicioCategoriaProducto(emf);
        ServicioPedido sp = new ServicioPedido(emf);
        ServicioPedidoProducto spp = new ServicioPedidoProducto(emf);
        ServicioReceta sr = new ServicioReceta(emf);
        ServicioListaCompra slc = new ServicioListaCompra(emf);

        //USUARIO
        Usuario usuario1 = new Usuario();
        usuario1.setEmail("panchon@gmail.com");
        usuario1.setPassword("1234");
        usuario1.setNombre("Juan Antonio");
        usuario1.setApellidos("Panchon");
        usuario1.setRol(RolEnum.admin);
        su.create(usuario1);

        //RECETA
        Receta receta1 = new Receta();
        receta1.setTitulo("Tarta de Chocolate");
        receta1.setDescripcion("Deliciosa tarta con mucho chocolate.");
        receta1.setPublicada(true);
        receta1.setUsuario(usuario1);
        receta1.setIngredientes("100gr de Queso, 100gr de galletas, 1 litro de leche. Mezclamos todo en un bol y dejamos reposar");
        sr.create(receta1);

        //CATEGORIA PRODUCTO
        CategoriaProducto categoria1 = new CategoriaProducto();
        categoria1.setNombre("Postres");
        scp.create(categoria1);

        // PRODUCTO
        Producto producto1 = new Producto();
        producto1.setNombre("Tarta de Manzana");
        producto1.setDescripcion("Deliciosa tarta casera de manzana.");
        producto1.setPrecio(15.99);
        producto1.setStock(50);
        producto1.setNovedad(true);
        producto1.setFechaProducto(LocalDate.now());
        producto1.setOferta(true);
        producto1.setDescuento(10.0);
        producto1.setCategoria(categoria1);

        spr.create(producto1);

        //PEDIDO
        Pedido pedido1 = new Pedido();
        pedido1.setUsuario(usuario1);
        pedido1.setFechaPedido(LocalDate.now());
        pedido1.setEstado(EstadoPedidoEnum.proceso);
        pedido1.setPrecio(34.98);
        sp.create(pedido1);

        //PEDIDOPRODUCTO
        PedidoProducto pedidoProducto1 = new PedidoProducto();
        pedidoProducto1.setPedido(pedido1);
        pedidoProducto1.setProducto(producto1);
        pedidoProducto1.setCantidad(2);
        spp.create(pedidoProducto1);

        //LISTA COMPRA
        ListaCompra listaCompra1 = new ListaCompra();
        listaCompra1.setUsuario(usuario1);
        listaCompra1.setProductos(Arrays.asList(producto1));
        slc.create(listaCompra1);

        emf.close();

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CrearDatos</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Se han creado los datos de prueba con productos en el pedido</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
/*
-- Receta.usuario → Usuario
ALTER TABLE RECETA DROP FOREIGN KEY FK_RECETA_id_usuario;
ALTER TABLE RECETA ADD CONSTRAINT FK_RECETA_id_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(ID) ON DELETE CASCADE;

-- Pedido.usuario → Usuario
ALTER TABLE PEDIDO DROP FOREIGN KEY FK_PEDIDO_id_usuario;
ALTER TABLE PEDIDO ADD CONSTRAINT FK_PEDIDO_id_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(ID) ON DELETE CASCADE;

-- PedidoProducto.pedido → Pedido
ALTER TABLE PEDIDOPRODUCTO DROP FOREIGN KEY FK_PEDIDOPRODUCTO_id_pedido;
ALTER TABLE PEDIDOPRODUCTO ADD CONSTRAINT FK_PEDIDOPRODUCTO_id_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(ID) ON DELETE CASCADE;

-- PedidoProducto.producto → Producto
ALTER TABLE PEDIDOPRODUCTO DROP FOREIGN KEY FK_PEDIDOPRODUCTO_id_producto;
ALTER TABLE PEDIDOPRODUCTO ADD CONSTRAINT FK_PEDIDOPRODUCTO_id_producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(ID) ON DELETE CASCADE;

-- Producto.categoria → CategoriaProducto
ALTER TABLE PRODUCTO DROP FOREIGN KEY FK_PRODUCTO_id_categoria;
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_id_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIAPRODUCTO(ID) ON DELETE CASCADE;

-- ListaCompra.usuario → Usuario
ALTER TABLE LISTACOMPRA DROP FOREIGN KEY FK_LISTACOMPRA_id_usuario;
ALTER TABLE LISTACOMPRA ADD CONSTRAINT FK_LISTACOMPRA_id_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(ID) ON DELETE CASCADE;

-- lista_compra_producto.id_lista_compra → ListaCompra
ALTER TABLE lista_compra_producto DROP FOREIGN KEY FK_lista_compra_producto_id_lista_compra;
ALTER TABLE lista_compra_producto ADD CONSTRAINT FK_lista_compra_producto_id_lista_compra FOREIGN KEY (id_lista_compra) REFERENCES LISTACOMPRA(ID) ON DELETE CASCADE;

-- lista_compra_producto.id_producto → Producto
ALTER TABLE lista_compra_producto DROP FOREIGN KEY FK_lista_compra_producto_id_producto;
ALTER TABLE lista_compra_producto ADD CONSTRAINT FK_lista_compra_producto_id_producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(ID) ON DELETE CASCADE;


*/

/* tamaño de ingrediente
ALTER TABLE INGREDIENTES MODIFY INGREDIENTES VARCHAR(400) NOT NULL;
*/