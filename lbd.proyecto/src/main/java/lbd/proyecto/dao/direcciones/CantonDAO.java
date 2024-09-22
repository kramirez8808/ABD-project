package lbd.proyecto.dao.direcciones;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Canton;

public interface CantonDAO extends JpaRepository<Canton, Long> {
    
    // Method to call an stored procedure to get a (single) canton
    @Procedure(procedureName = "ver_canton")
    Canton getCanton(Long idCanton);
    
    //Method to call an stored procedure to get all cantons
    @Procedure(procedureName = "ver_cantones")
    List<Canton> getAllCantones();
    
}
