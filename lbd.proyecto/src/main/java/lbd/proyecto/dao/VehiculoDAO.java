package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Vehiculo;
import oracle.net.aso.v;

public interface VehiculoDAO extends JpaRepository<Vehiculo, Long> {
    
    // Method to call an stored procedure to get a (single) vehicle
    @Procedure(procedureName = "ver_vehiculo")
    Vehiculo getVehiculo(Long idVehiculo);

    //Method to call an stored procedure to get all vehicles
    @Procedure(procedureName = "ver_vehiculos")
    List<Vehiculo> getAllVehiculos();

    // Method to call an stored procedure to insert a new vehicle
    @Procedure(procedureName = "insertar_vehiculo")
    void insertVehiculo(String marca, String modelo, Integer anio, String placa);

    // Method to call an stored procedure to update a vehicle
    @Procedure(procedureName = "actualizar_vehiculo")
    void updateVehiculo(Long idVehiculo, String marca, String modelo, Integer anio, String placa);

    // Method to call an stored procedure to delete a vehicle
    @Procedure(procedureName = "eliminar_vehiculo")
    void deleteVehiculo(Long idVehiculo);
    
}
