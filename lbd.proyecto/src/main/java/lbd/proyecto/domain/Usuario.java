package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;

@Data
@Entity
@Table(name = "FIDE_USUARIOS_TB")
public class Usuario implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_usuario")
    
    private Long idUsuario;
    
    private String usuario;
    private String contrasena;
    
    // Relationship with table FIDE_ROL_TB
    @ManyToOne
    @JoinColumn(name = "id_rol", referencedColumnName = "id_rol")
    private Rol ID_ROL;
    
    // Relationship with table FIDE_ESTADOS_TB
    @ManyToOne
    @JoinColumn(name = "id_estado", referencedColumnName = "id_estado")
    private Estado estado;
    
    @Override
    public String toString() {
        return "Usuario{id=" + idUsuario + ", usuario=" + usuario + ", contrasena=" + contrasena +"}";
    }

    public Usuario() {
    }

    public Usuario(Long idUsuario, String usuario, String contrasena, Rol ID_ROL, Estado estado) {
        this.idUsuario = idUsuario;
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.ID_ROL = ID_ROL;
        this.estado = estado;
    }
}
