package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Licencia;

public interface LicenciaService {

    // Method to get a license with the Stored Procedure
    Licencia getLicencia(Licencia licencia);

    // Method to get all licenses with the Stored Procedure
    List<Licencia> getAllLicencias();
    
}
