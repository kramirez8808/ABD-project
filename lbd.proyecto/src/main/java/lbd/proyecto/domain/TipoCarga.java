package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_TIPOS_CARGA_TB")
public class TipoCarga implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_tipo_carga")
    private Long idTipo; //Hibernate converts this to => id_tipo
    private String descripcion; //Column => descripcion

    //Relationship with table Pedido
    @OneToMany(mappedBy = "tiposCarga") // One type of load can be assigned to many orders
    private List<Pedido> pedidos; // List of orders
    
    // Relationship with table Estado
    @ManyToOne // A type of load can have one states
    @JoinColumn(name = "id_estado") // Foreign key to Estado
    private Estado estado;

    //Constructors
    public TipoCarga() {
    }

    public TipoCarga(String descripcion) {
        this.descripcion = descripcion;
    }

}
