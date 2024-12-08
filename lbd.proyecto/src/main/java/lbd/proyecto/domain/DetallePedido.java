package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_DETALLES_PEDIDO_TB") // Table name
public class DetallePedido implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_detalle")
    private Long idDetalle; //Hibernate converts this to => id_detalle
    private double cantidad; // Column => cantidad
    private String unidadMasa; // Column => unidad_masa

    //Relationship with table Pedido
    @ManyToOne // Many details can be assigned to one order
    @JoinColumn(name = "id_pedido") // Foreign key
    private Pedido pedido; // Order of the detail

    //Relationship with table Producto
    @ManyToOne // Many details can be assigned to one product
    @JoinColumn(name = "id_producto") // Foreign key
    private Producto producto; // Product of the detail

    //Relationship with table Estado
    @ManyToOne // Many details can have one status
    @JoinColumn(name = "id_estado") // Foreign key
    private Estado estado; // Status of the detail

    //Constructors
    public DetallePedido() {
    }

    public DetallePedido(double cantidad, String unidadMasa, Pedido pedido, Producto producto, Estado estado) {
        this.cantidad = cantidad;
        this.unidadMasa = unidadMasa;
        this.pedido = pedido;
        this.producto = producto;
        this.estado = estado;
    }

}
