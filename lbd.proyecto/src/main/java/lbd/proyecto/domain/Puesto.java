package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_PUESTOS_TB")
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
    
    @ManyToOne
    @JoinColumn(name = "id_estado")  // Especifica el nombre de la columna en la tabla 'Puesto' que hace referencia a 'Estado'
    private Estado estado;

    //Constructors
    public Puesto() {
    }

    public Puesto(double salario, String descripcion, Estado estado) {
        this.salario = salario;
        this.descripcion = descripcion;
        this.estado = estado;
    }
    
    @Override
    public String toString() {
        return "Puesto{" +
                "idPuesto='" + idPuesto + '\'' +
                ", salario=" + salario +
                ", descripcion='" + descripcion + '\'' +
                ", estado=" + (estado != null ? estado.getDescripcion() : "No asignado") +
                ", empleados=" + (empleados != null ? empleados.size() : 0) +
                '}';
    }

}
