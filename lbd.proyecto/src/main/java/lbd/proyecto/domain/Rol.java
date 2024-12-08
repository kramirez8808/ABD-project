package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;

@Data
@Entity
@Table(name = "FIDE_ROLES_TB")
public class Rol implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_rol")
    
    private Long idRol; 
    
    private String descripcion;// Column => descripcion
    
    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;
    
    @Override
    public String toString() {
        return "Rol{id=" + idRol + ", descripcion=" + descripcion + "}";
    }

    public Rol() {
    }

    public Rol(Long idRol, String descripcion, Estado estado) {
        this.idRol = idRol;
        this.descripcion = descripcion;
        this.estado = estado;
    }
}
