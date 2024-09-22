package lbd.proyecto.domain.direcciones;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Distrito;

@Data
@MappedSuperclass
public class Direccion implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_direccion")
    private Long idDireccion; //Hibernate converts this to => id_direccion
    private String detalles; // Column => detalles

    //Relationship with table Provincia
    // @ManyToOne // Many addresses can belong to one province
    // @JoinColumn(name = "id_provincia") // Foreign key
    // private Provincia provincia; // Province to which the address belongs

    //Relationship with table Canton
    // @ManyToOne // Many addresses can belong to one canton
    // @JoinColumn(name = "id_canton") // Foreign key
    // private Canton canton; // Canton to which the address belongs

    //Relationship with table Distrito
    @ManyToOne // Many addresses can belong to one district
    @JoinColumn(name = "id_distrito") // Foreign key
    private Distrito distrito; // District to which the address belongs

    //Constructors
    public Direccion() {
    }

    public Direccion(String detalles, Distrito distrito) {
        this.detalles = detalles;
        this.distrito = distrito;
    }

    // public Direccion(String detalles, Provincia provincia, Canton canton, Distrito distrito) {
    //     this.detalles = detalles;
    //     this.provincia = provincia;
    //     this.canton = canton;
    //     this.distrito = distrito;
    // }
}
