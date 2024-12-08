package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.direcciones.Provincia;


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
    
    // Relationship with the Canton table
    @OneToMany(mappedBy = "estado") // One state can be associated with many cantones
    private List<Canton> cantones; // List of cantones associated with the state
    
    // Relationship with the distrito table
    @OneToMany(mappedBy = "estado") // One state can be associated with many distritos
    private List<Distrito> distritos; // List of distritos associated with the state
    
    // Relationship with the provincias table
    @OneToMany(mappedBy = "estado") // One state can be associated with many distritos
    private List<Provincia> provincias; // List of distritos associated with the state
    
    // Relationship with the direccion cliente table
    @OneToMany(mappedBy = "estado") // One state can be associated with many direcciones cliente
    private List<DireccionCliente> direccionCliente; // List of direcciones cliente associated with the state
    
    // Relationship with the direccion empleado table
    @OneToMany(mappedBy = "estado") // One state can be associated with many direcciones empleado
    private List<DireccionEmpleado> direccionEmpleado; // List of direcciones empleado associated with the state
    
    // Relationship with the direccion pedido table
    @OneToMany(mappedBy = "estado") // One state can be associated with many direcciones pedido
    private List<DireccionPedido> direccionPedido; // List of direcciones pedido associated with the state
    
    // Relationship with the DetallePedido table
    @OneToMany(mappedBy = "estado") // One state can be associated with many details of orders
    private List<DetallePedido> detallesPedido; // List of details of orders associated with the state

    //Constructors
    public Estado() {
    }

    public Estado(String descripcion) {
        this.descripcion = descripcion;
    }

}
