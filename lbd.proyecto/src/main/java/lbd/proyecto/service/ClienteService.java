package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Cliente;

public interface ClienteService {
    
    // Method to save a new client with the Stored Procedure
    void insertCliente(Cliente cliente);

    // Method to update a client with the Stored Procedure
    void updateCliente(Long idCliente, Cliente cliente);

    // Method to get a client with the Stored Procedure
    Cliente getCliente(Cliente cliente);

    // Method to get all clients with the Stored Procedure
    List<Cliente> getAllClientes();

    // Method to delete a client with the Stored Procedure
    void deleteCliente(Long idCliente);

    // Method to search clients by string in name with the SQL function
    List<Cliente> searchClientesNombre(String nombre);

    // Method to search clients by string in email with the SQL function
    List<Cliente> searchClientesEmail(String email);
    
}
