package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.Cliente;

public interface DireccionClienteService {
    
    // Method to save a new direction with the Stored Procedure
    void insertDireccionCliente(DireccionCliente direccionCliente, Cliente cliente, Distrito distrito);

    // Method to update a direction with the Stored Procedure
    void updateDireccionCliente(DireccionCliente direccionCliente, Distrito distrito);

    // Method to delete a direction with the Stored Procedure
    void deleteDireccionCliente(DireccionCliente direccionCliente);

    // Method to get a direction with the Stored Procedure
    DireccionCliente getDireccionCliente(DireccionCliente direccionCliente);

    // Method to get all directions with the Stored Procedure
    List<DireccionCliente> getAllDirecciones();

    // Method to search directions by client ID with the SQL function
    List<DireccionCliente> searchDireccionesByCliente(Long idCliente);

}
