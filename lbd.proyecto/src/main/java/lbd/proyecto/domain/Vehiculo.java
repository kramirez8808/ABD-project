package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "FIDE_VEHICULOS_TB")
public class Vehiculo implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_vehiculo")
    private Long idVehiculo; //Hibernate converts this to => id_vehiculo
    
    private String marca; // Column => marca
    private String modelo; // Column => modelo
    private Integer anio; // Column => anio
    private String placa; // Column => placa
 
    
    

    //Relationship with table Pedido
    @OneToMany(mappedBy = "vehiculo") // One state can be assigned to many clients
    private List<Pedido> pedidos; // List of clients
    /*
    @OneToMany(mappedBy = "vehiculo") // One vehicle can be assigned to many orders
    private List<Pedido> pedidos; // List of orders
    */
    // Relationship with table Estado
    @ManyToOne // A vehicule can have one states
    @JoinColumn(name = "id_estado") // Foreign key to Estado
    private Estado estado;

    //Constructors
    public Vehiculo() {
    }

    public Vehiculo(String placa, String marca, String modelo, Integer anio, Estado estado) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.anio = anio;
        this.estado = estado;
    }

}
