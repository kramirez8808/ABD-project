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
import org.hibernate.Session;
import org.hibernate.jdbc.Work;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.dao.LicenciaEmpleadoDAO;
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.service.LicenciaEmpleadoService;

import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.dao.EmpleadoDAO;

import lbd.proyecto.domain.Licencia;
import lbd.proyecto.service.LicenciaService;
import lbd.proyecto.dao.LicenciaEmpleadoDAO;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

@Service
public class LicenciaEmpleadoServiceImpl implements LicenciaEmpleadoService {
    
    @Autowired
    private LicenciaEmpleadoDAO licenciaEmpleadoDAO;

    @Autowired
    private EmpleadoService empleadoService;

    @Autowired
    private LicenciaService licenciaService;
    
    @Autowired
    private EstadoService estadoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado, Empleado empleado, Licencia licencia) {
        Licencia licenciaResult = licenciaService.getLicencia(licencia);
        Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        licenciaEmpleadoDAO.insertLicenciaEmpleado(empleadoResult.getIdEmpleado(), licenciaResult.getIdLicencia(), licenciaEmpleado.getFechaExpedicion(), licenciaEmpleado.getFechaVencimiento(), licenciaEmpleado.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void updateLicenciaEmpleado(Licencia licencia, LicenciaEmpleado licenciaEmpleado) {
        Licencia licenciaResult = licenciaService.getLicencia(licencia);
        licenciaEmpleadoDAO.updateLicenciaEmpleado(licenciaEmpleado.getIdLicenciaEmpleado(), licenciaResult.getIdLicencia(), licenciaEmpleado.getFechaExpedicion(), licenciaEmpleado.getFechaVencimiento(), licenciaEmpleado.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void inactivarLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado) {
        licenciaEmpleadoDAO.inactivarLicenciaEmpleado(licenciaEmpleado.getIdLicenciaEmpleado());
    }

@Override
public LicenciaEmpleado getLicenciaEmpleado(LicenciaEmpleado licenciaEmpleado) {
    
    return transactionTemplate.execute(new TransactionCallback<LicenciaEmpleado>() {
        @Override
        public LicenciaEmpleado doInTransaction(TransactionStatus status) {
            // Create a StoredProcedureQuery instance for the stored procedure "FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIA_SP"
            StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIA_SP");

            // Register the input and output parameters
            query.registerStoredProcedureParameter("P_ID_LICENCIA_EMPLEADO", Long.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("P_ID_EMPLEADO", Long.class, ParameterMode.OUT);
            query.registerStoredProcedureParameter("P_ID_LICENCIA", Long.class, ParameterMode.OUT);
            query.registerStoredProcedureParameter("P_FECHA_EXPEDICION", Date.class, ParameterMode.OUT);
            query.registerStoredProcedureParameter("P_FECHA_VENCIMIENTO", Date.class, ParameterMode.OUT);
            query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);

            // Set the input parameter
            query.setParameter("P_ID_LICENCIA_EMPLEADO", licenciaEmpleado.getIdLicenciaEmpleado());

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

            // Map the output parameters to a LicenciaEmpleado object
            LicenciaEmpleado licenciaEmpleadoResult = new LicenciaEmpleado();
            licenciaEmpleadoResult.setIdLicenciaEmpleado(licenciaEmpleado.getIdLicenciaEmpleado());
            licenciaEmpleadoResult.setFechaExpedicion((Date) query.getOutputParameterValue("P_FECHA_EXPEDICION"));
            licenciaEmpleadoResult.setFechaVencimiento((Date) query.getOutputParameterValue("P_FECHA_VENCIMIENTO"));

            // Map the licencia to the LicenciaEmpleado object
            Long idLicencia = (Long) query.getOutputParameterValue("P_ID_LICENCIA");
            if (idLicencia != null) {
                Licencia licencia = new Licencia();
                licencia.setIdLicencia(idLicencia);
                licenciaEmpleadoResult.setLicencia(licenciaService.getLicencia(licencia));
            }

            // Map the empleado to the LicenciaEmpleado object
            Long idEmpleado = (Long) query.getOutputParameterValue("P_ID_EMPLEADO");
            if (idEmpleado != null) {
                Empleado empleado = new Empleado();
                empleado.setIdEmpleado(idEmpleado);
                licenciaEmpleadoResult.setEmpleado(empleadoService.getEmpleado(empleado));
            }

            // Map the estado to the LicenciaEmpleado object
            Long idEstado = (Long) query.getOutputParameterValue("P_ID_ESTADO");
            if (idEstado != null) {
                Estado estado = new Estado();
                estado.setIdEstado(idEstado);
                licenciaEmpleadoResult.setEstado(estadoService.getEstado(estado));
            }

            return licenciaEmpleadoResult;

        }
    });
}


@Override
@Transactional(readOnly = true)
public List<LicenciaEmpleado> getAllLicenciasEmpleados() {
    // Create a StoredProcedureQuery instance for the stored procedure "FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIAS_SP"
    StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIAS_SP");

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

    // Create a list to store the licenses for employees
    List<LicenciaEmpleado> licenciasEmpleados = new ArrayList<>();

    // Iterate over the result set
    try {
        while (rs.next()) {
            LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
            licenciaEmpleado.setIdLicenciaEmpleado(rs.getLong("id_licencia_empleado"));
            licenciaEmpleado.setFechaExpedicion(rs.getDate("fecha_expedicion"));
            licenciaEmpleado.setFechaVencimiento(rs.getDate("fecha_vencimiento"));

            // Map the licencia to the LicenciaEmpleado object
            Long idLicencia = rs.getLong("id_licencia");
            if (idLicencia != null) {
                Licencia licencia = new Licencia();
                licencia.setIdLicencia(idLicencia);
                licenciaEmpleado.setLicencia(licenciaService.getLicencia(licencia));
            }

            // Map the empleado to the LicenciaEmpleado object
            Long idEmpleado = rs.getLong("id_empleado");
            if (idEmpleado != null) {
                Empleado empleado = new Empleado();
                empleado.setIdEmpleado(idEmpleado);
                licenciaEmpleado.setEmpleado(empleadoService.getEmpleado(empleado));
            }

            // Map the estado to the LicenciaEmpleado object
            Long idEstado = rs.getLong("id_estado");
            if (idEstado != null) {
                Estado estado = new Estado();
                estado.setIdEstado(idEstado);
                licenciaEmpleado.setEstado(estadoService.getEstado(estado));
            }

            licenciasEmpleados.add(licenciaEmpleado);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return licenciasEmpleados;
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

    //Transacciones SP FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(?)
    @Override
    @Transactional(readOnly = true)
    public List<LicenciaEmpleado> searchLicenciasByEmpleado(Long idEmpleado) {
        Session session = entityManager.unwrap(Session.class);
        List<LicenciaEmpleado> licenciasEmpleados = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idEmpleado);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            LicenciaEmpleado licenciasEmpleado = new LicenciaEmpleado();
                            licenciasEmpleado.setIdLicenciaEmpleado(rs.getLong("id_licencia_empleado"));
                            licenciasEmpleado.setFechaExpedicion(rs.getDate("fecha_expedicion"));
                            licenciasEmpleado.setFechaVencimiento(rs.getDate("fecha_vencimiento"));

                            // Map the licencia to the LicenciaEmpleado object
                            Licencia licencia = new Licencia();
                            licencia.setIdLicencia(rs.getLong("id_licencia"));
                            licenciasEmpleado.setLicencia(licenciaService.getLicencia(licencia));

                            // Map the empleado to the LicenciaEmpleado object
                            Empleado empleado = new Empleado();
                            empleado.setIdEmpleado(rs.getLong("id_empleado"));
                            licenciasEmpleado.setEmpleado(empleadoService.getEmpleado(empleado));
                            
                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            licenciasEmpleado.setEstado(estadoService.getEstado(estado));
                            
                            licenciasEmpleados.add(licenciasEmpleado);

                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        return licenciasEmpleados;
        
    }

}
