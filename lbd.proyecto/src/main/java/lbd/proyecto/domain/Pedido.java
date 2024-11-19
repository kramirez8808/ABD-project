package lbd.proyecto.domain;

import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.sql.Date;

@Data
@Entity
@Table(name = "FIDE_PEDIDOS_TB")
public class Pedido implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_pedido")
    private Long idPedido; // Hibernate converts this to => id_pedido
    
    @Column(name = "fecha")
    private Date fechaPedido; // Column => fecha
    
    @ManyToOne
    @JoinColumn(name = "id_cliente", referencedColumnName = "id_cliente")
    private Cliente cliente;
    
    @ManyToOne
    @JoinColumn(name = "id_vehiculo", referencedColumnName = "id_vehiculo")
    private Vehiculo vehiculo;
    
    @ManyToOne
    @JoinColumn(name = "id_tipo_carga", referencedColumnName = "id_tipo_carga")
    private TipoCarga tipoCarga;
    
    @ManyToOne
    @JoinColumn(name = "id_licencia_empleado", referencedColumnName = "id_licencia_empleado")
    private LicenciaEmpleado licenciaEmpleado;
    
    /*
    @ManyToOne
    @JoinColumn(name = "id_cliente", referencedColumnName = "id_cliente")
    private Cliente cliente; // Foreign key to FIDE_CLIENTES_TB
    
    @ManyToOne
    @JoinColumn(name = "id_vehiculo", referencedColumnName = "id_vehiculo")
    private Vehiculo vehiculo; // Foreign key to FIDE_VEHICULOS_TB
    
    @ManyToOne
    @JoinColumn(name = "id_tipo_carga")
    private TipoCarga tipoCarga; // Foreign key to FIDE_TIPOS_CARGA_TB
    
    @ManyToOne
    @JoinColumn(name = "id_licencia_empleado", referencedColumnName = "id_licencia_empleado")
    private LicenciaEmpleado licenciaEmpleado; // Foreign key to FIDE_LICENCIAS_EMPLEADO_TB
    */
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado; // Foreign key to FIDE_ESTADOS_TB


    // Constructors
    public Pedido() {
    }

    public Pedido(Date fechaPedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, LicenciaEmpleado licenciaEmpleado, Estado estado) {
        this.fechaPedido = fechaPedido;
        this.cliente = cliente;
        this.vehiculo = vehiculo;
        this.tipoCarga = tipoCarga;
        this.licenciaEmpleado = licenciaEmpleado;
        this.estado = estado;
    }
}
