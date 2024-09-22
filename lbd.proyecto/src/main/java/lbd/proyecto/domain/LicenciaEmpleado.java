package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Licencia;

@Data
@Entity
@Table(name = "licencias_empleado")
public class LicenciaEmpleado implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_licencia_empleado")
    private Long idLicenciaEmpleado; //Hibernate converts this to => id_licencia_empleado
    private java.sql.Date fechaExpedicion; //Column => fecha_expedicion
    private java.sql.Date fechaVencimiento; //Column => fecha_vencimiento

    //Relationship with table Empleado
    @ManyToOne // One employee can have many licenses
    @JoinColumn(name = "id_empleado") // Foreign key
    private Empleado empleado; // Employee

    //Relationship with table Licencia
    @ManyToOne // Many licenses can be assigned to one employee
    @JoinColumn(name = "id_licencia") // Foreign key
    private Licencia licencia; // License

    //Constructors
    public LicenciaEmpleado() {
    }

    public LicenciaEmpleado(java.sql.Date fechaExpedicion, java.sql.Date fechaVencimiento, Empleado empleado, Licencia licencia) {
        this.fechaExpedicion = fechaExpedicion;
        this.fechaVencimiento = fechaVencimiento;
        this.empleado = empleado;
        this.licencia = licencia;
    }

    //Function to get the date returned by the HTML input and convert it to a java.sql.Date
    public java.sql.Date convertDate(String input) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dt = sdf.parse(input);
            java.sql.Date sqlDate = new java.sql.Date(dt.getTime());

            return sqlDate;
        } catch (Exception e) {
            return null;
        }
    }
}
