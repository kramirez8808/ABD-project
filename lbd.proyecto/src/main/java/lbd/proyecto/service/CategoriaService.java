package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Categoria;

public interface CategoriaService {
    
    // Method to save a new category with the Stored Procedure
    void insertCategoria(Categoria categoria);

    // Method to update a category with the Stored Procedure
    void updateCategoria(Long idCategoria, Categoria categoria);

    // Method to get a category with the Stored Procedure
    Categoria getCategoria(Categoria categoria);

    // Method to get all categories with the Stored Procedure
    List<Categoria> getAllCategorias();

    // Method to delete a category with the Stored Procedure
    void inactivarCategoria(Long idCategoria);

}
