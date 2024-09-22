package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Puesto;

public interface PuestoDAO extends JpaRepository<Puesto, Long> {
    
    // Method to call an stored procedure to get a (single) license
    @Procedure(procedureName = "ver_puesto")
    Puesto getPuesto(Long idPuesto);

    //Method to call an stored procedure to get all licenses
    @Procedure(procedureName = "ver_puestos")
    List<Puesto> getAllPuestos();
    
}
