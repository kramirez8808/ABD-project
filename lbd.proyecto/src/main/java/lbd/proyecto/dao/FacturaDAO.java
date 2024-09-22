package lbd.proyecto.dao;

// External imports
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.sql.Date;
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Factura;

public interface FacturaDAO extends JpaRepository<Factura, Long> {

    // Method to call an stored procedure to insert a new invoice
    @Procedure(procedureName = "insertar_factura")
    void insertFactura(Long idPedido, Date fecha, double total, Long idEstado);

    // Method to call an stored procedure to update an invoice
    @Procedure(procedureName = "actualizar_factura")
    void updateFactura(Long idFactura, Date fecha, double total, Long idEstado);

    // Method to call an stored procedure to delete an invoice
    @Procedure(procedureName = "eliminar_factura")
    void deleteFactura(Long idFactura);

    // Method to call an stored procedure to get a (single) invoice
    @Procedure(procedureName = "ver_factura")
    Factura getFactura(Long idFactura);

    // Method to call an stored procedure to get all invoices
    @Procedure(procedureName = "ver_facturas")
    List<Factura> getAllFacturas();
    
}
