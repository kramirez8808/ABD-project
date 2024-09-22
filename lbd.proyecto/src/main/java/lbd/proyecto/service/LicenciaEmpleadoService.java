package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Licencia;

public interface LicenciaEmpleadoService {
    
    // Method to save a new license for an employee with the Stored Procedure
    void insertLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado, Empleado empleado, Licencia licencia);

    // Method to update a license for an employee with the Stored Procedure
    void updateLicenciaEmpleado(Licencia licencia, LicenciaEmpleado licenciaEmpleado);

    // Method to delete a license for an employee with the Stored Procedure
    void deleteLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado);

    // Method to get a license for an employee with the Stored Procedure
    LicenciaEmpleado getLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado);

    // Method to get all licenses for employees with the Stored Procedure
    List<LicenciaEmpleado> getAllLicenciasEmpleados();

    // Method to search licenses by employee ID with the SQL function
    List<LicenciaEmpleado> searchLicenciasByEmpleado(Long idEmpleado);

}
