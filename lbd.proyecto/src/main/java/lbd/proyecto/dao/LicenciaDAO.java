package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Licencia;

public interface LicenciaDAO extends JpaRepository<Licencia, Long> {
    
    // Method to call an stored procedure to get a (single) license
    @Procedure(procedureName = "FIDE_LICENCIAS_TB_VER_LICENCIA_SP")
    Licencia getLicencia(Long idLicencia);

    //Method to call an stored procedure to get all licenses
    @Procedure(procedureName = "FIDE_LICENCIAS_TB_VER_LICENCIAS_SP")
    List<Licencia> getAllLicencias();
}
