package lbd.proyecto.dao;



// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Cliente;

public interface ClienteDAO extends JpaRepository<Cliente, Long> {
    
    // Method to call an stored procedure to insert a new client
    @Procedure(procedureName = "FIDE_PROYECTO_CLIENTES_PKG.FIDE_CLIENTES_TB_INSERTAR_SP")
    void insertCliente(String nombre, String apellidos, String telefono, String email, Long idEstado);
    
    // Method to call an stored procedure to update a client
    @Procedure(procedureName = "FIDE_PROYECTO_CLIENTES_PKG.FIDE_CLIENTES_TB_ACTUALIZAR_SP")
    void updateCliente(Long idCliente, String nombre, String apellidos, String telefono, String email, Long idEstado);

    // Method to call an stored procedure to get a (single) client
    // @Procedure(procedureName = "ver_cliente")
    // Cliente getCliente(Long idCliente);
    
    //Method to call an stored procedure to get all clients
    // @Procedure(procedureName = "ver_clientes")
    // List<Cliente> getAllClientes();

    //Method to call an stored procedure to delete a client
    @Procedure(procedureName = "FIDE_PROYECTO_CLIENTES_PKG.FIDE_CLIENTES_TB_INACTIVAR_SP")
    void inactivarCliente(Long idCliente);

}
