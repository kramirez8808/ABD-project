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
    @Procedure(procedureName = "FIDE_DIRECCIONES_EMPLEADO_TB_INSERTAR_SP")
    void insertDireccionEmpleado(Long idEmpleado, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstado);

    // Method to call an stored procedure to update a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_EMPLEADO_TB_ACTUALIZAR_SP")
    void updateDireccionEmpleado(Long idDireccion, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstados);

    // Method to call an stored procedure to delete a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_EMPLEADO_TB_INACTIVAR_SP")
    void inactivarDireccionEmpleado(Long idDireccion);

    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECION_SP")
    DireccionEmpleado getDireccionEmpleado(Long idDireccion);

    // Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECIONES_SP")
    List<DireccionEmpleado> getAllDireccionesEmpleado();

    // Method to call a SQL function to get all the directions by employee ID
    @Query(value = "SELECT * FROM TABLE(FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN(:p_id_empleado))", nativeQuery = true)
    List<DireccionEmpleado> buscarDireccionesEmpleado(@Param("p_id_empleado") Long idEmpleado);
    
}
