// package lbd.proyecto.impl;

// // External imports
// import java.util.List;
// import java.util.ArrayList;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Service;
// import org.springframework.transaction.TransactionStatus;
// import org.springframework.transaction.annotation.Transactional;
// import org.springframework.transaction.support.TransactionCallback;
// import org.springframework.transaction.support.TransactionTemplate;
// import org.hibernate.Session;
// import org.hibernate.jdbc.Work;

// import jakarta.persistence.EntityManager;
// import jakarta.persistence.ParameterMode;
// import jakarta.persistence.PersistenceContext;
// import jakarta.persistence.PersistenceException;
// import jakarta.persistence.StoredProcedureQuery;

// import java.sql.CallableStatement;
// import java.sql.Connection;
// import java.sql.Date;
// import java.sql.ResultSet;
// import java.sql.SQLException;
// import java.text.SimpleDateFormat;

// import oracle.jdbc.OracleTypes;

// // Internal imports
// import lbd.proyecto.dao.DetallePedidoDAO;
// import lbd.proyecto.domain.DetallePedido;
// import lbd.proyecto.domain.Empleado;
// import lbd.proyecto.service.DetallePedidoService;

// import lbd.proyecto.dao.PedidoDAO;
// import lbd.proyecto.domain.Pedido;
// import lbd.proyecto.service.PedidoService;

// import lbd.proyecto.domain.Producto;
// import lbd.proyecto.service.ProductoService;
// import lbd.proyecto.dao.ProductoDao;

// import lbd.proyecto.dao.EstadoDAO;
// import lbd.proyecto.domain.Estado;
// import lbd.proyecto.domain.Licencia;
// import lbd.proyecto.domain.LicenciaEmpleado;
// import lbd.proyecto.service.EstadoService;

// @Service
// public class DetallePedidoServiceImpl implements DetallePedidoService {
    
//     @Autowired
//     private DetallePedidoDAO detallePedidoDAO;

//     @Autowired
//     private PedidoService pedidoService;

//     @Autowired
//     private ProductoService productoService;

//     @Autowired
//     private EstadoService estadoService;

//     @PersistenceContext
//     private EntityManager entityManager;

//     @Autowired
//     private TransactionTemplate transactionTemplate;

//     @Override
//     @Transactional
//     public void insertDetallePedido(DetallePedido detallePedido, Pedido pedido, Producto producto) {

//         Pedido pedidoResult = pedidoService.getPedido(pedido);
//         Producto productoResult = productoService.getProducto(producto);
//         Estado estadoResult = estadoService.getEstado(detallePedido.getEstado());

//         detallePedidoDAO.insertDetallePedido(pedidoResult.getIdPedido(), productoResult.getIdProducto(), detallePedido.getCantidad(), detallePedido.getUnidadMasa(), estadoResult.getIdEstado());
//     }

//     @Override
//     @Transactional(readOnly = true)
//     public List<DetallePedido> searchDetallesByPedido(Long idPedido) {
//         Session session = entityManager.unwrap(Session.class);
//         List<DetallePedido> detallesPedido = new ArrayList<>();

//         session.doWork(new Work() {
//             @Override
//             public void execute(Connection connection) throws SQLException {
//                 try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_DETALLES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(?) }")) {
//                     callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
//                     callableStatement.setLong(2, idPedido);
//                     callableStatement.execute();

//                     try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
//                         while (rs.next()) {
                            
//                             DetallePedido detallePedido = new DetallePedido();
//                             detallePedido.setIdDetalle(rs.getLong("id_detalle_pedido"));
//                             detallePedido.setCantidad(rs.getDouble("cantidad"));
//                             detallePedido.setUnidadMasa(rs.getString("unidad_masa"));

//                             // Map the pedido to the DetallePedido object
//                             Pedido pedido = new Pedido();
//                             pedido.setIdPedido(rs.getLong("id_pedido"));
//                             detallePedido.setPedido(pedidoService.getPedido(pedido));

//                             // Map the producto to the DetallePedido object
//                             Producto producto = new Producto();
//                             producto.setIdProducto(rs.getLong("id_producto"));
//                             detallePedido.setProducto(productoService.getProducto(producto));

//                             // Map the estado to the DetallePedido object
//                             Estado estado = new Estado();
//                             estado.setIdEstado(rs.getLong("id_estado"));
//                             detallePedido.setEstado(estadoService.getEstado(estado));
                            
//                             detallesPedido.add(detallePedido);
                        
//                         }
//                     }
//                 } catch (SQLException e) {
//                     throw new RuntimeException(e);
//                 }
//             }
//         });

//         return detallesPedido;
        
//     }

//     @Override
//     @Transactional
//     public void insertMultipleDetallesPedido(List<DetallePedido> detallesPedido, Pedido pedido, Producto producto) {
//         transactionTemplate.execute(new TransactionCallback<Void>() {
//             @Override
//             public Void doInTransaction(TransactionStatus status) {
//                 try {
//                     for (DetallePedido detallePedido : detallesPedido) {
//                         insertDetallePedido(detallePedido, pedido, producto);
//                     }
//                 } catch (PersistenceException e) {
//                     status.setRollbackOnly();
//                     throw e;
//                 }
//                 return null;
//             }
//         });
//     }

// }
