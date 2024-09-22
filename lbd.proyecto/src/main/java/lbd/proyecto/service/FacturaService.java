package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Factura;

public interface FacturaService {

    // Method to save a new invoice with the Stored Procedure
    void insertFactura(Factura factura, Pedido pedido, Estado estado);

    // Method to update an invoice with the Stored Procedure
    void updateFactura(Factura factura, Estado estado);

    // Method to delete an invoice with the Stored Procedure
    void deleteFactura(Factura factura);

    // Method to get an invoice with the Stored Procedure
    Factura getFactura(Factura factura);

    // Method to get all invoices with the Stored Procedure
    List<Factura> getAllFacturas();

    // Method to search invoice by order ID with the SQL function
    Factura searchFacturaByPedido(Long idPedido);

    // Method to convert a string to a Date
    public java.sql.Date convertDate(String input);
    
}
