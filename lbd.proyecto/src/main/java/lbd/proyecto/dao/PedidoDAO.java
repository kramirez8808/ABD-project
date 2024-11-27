package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Pedido;

public interface PedidoDAO extends JpaRepository<Pedido, Long> {

    // Method to call an stored procedure to insert a new order
    @Procedure(procedureName = "FIDE_PEDIDOS_TB_INSERTAR_SP")
    void insertPedido(Long idCliente, Long idVehiculo, Long idTipoCarga, java.sql.Date fecha, Long idEstado, Long idLicenciaEmpleado);
    
    // Method to call an stored procedure to update an order
    @Procedure(procedureName = "FIDE_PEDIDOS_TB_VER_ACTUALIZAR_SP")
    void updatePedido(Long idPedido, Long idCliente, Long idVehiculo, Long idTipoCarga, java.sql.Date fecha, Long idEstado, Long idLicenciaEmpleado);

    // Method to call an stored procedure to delete an order
    @Procedure(procedureName = "FIDE_PEDIDOS_TB_INACTIVAR_SP")
    void inactivarPedido(Long idPedido);

    // Method to call an stored procedure to get a (single) order
    @Procedure(procedureName = "FIDE_PEDIDOS_TB_VER_PEDIDO_SP")
    Pedido getPedido(Long idPedido);

    // Method to call an stored procedure to get all orders
    @Procedure(procedureName = "FIDE_PEDIDOS_TB_VER_PEDIDOS_SP")
    List<Pedido> getAllPedidos();

    // Method to call a SQL function to get all the orders by client ID
    @Query(value = "SELECT * FROM TABLE(FIDE_PEDIDOS_TB_BUSCAR_POR_CLIENTE_FN(:p_id_cliente))", nativeQuery = true)
    List<Pedido> buscarPedidosCliente(@Param("p_id_cliente") Long idCliente);

}
