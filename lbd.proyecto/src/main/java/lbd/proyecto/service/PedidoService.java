package lbd.proyecto.service;

// External imports
import java.util.List;

// Internal imports
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.LicenciaEmpleado;

public interface PedidoService {
    
    // Method to save a new order with the Stored Procedure
    void insertPedido(Pedido pedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, Estado estado, LicenciaEmpleado licenciaEmpleado);

    // Method to update an order with the Stored Procedure
    void updatePedido(Pedido pedido, Cliente cliente, Vehiculo vehiculo, TipoCarga tipoCarga, Estado estado, LicenciaEmpleado licenciaEmpleado);

    // Method to delete an order with the Stored Procedure
    void deletePedido(Pedido pedido);

    // Method to get an order with the Stored Procedure
    Pedido getPedido(Pedido pedido);

    // Method to get all orders with the Stored Procedure
    List<Pedido> getAllPedidos();

    // Method to search orders by client ID with the SQL function
    List<Pedido> searchPedidosByCliente(Long idCliente);

    // Method to convert a string to a Date
    public java.sql.Date convertDate(String input);
}
