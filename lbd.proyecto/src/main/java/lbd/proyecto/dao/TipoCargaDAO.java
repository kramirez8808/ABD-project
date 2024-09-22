package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.TipoCarga;

public interface TipoCargaDAO extends JpaRepository<TipoCarga, Long> {
    
    // Method to call an stored procedure to get a (single) type of load
    @Procedure(procedureName = "ver_tipo_carga")
    TipoCarga getTipoCarga(Long idTipo);
    
    //Method to call an stored procedure to get all types of load
    @Procedure(procedureName = "ver_tipos_carga")
    List<TipoCarga> getAllTiposCarga();
    
}
