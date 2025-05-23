/*
 * ServicioPedidoProducto
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
import javax.persistence.EntityNotFoundException;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modelo.entidades.PedidoProducto;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioPedidoProducto implements Serializable {

    private EntityManagerFactory emf = null;

    public ServicioPedidoProducto(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(PedidoProducto pedidoProducto) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(pedidoProducto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(PedidoProducto pedidoProducto) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            pedidoProducto = em.merge(pedidoProducto);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Long id = pedidoProducto.getId();
                if (findPedidoProducto(id) == null) {
                    throw new NonexistentEntityException("The pedidoProducto with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(Long id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            PedidoProducto pedidoProducto;
            try {
                pedidoProducto = em.getReference(PedidoProducto.class, id);
                pedidoProducto.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The pedidoProducto with id " + id + " no longer exists.", enfe);
            }
            em.remove(pedidoProducto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<PedidoProducto> findPedidoProductoEntities() {
        return findPedidoProductoEntities(true, -1, -1);
    }

    public List<PedidoProducto> findPedidoProductoEntities(int maxResults, int firstResult) {
        return findPedidoProductoEntities(false, maxResults, firstResult);
    }

    private List<PedidoProducto> findPedidoProductoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(PedidoProducto.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public PedidoProducto findPedidoProducto(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(PedidoProducto.class, id);
        } finally {
            em.close();
        }
    }

    public int getPedidoProductoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<PedidoProducto> rt = cq.from(PedidoProducto.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}

