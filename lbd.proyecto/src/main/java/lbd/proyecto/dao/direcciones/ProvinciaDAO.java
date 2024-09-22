package lbd.proyecto.dao.direcciones;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.direcciones.Provincia;

public interface ProvinciaDAO extends JpaRepository<Provincia, Long> {
    
    // Method to call an stored procedure to get a (single) province
    @Procedure(procedureName = "ver_provincia")
    Provincia getProvincia(Long idProvincia);
    
    //Method to call an stored procedure to get all provinces
    @Procedure(procedureName = "ver_provincias")
    List<Provincia> getAllProvincias();
    
}

