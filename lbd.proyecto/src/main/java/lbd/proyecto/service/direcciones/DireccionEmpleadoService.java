package lbd.proyecto.service.direcciones;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.Empleado;

public interface DireccionEmpleadoService {

    // Method to save a new direction with the Stored Procedure
    void insertDireccionEmpleado(DireccionEmpleado direccionEmpleado, Empleado empleado, Distrito distrito);

    // Method to update a direction with the Stored Procedure
    void updateDireccionEmpleado(DireccionEmpleado direccionEmpleado, Distrito distrito);

    // Method to delete a direction with the Stored Procedure
    void deleteDireccionEmpleado(DireccionEmpleado direccionEmpleado);

    // Method to get a direction with the Stored Procedure
    DireccionEmpleado getDireccionEmpleado(DireccionEmpleado direccionEmpleado);

    // Method to get all directions with the Stored Procedure
    List<DireccionEmpleado> getAllDirecciones();

    // Method to search directions by employee ID with the SQL function
    List<DireccionEmpleado> searchDireccionesByEmpleado(Long idEmpleado);
    
}
