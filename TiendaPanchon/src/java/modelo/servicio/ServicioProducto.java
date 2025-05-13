/*
 * ServicioProducto
 */
package modelo.servicio;

/**
 *
 * @author juan-antonio
 */
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modelo.entidades.ListaCompra;
import modelo.entidades.Producto;
import modelo.servicio.exceptions.NonexistentEntityException;

public class ServicioProducto implements Serializable {

    private EntityManagerFactory emf = null;

    public ServicioProducto(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Producto producto) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(producto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Producto producto) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            producto = em.merge(producto);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Long id = producto.getId();
                if (findProducto(id) == null) {
                    throw new NonexistentEntityException("The producto with id " + id + " no longer exists.");
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
            Producto producto;
            try {
                producto = em.getReference(Producto.class, id);
                producto.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The producto with id " + id + " no longer exists.", enfe);
            }
            em.remove(producto);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Producto> findProductoEntities() {
        return findProductoEntities(true, -1, -1);
    }

    public List<Producto> findProductoEntities(int maxResults, int firstResult) {
        return findProductoEntities(false, maxResults, firstResult);
    }

    private List<Producto> findProductoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Producto.class));
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

    public Producto findProducto(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Producto.class, id);
        } finally {
            em.close();
        }
    }

    public int getProductoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Producto> rt = cq.from(Producto.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public List<Producto> findProductosByCategoria(Long idCategoria) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Producto p WHERE p.categoria.id = :idCategoria", Producto.class)
                    .setParameter("idCategoria", idCategoria)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public double redondear(double valor) {
        BigDecimal bd = new BigDecimal(valor);
        bd = bd.setScale(2, RoundingMode.HALF_UP); // Redondear a 2 decimales
        return bd.doubleValue();
    }

    public List<Producto> findProductosConOferta() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Producto p WHERE p.oferta = true", Producto.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Producto> findProductosNovedades() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Producto p WHERE p.novedad = true ORDER BY p.fechaProducto ASC", Producto.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public double calcularPrecioFinal(double precio, double descuento, boolean oferta) {
        if (oferta) {
            return precio - (precio * descuento / 100);
        } else {
            return precio;
        }
    }

    public List<Producto> findProductosConStockBajo() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Producto p WHERE p.stock <= 10", Producto.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> findProductosMasVendidos(LocalDate fechaInicio, LocalDate fechaFin, Long categoriaId) {
        EntityManager em = emf.createEntityManager();
        try {
            // Consulta SQL
            String sql = "SELECT p.nombre, SUM(pp.cantidad) "
                    + "FROM PRODUCTO p "
                    + "JOIN PEDIDOPRODUCTO pp ON pp.id_producto = p.id "
                    + "JOIN PEDIDO pd ON pp.id_pedido = pd.id "
                    + "WHERE pd.FECHAPEDIDO >= ? AND pd.FECHAPEDIDO <= ? "
                    + "AND p.id_categoria = ? "
                    + "GROUP BY p.id "
                    + "ORDER BY SUM(pp.cantidad) DESC";

            // Preparar consulta
            Query query = em.createNativeQuery(sql);
            query.setParameter(1, java.sql.Date.valueOf(fechaInicio));
            query.setParameter(2, java.sql.Date.valueOf(fechaFin));
            query.setParameter(3, categoriaId);

            // Ejecutar consulta
            List<Object[]> productos = query.getResultList();

            return productos;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public void eliminarProductoYLimpiarListas(Long idProducto) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            Producto producto = em.find(Producto.class, idProducto);

            if (producto != null) {
                
                for (ListaCompra lista : producto.getListasCompra()) {
                    lista.getProductos().remove(producto);
                    em.merge(lista);
                }

                producto.getListasCompra().clear();

                
                em.remove(em.merge(producto));
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

}
