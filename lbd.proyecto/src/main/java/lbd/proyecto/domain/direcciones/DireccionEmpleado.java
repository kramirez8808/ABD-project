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

@Data
@Entity
@Table(name = "direcciones_empleado")
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

    //Constructors
    public DireccionEmpleado() {
    }
    
    public DireccionEmpleado(String detalles, Distrito distrito) {
        super(detalles, distrito);
    }

    // public DireccionEmpleado(String detalles, Provincia provincia, Canton canton, Distrito distrito) {
    //     super(detalles, provincia, canton, distrito);
    // }
}
