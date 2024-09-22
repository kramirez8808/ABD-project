package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "puestos")
public class Puesto implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;
    
    //Attributes
    @Id // Primary key
    @Column(name = "id_puesto")
    private String idPuesto; //Hibernate converts this to => id_puesto
    private double salario; // Column => salario
    private String descripcion; // Column => descripcion

    //Relationship with table Empleado
    @OneToMany(mappedBy = "puesto") // One job can have many employees
    private List<Empleado> empleados; // List of employees

    //Constructors
    public Puesto() {
    }

    public Puesto(double salario, String descripcion) {
        this.salario = salario;
        this.descripcion = descripcion;
    }

}
