package lbd.proyecto.dao;



// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.DetallePedido;

public interface DetallePedidoDAO extends JpaRepository<DetallePedido, Long> {
    
    // Method to call an stored procedure to insert a new order detail
    @Procedure(procedureName = "FIDE_DETALLES_PEDIDO_TB_INSERTAR_SP")
    void insertDetallePedido(Long idPedido, Long idProducto, double cantidad, String unidadMasa, Long idEstado);

    // Method to call an stored procedure to update an order detail
    @Procedure(procedureName = "FIDE_DETALLES_PEDIDO_TB_ACTUALIZAR_SP")
    void updateDetallePedido(Long idDetalle, Long idPedido, Long idProducto, double cantidad, String unidadMasa, Long idEstado);

    // Method to call an stored procedure to delete an order detail
    @Procedure(procedureName = "FIDE_DETALLES_PEDIDO_TB_INACTIVAR_SP")
    void inactivarDetallePedido(Long idDetalle);

    // Method to call an stored procedure to get a (single) order detail
    // @Procedure(procedureName = "FIDE_DETALLES_PEDIDO_TB_VER_DETALLE_PEDIDO_SP")
    // DetallePedido getDetallePedido(Long idDetalle);

    // Method to call an stored procedure to get all order details
    // @Procedure(procedureName = "FIDE_DETALLES_PEDIDO_TB_VER_DETALLES_PEDIDO_SP")
    // List<DetallePedido> getAllDetallesPedido();

    // Method to call a SQL function to get all the order details by order ID
    // @Query(value = "SELECT * FROM TABLE(FIDE_DETALLES_PEDIDO_TB_BUSCAR_DETALLE_POR_PEDIDO_FN(:p_id_pedido))", nativeQuery = true)
    // List<DetallePedido> buscarDetallesPedido(@Param("p_id_pedido") Long idPedido);

}
