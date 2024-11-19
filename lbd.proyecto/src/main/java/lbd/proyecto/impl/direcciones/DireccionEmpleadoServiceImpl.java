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
import lbd.proyecto.dao.direcciones.DireccionEmpleadoDAO;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.service.direcciones.DireccionEmpleadoService;

import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.dao.EmpleadoDAO;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.dao.direcciones.DistritoDAO;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

@Service
public class DireccionEmpleadoServiceImpl implements DireccionEmpleadoService {

    @Autowired
    private DireccionEmpleadoDAO direccionEmpleadoDAO;

    @Autowired
    private EmpleadoService empleadoService;

    @Autowired
    private DistritoService distritoService;
    
    @Autowired
    private EstadoService estadoService;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertDireccionEmpleado(DireccionEmpleado direccionEmpleado, Empleado empleado, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        direccionEmpleadoDAO.insertDireccionEmpleado(empleadoResult.getIdEmpleado(), direccionEmpleado.getDetalles(),
                distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), 
                distritoResult.getIdDistrito(), direccionEmpleado.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void updateDireccionEmpleado(DireccionEmpleado direccionEmpleado, Distrito distrito) {
        Distrito distritoResult = distritoService.getDistrito(distrito);
        direccionEmpleadoDAO.updateDireccionEmpleado(direccionEmpleado.getIdDireccion(), direccionEmpleado.getDetalles(),
                distritoResult.getCanton().getProvincia().getIdProvincia(), distritoResult.getCanton().getIdCanton(), 
                distritoResult.getIdDistrito(), direccionEmpleado.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void inactivarDireccionEmpleado(DireccionEmpleado direccionEmpleado) {
        direccionEmpleadoDAO.inactivarDireccionEmpleado(direccionEmpleado.getIdDireccion());
    }

    @Override
    @Transactional
    public DireccionEmpleado getDireccionEmpleado(DireccionEmpleado direccionEmpleado) {
        return transactionTemplate.execute(new TransactionCallback<DireccionEmpleado>() {
            @Override
            public DireccionEmpleado doInTransaction(TransactionStatus status) {
                // Crear instancia de StoredProcedureQuery para llamar al procedimiento almacenado
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECION_SP");

                // Registrar los parámetros de entrada y salida
                query.registerStoredProcedureParameter("p_id_direccion", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("p_id_empleado", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_detalles", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_distrito", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("p_id_estado", Long.class, ParameterMode.OUT);

                // Establecer el parámetro de entrada
                query.setParameter("p_id_direccion", direccionEmpleado.getIdDireccion());

                // Ejecutar el procedimiento almacenado
                try {
                    query.execute();
                } catch (PersistenceException e) {
                    if (e.getCause() instanceof SQLException) {
                        // Manejo de excepciones SQL
                        SQLException sqlException = (SQLException) e.getCause();
                        System.err.println("Error Code: " + sqlException.getErrorCode());
                        System.err.println("SQL State: " + sqlException.getSQLState());
                        System.err.println("Message: " + sqlException.getMessage());
                        status.setRollbackOnly();
                        return null;  // Retorna null si ocurre un error
                    } else {
                        throw e;  // Rethrow si no es una SQLException
                    }
                }

                // Crear un objeto nuevo de DireccionEmpleado
                DireccionEmpleado newDireccionEmpleado = new DireccionEmpleado();
                newDireccionEmpleado.setIdDireccion(direccionEmpleado.getIdDireccion());

                // Obtener y verificar los parámetros de salida
                String detalles = (String) query.getOutputParameterValue("p_detalles");
                newDireccionEmpleado.setDetalles(detalles);

                // Verificar si los valores de salida no son nulos antes de asignarlos
                Long idEmpleado = (Long) query.getOutputParameterValue("p_id_empleado");
                if (idEmpleado != null) {
                    Empleado empleado = new Empleado();
                    empleado.setIdEmpleado(idEmpleado);
                    // Asegurarse de que el empleado existe en el sistema
                    newDireccionEmpleado.setEmpleado(empleadoService.getEmpleado(empleado));
                } else {
                    System.out.println("Empleado no encontrado para la dirección: " + direccionEmpleado.getIdDireccion());
                }

                Long idDistrito = (Long) query.getOutputParameterValue("p_id_distrito");
                if (idDistrito != null) {
                    Distrito distrito = new Distrito();
                    distrito.setIdDistrito(idDistrito);
                    // Asegurarse de que el distrito existe
                    newDireccionEmpleado.setDistrito(distritoService.getDistrito(distrito));
                } else {
                    System.out.println("Distrito no encontrado para la dirección: " + direccionEmpleado.getIdDireccion());
                }

                Long estadoId = (Long) query.getOutputParameterValue("p_id_estado");
                if (estadoId != null) {
                    Estado estado = new Estado();
                    estado.setIdEstado(estadoId);
                    // Asegurarse de que el estado existe
                    Estado newEstado = estadoService.getEstado(estado);
                    newDireccionEmpleado.setEstado(newEstado);
                } else {
                    System.out.println("Estado no encontrado para la dirección: " + direccionEmpleado.getIdDireccion());
                }

                return newDireccionEmpleado;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<DireccionEmpleado> getAllDirecciones() {
        // Create a StoredProcedureQuery instance for the stored procedure "FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECIONES_SP"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECIONES_SP");

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
        List<DireccionEmpleado> direcciones = new ArrayList<>();

        // Iterate over the result set
        try {
            while (rs.next()) {
                DireccionEmpleado direccion = new DireccionEmpleado();
                direccion.setIdDireccion(rs.getLong("id_direccion"));
                direccion.setDetalles(rs.getString("detalles"));

                Distrito distrito = new Distrito();
                distrito.setIdDistrito(rs.getLong("id_distrito"));
                direccion.setDistrito(distritoService.getDistrito(distrito));

                Empleado empleado = new Empleado();
                empleado.setIdEmpleado(rs.getLong("id_empleado"));
                direccion.setEmpleado(empleadoService.getEmpleado(empleado));
                
                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                Estado newEstado = estadoService.getEstado(estado);
                direccion.setEstado(newEstado);

                direcciones.add(direccion);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return direcciones;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<DireccionEmpleado> searchDireccionesByEmpleado(Long idEmpleado) {
        Session session = entityManager.unwrap(Session.class);
        List<DireccionEmpleado> direcciones = new ArrayList<>();

        session.doWork(new Work() {
            @Override
            public void execute(Connection connection) throws SQLException {
                // Usar try-with-resources para garantizar el cierre automático de recursos
                try (CallableStatement callableStatement = connection.prepareCall("{ ? = call FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN(?) }")) {
                    // Registrar el parámetro de salida del cursor
                    callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                    callableStatement.setLong(2, idEmpleado);

                    // Ejecutar la llamada a la función
                    callableStatement.execute();

                    // Obtener el resultado del cursor
                    try (ResultSet rs = (ResultSet) callableStatement.getObject(1)) {
                        // Procesar los resultados del cursor
                        while (rs.next()) {
                            DireccionEmpleado direccion = new DireccionEmpleado();
                            direccion.setIdDireccion(rs.getLong("id_direccion"));
                            direccion.setDetalles(rs.getString("detalles"));

                            // Obtener y establecer el distrito
                            Long idDistrito = rs.getLong("id_distrito");
                            if (!rs.wasNull()) {
                                Distrito distrito = new Distrito();
                                distrito.setIdDistrito(idDistrito);
                                direccion.setDistrito(distritoService.getDistrito(distrito));
                            }

                            // Obtener y establecer el empleado
                            Long idEmpleado = rs.getLong("id_empleado");
                            if (!rs.wasNull()) {
                                Empleado empleado = new Empleado();
                                empleado.setIdEmpleado(idEmpleado);
                                direccion.setEmpleado(empleadoService.getEmpleado(empleado));
                            }

                            // Obtener y establecer el estado
                            Long idEstado = rs.getLong("id_estado");
                            if (!rs.wasNull()) {
                                Estado estado = new Estado();
                                estado.setIdEstado(idEstado);
                                Estado newEstado = estadoService.getEstado(estado);
                                direccion.setEstado(newEstado);
                            }

                            // Añadir la dirección a la lista
                            direcciones.add(direccion);
                        }
                    }
                } catch (SQLException e) {
                    // Manejo de excepciones con mensaje más detallado
                    throw new RuntimeException("Error al ejecutar la función FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN: " + e.getMessage(), e);
                }
            }
        });

        return direcciones;
    }



}
