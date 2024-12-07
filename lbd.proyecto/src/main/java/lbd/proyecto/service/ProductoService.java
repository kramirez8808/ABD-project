package lbd.proyecto.service;

import java.util.List;
import lbd.proyecto.domain.Producto;

public interface ProductoService {

    // Method to get a product with the Stored Procedure
    Producto getProducto(Producto producto);

    // Method to get all products with the Stored Procedure
    List<Producto> getAllProductos();

    // Method to save a new product with the Stored Procedure
    void insertProducto(Producto producto);

    // Method to update a product with the Stored Procedure
    void updateProducto(Long idProducto, Producto producto);

    // Method to delete a product with the Stored Procedure
    void inactivarProducto(Long idProducto);

}
