package lbd.proyecto.domain.direcciones;

//External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lbd.proyecto.domain.Estado;

//Internal imports
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Provincia;

@Data
@Entity
@Table(name = "FIDE_DISTRITOS_TB")
public class Distrito implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_distrito")
    private Long idDistrito; //Hibernate converts this to => id_distrito
    private String nombre; // Column => nombre

    //Relationship with table Canton
    @ManyToOne // Many districts can belong to one canton
    @JoinColumn(name = "id_canton") // Foreign key
    private Canton canton; // Canton to which the district belongs
    
    //Relationship with table Provincia
    @ManyToOne // Many distritos can belong to one provincia
    @JoinColumn(name = "id_provincia") // Foreign key
    private Provincia provincia; // Canton to which the district belongs
    
    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;

    //Constructors
    public Distrito() {
    }

    public Distrito(String nombre, Canton canton, Estado estado, Provincia provincia) {
        this.nombre = nombre;
        this.canton = canton;
        this.estado = estado;
        this.provincia = provincia;
    }
    
}
