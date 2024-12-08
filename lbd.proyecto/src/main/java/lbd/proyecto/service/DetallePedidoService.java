package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.DetallePedido;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Producto;

public interface DetallePedidoService {
    
    // Method to save a new order detail with the Stored Procedure
    void insertDetallePedido(DetallePedido detallePedido, Pedido pedido, Producto producto);

    // Method to search order details by order ID with the SQL function
    List<DetallePedido> searchDetallesByPedido(Long idPedido);

    // Java function to insert multiple order details to a single order
    void insertMultipleDetallesPedido(List<DetallePedido> detallesPedido, Pedido pedido, Producto producto);
    
}
