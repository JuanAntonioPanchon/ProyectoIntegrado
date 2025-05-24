/*
 * Entidad Producto
 */
package modelo.entidades;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

/**
 *
 * @author juan-antonio
 */
@Entity
public class Producto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 1000)
    private String descripcion;

    @Column(nullable = false)
    private Double precio;

    @Column(nullable = false)
    private Integer stock;

    @Column(nullable = false)
    private Boolean novedad;

    @Column(nullable = false)
    private LocalDate fechaProducto;

    @Column(nullable = false)
    private Boolean oferta;

    @Column(name = "descuento", nullable = false)
    private Double descuento;

    @Column(nullable = false)
    private List<String> imagenes;

    @ManyToOne
    @JoinColumn(name = "id_categoria", nullable = false)
    private CategoriaProducto categoria;

    @OneToMany(mappedBy = "producto", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PedidoProducto> pedidos;

    @ManyToMany(mappedBy = "productos")
    private Set<ListaCompra> listasCompra = new HashSet<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Double getPrecio() {
        return precio;
    }

    public void setPrecio(Double precio) {
        this.precio = precio;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Boolean getNovedad() {
        return novedad;
    }

    public void setNovedad(Boolean novedad) {
        this.novedad = novedad;
    }

    public LocalDate getFechaProducto() {
        return fechaProducto;
    }

    public void setFechaProducto(LocalDate fechaProducto) {
        this.fechaProducto = fechaProducto;
    }

    public Boolean getOferta() {
        return oferta;
    }

    public List<String> getImagenes() {
        return imagenes;
    }

    public void setImagenes(List<String> imagenes) {
        this.imagenes = imagenes;
    }

        
    public void setOferta(Boolean oferta) {
        this.oferta = oferta;
    }

    public Double getDescuento() {
        return descuento;
    }

    public void setDescuento(Double descuento) {
        this.descuento = descuento;
    }

    public CategoriaProducto getCategoria() {
        return categoria;
    }

    public void setCategoria(CategoriaProducto categoria) {
        this.categoria = categoria;
    }
    
    public List<PedidoProducto> getPedidos() {
        return pedidos;
    }

    public void setPedidos(List<PedidoProducto> pedidos) {
        this.pedidos = pedidos;
    }

    public Set<ListaCompra> getListasCompra() {
        return listasCompra;
    }

    public void setListasCompra(Set<ListaCompra> listasCompra) {
        this.listasCompra = listasCompra;
    }
    

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 19 * hash + Objects.hashCode(this.id);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Producto other = (Producto) obj;
        return Objects.equals(this.id, other.id);
    }

    @Override
    public String toString() {
        return "Producto{" + "id=" + id + ", nombre=" + nombre + ", descripcion=" + descripcion + ", precio=" + precio + ", stock=" + stock + ", novedad=" + novedad + ", fechaProducto=" + fechaProducto + ", oferta=" + oferta + ", descuento=" + descuento + ", imagenes=" + imagenes + ", categoria=" + categoria + ", pedidos=" + pedidos + ", listasCompra=" + listasCompra + '}';
    }    

}
