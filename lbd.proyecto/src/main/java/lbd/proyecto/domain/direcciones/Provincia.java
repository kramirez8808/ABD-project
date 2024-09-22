package lbd.proyecto.domain.direcciones;

//External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

//Internal imports
import lbd.proyecto.domain.direcciones.Canton;

@Data
@Entity
@Table(name = "provincia")
public class Provincia implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_provincia")
    private Long idProvincia; //Hibernate converts this to => id_provincia
    private String nombre; // Column => nombre

    //Relationship with table Canton
    @OneToMany(mappedBy = "provincia") // One province can have many cantons
    private List<Canton> cantones; // List of cantons

    //Constructors
    public Provincia() {
    }

    public Provincia(String nombre) {
        this.nombre = nombre;
    }
    
}
