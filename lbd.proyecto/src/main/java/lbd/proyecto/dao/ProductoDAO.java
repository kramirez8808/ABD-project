package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Producto;

public interface ProductoDAO extends JpaRepository<Producto, Long> {
    
    // Method to call an stored procedure to get a product
    // @Procedure(procedureName = "FIDE_PRODUCTOS_TB_VER_PRODUCTO_SP")
    // Producto getProducto(Long idProducto);

    // Method to call an stored procedure to get all products
    // @Procedure(procedureName = "FIDE_PRODUCTOS_TB_VER_PRODUCTOS_SP")
    // List<Producto> getAllProductos();

    // Method to call an stored procedure to insert a new product
    @Procedure(procedureName = "FIDE_PRODUCTOS_TB_INSERTAR_SP")
    void insertProducto(String nombre, String descripcion, Long idCategoria, Long idEstado);

    // Method to call an stored procedure to update a product
    @Procedure(procedureName = "FIDE_PRODUCTOS_TB_ACTUALIZAR_SP")
    void updateProducto(Long idProducto, String nombre, String descripcion, Long idCategoria, Long idEstado);

    // Method to call an stored procedure to delete a product
    @Procedure(procedureName = "FIDE_PRODUCTOS_TB_INACTIVAR_SP")
    void inactivarProducto(Long idProducto);
    
}
