package lbd.proyecto.domain;

import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

// Imports locales
import lbd.proyecto.domain.Categoria;
import lbd.proyecto.domain.Estado;

@Data
@Entity
@Table(name = "FIDE_PRODUCTOS_TB")
public class Producto implements Serializable {
    
    private static final long serialVersionUID = 1L;

    //Atributos
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) //Campo Auto-Incremental
    @Column(name = "id_producto")
    private Long idProducto; //Hibernate lo transforma/MySQL => id_producto PK
    private String nombre; //MySQL => nombre
    private String descripcion; //MySQL => descripcion
    
    //private Long idCategoria; //MySQL => id_categoria FK
    
    //Relación con la tabla Categoria
    // @ManyToOne
    // @JoinColumn(name = "id_categoria")
    // Categoria categoria; 
    //MySQL => id_categoria FK
    
    // Relación con la tabla Categoria
    @ManyToOne // Un producto puede tener una categoría
    @JoinColumn(name = "id_categoria") // Clave foránea de categoría
    private Categoria categoria;
    
    // Relación con la tabla Estado
    @ManyToOne // Un producto puede tener un estado
    @JoinColumn(name = "id_estado") // Clave foránea de estado
    private Estado estado;

    //Relación con la tabla DetallePedido
    @OneToMany(mappedBy = "producto")
    private List<DetallePedido> detallesPedido;
    
    //Constructores
    public Producto() {
    }

    public Producto(String nombre, String descripcion, Categoria categoria, Estado estado) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.estado = estado;
    }
}
