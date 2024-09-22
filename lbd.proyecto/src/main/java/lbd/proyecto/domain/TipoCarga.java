package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "tipos_carga")
public class TipoCarga implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_tipo")
    private Long idTipo; //Hibernate converts this to => id_tipo
    private String descripcion; //Column => descripcion

    //Relationship with table Pedido
    @OneToMany(mappedBy = "tiposCarga") // One type of load can be assigned to many orders
    private List<Pedido> pedidos; // List of orders

    //Constructors
    public TipoCarga() {
    }

    public TipoCarga(String descripcion) {
        this.descripcion = descripcion;
    }

}
