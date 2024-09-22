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
import org.checkerframework.checker.units.qual.A;
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
import lbd.proyecto.dao.VehiculoDAO;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.VehiculoService;

@Service
public class VehiculoServiceImpl implements VehiculoService {
    
    @Autowired
    private VehiculoDAO vehiculoDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertVehiculo(Vehiculo vehiculo) {
        vehiculoDAO.insertVehiculo(vehiculo.getMarca(), vehiculo.getModelo(), vehiculo.getAnio(), vehiculo.getPlaca());
    }

    @Override
    @Transactional
    public void updateVehiculo(Long idVehiculo, Vehiculo vehiculo) {
        vehiculoDAO.updateVehiculo(idVehiculo, vehiculo.getMarca(), vehiculo.getModelo(), vehiculo.getAnio(), vehiculo.getPlaca());
    }

    @Override
    @Transactional
    public void deleteVehiculo(Long idVehiculo) {
        vehiculoDAO.deleteVehiculo(idVehiculo);
    }

    @Override
    public Vehiculo getVehiculo(Vehiculo vehiculo) {

        return transactionTemplate.execute(new TransactionCallback<Vehiculo>() {
            @Override
            public Vehiculo doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_vehiculo"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_vehiculo");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_vehiculo", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_marca", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_modelo", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_anio", Integer.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_placa", String.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_vehiculo", vehiculo.getIdVehiculo());

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

                // Print the output parameters
                System.out.println("Marca: " + query.getOutputParameterValue("p_marca"));
                System.out.println("Modelo: " + query.getOutputParameterValue("p_modelo"));

                // Map the output parameters to a Vehiculo object
                Vehiculo vehiculoResult = new Vehiculo();
                vehiculoResult.setIdVehiculo(vehiculo.getIdVehiculo());
                vehiculoResult.setMarca((String) query.getOutputParameterValue("p_marca"));
                vehiculoResult.setModelo((String) query.getOutputParameterValue("p_modelo"));
                vehiculoResult.setAnio((Integer) query.getOutputParameterValue("p_anio"));
                vehiculoResult.setPlaca((String) query.getOutputParameterValue("p_placa"));

                return vehiculoResult;
                
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Vehiculo> getAllVehiculos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_vehiculos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_vehiculos", Vehiculo.class);

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

        // Create a list of vehicles
        List<Vehiculo> vehiculos = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                Vehiculo vehiculo = new Vehiculo();
            vehiculo.setIdVehiculo(resultSet.getLong("id_vehiculo"));
            vehiculo.setMarca(resultSet.getString("marca"));
            vehiculo.setModelo(resultSet.getString("modelo"));
            vehiculo.setAnio(resultSet.getInt("anio"));
            vehiculo.setPlaca(resultSet.getString("placa"));
            vehiculos.add(vehiculo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return vehiculos;
    }
}
