package lbd.proyecto.domain.direcciones;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lbd.proyecto.domain.Estado;

// Internal imports
import lbd.proyecto.domain.direcciones.Direccion;
import lbd.proyecto.domain.Pedido;

@Data
@Entity
@Table(name = "FIDE_DIRECCIONES_PEDIDO_TB")
public class DireccionPedido extends Direccion {

    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_direccion")
    private Long idDireccion; //Hibernate converts this to => id_direccion

    //Relationship with table Pedido
    @ManyToOne // Many addresses can belong to one order
    @JoinColumn(name = "id_pedido") // Foreign key
    private Pedido pedido; // Order to which the address belongs

    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;
    
    //Constructors
    public DireccionPedido() {
    }

    public DireccionPedido(String detalles, Distrito distrito, Estado estado) {
        super(detalles, distrito);
        this.estado = estado;
    }
    
    // public DireccionPedido(String detalles, Provincia provincia, Canton canton, Distrito distrito) {
    //     super(detalles, provincia, canton, distrito);
    // }
    
}
