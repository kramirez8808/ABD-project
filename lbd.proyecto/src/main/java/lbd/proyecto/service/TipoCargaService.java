package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.TipoCarga;

public interface TipoCargaService {

    // Method to get a type of load with the Stored Procedure
    TipoCarga getTipoCarga(TipoCarga tipoCarga);

    // Method to get all types of load with the Stored Procedure
    List<TipoCarga> getAllTiposCarga();
    
}
