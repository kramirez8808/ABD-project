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
import lbd.proyecto.dao.direcciones.DireccionPedidoDAO;
import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.service.direcciones.DireccionPedidoService;

import lbd.proyecto.domain.Pedido;
import lbd.proyecto.service.PedidoService;
import lbd.proyecto.dao.PedidoDAO;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.dao.direcciones.DistritoDAO;

@Service
public class DireccionPedidoServiceImpl implements DireccionPedidoService {
    
    @Autowired
    private DireccionPedidoDAO direccionPedidoDAO;

    @Autowired
    private DistritoService distritoService;

    @Autowired
    private PedidoService pedidoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertDireccionPedido(DireccionPedido direccionPedido, Pedido pedido, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        Pedido pedidoResult = pedidoService.getPedido(pedido);
        direccionPedidoDAO.insertDireccionPedido(pedidoResult.getIdPedido(), direccionPedido.getDetalles(), distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());    
    }

    @Override
    @Transactional
    public void updateDireccionPedido(DireccionPedido direccionPedido, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        direccionPedidoDAO.updateDireccionPedido(direccionPedido.getIdDireccion(), direccionPedido.getDetalles(), distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), distritoResult.getIdDistrito());
    }

    @Override
    @Transactional
    public void deleteDireccionPedido(DireccionPedido direccionPedido) {
        direccionPedidoDAO.deleteDireccionPedido(direccionPedido.getIdDireccion());
    }

    @Override
    @Transactional
    public DireccionPedido getDireccionPedido(DireccionPedido direccionPedido) {
        
        return transactionTemplate.execute(new TransactionCallback<DireccionPedido>() {
            @Override
            public DireccionPedido doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_direccion_pedido"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direccion_pedido");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_direccion", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_id_pedido", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_detalles", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_distrito", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_direccion", direccionPedido.getIdDireccion());

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

                // Map the output parameters to the DireccionPedido object
                DireccionPedido direccionPedidoResult = new DireccionPedido();
                direccionPedidoResult.setIdDireccion(direccionPedido.getIdDireccion());
                direccionPedidoResult.setDetalles((String) query.getOutputParameterValue("p_detalles"));

                // Map the distrito to the Distrito object
                Distrito distrito = new Distrito();
                distrito.setIdDistrito((Long) query.getOutputParameterValue("p_id_distrito"));
                direccionPedidoResult.setDistrito(distritoService.getDistrito(distrito));

                // Map the pedido to the Pedido object
                Pedido pedido = new Pedido();
                pedido.setIdPedido((Long) query.getOutputParameterValue("p_id_pedido"));
                direccionPedidoResult.setPedido(pedidoService.getPedido(pedido));

                return direccionPedidoResult;

            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionPedido> getAllDirecciones() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_direcciones_pedidos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_direcciones_pedidos");

        // Register the output parameters
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
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list to store the results
        List<DireccionPedido> direcciones = new ArrayList<DireccionPedido>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                DireccionPedido direccion = new DireccionPedido();
                direccion.setIdDireccion(rs.getLong("id_direccion"));
                direccion.setDetalles(rs.getString("detalles"));

                Distrito distrito = new Distrito();
                distrito.setIdDistrito(rs.getLong("id_distrito"));
                direccion.setDistrito(distritoService.getDistrito(distrito));

                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getLong("id_pedido"));
                direccion.setPedido(pedidoService.getPedido(pedido));

                direcciones.add(direccion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return direcciones;

    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionPedido> searchDireccionesByPedido(Long idPedido) {
        Session session = entityManager.unwrap(Session.class);
        List<DireccionPedido> direcciones = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call buscar_direcciones_por_pedido(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idPedido);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            DireccionPedido direccion = new DireccionPedido();
                            direccion.setIdDireccion(rs.getLong("id_direccion"));
                            direccion.setDetalles(rs.getString("detalles"));

                            Distrito distrito = new Distrito();
                            distrito.setIdDistrito(rs.getLong("id_distrito"));
                            direccion.setDistrito(distritoService.getDistrito(distrito));

                            Pedido pedido = new Pedido();
                            pedido.setIdPedido(rs.getLong("id_pedido"));
                            direccion.setPedido(pedidoService.getPedido(pedido));

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

}
