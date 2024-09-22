package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Provincia;

public interface ProvinciaService {

    // Method to get a province with the Stored Procedure
    Provincia getProvincia(Provincia provincia);

    // Method to get all provinces with the Stored Procedure
    List<Provincia> getAllProvincias();
    
}
