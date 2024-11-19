package lbd.proyecto.domain.direcciones;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lbd.proyecto.domain.Estado;

//Internal imports
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.domain.direcciones.Distrito;

@Data
@Entity
@Table(name = "FIDE_CANTONES_TB")
public class Canton implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_canton")
    private Long idCanton; //Hibernate converts this to => id_canton
    private String nombre; // Column => nombre

    //Relationship with table Provincia
    @ManyToOne // Many cantons can belong to one province
    @JoinColumn(name = "id_provincia") // Foreign key
    private Provincia provincia; // Province to which the canton belongs

    //Relationship with table Distrito
    @OneToMany(mappedBy = "canton") // One canton can have many districts
    private List<Distrito> distritos; // List of districts
    
    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;

    //Constructors
    public Canton() {
    }

    public Canton(String nombre, Provincia provincia, Estado estado) {
        this.nombre = nombre;
        this.provincia = provincia;
        this.estado = estado;
    }

}
