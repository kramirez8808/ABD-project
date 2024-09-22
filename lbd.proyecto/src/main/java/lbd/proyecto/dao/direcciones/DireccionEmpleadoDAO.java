package lbd.proyecto.dao.direcciones;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionEmpleado;

public interface DireccionEmpleadoDAO extends JpaRepository<DireccionEmpleado, Long> {
    
    // Method to call an stored procedure to insert a new direction
    @Procedure(procedureName = "insertar_direccion_empleado")
    void insertDireccionEmpleado(Long idEmpleado, String detalles, Long idProvincia, Long idCanton, Long idDistrito);

    // Method to call an stored procedure to update a direction
    @Procedure(procedureName = "actualizar_direccion_empleado")
    void updateDireccionEmpleado(Long idDireccion, String detalles, Long idProvincia, Long idCanton, Long idDistrito);

    // Method to call an stored procedure to delete a direction
    @Procedure(procedureName = "eliminar_direccion_empleado")
    void deleteDireccionEmpleado(Long idDireccion);

    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "ver_direccion_empleado")
    DireccionEmpleado getDireccionEmpleado(Long idDireccion);

    // Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "ver_direcciones_empleados")
    List<DireccionEmpleado> getAllDireccionesEmpleado();

    // Method to call a SQL function to get all the directions by employee ID
    @Query(value = "SELECT * FROM TABLE(buscar_direcciones_empleado(:p_id_empleado))", nativeQuery = true)
    List<DireccionEmpleado> buscarDireccionesEmpleado(@Param("p_id_empleado") Long idEmpleado);
    
}
