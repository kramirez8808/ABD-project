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
    @Procedure(procedureName = "FIDE_DIRECCIONES_PEDIDO_TB_INSERTAR_SP")
    void insertDireccionPedido(Long idPedido, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstado);

    // Method to call an stored procedure to update a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_PEDIDO_TB_ACTUALIZAR_SP")
    void updateDireccionPedido(Long idDireccion, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstado);

    // Method to call an stored procedure to delete a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_PEDIDO_TB_INACTIVAR_SP")
    void inactivarDireccionPedido(Long idDireccion);

    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCION_SP")
    DireccionPedido getDireccionPedido(Long idDireccion);

    // Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCIONES_SP")
    List<DireccionPedido> getAllDireccionesPedido();

    // Method to call a SQL function to get all the directions by client ID
    @Query(value = "SELECT * FROM TABLE(FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(:p_id_pedido))", nativeQuery = true)
    List<DireccionPedido> buscarDireccionesPedido(@Param("p_id_pedido") Long idPedido);
    
}
