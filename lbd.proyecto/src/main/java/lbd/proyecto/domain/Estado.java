package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;


@Data
@Entity
@Table(name = "estados")
public class Estado implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_estado")
    private Long idEstado; //Hibernate converts this to => id_estado
    private String descripcion; //Column => descripcion

    //Relationship with table Pedidos
    @OneToMany(mappedBy = "estado") // One state can be assigned to many orders
    private List<Pedido> pedidos; // List of orders

    //Relationship with table Facturas
    @OneToMany(mappedBy = "estado") // One state can be assigned to many invoices
    private List<Factura> facturas; // List of invoices

    //Constructors
    public Estado() {
    }

    public Estado(String descripcion) {
        this.descripcion = descripcion;
    }

}
