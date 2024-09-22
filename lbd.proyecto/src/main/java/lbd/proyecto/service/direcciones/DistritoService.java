package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Distrito;

public interface DistritoService {
    
    // Method to get a distrito with the Stored Procedure
    Distrito getDistrito(Distrito distrito);

    // Method to get all distritos with the Stored Procedure
    List<Distrito> getAllDistritos();

}
