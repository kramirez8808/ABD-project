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
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.VehiculoService;

@Service
public class VehiculoServiceImpl implements VehiculoService {
    
    @Autowired
    private VehiculoDAO vehiculoDAO;

    @PersistenceContext
    private EntityManager entityManager;
    
    @Autowired
    private EstadoService estadoService;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertVehiculo(Vehiculo vehiculo) {
        vehiculoDAO.insertVehiculo(vehiculo.getMarca(), vehiculo.getModelo(), vehiculo.getAnio(), vehiculo.getPlaca(), vehiculo.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void updateVehiculo(Long idVehiculo, Vehiculo vehiculo) {
        vehiculoDAO.updateVehiculo(idVehiculo, vehiculo.getMarca(), vehiculo.getModelo(), vehiculo.getAnio(), vehiculo.getPlaca(), vehiculo.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void inactivarVehiculo(Long idVehiculo) {
        vehiculoDAO.inactivarVehiculo(idVehiculo);
    }

    @Override
    public Vehiculo getVehiculo(Vehiculo vehiculo) {
        return transactionTemplate.execute(new TransactionCallback<Vehiculo>() {
            @Override
            public Vehiculo doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_vehiculo"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_VEHICULOS_TB_VER_VEHICULO_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_VEHICULO", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_MARCA", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_MODELO", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ANIO", Integer.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_PLACA", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("P_ID_VEHICULO", vehiculo.getIdVehiculo());

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
                // System.out.println("Marca: " + query.getOutputParameterValue("P_MARCA"));
                // System.out.println("Modelo: " + query.getOutputParameterValue("P_MODELO"));

                // Map the output parameters to a Vehiculo object
                Vehiculo vehiculoResult = new Vehiculo();
                vehiculoResult.setIdVehiculo(vehiculo.getIdVehiculo());
                vehiculoResult.setMarca((String) query.getOutputParameterValue("P_MARCA"));
                vehiculoResult.setModelo((String) query.getOutputParameterValue("P_MODELO"));
                vehiculoResult.setAnio((Integer) query.getOutputParameterValue("P_ANIO"));
                vehiculoResult.setPlaca((String) query.getOutputParameterValue("P_PLACA"));
                
                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO");
                if (estadoId != null) {
                    Estado estado = new Estado();
                    estado.setIdEstado(estadoId);
                    Estado newEstado = estadoService.getEstado(estado);
                    vehiculoResult.setEstado(newEstado);
                }

                return vehiculoResult;
                
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Vehiculo> getAllVehiculos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_vehiculos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_VEHICULOS_TB_VER_VEHICULOS_SP", Vehiculo.class);

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

                Estado estado = new Estado();
                estado.setIdEstado(resultSet.getLong("id_estado"));
                Estado newEstado = estadoService.getEstado(estado);
                vehiculo.setEstado(newEstado);
                
                vehiculos.add(vehiculo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return vehiculos;
    }
}
