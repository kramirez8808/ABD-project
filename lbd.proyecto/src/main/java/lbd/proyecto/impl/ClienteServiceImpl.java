package lbd.proyecto.impl;


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
import lbd.proyecto.dao.ClienteDAO;
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.service.EstadoService;

@Service
public class ClienteServiceImpl implements ClienteService {

    @Autowired
    private ClienteDAO clienteDAO;

    @PersistenceContext
    private EntityManager entityManager;
    
    @Autowired
    private EstadoService estadoService;

    @Override
    @Transactional
    public void insertCliente(Cliente cliente) {
        clienteDAO.insertCliente(cliente.getNombre(), cliente.getApellido(), cliente.getTelefono(), cliente.getEmail(), cliente.getEstado().getIdEstado());
    }
    
    @Override
    @Transactional
    public void updateCliente(Long idCliente, Cliente cliente) {
        clienteDAO.updateCliente(idCliente, cliente.getNombre(), cliente.getApellido(), cliente.getTelefono(), cliente.getEmail(), cliente.getEstado().getIdEstado());
    }

    // @Override
    // @Transactional(readOnly = true)
    // public Cliente getCliente(Cliente cliente) {
    //     // Create a StoredProcedureQuery instance for the stored procedure "ver_cliente"
    //     StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_cliente");

    //     // Register the input and output parameters
    //     query.registerStoredProcedureParameter("p_id_cliente", Long.class, ParameterMode.IN);
    //     query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.OUT);
    //     query.registerStoredProcedureParameter("p_apellido", String.class, ParameterMode.OUT);
    //     query.registerStoredProcedureParameter("p_telefono", String.class, ParameterMode.OUT);
    //     query.registerStoredProcedureParameter("p_correo", String.class, ParameterMode.OUT);

    //     // Set the input parameter
    //     query.setParameter("p_id_cliente", cliente.getIdCliente());

    //     // Execute the stored procedure
    //     try {
    //         query.execute();
    //     } catch (PersistenceException e) {
    //         if (e.getCause() instanceof SQLException) {
    //             // Handle the SQLException
    //             SQLException sqlException = (SQLException) e.getCause();
    //             System.err.println("Error Code: " + sqlException.getErrorCode());
    //             System.err.println("SQL State: " + sqlException.getSQLState());
    //             System.err.println("Message: " + sqlException.getMessage());
    //             return null;
    //         } else {
    //             throw e;
    //         }
    //     }

    //     //Print the Output Parameters
    //     System.out.println("Nombre: " + query.getOutputParameterValue("p_nombre"));
    //     System.out.println("Apellido: " + query.getOutputParameterValue("p_apellido"));
    //     System.out.println("Telefono: " + query.getOutputParameterValue("p_telefono"));
    //     System.out.println("Correo: " + query.getOutputParameterValue("p_correo"));

    //     // Map the output parameters to a Cliente object
    //     Cliente newCliente = new Cliente();
    //     newCliente.setIdCliente(cliente.getIdCliente());
    //     newCliente.setNombre((String) query.getOutputParameterValue("p_nombre"));
    //     newCliente.setApellido((String) query.getOutputParameterValue("p_apellido"));
    //     newCliente.setTelefono((String) query.getOutputParameterValue("p_telefono"));
    //     newCliente.setEmail((String) query.getOutputParameterValue("p_correo"));

    //     return newCliente;
    // }

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    public Cliente getCliente(Cliente cliente) {
        return transactionTemplate.execute(new TransactionCallback<Cliente>() {
            @Override
            public Cliente doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_cliente"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_CLIENTES_TB_VER_CLIENTE_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_CLIENTE", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_NOMBRE", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_APELLIDO", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_TELEFONO", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_EMAIL", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);
                // Set the input parameter
                query.setParameter("P_ID_CLIENTE", cliente.getIdCliente());

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
                } catch (Exception e) {
                    e.printStackTrace();
                }

                //Print the Output Parameters
                // System.out.println("Nombre: " + query.getOutputParameterValue("p_nombre"));
                // System.out.println("Apellido: " + query.getOutputParameterValue("p_apellido"));
                // System.out.println("Telefono: " + query.getOutputParameterValue("p_telefono"));
                // System.out.println("Correo: " + query.getOutputParameterValue("p_correo"));

                // Map the output parameters to a Cliente object
                Cliente newCliente = new Cliente();
                newCliente.setIdCliente(cliente.getIdCliente());
                newCliente.setNombre((String) query.getOutputParameterValue("P_NOMBRE"));
                newCliente.setApellido((String) query.getOutputParameterValue("P_APELLIDO"));
                newCliente.setTelefono((String) query.getOutputParameterValue("P_TELEFONO"));
                newCliente.setEmail((String) query.getOutputParameterValue("P_EMAIL"));
                
                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO");
                    if (estadoId != null) {
                        Estado estado = new Estado();
                        estado.setIdEstado(estadoId);
                        Estado newEstado = estadoService.getEstado(estado);
                        newCliente.setEstado(newEstado);
                    }
                
                return newCliente;
            }
        });
    }


    @Override
    @Transactional(readOnly = true)
    public List<Cliente> getAllClientes() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_clientes"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_CLIENTES_TB_VER_CLIENTES_SP", Cliente.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        query.execute();

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of clients
        List<Cliente> clientes = new ArrayList<>();

        // Iterate over the ResultSet and add the clients to the list
        try {
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getLong("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                
                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                Estado newEstado = estadoService.getEstado(estado);
                cliente.setEstado(newEstado);
                
                clientes.add(cliente);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return clientes;
    }

    @Override
    @Transactional
    public void inactivarCliente(Long idCliente) {
        clienteDAO.inactivarCliente(idCliente);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Cliente> searchClientesNombre(String nombre) {        
        Session session = entityManager.unwrap(Session.class);
        List<Cliente> clientes = new ArrayList<>();
    
        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setString(2, nombre);
                    callableStatement.execute();
    
                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            Cliente cliente = new Cliente();
                            cliente.setIdCliente(rs.getLong("ID_Cliente"));
                            cliente.setNombre(rs.getString("Nombre"));
                            cliente.setApellido(rs.getString("Apellido"));
                            cliente.setTelefono(rs.getString("Telefono"));
                            cliente.setEmail(rs.getString("Email"));
                            
                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            Estado newEstado = estadoService.getEstado(estado);
                            cliente.setEstado(newEstado);
                            
                            clientes.add(cliente);
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });
    
        return clientes;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Cliente> searchClientesEmail(String email) {
        Session session = entityManager.unwrap(Session.class);
        List<Cliente> clientes = new ArrayList<>();
    
        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setString(2, email);
                    callableStatement.execute();
    
                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            Cliente cliente = new Cliente();
                            cliente.setIdCliente(rs.getLong("ID_Cliente"));
                            cliente.setNombre(rs.getString("Nombre"));
                            cliente.setApellido(rs.getString("Apellido"));
                            cliente.setTelefono(rs.getString("Telefono"));
                            cliente.setEmail(rs.getString("Email"));
                            
                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            Estado newEstado = estadoService.getEstado(estado);
                            cliente.setEstado(newEstado);
                            
                            clientes.add(cliente);
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });
    
        return clientes;
    }
    
    
}
