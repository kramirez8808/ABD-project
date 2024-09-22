package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Estado;

public interface EstadoService {

    // Method to get a license with the Stored Procedure
    Estado getEstado(Estado estado);

    // Method to get all licenses with the Stored Procedure
    List<Estado> getAllEstados();
    
}
