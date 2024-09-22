package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.Pedido;

public interface DireccionPedidoService {
    
    // Method to save a new direction with the Stored Procedure
    void insertDireccionPedido(DireccionPedido direccionPedido, Pedido pedido, Distrito distrito);

    // Method to update a direction with the Stored Procedure
    void updateDireccionPedido(DireccionPedido direccionPedido, Distrito distrito);

    // Method to delete a direction with the Stored Procedure
    void deleteDireccionPedido(DireccionPedido direccionPedido);

    // Method to get a direction with the Stored Procedure
    DireccionPedido getDireccionPedido(DireccionPedido direccionPedido);

    // Method to get all directions with the Stored Procedure
    List<DireccionPedido> getAllDirecciones();

    // Method to search directions by client ID with the SQL function
    List<DireccionPedido> searchDireccionesByPedido(Long idPedido);
    
}
