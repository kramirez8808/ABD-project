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
import lbd.proyecto.dao.TipoCargaDAO;
import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.service.TipoCargaService;

@Service
public class TipoCargaServiceImpl implements TipoCargaService {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public TipoCarga getTipoCarga(TipoCarga tipoCarga) {

        return transactionTemplate.execute(new TransactionCallback<TipoCarga>() {
            @Override
            public TipoCarga doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_tipo_carga"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_tipo_carga");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_tipo", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_descripcion", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_tipo", tipoCarga.getIdTipo());
                System.out.println(" ----- TEST 1 ------");
                System.out.println(tipoCarga.toString());

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
                System.out.println("Tipo: " + query.getOutputParameterValue("p_descripcion"));

                // Map the output parameters to a TipoCarga object
                TipoCarga tipoCargaResult = new TipoCarga();
                tipoCargaResult.setIdTipo(tipoCarga.getIdTipo());
                tipoCargaResult.setDescripcion((String) query.getOutputParameterValue("p_descripcion"));

                return tipoCargaResult;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<TipoCarga> getAllTiposCarga() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_tipos_carga"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_tipos_carga", TipoCarga.class);

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

        // Create a list of loads
        List<TipoCarga> tiposCarga = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                TipoCarga tipoCarga = new TipoCarga();
                tipoCarga.setIdTipo(resultSet.getLong("id_tipo"));
                tipoCarga.setDescripcion(resultSet.getString("descripcion"));
                tiposCarga.add(tipoCarga);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return tiposCarga;
    }
    
}
