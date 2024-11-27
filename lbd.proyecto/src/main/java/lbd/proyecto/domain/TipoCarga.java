package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_TIPOS_CARGA_TB")
public class TipoCarga implements Serializable {

    // Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    // Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_tipo_carga")
    private Long idTipoCarga; // Hibernate converts this to => id_tipo

    private String descripcion; // Column => descripcion

    // Relationship with table Pedidos
    @OneToMany(mappedBy = "tipoCarga") // One state can be assigned to many clients
    private List<Pedido> pedidos; // List of clients
    
// Relationship with table Estado
    @ManyToOne // A type of load can have one state
    @JoinColumn(name = "id_estado") // Foreign key to Estado
    private Estado estado;

    // Constructors
    public TipoCarga() {
    }

    public TipoCarga(String descripcion) {
        this.descripcion = descripcion;
    }

    // Custom getters and setters for idTipoCarga
    public Long getIdTipo() {
        return this.idTipoCarga;
    }

    public void setIdTipo(Long idTipo) {
        this.idTipoCarga = idTipo;
    }
    
    public TipoCarga(Long idTipoCarga, String description, Estado estado) {
        this.idTipoCarga = idTipoCarga;
        this.descripcion = descripcion;
        this.estado = estado;
    }
}
