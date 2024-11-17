package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;


@Data
@Entity
@Table(name = "FIDE_ESTADOS_TB")
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
    
    // Relationship with table Clientes
    @OneToMany(mappedBy = "estado") // One state can be assigned to many clients
    private List<Cliente> clientes; // List of clients
    
    // Relationship with table Licencias
    @OneToMany(mappedBy = "estado") // One state can be assigned to many licenses
    private List<Licencia> licencias; // List of licenses

     // Relationship with table LicenciaEmpleado
    @OneToMany(mappedBy = "estado") // One state can be assigned to many license-employee relations
    private List<LicenciaEmpleado> licenciasEmpleado;
    
    // Relationship with the Producto table
    @OneToMany(mappedBy = "estado") // One state can be associated with many products
    private List<Producto> productos; // List of products associated with the state
    
    // Relationship with the Puesto table
    @OneToMany(mappedBy = "estado")  // Asegúrate de que "estado" sea el nombre del campo en la entidad 'Puesto'
    private List<Puesto> puestos; // List of jobs associated with the state
    
    // Relationship with the Tipos_carga table
    @OneToMany(mappedBy = "estado") // One state can be associated with many type of loads
    private List<TipoCarga> tiposcarga; // List of type of loads associated with the state
    
    // Relationship with the Vehiculo table
    @OneToMany(mappedBy = "estado") // One state can be associated with many vehicules
    private List<Vehiculo> vehiculos; // List of vehicules associated with the state
    
    //Constructors
    public Estado() {
    }

    public Estado(String descripcion) {
        this.descripcion = descripcion;
    }

}
