package lbd.proyecto.impl;

// External imports
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import lbd.proyecto.dao.EmpleadoDAO;
// Internal imports
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.service.PuestoService;

@Service
public class EmpleadoServiceImpl implements EmpleadoService {

    @Autowired
    private PuestoService puestoService;

    @Autowired
    private EmpleadoDAO empleadoDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertEmpleado(Empleado empleado) {
        empleadoDAO.insertEmpleado(empleado.getNombre(), empleado.getApellido(), empleado.getFechaNacimiento(),
                empleado.getFechaContratacion(), empleado.getPuesto().getIdPuesto());
    }

    @Override
    @Transactional
    public void updateEmpleado(Long idEmpleado, Empleado empleado) {
        empleadoDAO.updateEmpleado(idEmpleado, empleado.getNombre(), empleado.getApellido(), empleado.getFechaNacimiento(),
                empleado.getFechaContratacion(), empleado.getPuesto().getIdPuesto());
    }

    @Override
    @Transactional
    public void deleteEmpleado(Long idEmpleado) {
        empleadoDAO.deleteEmpleado(idEmpleado);
    }

    @Override
    public Empleado getEmpleado(Empleado empleado) {

        return transactionTemplate.execute(new TransactionCallback<Empleado>() {
            @Override
            public Empleado doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_empleado"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_empleado");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_empleado", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_apellido", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_fecha_nacimiento", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_fecha_contratacion", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_puesto", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_empleado", empleado.getIdEmpleado());

                // Execute the stored procedure
                try {
                    query.execute();
                } catch (PersistenceException e) {
                    if (e.getCause() instanceof SQLException) {
                        // Handle the SQLException
                        SQLException sqlException = (SQLException) e.getCause();
                        System.err.println("Error Code: " + sqlException.getErrorCode());
                        System.err.println("SQL State: " + sqlException.getSQLState());
                        System.err.println("Message: " + sqlException.getMessage());
                        status.setRollbackOnly();
                        return null;
                    } else {
                        throw e;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Print the output parameters
                // System.out.println("Output Parameters:");
                // System.out.println("Nombre: " + query.getOutputParameterValue("p_nombre"));
                // System.out.println("Apellido: " + query.getOutputParameterValue("p_apellido"));
                // System.out.println("Fecha de Nacimiento: " + query.getOutputParameterValue("p_fecha_nacimiento"));
                // System.out.println("Fecha de Contratacion: " + query.getOutputParameterValue("p_fecha_contratacion"));
                // System.out.println("ID Puesto: " + query.getOutputParameterValue("p_id_puesto"));

                // Map the output parameters to an Empleado object
                Empleado newEmpleado = new Empleado();
                newEmpleado.setIdEmpleado(empleado.getIdEmpleado());
                newEmpleado.setNombre((String) query.getOutputParameterValue("p_nombre"));
                newEmpleado.setApellido((String) query.getOutputParameterValue("p_apellido"));
                newEmpleado.setFechaNacimiento((Date) query.getOutputParameterValue("p_fecha_nacimiento"));
                newEmpleado.setFechaContratacion((Date) query.getOutputParameterValue("p_fecha_contratacion"));

                // Map the job to the Empleado object
                Puesto puesto = new Puesto();
                puesto.setIdPuesto((String) query.getOutputParameterValue("p_id_puesto"));
                Puesto newPuesto = puestoService.getPuesto(puesto);

                newEmpleado.setPuesto(newPuesto);

                return newEmpleado;

            }
        });

    }

    @Override
    @Transactional(readOnly = true)
    public List<Empleado> getAllEmpleados () {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_empleados"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_empleados", Empleado.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        try {
            query.execute();
        } catch (PersistenceException e) {
            if (e.getCause() instanceof SQLException) {
                // Handle the SQLException
                SQLException sqlException = (SQLException) e.getCause();
                System.err.println("Error Code: " + sqlException.getErrorCode());
                System.err.println("SQL State: " + sqlException.getSQLState());
                System.err.println("Message: " + sqlException.getMessage());
                return null;
            } else {
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list to store the employees
        List<Empleado> empleados = new ArrayList<>();

        // Iterate over the ResultSet
        try {
            while (rs.next()) {
                Empleado empleado = new Empleado();
                empleado.setIdEmpleado(rs.getLong("id_empleado"));
                empleado.setNombre(rs.getString("nombre"));
                empleado.setApellido(rs.getString("apellido"));
                empleado.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                empleado.setFechaContratacion(rs.getDate("fecha_contratacion"));
                
                // Map the job to the Empleado object
                Puesto puesto = new Puesto();
                puesto.setIdPuesto(rs.getString("id_puesto"));
                Puesto newPuesto = puestoService.getPuesto(puesto);

                empleado.setPuesto(newPuesto);

                empleados.add(empleado);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return empleados;

    }

    //Function to get the date returned by the HTML input and convert it to a java.sql.Date
    public java.sql.Date convertDate(String input) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dt = sdf.parse(input);
            java.sql.Date sqlDate = new java.sql.Date(dt.getTime());

            return sqlDate;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        
        
    }
    
}
