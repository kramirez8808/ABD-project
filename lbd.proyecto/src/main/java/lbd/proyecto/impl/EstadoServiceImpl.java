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
import lbd.proyecto.dao.EstadoDAO;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

@Service
public class EstadoServiceImpl implements EstadoService {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Estado getEstado(Estado estado) {

        return transactionTemplate.execute(new TransactionCallback<Estado>() {
            @Override
            public Estado doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_estado"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_estado");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_estado", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_descripcion", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_estado", estado.getIdEstado());

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
                System.out.println("Descripcion: " + query.getOutputParameterValue("p_descripcion"));

                // Map the output parameters to a Estado object
                Estado estadoResult = new Estado();
                estadoResult.setIdEstado(estado.getIdEstado());
                estadoResult.setDescripcion((String) query.getOutputParameterValue("p_descripcion"));

                System.out.println("Id: " + estadoResult.getIdEstado());

                return estadoResult;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Estado> getAllEstados() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_estados"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_estados", Estado.class);

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

        // Create a list of states
        List<Estado> estados = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                Estado estado = new Estado();
                estado.setIdEstado(resultSet.getLong("id_estado"));
                estado.setDescripcion(resultSet.getString("descripcion"));
                estados.add(estado);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return estados;
    }
    
}
