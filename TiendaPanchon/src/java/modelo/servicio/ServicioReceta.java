/*
 * class ServicioReceta
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
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import modelo.entidades.Receta;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioReceta implements Serializable {

    private EntityManagerFactory emf = null;

    public ServicioReceta(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Receta receta) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(receta);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Receta receta) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            receta = em.merge(receta);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Long id = receta.getId();
                if (findReceta(id) == null) {
                    throw new NonexistentEntityException("The receta with id " + id + " no longer exists.");
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
            Receta receta;
            try {
                receta = em.getReference(Receta.class, id);
                receta.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The receta with id " + id + " no longer exists.", enfe);
            }
            em.remove(receta);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Receta> findRecetaEntities() {
        return findRecetaEntities(true, -1, -1);
    }

    public List<Receta> findRecetaEntities(int maxResults, int firstResult) {
        return findRecetaEntities(false, maxResults, firstResult);
    }

    private List<Receta> findRecetaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Receta.class));
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

    public Receta findReceta(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Receta.class, id);
        } finally {
            em.close();
        }
    }

    public int getRecetaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Receta> rt = cq.from(Receta.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public List<Receta> findRecetasPublicadas() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Receta r WHERE r.publicada = true", Receta.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Receta> findRecetasPorUsuarioPaginado(Long idUsuario, int pagina, int tamanio) {
        EntityManager em = getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Receta> cq = cb.createQuery(Receta.class);
            Root<Receta> root = cq.from(Receta.class);
            cq.select(root);
            cq.where(cb.equal(root.get("usuario").get("id"), idUsuario));
            cq.orderBy(cb.desc(root.get("id")));

            return em.createQuery(cq)
                    .setFirstResult((pagina - 1) * tamanio)
                    .setMaxResults(tamanio)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long contarRecetasPorUsuario(Long idUsuario) {
        EntityManager em = getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Receta> root = cq.from(Receta.class);
            cq.select(cb.count(root));
            cq.where(cb.equal(root.get("usuario").get("id"), idUsuario));
            return em.createQuery(cq).getSingleResult();
        } finally {
            em.close();
        }
    }

    public List<Receta> findRecetasPublicadasPaginado(int pagina, int tamanio) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Receta r WHERE r.publicada = true ORDER BY r.id DESC", Receta.class)
                    .setFirstResult((pagina - 1) * tamanio)
                    .setMaxResults(tamanio)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long contarRecetasPublicadas() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(r) FROM Receta r WHERE r.publicada = true", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

}
