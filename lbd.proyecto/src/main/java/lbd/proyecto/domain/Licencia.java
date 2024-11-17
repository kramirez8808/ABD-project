package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_LICENCIAS_TB")
public class Licencia implements Serializable {

    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_licencia")
    private Long idLicencia; //Hibernate converts this to => id_licencia
    
    private String tipo; // Column => tipo

    //Relationship with table Licencias_Empleado
    @OneToMany(mappedBy = "licencia") // One license can be assigned to many employees
    private List<LicenciaEmpleado> licenciaEmpleado; // Employees with the license

    // Relationship with table Estado
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado") // Foreign key to Estado
    private Estado estado; // The state associated with the license
    
    //Constructors
    public Licencia() {
    }

    public Licencia(String tipo, Estado estado) {
        this.tipo = tipo;
        this.estado = estado;
    }
    
}
