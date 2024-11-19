package lbd.proyecto.dao.direcciones;



// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.DireccionCliente;

public interface DireccionClienteDAO extends JpaRepository<DireccionCliente, Long> {
    
    // Method to call an stored procedure to insert a new direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_CLIENTE_TB_INSERTAR_SP")
    void insertDireccionCliente(Long idCliente, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstado);

    // Method to call an stored procedure to update a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_CLIENTE_TB_ACTUALIZAR_SP")
    void updateDireccionCliente(Long idDireccion, String detalles, Long idProvincia, Long idCanton, Long idDistrito, Long idEstado);

    // Method to call an stored procedure to delete a direction
    @Procedure(procedureName = "FIDE_DIRECCIONES_CLIENTE_TB_INACTIVAR_SP")
    void inactivarDireccionCliente(Long idDireccion);

    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCION_SP")
    DireccionCliente getDireccionCliente(Long idDireccion);

    // Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCIONES_SP")
    List<DireccionCliente> getAllDireccionesCliente();

    // Method to call a SQL function to get all the directions by client ID
    @Query(value = "SELECT * FROM TABLE(FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN(:p_id_cliente))", nativeQuery = true)
    List<DireccionCliente> buscarDireccionesCliente(@Param("p_id_cliente") Long idCliente);

}
