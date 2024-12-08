package lbd.proyecto.impl;

// External imports
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
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
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Factura;
import lbd.proyecto.domain.LicenciaEmpleado;

import lbd.proyecto.domain.DetallePedido;

import lbd.proyecto.dao.PedidoDAO;


import lbd.proyecto.service.PedidoService;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.service.VehiculoService;
import lbd.proyecto.service.TipoCargaService;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.LicenciaEmpleadoService;
import lbd.proyecto.service.FacturaService;
import lbd.proyecto.service.DetallePedidoService;



@Service
public class PedidoServiceImpl implements PedidoService {
    
    @Autowired
    private PedidoDAO pedidoDAO;

    @Autowired
    private ClienteService clienteService;

    @Autowired
    private VehiculoService vehiculoService;

    @Autowired
    private TipoCargaService tipoCargaService;

    @Autowired
    private EstadoService estadoService;

    @Autowired
    private LicenciaEmpleadoService licenciaEmpleadoService;

    @Autowired
    @Lazy
    private FacturaService facturaService;

    @Autowired
    @Lazy
    private DetallePedidoService detallePedidoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertPedido(Pedido pedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, Estado estado, LicenciaEmpleado licenciaEmpleado) {
        Cliente clienteResult = clienteService.getCliente(cliente);
        Vehiculo vehiculoResult = vehiculoService.getVehiculo(vehiculo);
        TipoCarga tipoCargaResult = tipoCargaService.getTipoCarga(tipoCarga);
        Estado estadoResult = estadoService.getEstado(estado);
        LicenciaEmpleado licenciaEmpleadoResult = licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado);
        pedidoDAO.insertPedido(clienteResult.getIdCliente(), vehiculoResult.getIdVehiculo(), tipoCargaResult.getIdTipo(), pedido.getFechaPedido(), estadoResult.getIdEstado(), licenciaEmpleadoResult.getIdLicenciaEmpleado());
    }

    @Override
    @Transactional
    public void updatePedido(Pedido pedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, Estado estado, LicenciaEmpleado licenciaEmpleado) {
        Cliente clienteResult = clienteService.getCliente(cliente);
        Vehiculo vehiculoResult = vehiculoService.getVehiculo(vehiculo);
        TipoCarga tipoCargaResult = tipoCargaService.getTipoCarga(tipoCarga);
        Estado estadoResult = estadoService.getEstado(estado);
        LicenciaEmpleado licenciaEmpleadoResult = licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado);

        pedidoDAO.updatePedido(pedido.getIdPedido(), clienteResult.getIdCliente(), vehiculoResult.getIdVehiculo(), tipoCargaResult.getIdTipo(), pedido.getFechaPedido(), estadoResult.getIdEstado(), licenciaEmpleadoResult.getIdLicenciaEmpleado());
    }

    @Override
    @Transactional
    public void inactivarPedido(Pedido pedido) {
        pedidoDAO.inactivarPedido(pedido.getIdPedido());
    }
    
    @Override
    public Pedido getPedido(Pedido pedido) {
        return transactionTemplate.execute(new TransactionCallback<Pedido>() {
            @Override
            public Pedido doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_pedido"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PEDIDOS_TB_VER_PEDIDO_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_PEDIDO", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_ID_CLIENTE", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_VEHICULO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_TIPO_CARGA", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_FECHA", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_LICENCIA_EMPLEADO", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("P_ID_PEDIDO", pedido.getIdPedido());

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

                // Create the Pedido object to hold the results
                Pedido pedidoResult = new Pedido();
                pedidoResult.setIdPedido(pedido.getIdPedido());

                // Map the output parameters to the Pedido object if they are not null
                if (query.getOutputParameterValue("P_FECHA") != null) {
                    pedidoResult.setFechaPedido((Date) query.getOutputParameterValue("P_FECHA"));
                } else {
                    System.err.println("No se encontró la fecha del pedido para el ID: " + pedido.getIdPedido());
                    return null;
                }

                // Map the client
                Long clienteId = (Long) query.getOutputParameterValue("P_ID_CLIENTE");
                if (clienteId != null) {
                    Cliente cliente = new Cliente();
                    cliente.setIdCliente(clienteId);
                    pedidoResult.setCliente(clienteService.getCliente(cliente));
                } else {
                    System.err.println("No se encontró el cliente para el pedido ID: " + pedido.getIdPedido());
                    return null;
                }

                // Map the vehicle
                Long vehiculoId = (Long) query.getOutputParameterValue("P_ID_VEHICULO");
                if (vehiculoId != null) {
                    Vehiculo vehiculo = new Vehiculo();
                    vehiculo.setIdVehiculo(vehiculoId);
                    pedidoResult.setVehiculo(vehiculoService.getVehiculo(vehiculo));
                } else {
                    System.err.println("No se encontró el vehículo para el pedido ID: " + pedido.getIdPedido());
                    return null;
                }

                // Map the type of load
                Long tipoCargaId = (Long) query.getOutputParameterValue("P_ID_TIPO_CARGA");
                if (tipoCargaId != null) {
                    TipoCarga tipoCarga = new TipoCarga();
                    tipoCarga.setIdTipo(tipoCargaId);
                    pedidoResult.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));
                } else {
                    System.err.println("No se encontró el tipo de carga para el pedido ID: " + pedido.getIdPedido());
                    return null;
                }

                // Map the state
                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO");
                if (estadoId != null) {
                    Estado estado = new Estado();
                    estado.setIdEstado(estadoId);
                    pedidoResult.setEstado(estadoService.getEstado(estado));
                } else {
                    System.err.println("No se encontró el estado para el pedido ID: " + pedido.getIdPedido());
                    return null;
                }

                // Map the employee license
                Long licenciaEmpleadoId = (Long) query.getOutputParameterValue("P_ID_LICENCIA_EMPLEADO");
                if (licenciaEmpleadoId != null) {
                    LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                    licenciaEmpleado.setIdLicenciaEmpleado(licenciaEmpleadoId);
                    pedidoResult.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));
                } else {
                    System.err.println("No se encontró la licencia de empleado para el pedido ID: " + pedido.getIdPedido());
                    return null;
                }


                return pedidoResult;
            }
        });
    }


    /*
    @Override
    public Pedido getPedido(Pedido pedido) {
        
        return transactionTemplate.execute(new TransactionCallback<Pedido>() {
            @Override
            public Pedido doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_pedido"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PEDIDOS_TB_VER_PEDIDO_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_PEDIDO", Long.class, ParameterMode.IN);
                //query.registerStoredProcedureParameter("P_DESCRIPCION", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_CLIENTE", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_VEHICULO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_TIPO_CARGA", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_FECHA", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_LICENCIAS_EMPLEADO", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("P_ID_PEDIDO", pedido.getIdPedido());

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

                try {

                    // Map the output parameters to the Pedido object
                    Pedido pedidoResult = new Pedido();
                    pedidoResult.setIdPedido(pedido.getIdPedido());
                    //pedidoResult.setDescripcion((String) query.getOutputParameterValue("p_descripcion"));
                    pedidoResult.setFechaPedido((Date) query.getOutputParameterValue("p_fecha"));

                    // Map the client, vehicle, type of load, state and employee license to the Pedido object
                    Cliente cliente = new Cliente();
                    cliente.setIdCliente((Long) query.getOutputParameterValue("p_id_cliente"));
                    pedidoResult.setCliente(clienteService.getCliente(cliente));

                    Vehiculo vehiculo = new Vehiculo();
                    vehiculo.setIdVehiculo((Long) query.getOutputParameterValue("p_id_vehiculo"));
                    pedidoResult.setVehiculo(vehiculoService.getVehiculo(vehiculo));

                    TipoCarga tipoCarga = new TipoCarga();
                    tipoCarga.setIdTipo((Long) query.getOutputParameterValue("p_id_tipo_carga"));
                    pedidoResult.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));

                    Estado estado = new Estado();
                    estado.setIdEstado((Long) query.getOutputParameterValue("p_id_estado"));
                    pedidoResult.setEstado(estadoService.getEstado(estado));

                    LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                    licenciaEmpleado.setIdLicenciaEmpleado((Long) query.getOutputParameterValue("p_id_licencia_empleado"));
                    pedidoResult.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

                    // Verify if the Pedido has an invoice and add it
                    Factura factura = new Factura();
                    factura.setPedido(pedidoResult);
                    Factura facturaResulFactura = facturaService.searchFacturaByPedido(pedidoResult.getIdPedido());
                    /*
                    if (facturaResulFactura.getIdFactura() != null && facturaResulFactura.getIdFactura() != 0) {
                        pedidoResult.(facturaResulFactura);
                    }
                    *
                    return pedidoResult;

                } catch (Exception e) {
                    e.printStackTrace();
                }
                
                return null;

            }
        });
        
    }
    */
    
    @Override
    @Transactional(readOnly = true)
    public List<Pedido> getAllPedidos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_pedidos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PEDIDOS_TB_VER_PEDIDOS_SP");

        // Register the output parameters
        query.registerStoredProcedureParameter(1, ResultSet.class, ParameterMode.REF_CURSOR);

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

        // Create a list to store the Pedido objects
        List<Pedido> pedidos = new ArrayList<>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getLong("ID_Pedido"));
                pedido.setFechaPedido(rs.getDate("Fecha"));

                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getLong("ID_Cliente"));
                pedido.setCliente(clienteService.getCliente(cliente));

                Vehiculo vehiculo = new Vehiculo();
                vehiculo.setIdVehiculo(rs.getLong("ID_Vehiculo"));
                pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));

                TipoCarga tipoCarga = new TipoCarga();
                tipoCarga.setIdTipo(rs.getLong("ID_Tipo_Carga"));
                pedido.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));

                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("ID_Estado"));
                pedido.setEstado(estadoService.getEstado(estado));

                LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                licenciaEmpleado.setIdLicenciaEmpleado(rs.getLong("ID_Licencia_Empleado"));
                pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

                Factura factura = new Factura();
                factura.setPedido(pedido);
                Factura facturaResult = facturaService.searchFacturaByPedido(pedido.getIdPedido());
                if (facturaResult.getIdFactura() != null && facturaResult.getIdFactura() != 0) {
                    pedido.setFactura(facturaResult);
                }

                List<DetallePedido> detallesPedido = detallePedidoService.searchDetallesByPedido(pedido.getIdPedido());
                if (detallesPedido.size() > 0) {
                    pedido.setDetallesPedido(detallesPedido);
                }
                
                pedidos.add(pedido);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pedidos;
    }


