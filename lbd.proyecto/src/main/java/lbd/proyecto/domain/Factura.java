package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

//Internal imports
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Estado;

@Data
@Entity
@Table(name = "facturas")
public class Factura implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_factura")
    private Long idFactura; //Hibernate converts this to => id_factura
    private java.sql.Date fecha; // Column => fecha
    private double total; // Column => total

    //Relationship with table Pedido
    @OneToOne(mappedBy = "factura") // One invoice can be assigned to one order 
    private Pedido pedido; // Order of the invoice

    //Relationship with table Estado
    @ManyToOne // Many invoices can have one status
    @JoinColumn(name = "id_estado") // Foreign key
    private Estado estado; // Status of the invoice

    //Constructors
    public Factura() {
    }

    public Factura(java.sql.Date fecha, double total) {
        this.fecha = fecha;
        this.total = total;
    }

}
