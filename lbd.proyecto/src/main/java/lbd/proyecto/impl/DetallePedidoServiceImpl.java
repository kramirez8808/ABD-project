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
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.dao.DetallePedidoDAO;
import lbd.proyecto.domain.DetallePedido;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.DetallePedidoService;

import lbd.proyecto.domain.Pedido;
import lbd.proyecto.service.PedidoService;

import lbd.proyecto.domain.Producto;
import lbd.proyecto.service.ProductoService;

import lbd.proyecto.dao.EstadoDAO;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.service.EstadoService;

@Service
public class DetallePedidoServiceImpl implements DetallePedidoService {
    
    @Autowired
    private DetallePedidoDAO detallePedidoDAO;

    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private ProductoService productoService;

    @Autowired
    private EstadoService estadoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertDetallePedido(DetallePedido detallePedido, Pedido pedido, Producto producto) {

        Pedido pedidoResult = pedidoService.getPedido(pedido);
        Producto productoResult = productoService.getProducto(producto);
        Estado estadoResult = estadoService.getEstado(detallePedido.getEstado());

        detallePedidoDAO.insertDetallePedido(pedidoResult.getIdPedido(), productoResult.getIdProducto(), detallePedido.getCantidad(), detallePedido.getUnidadMasa(), estadoResult.getIdEstado());
    }

    @Override
    @Transactional
    public void updateDetallePedido(Long idDetalle, DetallePedido detallePedido) {
        Pedido pedidoResult = pedidoService.getPedido(detallePedido.getPedido());
        Producto productoResult = productoService.getProducto(detallePedido.getProducto());
        Estado estadoResult = estadoService.getEstado(detallePedido.getEstado());

        detallePedidoDAO.updateDetallePedido(idDetalle, pedidoResult.getIdPedido(), productoResult.getIdProducto(), detallePedido.getCantidad(), detallePedido.getUnidadMasa(), estadoResult.getIdEstado());
    }

    @Override
    @Transactional
    public void inactivarDetallePedido(Long idDetalle) {
        detallePedidoDAO.inactivarDetallePedido(idDetalle);
    }

    @Override
    @Transactional(readOnly = true)
    public DetallePedido getDetallePedido(DetallePedido detallePedido) {
        return transactionTemplate.execute(new TransactionCallback<DetallePedido>() {
            @Override
            public DetallePedido doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_DETALLES_PEDIDO_TB_VER_DETALLE_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_DETALLE", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_ID_PEDIDO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_PRODUCTO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_CANTIDAD", Double.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_UNIDAD_MASA", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("P_ID_DETALLE", detallePedido.getIdDetalle());

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

                // Map the output parameters to a DetallePedido object
                DetallePedido detallePedidoResult = new DetallePedido();
                detallePedidoResult.setIdDetalle(detallePedido.getIdDetalle());
                detallePedidoResult.setCantidad((Double) query.getOutputParameterValue("P_CANTIDAD"));
                detallePedidoResult.setUnidadMasa((String) query.getOutputParameterValue("P_UNIDAD_MASA"));

                // Map the pedido to the Pedido object
                Pedido pedido = new Pedido();
                pedido.setIdPedido((Long) query.getOutputParameterValue("P_ID_PEDIDO"));
                detallePedidoResult.setPedido(pedidoService.getPedido(pedido));

                // Map the producto to the Producto object
                Producto producto = new Producto();
                producto.setIdProducto((Long) query.getOutputParameterValue("P_ID_PRODUCTO"));
                detallePedidoResult.setProducto(productoService.getProducto(producto));

                // Map the estado to the Estado object
                Estado estado = new Estado();
                estado.setIdEstado((Long) query.getOutputParameterValue("P_ID_ESTADO"));
                detallePedidoResult.setEstado(estadoService.getEstado(estado));

                return detallePedidoResult;

            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<DetallePedido> getAllDetallesPedidos() {
        // Create a StoredProcedureQuery instance for the stored procedure
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_DETALLES_PEDIDO_TB_VER_DETALLES_SP");

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

        // Create a list of order details
        List<DetallePedido> detallesPedido = new ArrayList<>();

        try {
            while (rs.next()) {
                DetallePedido detallePedido = new DetallePedido();
                detallePedido.setIdDetalle(rs.getLong("id_detalle_pedido"));
                detallePedido.setCantidad(rs.getDouble("cantidad"));
                detallePedido.setUnidadMasa(rs.getString("unidad_masa"));

                // Map the pedido to the Pedido object
                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getLong("id_pedido"));
                detallePedido.setPedido(pedidoService.getPedido(pedido));

                // Map the producto to the Producto object
                Producto producto = new Producto();
                producto.setIdProducto(rs.getLong("id_producto"));
                detallePedido.setProducto(productoService.getProducto(producto));

                // Map the estado to the Estado object
                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                detallePedido.setEstado(estadoService.getEstado(estado));

                detallesPedido.add(detallePedido);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return detallesPedido;
        
    }

    @Override
    @Transactional(readOnly = true)
    public List<DetallePedido> searchDetallesByPedido(Long idPedido) {
        Session session = entityManager.unwrap(Session.class);
        List<DetallePedido> detallesPedido = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_DETALLES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idPedido);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            
                            DetallePedido detallePedido = new DetallePedido();
                            detallePedido.setIdDetalle(rs.getLong("id_detalle"));
                            detallePedido.setCantidad(rs.getDouble("cantidad"));
                            detallePedido.setUnidadMasa(rs.getString("unidad_masa"));

                            // Map the pedido to the Pedido object
                            Pedido pedido = new Pedido();
                            pedido.setIdPedido(rs.getLong("id_pedido"));
                            detallePedido.setPedido(pedidoService.getPedido(pedido));

                            // Map the producto to the Producto object
                            Producto producto = new Producto();
                            producto.setIdProducto(rs.getLong("id_producto"));
                            detallePedido.setProducto(productoService.getProducto(producto));

                            // Map the estado to the Estado object
                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            detallePedido.setEstado(estadoService.getEstado(estado));
                            
                            detallesPedido.add(detallePedido);
                        
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        return detallesPedido;
        
    }

    @Override
    @Transactional
    public void insertMultipleDetallesPedido(List<DetallePedido> detallesPedido) {
        try {
            for (DetallePedido detallePedido : detallesPedido) {
                insertDetallePedido(detallePedido, detallePedido.getPedido(), detallePedido.getProducto());
            }
        } catch (PersistenceException e) {
            throw e;
        }
    }

    @Override
    @Transactional
    public void insertPedidoConDetalles(Pedido pedido, List<DetallePedido> detallesPedido) {
        pedidoService.insertPedido(pedido, pedido.getCliente(), pedido.getVehiculo(), pedido.getTipoCarga(), pedido.getEstado(), pedido.getLicenciaEmpleado());
        
        insertMultipleDetallesPedido(detallesPedido);

    }

}
