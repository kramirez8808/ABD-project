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

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.ResultSet;
import java.sql.SQLException;

// Internal imports
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.ProvinciaService;

@Service
public class ProvinciaServiceImpl implements ProvinciaService {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Provincia getProvincia(Provincia provincia) {
        
        return transactionTemplate.execute(new TransactionCallback<Provincia>() {
            @Override
            public Provincia doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "provincia"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_provincia");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_provincia", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_provincia", provincia.getIdProvincia());

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
                System.out.println("Nombre: " + query.getOutputParameterValue("p_nombre"));

                // Map the output parameters to a Provincia object
                Provincia newProvincia = new Provincia();
                newProvincia.setIdProvincia(provincia.getIdProvincia());
                newProvincia.setNombre((String) query.getOutputParameterValue("p_nombre"));

                return newProvincia;
            }
        });

    }

    @Override
    @Transactional(readOnly = true)
    public List<Provincia> getAllProvincias() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_provincias"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_provincias", Provincia.class);

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

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of clients
        List<Provincia> provincias = new ArrayList<>();

        // Iterate over the ResultSet and add the clients to the list
        try {
            while (rs.next()) {
                Provincia provincia = new Provincia();
                provincia.setIdProvincia(rs.getLong("id_provincia"));
                provincia.setNombre(rs.getString("nombre"));
                provincias.add(provincia);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return provincias;
    }
}
