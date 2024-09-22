package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Puesto;

public interface PuestoService {
    
    // Method to get a license with the Stored Procedure
    Puesto getPuesto(Puesto puesto);

    // Method to get all licenses with the Stored Procedure
    List<Puesto> getAllPuestos();
    
}
