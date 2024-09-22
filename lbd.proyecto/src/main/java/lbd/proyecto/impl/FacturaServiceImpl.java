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

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.domain.Factura;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Estado;

import lbd.proyecto.dao.FacturaDAO;
import lbd.proyecto.service.FacturaService;
import lbd.proyecto.service.PedidoService;
import lbd.proyecto.service.EstadoService;

@Service
public class FacturaServiceImpl implements FacturaService {
    
    @Autowired
    private FacturaDAO facturaDAO;

    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private EstadoService estadoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertFactura(Factura factura, Pedido pedido, Estado estado) {
        Pedido pedidoResult = pedidoService.getPedido(pedido);
        Estado estadoResult = estadoService.getEstado(estado);
        factura.setPedido(pedidoResult);
        factura.setEstado(estadoResult);
        facturaDAO.insertFactura(factura.getPedido().getIdPedido(), factura.getFecha(), factura.getTotal(), factura.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void updateFactura(Factura factura, Estado estado) {
        Estado estadoResult = estadoService.getEstado(estado);
        factura.setEstado(estadoResult);
        facturaDAO.updateFactura(factura.getIdFactura(), factura.getFecha(), factura.getTotal(), factura.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void deleteFactura(Factura factura) {
        facturaDAO.deleteFactura(factura.getIdFactura());
    }

    @Override
    @Transactional
    public Factura getFactura(Factura factura) {
        
        return transactionTemplate.execute(new TransactionCallback<Factura>() {
           @Override
              public Factura doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_factura"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_factura");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_factura", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_id_pedido", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_fecha", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_total", BigDecimal.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_estado", Long.class, ParameterMode.OUT);

                // Set the value of the input parameter
                query.setParameter("p_id_factura", factura.getIdFactura());

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

                // Map the output parameters to the Factura object
                Factura facturaResult = new Factura();
                facturaResult.setIdFactura(factura.getIdFactura());
                facturaResult.setFecha((Date) query.getOutputParameterValue("p_fecha"));
                facturaResult.setTotal(((BigDecimal) query.getOutputParameterValue("p_total")).doubleValue());

                // Map the state and order to the Factura object
                Estado estado = new Estado();
                estado.setIdEstado((Long) query.getOutputParameterValue("p_id_estado"));
                facturaResult.setEstado(estadoService.getEstado(estado));

                Pedido pedido = new Pedido();
                pedido.setIdPedido((Long) query.getOutputParameterValue("p_id_pedido"));
                facturaResult.setPedido(pedidoService.getPedido(pedido));

                return facturaResult;

              } 
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Factura> getAllFacturas() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_facturas"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_facturas");

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
        List<Factura> facturas = new ArrayList<>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getLong("id_factura"));
                factura.setFecha(rs.getDate("fecha"));
                factura.setTotal(rs.getDouble("total"));

                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                factura.setEstado(estadoService.getEstado(estado));

                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getLong("id_pedido"));
                factura.setPedido(pedidoService.getPedido(pedido));

                facturas.add(factura);
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return facturas;
    }

    @Override
    @Transactional(readOnly = true)
    public Factura searchFacturaByPedido(Long idPedido) {
        Session session = entityManager.unwrap(Session.class);
        Factura facturaResult = new Factura();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call buscar_factura_por_pedido(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setString(2, idPedido.toString());
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            facturaResult.setIdFactura(rs.getLong("id_factura"));
                            facturaResult.setFecha(rs.getDate("fecha"));
                            facturaResult.setTotal(rs.getDouble("total"));

                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            facturaResult.setEstado(estadoService.getEstado(estado));

                            Pedido pedido = new Pedido();
                            pedido.setIdPedido(rs.getLong("id_pedido"));
                            // facturaResult.setPedido(pedidoService.getPedido(pedido));
                            facturaResult.setPedido(pedido);

                        }
                    }

                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        return facturaResult;

    }

    //Function to get the date returned by the HTML input and convert it to a java.sql.Date
    public java.sql.Date convertDate(String input) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dt = sdf.parse(input);
            java.sql.Date sqlDate = new java.sql.Date(dt.getTime());

            return sqlDate;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        
        
    }


}
