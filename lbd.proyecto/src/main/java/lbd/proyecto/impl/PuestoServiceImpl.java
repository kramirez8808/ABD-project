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
import lbd.proyecto.domain.Estado;
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
                // Crear una instancia de StoredProcedureQuery para el procedimiento almacenado "ver_puesto"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PUESTOS_TB_VER_PUESTO_SP");

                // Registrar los parámetros de entrada y salida
                query.registerStoredProcedureParameter("P_ID_PUESTO", String.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_DESCRIPCION", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_SALARIO", BigDecimal.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT); // Cambiado a Long

                // Establecer el parámetro de entrada
                query.setParameter("P_ID_PUESTO", puesto.getIdPuesto());

                // Ejecutar el procedimiento almacenado
                try {
                    query.execute();
                } catch (PersistenceException e) {
                    handlePersistenceException(e, status);
                    return null;
                }

                // Mapear los parámetros de salida a un objeto Puesto
                Puesto puestoResult = new Puesto();
                puestoResult.setIdPuesto(puesto.getIdPuesto());
                puestoResult.setSalario(((BigDecimal) query.getOutputParameterValue("P_SALARIO")).doubleValue());
                puestoResult.setDescripcion((String) query.getOutputParameterValue("P_DESCRIPCION"));

                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO"); // Cambiado a Long

                // Buscar el estado en la base de datos usando el idEstado
                Estado estado = entityManager.find(Estado.class, estadoId); // Buscar el estado por idEstado

                puestoResult.setEstado(estado); // Asignar el objeto Estado al puesto

                return puestoResult;
            }
        });
    }



    @Override
    @Transactional(readOnly = true)
    public List<Puesto> getAllPuestos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_puestos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PUESTOS_TB_VER_PUESTOS_SP", Puesto.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        try {
            query.execute();
        } catch (PersistenceException e) {
            handlePersistenceException(e, null);
            return new ArrayList<>();
        }

        // Get the result set
        ResultSet resultSet = (ResultSet) query.getOutputParameterValue(1);

        // Use a RowMapper to map the result set to a list of Puesto objects
        List<Puesto> puestos = new ArrayList<>();
        try {
            while (resultSet.next()) {
                Puesto puesto = mapPuestoFromResultSet(resultSet);
                puestos.add(puesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        return puestos;
    }

    private void handlePersistenceException(PersistenceException e, TransactionStatus status) {
        if (e.getCause() instanceof SQLException) {
            SQLException sqlException = (SQLException) e.getCause();
            System.err.println("Error Code: " + sqlException.getErrorCode());
            System.err.println("SQL State: " + sqlException.getSQLState());
            System.err.println("Message: " + sqlException.getMessage());
            if (status != null) {
                status.setRollbackOnly();
            }
        } else {
            throw e; // Re-throw if the exception is not an SQL exception
        }
    }

    private Puesto mapPuestoFromResultSet(ResultSet resultSet) throws SQLException {
        Puesto puesto = new Puesto();
        puesto.setIdPuesto(resultSet.getString("id_puesto"));
        puesto.setSalario(resultSet.getDouble("salario"));
        puesto.setDescripcion(resultSet.getString("descripcion"));
        // You can map additional fields as needed, e.g. Estado
        return puesto;
    }
}
