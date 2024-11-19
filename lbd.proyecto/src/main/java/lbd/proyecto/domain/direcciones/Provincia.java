package lbd.proyecto.domain.direcciones;

//External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lbd.proyecto.domain.Estado;

//Internal imports
import lbd.proyecto.domain.direcciones.Canton;

@Data
@Entity
@Table(name = "FIDE_PROVINCIAS_TB")
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
    
    //Relationship with table Distrito
    @OneToMany(mappedBy = "provincia") // One province can have many distritos
    private List<Distrito> distrito; // List of distritos
    
    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;

    //Constructors
    public Provincia() {
    }

    public Provincia(String nombre, Estado estado) {
        this.nombre = nombre;
        this.estado = estado;
        
    }
    
}
