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

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.dao.PuestoDAO;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.service.PuestoService;

@Service
public class PuestoServiceImpl implements PuestoService {
    
    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Puesto getPuesto(Puesto puesto) {
        return transactionTemplate.execute(new TransactionCallback<Puesto>() {
            @Override
            public Puesto doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_puesto"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_puesto");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_puesto", String.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_descripcion", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_salario", BigDecimal.class, ParameterMode.OUT);


                // Set the input parameter
                query.setParameter("p_id_puesto", puesto.getIdPuesto());

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
                // System.out.println("Puesto: " + query.getOutputParameterValue("p_descripcion"));
                // System.out.println("Tipo de p_salario: " + query.getOutputParameterValue("p_salario").getClass());

                // Map the output parameters to a Licencia object
                Puesto puestoResult = new Puesto();
                puestoResult.setIdPuesto(puesto.getIdPuesto());
                puestoResult.setSalario(((BigDecimal) query.getOutputParameterValue("p_salario")).doubleValue());
                puestoResult.setDescripcion((String) query.getOutputParameterValue("p_descripcion"));

                return puestoResult;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Puesto> getAllPuestos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_puestos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_puestos", Puesto.class);

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
        List<Puesto> puestos = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                Puesto puesto = new Puesto();
                puesto.setIdPuesto(resultSet.getString("id_puesto"));
                puesto.setSalario(resultSet.getDouble("salario"));
                puesto.setDescripcion(resultSet.getString("descripcion"));
                puestos.add(puesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return puestos;
    }
}
