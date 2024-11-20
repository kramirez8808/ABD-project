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
    @Procedure(procedureName = "FIDE_VEHICULOS_TB_VER_VEHICULO_SP")
    Vehiculo getVehiculo(Long idVehiculo);

    //Method to call an stored procedure to get all vehicles
    @Procedure(procedureName = "FIDE_VEHICULOS_TB_VER_VEHICULOS_SP")
    List<Vehiculo> getAllVehiculos();

    // Method to call an stored procedure to insert a new vehicle
    @Procedure(procedureName = "FIDE_VEHICULOS_TB_INSERTAR_SP")
    void insertVehiculo(String marca, String modelo, Integer anio, String placa, Long idEstado);

    // Method to call an stored procedure to update a vehicle
    @Procedure(procedureName = "FIDE_VEHICULOS_TB_ACTUALIZAR_SP")
    void updateVehiculo(Long idVehiculo, String marca, String modelo, Integer anio, String placa, Long idEstado);

    // Method to call an stored procedure to delete a vehicle
    @Procedure(procedureName = "FIDE_VEHICULOS_TB_INACTIVAR_SP")
    void inactivarVehiculo(Long idVehiculo);
    
}
