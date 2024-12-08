package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.DetallePedido;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Producto;

public interface DetallePedidoService {

    // Method to get a order detail with the Stored Procedure
    DetallePedido getDetallePedido(DetallePedido detallePedido);

    // Method to get all order details with the Stored Procedure
    List<DetallePedido> getAllDetallesPedidos();
    
    // Method to save a new order detail with the Stored Procedure
    void insertDetallePedido(DetallePedido detallePedido, Pedido pedido, Producto producto);

    // Method to search order details by order ID with the SQL function
    List<DetallePedido> searchDetallesByPedido(Long idPedido);

    // Java function to insert multiple order details to a single order
    void insertMultipleDetallesPedido(List<DetallePedido> detallesPedido);
    
    // Method to update a order detail with the Stored Procedure
    void updateDetallePedido(Long idDetalle, DetallePedido detallePedido);

    // Method to delete a order detail with the Stored Procedure
    void inactivarDetallePedido(Long idDetalle);

    // Method to insert order with order details
    void insertPedidoConDetalles(Pedido pedido, List<DetallePedido> detallesPedido);

}
