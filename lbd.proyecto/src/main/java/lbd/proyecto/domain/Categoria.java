package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionEmpleado;

@Data
@Entity
@Table(name = "FIDE_CATEGORIAS_TB") // Table name
public class Categoria implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_categoria") // Column name
    private Long idCategoria; // Hibernate converts this to => id_categoria
    private String descripcion; // Column => descripcion
    
    // Relationship with table Estado
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;

    // Relationship with table Producto
    @OneToMany(mappedBy = "categoria")
    private List<Producto> productos;

    //Constructors
    public Categoria() {
    }

    public Categoria(String descripcion, Estado estado) {
        this.descripcion = descripcion;
        this.estado = estado;
    }

}
