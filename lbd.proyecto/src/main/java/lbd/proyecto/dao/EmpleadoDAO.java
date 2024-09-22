package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.sql.Date;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Empleado;

public interface EmpleadoDAO extends JpaRepository<Empleado, Long> {
    
    // Method to call an stored procedure to get a (single) employee
    @Procedure(procedureName = "ver_empleado")
    Empleado getEmpleado(Long idEmpleado);
    
    // Method to call an stored procedure to get all employees
    @Procedure(procedureName = "ver_empleados")
    List<Empleado> getAllEmpleados();

    // Method to call an stored procedure to insert an employee
    @Procedure(procedureName = "insertar_empleado")
    void insertEmpleado(String nombre, String apellido, Date fechaNacimiento, Date fechaContratacion, String idPuesto);

    // Method to call an stored procedure to update an employee
    @Procedure(procedureName = "actualizar_empleado")
    void updateEmpleado(Long idEmpleado, String nombre, String apellido, Date fechaNacimiento, Date fechaContratacion, String idPuesto);

    // Method to call an stored procedure to delete an employee
    @Procedure(procedureName = "eliminar_empleado")
    void deleteEmpleado(Long idEmpleado);

    
}
