package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Vehiculo;

public interface VehiculoService {
    
    // Method to get a vehicle with the Stored Procedure
    Vehiculo getVehiculo(Vehiculo vehiculo);

    // Method to get all vehicles with the Stored Procedure
    List<Vehiculo> getAllVehiculos();

    // Method to save a new vehicle with the Stored Procedure
    void insertVehiculo(Vehiculo vehiculo);

    // Method to update a vehicle with the Stored Procedure
    void updateVehiculo(Long idVehiculo, Vehiculo vehiculo);

    // Method to delete a vehicle with the Stored Procedure
    void deleteVehiculo(Long idVehiculo);
    
}
