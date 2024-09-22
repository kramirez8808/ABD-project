package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Estado;

public interface EstadoDAO extends JpaRepository<Estado, Long> {
    
    // Method to call an stored procedure to get a (single) license
    @Procedure(procedureName = "ver_estado")
    Estado getEstado(Long idEstado);

    //Method to call an stored procedure to get all licenses
    @Procedure(procedureName = "ver_estados")
    List<Estado> getAllEstados();
    
}
