package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Canton;

public interface CantonService {
    
    // Method to get a canton with the Stored Procedure
    Canton getCanton(Canton canton);

    // Method to get all cantons with the Stored Procedure
    List<Canton> getAllCantones();

}
