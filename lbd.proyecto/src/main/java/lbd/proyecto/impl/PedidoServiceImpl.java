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

import lbd.proyecto.dao.PedidoDAO;
import lbd.proyecto.dao.ClienteDAO;
import lbd.proyecto.dao.VehiculoDAO;
import lbd.proyecto.dao.TipoCargaDAO;
import lbd.proyecto.dao.EstadoDAO;
import lbd.proyecto.dao.LicenciaEmpleadoDAO;

import lbd.proyecto.service.PedidoService;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.service.VehiculoService;
import lbd.proyecto.service.TipoCargaService;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.LicenciaEmpleadoService;
import lbd.proyecto.service.FacturaService;



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

        pedidoDAO.insertPedido(pedido.getDescripcion(), clienteResult.getIdCliente(), vehiculoResult.getIdVehiculo(), tipoCargaResult.getIdTipo(), pedido.getFechaPedido(), estadoResult.getIdEstado(), licenciaEmpleadoResult.getIdLicenciaEmpleado());
    }

    @Override
    @Transactional
    public void updatePedido(Pedido pedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, Estado estado, LicenciaEmpleado licenciaEmpleado) {
        Cliente clienteResult = clienteService.getCliente(cliente);
        Vehiculo vehiculoResult = vehiculoService.getVehiculo(vehiculo);
        TipoCarga tipoCargaResult = tipoCargaService.getTipoCarga(tipoCarga);
        Estado estadoResult = estadoService.getEstado(estado);
        LicenciaEmpleado licenciaEmpleadoResult = licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado);

        pedidoDAO.updatePedido(pedido.getIdPedido(), pedido.getDescripcion(), clienteResult.getIdCliente(), vehiculoResult.getIdVehiculo(), tipoCargaResult.getIdTipo(), pedido.getFechaPedido(), estadoResult.getIdEstado(), licenciaEmpleadoResult.getIdLicenciaEmpleado());
    }

    @Override
    @Transactional
    public void deletePedido(Pedido pedido) {
        pedidoDAO.deletePedido(pedido.getIdPedido());
    }

    @Override
    
    public Pedido getPedido(Pedido pedido) {
        
        return transactionTemplate.execute(new TransactionCallback<Pedido>() {
            @Override
            public Pedido doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_pedido"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_pedido");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("p_id_pedido", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_descripcion", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_cliente", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_vehiculo", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_tipo_carga", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_fecha", Date.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_estado", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_licencia_empleado", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("p_id_pedido", pedido.getIdPedido());

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
                    pedidoResult.setDescripcion((String) query.getOutputParameterValue("p_descripcion"));
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
                    pedidoResult.setTiposCarga(tipoCargaService.getTipoCarga(tipoCarga));

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

                    if (facturaResulFactura.getIdFactura() != null && facturaResulFactura.getIdFactura() != 0) {
                        pedidoResult.setFactura(facturaResulFactura);
                    }

                    return pedidoResult;

                } catch (Exception e) {
                    e.printStackTrace();
                }
                
                return null;

            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Pedido> getAllPedidos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_pedidos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("ver_pedidos");

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

        // Create a list to store the Pedido objects
        List<Pedido> pedidos = new ArrayList<>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getLong("id_pedido"));
                pedido.setDescripcion(rs.getString("descripcion"));
                pedido.setFechaPedido(rs.getDate("fecha"));

                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getLong("id_cliente"));
                pedido.setCliente(clienteService.getCliente(cliente));

                Vehiculo vehiculo = new Vehiculo();
                vehiculo.setIdVehiculo(rs.getLong("id_vehiculo"));
                pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));

                TipoCarga tipoCarga = new TipoCarga();
                tipoCarga.setIdTipo(rs.getLong("id_tipo_carga"));
                pedido.setTiposCarga(tipoCargaService.getTipoCarga(tipoCarga));

                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                pedido.setEstado(estadoService.getEstado(estado));

                LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                licenciaEmpleado.setIdLicenciaEmpleado(rs.getLong("id_licencia_empleado"));
                pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

                Factura factura = new Factura();
                factura.setPedido(pedido);
                Factura facturaResulFactura = facturaService.searchFacturaByPedido(pedido.getIdPedido());

                if (facturaResulFactura.getIdFactura() != null && facturaResulFactura.getIdFactura() != 0) {
                    pedido.setFactura(facturaResulFactura);
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
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call buscar_pedidos_por_cliente(?) }")) {
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idCliente);
                    callableStatement.execute();

                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        while (rs.next()) {
                            Pedido pedido = new Pedido();
                            pedido.setIdPedido(rs.getLong("id_pedido"));
                            pedido.setDescripcion(rs.getString("descripcion"));
                            pedido.setFechaPedido(rs.getDate("fecha"));

                            Cliente cliente = new Cliente();
                            cliente.setIdCliente(rs.getLong("id_cliente"));
                            pedido.setCliente(clienteService.getCliente(cliente));

                            Vehiculo vehiculo = new Vehiculo();
                            vehiculo.setIdVehiculo(rs.getLong("id_vehiculo"));
                            pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));

                            TipoCarga tipoCarga = new TipoCarga();
                            tipoCarga.setIdTipo(rs.getLong("id_tipo_carga"));
                            pedido.setTiposCarga(tipoCargaService.getTipoCarga(tipoCarga));

                            Estado estado = new Estado();
                            estado.setIdEstado(rs.getLong("id_estado"));
                            pedido.setEstado(estadoService.getEstado(estado));

                            LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
                            licenciaEmpleado.setIdLicenciaEmpleado(rs.getLong("id_licencia_empleado"));
                            pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

                            pedidos.add(pedido);
                        }
                    } 
                } catch (SQLException e) {
                    throw new RuntimeException(e);
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
