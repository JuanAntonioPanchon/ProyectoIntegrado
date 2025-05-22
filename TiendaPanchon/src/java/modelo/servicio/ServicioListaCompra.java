/*
 * ServicioListaCompra
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
import modelo.entidades.ListaCompra;
import modelo.entidades.Producto;
import modelo.entidades.Usuario;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioListaCompra implements Serializable {

    private EntityManagerFactory emf = null;

    public ServicioListaCompra(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(ListaCompra listaCompra) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(listaCompra);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(ListaCompra listaCompra) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            listaCompra = em.merge(listaCompra);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Long id = listaCompra.getId();
                if (findListaCompra(id) == null) {
                    throw new NonexistentEntityException("The listaCompra with id " + id + " no longer exists.");
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
            ListaCompra listaCompra;
            try {
                listaCompra = em.getReference(ListaCompra.class, id);
                listaCompra.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The listaCompra with id " + id + " no longer exists.", enfe);
            }
            em.remove(listaCompra);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<ListaCompra> findListaCompraEntities() {
        return findListaCompraEntities(true, -1, -1);
    }

    public List<ListaCompra> findListaCompraEntities(int maxResults, int firstResult) {
        return findListaCompraEntities(false, maxResults, firstResult);
    }

    private List<ListaCompra> findListaCompraEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(ListaCompra.class));
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

    public ListaCompra findListaCompra(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(ListaCompra.class, id);
        } finally {
            em.close();
        }
    }

    public int getListaCompraCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<ListaCompra> rt = cq.from(ListaCompra.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public List<Producto> obtenerListaPorUsuario(Long idUsuario) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Producto p "
                    + "JOIN p.listasCompra lc "
                    + "WHERE lc.usuario.id = :idUsuario", Producto.class)
                    .setParameter("idUsuario", idUsuario)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void eliminarProductoDeLista(Long idUsuario, Long idProducto) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            
            ListaCompra lista = em.createQuery(
                    "SELECT l FROM ListaCompra l WHERE l.usuario.id = :idUsuario", ListaCompra.class)
                    .setParameter("idUsuario", idUsuario)
                    .getSingleResult();

            
            Producto producto = em.find(Producto.class, idProducto);

            
            if (lista != null && producto != null) {
                lista.getProductos().remove(producto);
                em.merge(lista);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void vaciarListaCompra(Long idUsuario) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Query query = em.createQuery("DELETE FROM ListaCompra l WHERE l.usuario.id = :idUsuario")
                    .setParameter("idUsuario", idUsuario);
            query.executeUpdate();
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void agregarProductoALista(Long idUsuario, Long idProducto) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            Usuario usuario = em.find(Usuario.class, idUsuario);
            Producto producto = em.find(Producto.class, idProducto);

            if (usuario != null && producto != null) {
                ListaCompra listaCompra = em.createQuery(
                        "SELECT l FROM ListaCompra l WHERE l.usuario.id = :idUsuario", ListaCompra.class)
                        .setParameter("idUsuario", idUsuario)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (listaCompra == null) {
                    listaCompra = new ListaCompra();
                    listaCompra.setUsuario(usuario);
                    listaCompra.getProductos().add(producto);
                    em.persist(listaCompra);

                } else {
                    listaCompra = em.merge(listaCompra);
                    if (!listaCompra.getProductos().contains(producto)) {
                        listaCompra.getProductos().add(producto);

                    } else {

                    }
                }

            } else {

            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
    }

    public boolean productoYaEnLista(Long idUsuario, Long idProducto) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(p) FROM ListaCompra l JOIN l.productos p WHERE l.usuario.id = :idUsuario AND p.id = :idProducto",
                    Long.class)
                    .setParameter("idUsuario", idUsuario)
                    .setParameter("idProducto", idProducto)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    public String obtenerNombreProducto(Long idProducto) {
        EntityManager em = getEntityManager();
        try {
            Producto producto = em.find(Producto.class, idProducto);
            return (producto != null) ? producto.getNombre() : "desconocido";
        } finally {
            em.close();
        }
    }

    public List<Producto> obtenerListaPorUsuarioPaginado(Long idUsuario, int pagina, int tamanio) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM Producto p "
                    + "JOIN p.listasCompra lc "
                    + "WHERE lc.usuario.id = :idUsuario", Producto.class)
                    .setParameter("idUsuario", idUsuario)
                    .setFirstResult((pagina - 1) * tamanio)
                    .setMaxResults(tamanio)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long contarProductosPorUsuario(Long idUsuario) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(p) FROM Producto p "
                    + "JOIN p.listasCompra lc "
                    + "WHERE lc.usuario.id = :idUsuario", Long.class)
                    .setParameter("idUsuario", idUsuario)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
