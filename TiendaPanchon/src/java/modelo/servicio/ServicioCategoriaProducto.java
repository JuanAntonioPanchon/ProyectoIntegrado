/*
 * ServicioCategoriaProducto
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
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modelo.entidades.CategoriaProducto;
import modelo.entidades.Producto;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioCategoriaProducto implements Serializable {

    private EntityManagerFactory emf = null;

    public ServicioCategoriaProducto(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(CategoriaProducto categoriaProducto) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(categoriaProducto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(CategoriaProducto categoriaProducto) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            categoriaProducto = em.merge(categoriaProducto);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Long id = categoriaProducto.getId();
                if (findCategoriaProducto(id) == null) {
                    throw new NonexistentEntityException("The categoriaProducto with id " + id + " no longer exists.");
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
            CategoriaProducto categoriaProducto;
            try {
                categoriaProducto = em.getReference(CategoriaProducto.class, id);
                categoriaProducto.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The categoriaProducto with id " + id + " no longer exists.", enfe);
            }
            em.remove(categoriaProducto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<CategoriaProducto> findCategoriaProductoEntities() {
        return findCategoriaProductoEntities(true, -1, -1);
    }

    public List<CategoriaProducto> findCategoriaProductoEntities(int maxResults, int firstResult) {
        return findCategoriaProductoEntities(false, maxResults, firstResult);
    }

    private List<CategoriaProducto> findCategoriaProductoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(CategoriaProducto.class));
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

    public CategoriaProducto findCategoriaProducto(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(CategoriaProducto.class, id);
        } finally {
            em.close();
        }
    }

    public int getCategoriaProductoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<CategoriaProducto> rt = cq.from(CategoriaProducto.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public CategoriaProducto findCategoriaProductoByName(String nombre) {
        EntityManager em = getEntityManager();
        try {
            
            return em.createQuery("SELECT c FROM CategoriaProducto c WHERE c.nombre = :nombre", CategoriaProducto.class)
                    .setParameter("nombre", nombre)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    
    public List<Producto> cargarProductosDeCategoria(Long categoriaId) {
        EntityManager em = emf.createEntityManager();
        try {
            
            String query = "SELECT p FROM Producto p WHERE p.categoria.id = :categoriaId";
            return em.createQuery(query, Producto.class)
                    .setParameter("categoriaId", categoriaId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

}
