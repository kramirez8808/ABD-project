package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionEmpleado;

@Data
@Entity
@Table(name = "empleados")
public class Empleado implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_empleado")
    private Long idEmpleado; //Hibernate converts this to => id_empleado
    private String nombre; //Column => nombre
    private String apellido; //Column => apellido
    private java.sql.Date fechaNacimiento; //Column => fecha_nacimiento
    private java.sql.Date fechaContratacion; //Column => fecha_contratacion

    //Relationship with table Puesto
    @ManyToOne // Many employees can have one job
    @JoinColumn(name = "id_puesto") // Foreign key
    private Puesto puesto; // Job

    //Relationship with table Licencias_Empleado
    @OneToMany(mappedBy = "empleado") // One employee can have many licenses
    private List<LicenciaEmpleado> licenciaEmpleado; // Licenses

    //Relationship with table Direcciones_Empleado
    @OneToMany(mappedBy = "empleado") // One employee can have many addresses
    private List<DireccionEmpleado> direccionEmpleado; // Addresses

    //Constructors
    public Empleado() {
    }

    public Empleado(String nombre, String apellido, java.sql.Date fechaNacimiento, java.sql.Date fechaContratacion) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.fechaNacimiento = fechaNacimiento;
        this.fechaContratacion = fechaContratacion;
    }

    //Function to get the date returned by the HTML input and convert it to a java.sql.Date
    public java.sql.Date convertDate(String input) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dt = sdf.parse(input);
            java.sql.Date sqlDate = new java.sql.Date(dt.getTime());

            return sqlDate;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        
        
    }

    //Function to return if the employee is a driver
    public boolean isDriver() {
        System.out.println(this.puesto.getIdPuesto());
        if (this.puesto.getIdPuesto().equals("DRV-01") || this.puesto.getIdPuesto().equals("DRV-02") || this.puesto.getIdPuesto().equals("DRV-03")) {
            return true;
        } else {
            return false;
        }
    }


}
