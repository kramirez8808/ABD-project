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
import lbd.proyecto.dao.direcciones.DireccionClienteDAO;
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.service.direcciones.DireccionClienteService;

import lbd.proyecto.domain.Cliente;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.dao.ClienteDAO;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.dao.direcciones.DistritoDAO;

@Service
public class DireccionClienteServiceImpl implements DireccionClienteService {
    
    @Autowired
    private DireccionClienteDAO direccionClienteDAO;

    @Autowired
    private DistritoService distritoService;

    @Autowired
    private ClienteService clienteService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertDireccionCliente(DireccionCliente direccionCliente, Cliente cliente, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        Cliente clienteResult = clienteService.getCliente(cliente);
        direccionClienteDAO.insertDireccionCliente(clienteResult.getIdCliente(), direccionCliente.getDetalles(), distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());

        direccionCliente.setCliente(clienteResult);
        direccionCliente.setDistrito(distritoResult);
        System.out.println(direccionCliente.toString());
    }

    @Override
    @Transactional
    public void updateDireccionCliente(DireccionCliente direccionCliente, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        direccionClienteDAO.updateDireccionCliente(direccionCliente.getIdDireccion(), direccionCliente.getDetalles(), distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());
        
        direccionCliente.setDistrito(distritoResult);
        System.out.println(direccionCliente.toString());
        System.out.println(direccionCliente.getDistrito().toString());
    }

    @Override
    @Transactional
    public DireccionCliente getDireccionCliente(DireccionCliente direccionCliente) {
        
        return transactionTemplate.execute(new TransactionCallback<DireccionCliente>() {
            @Override
            public DireccionCliente doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_direccion_cliente"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direccion_cliente");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_direccion", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_id_cliente", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_detalles", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_distrito", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_direccion", direccionCliente.getIdDireccion());

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
                // System.out.println("Detalles: " + query.getOutputParameterValue("p_detalles"));

                // Map the output parameters to a DireccionCliente object
                DireccionCliente newDireccionCliente = new DireccionCliente();
                newDireccionCliente.setIdDireccion(direccionCliente.getIdDireccion());
                newDireccionCliente.setDetalles((String) query.getOutputParameterValue("p_detalles"));

                // Map the cliente to the Cliente object
                Cliente cliente = new Cliente();
                cliente.setIdCliente((Long) query.getOutputParameterValue("p_id_cliente"));
                newDireccionCliente.setCliente(clienteService.getCliente(cliente));

                // Map the distrito to the Distrito object
                Distrito distrito = new Distrito();
                distrito.setIdDistrito((Long) query.getOutputParameterValue("p_id_distrito"));
                newDireccionCliente.setDistrito(distritoService.getDistrito(distrito));

                return newDireccionCliente;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionCliente> getAllDirecciones() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_direcciones_clientes"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direcciones_clientes");

        // Register the output parameters
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        query.execute();

        // Get the result set
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list to store the results
        List<DireccionCliente> direcciones = new ArrayList<DireccionCliente>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                DireccionCliente direccion = new DireccionCliente();
                direccion.setIdDireccion(rs.getLong("id_direccion"));
                direccion.setDetalles(rs.getString("detalles"));

                Distrito distrito = new Distrito();
                distrito.setIdDistrito(rs.getLong("id_distrito"));
                direccion.setDistrito(distritoService.getDistrito(distrito));

                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getLong("id_cliente"));
                direccion.setCliente(clienteService.getCliente(cliente));

                direcciones.add(direccion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return direcciones;

    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionCliente> searchDireccionesByCliente(Long idCliente) {
        Session session = entityManager.unwrap(Session.class);
        List<DireccionCliente> direcciones = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call buscar_direcciones_por_cliente(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idCliente);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            DireccionCliente direccion = new DireccionCliente();
                            direccion.setIdDireccion(rs.getLong("id_direccion"));
                            direccion.setDetalles(rs.getString("detalles"));

                            Distrito distrito = new Distrito();
                            distrito.setIdDistrito(rs.getLong("id_distrito"));
                            direccion.setDistrito(distritoService.getDistrito(distrito));

                            Cliente cliente = new Cliente();
                            cliente.setIdCliente(rs.getLong("id_cliente"));
                            direccion.setCliente(clienteService.getCliente(cliente));

                            direcciones.add(direccion);
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        return direcciones;
    }

    @Override
    @Transactional
    public void deleteDireccionCliente(DireccionCliente direccionCliente) {
        direccionClienteDAO.deleteDireccionCliente(direccionCliente.getIdDireccion());
    }
}
