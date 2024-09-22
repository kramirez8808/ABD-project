package lbd.proyecto.dao.direcciones;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionPedido;

public interface DireccionPedidoDAO extends JpaRepository<DireccionPedido, Long> {
    
    // Method to call an stored procedure to insert a new direction
    @Procedure(procedureName = "insertar_direccion_pedido")
    void insertDireccionPedido(Long idPedido, String detalles, Long idProvincia, Long idCanton, Long idDistrito);

    // Method to call an stored procedure to update a direction
    @Procedure(procedureName = "actualizar_direccion_pedido")
    void updateDireccionPedido(Long idDireccion, String detalles, Long idProvincia, Long idCanton, Long idDistrito);

    // Method to call an stored procedure to delete a direction
    @Procedure(procedureName = "eliminar_direccion_pedido")
    void deleteDireccionPedido(Long idDireccion);

    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "ver_direccion_pedido")
    DireccionPedido getDireccionPedido(Long idDireccion);

    // Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "ver_direcciones_pedidos")
    List<DireccionPedido> getAllDireccionesPedido();

    // Method to call a SQL function to get all the directions by client ID
    @Query(value = "SELECT * FROM TABLE(buscar_direcciones_pedido(:p_id_pedido))", nativeQuery = true)
    List<DireccionPedido> buscarDireccionesPedido(@Param("p_id_pedido") Long idPedido);
    
}
