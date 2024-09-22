package lbd.proyecto.impl.direcciones;

// External imports
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.hibernate.Session;
import org.hibernate.jdbc.Work;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.dao.direcciones.DireccionEmpleadoDAO;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.service.direcciones.DireccionEmpleadoService;

import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.dao.EmpleadoDAO;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.dao.direcciones.DistritoDAO;

@Service
public class DireccionEmpleadoServiceImpl implements DireccionEmpleadoService {

    @Autowired
    private DireccionEmpleadoDAO direccionEmpleadoDAO;

    @Autowired
    private EmpleadoService empleadoService;

    @Autowired
    private DistritoService distritoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertDireccionEmpleado(DireccionEmpleado direccionEmpleado, Empleado empleado, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        direccionEmpleadoDAO.insertDireccionEmpleado(empleadoResult.getIdEmpleado(), direccionEmpleado.getDetalles(),
                distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());
    }

    @Override
    @Transactional
    public void updateDireccionEmpleado(DireccionEmpleado direccionEmpleado, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        direccionEmpleadoDAO.updateDireccionEmpleado(direccionEmpleado.getIdDireccion(), direccionEmpleado.getDetalles(),
                distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());
    }

    @Override
    @Transactional
    public void deleteDireccionEmpleado(DireccionEmpleado direccionEmpleado) {
        direccionEmpleadoDAO.deleteDireccionEmpleado(direccionEmpleado.getIdDireccion());
    }

    @Override
    @Transactional
    public DireccionEmpleado getDireccionEmpleado(DireccionEmpleado direccionEmpleado) {
        return transactionTemplate.execute(new TransactionCallback<DireccionEmpleado>() {
            @Override
            public DireccionEmpleado doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_direccion_empleado"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direccion_empleado");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_direccion", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_id_empleado", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_detalles", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_distrito", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_direccion", direccionEmpleado.getIdDireccion());

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
                }

                //Print the Output Parameters
                // System.out.println("Detalles: " + query.getOutputParameterValue("p_detalles"));

                // Map the output parameters to a DireccionEmpleado object
                DireccionEmpleado newDireccionEmpleado  = new DireccionEmpleado();
                newDireccionEmpleado.setIdDireccion(direccionEmpleado.getIdDireccion());
                newDireccionEmpleado.setDetalles((String) query.getOutputParameterValue("p_detalles"));
                System.out.println(" *** TEST ***");
                System.out.println("p_detalles: " + query.getOutputParameterValue("p_detalles"));
                System.out.println("p_id_distrito: " + query.getOutputParameterValue("p_id_distrito"));
                // System.out.println("p_id_distrito: " + query.getOutputParameterValue("p_id_distrito"));
                // System.out.println("p_id_empleado: " + query.getOutputParameterValue("p_id_empleado"));

                // Map the empleado to the Empleado object
                Empleado empleado = new Empleado();
                empleado.setIdEmpleado((Long) query.getOutputParameterValue("p_id_empleado"));
                newDireccionEmpleado.setEmpleado(empleadoService.getEmpleado(empleado));

                // Map the distrito to the Distrito object
                Distrito distrito = new Distrito();
                distrito.setIdDistrito((Long) query.getOutputParameterValue("p_id_distrito"));
                // System.out.println(" *** TEST ***");
                // System.out.println("distrito.getIdDistrito(): " + distrito.getIdDistrito());

                newDireccionEmpleado.setDistrito(distritoService.getDistrito(distrito));

                return newDireccionEmpleado;

            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionEmpleado> getAllDirecciones() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_direcciones_empleados"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direcciones_empleados");

        // Register the output parameters
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
        }

        // Get the result set
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list to store the results
        List<DireccionEmpleado> direcciones = new ArrayList<>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                DireccionEmpleado direccion = new DireccionEmpleado();
                direccion.setIdDireccion(rs.getLong("id_direccion"));
                direccion.setDetalles(rs.getString("detalles"));

                Distrito distrito = new Distrito();
                distrito.setIdDistrito(rs.getLong("id_distrito"));
                direccion.setDistrito(distritoService.getDistrito(distrito));

                Empleado empleado = new Empleado();
                empleado.setIdEmpleado(rs.getLong("id_empleado"));
                direccion.setEmpleado(empleadoService.getEmpleado(empleado));

                direcciones.add(direccion);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return direcciones;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<DireccionEmpleado> searchDireccionesByEmpleado(Long idEmpleado) {
        Session session = entityManager.unwrap(Session.class);
        List<DireccionEmpleado> direcciones = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call buscar_direcciones_por_empleado(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idEmpleado);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            DireccionEmpleado direccion = new DireccionEmpleado();
                            direccion.setIdDireccion(rs.getLong("id_direccion"));
                            direccion.setDetalles(rs.getString("detalles"));

                            Distrito distrito = new Distrito();
                            distrito.setIdDistrito(rs.getLong("id_distrito"));
                            direccion.setDistrito(distritoService.getDistrito(distrito));

                            Empleado empleado = new Empleado();
                            empleado.setIdEmpleado(rs.getLong("id_empleado"));
                            direccion.setEmpleado(empleadoService.getEmpleado(empleado));

                            direcciones.add(direccion);
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        return direcciones;
    }


}
