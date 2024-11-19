package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.sql.Date;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.LicenciaEmpleado;

public interface LicenciaEmpleadoDAO extends JpaRepository<LicenciaEmpleado, Long> {

    // Method to call an stored procedure to insert a new license for an employee
    @Procedure(procedureName = "FIDE_LICENCIAS_EMPLEADO_TB_INSERTAR_SP")
    void insertLicenciaEmpleado(Long idEmpleado, Long idLicencia, Date fechaExpedicion, Date fechaVencimiento, Long idEstado);

    // Method to call an stored procedure to update a license for an employee
    @Procedure(procedureName = "FIDE_LICENCIAS_EMPLEADO_TB_ACTUALIZAR_SP")
    void updateLicenciaEmpleado(Long idLicenciaEmpleado, Long idLicencia, Date fechaInicio, Date fechaFin, Long idEstado);

    // Method to call an stored procedure to delete a license for an employee
    @Procedure(procedureName = "FIDE_LICENCIAS_EMPLEADO_TB_INACTIVAR_SP")
    void inactivarLicenciaEmpleado(Long idLicencia);

    // Method to call an stored procedure to get a (single) license for an employee
    @Procedure(procedureName = "FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIA_SP")
    LicenciaEmpleado getLicenciaEmpleado(Long idLicencia);

    // Method to call an stored procedure to get all licenses for employees
    @Procedure(procedureName = "FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIAS_SP")
    List<LicenciaEmpleado> getAllLicenciasEmpleado();

    // Method to call a SQL function to get all the licenses by employee ID
    @Query(value = "SELECT * FROM TABLE(FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(:p_id_empleado))", nativeQuery = true)
    List<LicenciaEmpleado> buscarLicenciasEmpleado(@Param("p_id_empleado") Long idEmpleado);
    
}
