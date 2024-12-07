package lbd.proyecto.dao;



// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Categoria;

public interface CategoriaDAO extends JpaRepository<Categoria, Long> {
     
    //Method to call an stored procedure to insert a new category
    @Procedure(procedureName = "FIDE_CATEGORIAS_TB_INSERTAR_SP")
    void insertCategoria(String descripcion, Long idEstado);

    // Method to call an stored procedure to update a category
    @Procedure(procedureName = "FIDE_CATEGORIAS_TB_ACTUALIZAR_SP")
    void updateCategoria(Long idCategoria, String descripcion, Long idEstado);

    // Method to call an stored procedure to get a (single) category
    // @Procedure(procedureName = "")
    // Categoria getCategoria(Long idCategoria);

    // Method to call an stored procedure to get all categories
    // @Procedure(procedureName = "")
    // List<Categoria> getAllCategorias();

    //Method to call an stored procedure to delete a category
    @Procedure(procedureName = "FIDE_CATEGORIAS_TB_INACTIVAR_SP")
    void inactivarCategoria(Long idCategoria);

}
