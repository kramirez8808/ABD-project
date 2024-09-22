package lbd.proyecto.domain;

import lombok.Data;
import jakarta.persistence.*;
import java.io.Serializable;

@Data
@Entity
@Table(name = "producto")
public class Producto implements Serializable {
    
    private static final long serialVersionUID = 1L;

    //Atributos
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) //Campo Auto-Incremental
    @Column(name = "id_producto")
    private Long idProducto; //Hibernate lo transforma/MySQL => id_producto PK
    private String descripcion; //MySQL => descripcion
    private String detalle; //MySQL => detalle
    private double precio; //MySQL => precio
    private int existencias; //MySQL => existencias
    private String rutaImagen; //MySQL => ruta_imagen
    private boolean activo; //MySQL => activo
    //private Long idCategoria; //MySQL => id_categoria FK
    
    //Relación con la tabla Categoria
    // @ManyToOne
    // @JoinColumn(name = "id_categoria")
    // Categoria categoria; 
    //MySQL => id_categoria FK

    //Constructores
    public Producto() {
    }

    public Producto(String descripcion, String detalle, double precio, int existencias, String rutaImagen, boolean activo) {
        this.descripcion = descripcion;
        this.detalle = detalle;
        this.precio = precio;
        this.existencias = existencias;
        this.rutaImagen = rutaImagen;
        this.activo = activo;
    }
}
