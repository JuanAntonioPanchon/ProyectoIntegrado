/*
 * ServicioPedido
 */
package modelo.servicio;

/**
 *
 * @author juan-antonio
 */
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modelo.entidades.EstadoPedidoEnum;
import modelo.entidades.Pedido;
import modelo.entidades.PedidoProducto;
import modelo.entidades.Producto;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioPedido implements Serializable {

    private final EntityManagerFactory emf;

    public ServicioPedido(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Pedido pedido) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            // Asocia productos al pedido
            for (PedidoProducto pedidoProducto : pedido.getProductos()) {
                pedidoProducto.setPedido(pedido);
                em.persist(pedidoProducto);
            }

            em.persist(pedido);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void edit(Pedido pedido) throws NonexistentEntityException, Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            pedido = em.merge(pedido);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findPedido(pedido.getId()) == null) {
                throw new NonexistentEntityException("El pedido con ID " + pedido.getId() + " no existe.");
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    public void destroy(Long id) throws NonexistentEntityException {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Pedido pedido = em.find(Pedido.class, id);
            if (pedido == null) {
                throw new NonexistentEntityException("El pedido con ID " + id + " no existe.");
            }
            em.remove(pedido);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Pedido findPedido(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Pedido.class, id);
        } finally {
            em.close();
        }
    }

    public List<Pedido> findPedidoEntities() {
        return findPedidoEntities(true, -1, -1);
    }

    public List<Pedido> findPedidoEntities(int maxResults, int firstResult) {
        return findPedidoEntities(false, maxResults, firstResult);
    }

    private List<Pedido> findPedidoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Pedido> cq = em.getCriteriaBuilder().createQuery(Pedido.class);
            cq.select(cq.from(Pedido.class));
            TypedQuery<Pedido> q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Pedido> findPedidosPorUsuario(Long idUsuario) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT p FROM Pedido p WHERE p.usuario.id = :id ORDER BY p.fechaPedido DESC";
            return em.createQuery(jpql, Pedido.class)
                    .setParameter("id", idUsuario)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<PedidoProducto> findProductosPorPedido(Long idPedido) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT pp FROM PedidoProducto pp WHERE pp.pedido.id = :idPedido";
            return em.createQuery(jpql, PedidoProducto.class)
                    .setParameter("idPedido", idPedido)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public int getPedidoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<Pedido> rt = cq.from(Pedido.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            return em.createQuery(cq).getSingleResult().intValue();
        } finally {
            em.close();
        }
    }

    public boolean cancelarPedidoConRestauracionStock(Long idPedido, ServicioProducto servicioProducto) {
        EntityManager em = getEntityManager();
        try {
            Pedido pedido = em.find(Pedido.class, idPedido);
            if (pedido == null || pedido.getEstado() != EstadoPedidoEnum.proceso) {
                return false;
            }

            em.getTransaction().begin();

            // Restaurar stock de productos
            List<PedidoProducto> productosPedido = findProductosPorPedido(idPedido);
            for (PedidoProducto pp : productosPedido) {
                Producto producto = pp.getProducto();
                int nuevaCantidad = producto.getStock() + pp.getCantidad();
                producto.setStock(nuevaCantidad);
                servicioProducto.edit(producto); // Usa merge dentro del método edit()
            }

            // Eliminar el pedido
            pedido = em.merge(pedido); // Asegurar que está gestionado
            em.remove(pedido);

            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

}