@Override
@Transactional(readOnly = true)
public List<Pedido> searchPedidosByCliente(Long idCliente) {
    Session session = entityManager.unwrap(Session.class);
    List<Pedido> pedidos = new ArrayList<>();

    session.doWork(new Work() {
        @Override
        public void execute(Connection connection) throws SQLException {
            CallableStatement callableStatement = null;
            ResultSet rs = null;

            try {
                callableStatement = connection.prepareCall("{ ? = call FIDE_PEDIDOS_TB_BUSCAR_POR_CLIENTE_FN(?) }");
                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                callableStatement.setLong(2, idCliente);
                callableStatement.execute();

                rs = (ResultSet) callableStatement.getObject(1);

                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setIdPedido(rs.getLong("id_pedido"));
                    //pedido.setDescripcion(rs.getString("descripcion"));
                    pedido.setFechaPedido(rs.getDate("fecha"));

                    Cliente cliente = new Cliente();
                    cliente.setIdCliente(rs.getLong("id_cliente"));
                    pedido.setCliente(clienteService.getCliente(cliente));

                    Vehiculo vehiculo = new Vehiculo();
                    vehiculo.setIdVehiculo(rs.getLong("id_vehiculo"));
                    pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));

                    TipoCarga tipoCarga = new TipoCarga();
                    tipoCarga.setIdTipo(rs.getLong("id_tipo_carga"));
                    pedido.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));

                    Estado estado = new Estado();
                    estado.setIdEstado(rs.getLong("id_estado"));
                    pedido.setEstado(estadoService.getEstado(estado));

                    LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                    licenciaEmpleado.setIdLicenciaEmpleado(rs.getLong("id_licencia_empleado"));
                    pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

                    pedidos.add(pedido);
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            } finally {
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) {
                        System.err.println("Failed to close ResultSet: " + e.getMessage());
                    }
                }
                if (callableStatement != null) {
                    try {
                        callableStatement.close();
                    } catch (SQLException e) {
                        System.err.println("Failed to close CallableStatement: " + e.getMessage());
                    }
                }
            }
        }
    });

    return pedidos;
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
