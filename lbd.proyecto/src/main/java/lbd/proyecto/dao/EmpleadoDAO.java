package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.sql.Date;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Empleado;
import org.springframework.data.repository.query.Param;

public interface EmpleadoDAO extends JpaRepository<Empleado, Long> {

    // Method to call an stored procedure to insert an employee
    @Procedure(procedureName = "FIDE_EMPLEADOS_TB_INSERTAR_SP")
    void insertEmpleado(String nombre, String apellido, Date fechaNacimiento, Date fechaContratacion, String idPuesto, Long idEstado);

    // Method to call an stored procedure to update an employee
    @Procedure(procedureName = "FIDE_EMPLEADOS_TB_ACTUALIZAR_SP")
    void updateEmpleado(
        @Param("P_ID_EMPLEADO") Long idEmpleado, 
        @Param("P_NOMBRE") String nombre, 
        @Param("P_APELLIDO") String apellido, 
        @Param("P_FECHA_NACIMIENTO") Date fechaNacimiento, 
        @Param("P_FECHA_CONTRATACION") Date fechaContratacion, 
        @Param("P_ID_PUESTO") String idPuesto, 
        @Param("P_ID_ESTADO") Long idEstado
    );

    // Method to call an stored procedure to delete an employee
    @Procedure(procedureName = "FIDE_EMPLEADOS_TB_INACTIVAR_SP")
    void inactivarEmpleado(Long idEmpleado);

    
}
