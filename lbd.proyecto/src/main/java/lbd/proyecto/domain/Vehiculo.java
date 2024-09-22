package lbd.proyecto.domain;

// External imports
import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Data
@Entity
@Table(name = "vehiculo")
public class Vehiculo implements Serializable {
    
    //Serial version UID for Serializable classes
    private static final long serialVersionUID = 1L;

    //Attributes
    @Id // Primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Autoincremental value
    @Column(name = "id_vehiculo")
    private Long idVehiculo; //Hibernate converts this to => id_vehiculo
    private String placa; // Column => placa
    private String marca; // Column => marca
    private String modelo; // Column => modelo
    private Integer anio; // Column => anio

    //Relationship with table Pedido
    @OneToMany(mappedBy = "vehiculo") // One vehicle can be assigned to many orders
    private List<Pedido> pedidos; // List of orders

    //Constructors
    public Vehiculo() {
    }

    public Vehiculo(String placa, String marca, String modelo, Integer anio) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.anio = anio;
    }

}
