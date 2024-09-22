package lbd.proyecto.impl.direcciones;

// External imports
import java.util.List;
import java.util.ArrayList;

import org.checkerframework.checker.units.qual.A;
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
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.ProvinciaService;
import lbd.proyecto.service.direcciones.CantonService;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;

@Service
public class DistritoServiceImpl implements DistritoService {
    
    @Autowired
    private CantonService cantonService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public Distrito getDistrito(Distrito distrito) {

        return transactionTemplate.execute(new TransactionCallback<Distrito>() {
            @Override
            public Distrito doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_distrito"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_distrito");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_distrito", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_canton", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_distrito", distrito.getIdDistrito());

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
                // System.out.println("Nombre: " + query.getOutputParameterValue("p_nombre"));

                // Map the output parameters to a Distrito object
                Distrito newDistrito = new Distrito();
                newDistrito.setIdDistrito(distrito.getIdDistrito());
                newDistrito.setNombre((String) query.getOutputParameterValue("p_nombre"));

                // Map the canton to the Canton object
                Canton canton = new Canton();
                canton.setIdCanton((Long) query.getOutputParameterValue("p_id_canton"));
                newDistrito.setCanton(cantonService.getCanton(canton));

                return newDistrito;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Distrito> getAllDistritos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_distritos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_distritos");

        // Register the output parameters
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        query.execute();

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of districts
        List<Distrito> distritos = new ArrayList<Distrito>();

        // Iterate over the ResultSet and add the districts to the list
        try {
            while (rs.next()) {
                Distrito distrito = new Distrito();
                distrito.setIdDistrito(rs.getLong("id_distrito"));
                distrito.setNombre(rs.getString("nombre"));

                // Map the canton to the Canton object
                Canton canton = new Canton();
                canton.setIdCanton(rs.getLong("id_canton"));
                Canton newCanton = cantonService.getCanton(canton);

                distrito.setCanton(newCanton);

                distritos.add(distrito);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return distritos;

    }

}
