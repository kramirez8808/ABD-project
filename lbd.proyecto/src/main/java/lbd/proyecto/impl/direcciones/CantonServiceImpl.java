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
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.ProvinciaService;
import lbd.proyecto.service.direcciones.CantonService;

@Service
public class CantonServiceImpl implements CantonService {

    @Autowired
    private ProvinciaService provinciaService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Canton getCanton(Canton canton) {

        return transactionTemplate.execute(new TransactionCallback<Canton>() {
            @Override
            public Canton doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "canton"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_canton");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_canton", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_provincia", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_canton", canton.getIdCanton());

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

                // Map the output parameters to a Canton object
                Canton newCanton = new Canton();
                newCanton.setIdCanton(canton.getIdCanton());
                newCanton.setNombre((String) query.getOutputParameterValue("p_nombre"));

                // Map the province to the Canton object
                Provincia provincia = new Provincia();
                provincia.setIdProvincia((Long) query.getOutputParameterValue("p_id_provincia"));
                Provincia newProvincia = provinciaService.getProvincia(provincia);                

                newCanton.setProvincia(newProvincia);

                return newCanton;
            }
        });

    }

    @Override
    @Transactional(readOnly = true)
    public List<Canton> getAllCantones() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_cantones"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_cantones", Canton.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        query.execute();

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of cantons
        List<Canton> cantones = new ArrayList<>();

        // Iterate over the ResultSet and add the cantons to the list
        try {
            while (rs.next()) {
                Canton canton = new Canton();
                canton.setIdCanton(rs.getLong("id_canton"));
                canton.setNombre(rs.getString("nombre"));

                // Map the province to the Canton object
                Provincia provincia = new Provincia();
                provincia.setIdProvincia(rs.getLong("id_provincia"));
                Provincia newProvincia = provinciaService.getProvincia(provincia);                

                canton.setProvincia(newProvincia);

                cantones.add(canton);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cantones;
    }

}
