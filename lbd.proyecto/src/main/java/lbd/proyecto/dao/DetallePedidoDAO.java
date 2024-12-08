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

}
