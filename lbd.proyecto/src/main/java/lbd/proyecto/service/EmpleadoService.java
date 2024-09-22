package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Empleado;

public interface EmpleadoService {

    // Method to get a employee with the Stored Procedure
    Empleado getEmpleado(Empleado empleado);

    // Method to get all employees with the Stored Procedure
    List<Empleado> getAllEmpleados();

    // Method to save a new employee with the Stored Procedure
    void insertEmpleado(Empleado empleado);

    // Method to update a employee with the Stored Procedure
    void updateEmpleado(Long idEmpleado, Empleado empleado);

    // Method to delete a employee with the Stored Procedure
    void deleteEmpleado(Long idEmpleado);

    // Method to convert a string to a Date
    public java.sql.Date convertDate(String input);

    
}
