package lbd.proyecto.impl;

// External imports
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.ssl.JksSslBundleProperties.Store;
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
import lbd.proyecto.dao.LicenciaDAO;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.service.LicenciaService;

@Service
public class LicenciaServiceImpl implements LicenciaService {
    
    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Licencia getLicencia(Licencia licencia) {

        return transactionTemplate.execute(new TransactionCallback<Licencia>() {
            @Override
            public Licencia doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_licencia"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_licencia");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_licencia", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_tipo", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_licencia", licencia.getIdLicencia());

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

                // Print the output parameter
                System.out.println("Tipo: " + query.getOutputParameterValue("p_tipo"));

                // Map the output parameters to a Licencia object
                Licencia licenciaResult = new Licencia();
                licenciaResult.setIdLicencia(licencia.getIdLicencia());
                licenciaResult.setTipo((String) query.getOutputParameterValue("p_tipo"));

                return licenciaResult;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Licencia> getAllLicencias() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_licencias"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_licencias", Licencia.class);

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
        }

        // Get the result set
        ResultSet resultSet = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of licenses
        List<Licencia> licencias = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                Licencia licencia = new Licencia();
                licencia.setIdLicencia(resultSet.getLong("id_licencia"));
                licencia.setTipo(resultSet.getString("tipo"));
                licencias.add(licencia);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return licencias;

    }
}
