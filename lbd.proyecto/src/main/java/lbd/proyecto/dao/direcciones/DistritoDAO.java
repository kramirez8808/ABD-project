package lbd.proyecto.dao.direcciones;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Distrito;

public interface DistritoDAO extends JpaRepository<Distrito, Long> {
    
    // Method to call an stored procedure to get a (single) distrito
    @Procedure(procedureName = "ver_distrito")
    Distrito getDistrito(Long idDistrito);
    
    //Method to call an stored procedure to get all distritos
    @Procedure(procedureName = "ver_distritos")
    List<Distrito> getAllDistritos();
    
}
