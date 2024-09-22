package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

//Internal imports
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.impl.PedidoServiceImpl;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.domain.Estado;

@Data
@Entity
@Table(name = "pedidos")
public class Pedido implements Serializable {

    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_pedido")
    private Long idPedido; //Hibernate converts this to => id_pedido
    private java.sql.Date fechaPedido; // Column => fecha_pedido
    private String descripcion; // Column => descripcion

    //Relationship with table Cliente
    @ManyToOne // Many orders can be assigned to one client
    @JoinColumn(name = "id_cliente") // Foreign key
    private Cliente cliente; // Client

    //Relationship with table Vehiculo
    @ManyToOne // Many orders can be assigned to one vehicle
    @JoinColumn(name = "id_vehiculo") // Foreign key
    private Vehiculo vehiculo; // Vehicle

    //Relationship with table Tipos_Carga
    @ManyToOne // Many orders can be assigned to one type of load
    @JoinColumn(name = "id_tipo_carga") // Foreign key
    private TipoCarga tiposCarga; // Type of load

    //Relationship with table Estado
    @ManyToOne // Many orders can be assigned to one state
    @JoinColumn(name = "id_estado") // Foreign key
    private Estado estado; // State

    //Relationship with table Direcciones_Cliente
    @ManyToOne // Many orders can be assigned to one client address
    @JoinColumn(name = "id_direccion_cliente") // Foreign key
    private DireccionCliente direccionCliente; // Client address

    //Relationship with table Licencias_Empleado
    @ManyToOne // Many orders can be assigned to one employee license
    @JoinColumn(name = "id_licencia_empleado") // Foreign key
    private LicenciaEmpleado licenciaEmpleado; // Employee license

    //Relationship with table Facturas
    @OneToOne // One order can have one invoice
    @JoinColumn(name = "id_factura") // Foreign key
    private Factura factura; // Invoice of the order

    //Constructors
    public Pedido() {
    }

    public Pedido(java.sql.Date fechaPedido, String descripcion, Cliente cliente, Vehiculo vehiculo, TipoCarga tiposCarga, Estado estado, DireccionCliente direccionCliente) {
        this.fechaPedido = fechaPedido;
        this.descripcion = descripcion;
        this.cliente = cliente;
        this.vehiculo = vehiculo;
        this.tiposCarga = tiposCarga;
        this.estado = estado;
        this.direccionCliente = direccionCliente;
    }
    
    // Method to verify if the order has an invoice
    public boolean hasFactura() {
        return this.factura != null;
    }

    // Method to verify if the order is canceled
    public boolean isCanceled() {
        if (this.estado.getIdEstado() == 1) {
            return true;
        } else {
            return false;
        }
    }

}
