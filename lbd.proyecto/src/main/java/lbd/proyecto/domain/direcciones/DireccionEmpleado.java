package lbd.proyecto.domain.direcciones;

// External imports
import lombok.Data;
import lombok.EqualsAndHashCode;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Direccion;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Estado;

@Data
@Entity
@Table(name = "FIDE_DIRECCIONES_EMPLEADO_TB")
@EqualsAndHashCode(callSuper = true)
public class DireccionEmpleado extends Direccion {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_direccion")
    private Long idDireccion; //Hibernate converts this to => id_direccion

    //Relationship with table Empleado
    @ManyToOne // Many addresses can belong to one employee
    @JoinColumn(name = "id_empleado") // Foreign key
    private Empleado empleado; // Employee to which the address belongs

    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;
    
    //Constructors
    public DireccionEmpleado() {
    }
    
    public DireccionEmpleado(String detalles, Distrito distrito, Estado estado) {
        super(detalles, distrito);
        this.estado = estado;
    }

}
