package lbd.proyecto.controller;

// External imports
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import jakarta.persistence.NoResultException;

// Internal imports
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Producto;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.service.PedidoService;

import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.service.TipoCargaService;

import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.DetallePedido;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.ClienteService;

import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.VehiculoService;

import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.service.LicenciaEmpleadoService;

import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.service.direcciones.DireccionPedidoService;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.CantonService;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.service.direcciones.ProvinciaService;

import lbd.proyecto.service.DetallePedidoService;
import lbd.proyecto.domain.DetallePedido;

import lbd.proyecto.domain.Producto;
import lbd.proyecto.service.ProductoService;

@Controller
@RequestMapping("/pedidos")
public class PedidoController {
    
    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private TipoCargaService tipoCargaService;

    @Autowired
    private EstadoService estadoService;

    @Autowired
    private ClienteService clienteService;

    @Autowired
    private VehiculoService vehiculoService;
    
    @Autowired
    ProvinciaService provinciaService;
    
    @Autowired
    CantonService cantonService;

    @Autowired
    private LicenciaEmpleadoService licenciaEmpleadoService;

    @Autowired
    private DireccionPedidoService direccionPedidoService;

    @Autowired
    private DistritoService distritoService;

    @Autowired
    private DetallePedidoService detallePedidoService;

    @Autowired
    private ProductoService productoService;

    @GetMapping("/agregar")
    public String agregarPedido(Model model) {
        List<TipoCarga> tiposCarga = tipoCargaService.getAllTiposCarga();
        // Verificar si la lista de tiposCarga está vacía
//        if (tiposCarga.isEmpty()) {
//            System.out.println("No se encontraron tipos de carga");
//        } else {
//            System.out.println("Tipos de carga: " + tiposCarga);
//        }

        List<Estado> estados = estadoService.getAllEstados();
        List<Cliente> clientes = clienteService.getAllClientes();
        List<Vehiculo> vehiculos = vehiculoService.getAllVehiculos();
        List<LicenciaEmpleado> licenciasEmpleado = licenciaEmpleadoService.getAllLicenciasEmpleados();

        // Agregar los atributos al modelo
        model.addAttribute("tiposCarga", tiposCarga);
        model.addAttribute("estados", estados);
        model.addAttribute("clientes", clientes);
        model.addAttribute("vehiculos", vehiculos);
        model.addAttribute("licenciasEmpleado", licenciasEmpleado);

        return "pedido/agregar";
    }

    
    /*
    @GetMapping("/agregar")
    public String agregarPedido(Model model) {
        List<TipoCarga> tiposCarga = tipoCargaService.getAllTiposCarga();
        List<Estado> estados = estadoService.getAllEstados();
        List<Cliente> clientes = clienteService.getAllClientes();
        List<Vehiculo> vehiculos = vehiculoService.getAllVehiculos();
        List<LicenciaEmpleado> licenciasEmpleado = licenciaEmpleadoService.getAllLicenciasEmpleados();
        model.addAttribute("tiposCarga", tiposCarga);
        model.addAttribute("estados", estados);
        model.addAttribute("clientes", clientes);
        model.addAttribute("vehiculos", vehiculos);
        model.addAttribute("licenciasEmpleado", licenciasEmpleado);
        return "pedido/agregar";
    }
    */


    @PostMapping("/add")
    public String insertarPedido(@RequestParam String fechaPedido, @RequestParam String idTipo, 
        @RequestParam String idEstado, @RequestParam String idLicenciaEmpleado, @RequestParam String idCliente, @RequestParam String idVehiculo,
        RedirectAttributes redirectAttributes) {
            Pedido pedido = new Pedido();
            pedido.setFechaPedido(pedidoService.convertDate(fechaPedido));
            //pedido.setDescripcion(descripcion);
            TipoCarga tipoCarga = new TipoCarga();
            tipoCarga.setIdTipo(Long.parseLong(idTipo));
            pedido.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));
            Estado estado = new Estado();
            estado.setIdEstado(Long.parseLong(idEstado));
            pedido.setEstado(estadoService.getEstado(estado));
            Cliente cliente = new Cliente();
            cliente.setIdCliente(Long.parseLong(idCliente));
            pedido.setCliente(clienteService.getCliente(cliente));
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setIdVehiculo(Long.parseLong(idVehiculo));
            pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));
            LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
            licenciaEmpleado.setIdLicenciaEmpleado(Long.parseLong(idLicenciaEmpleado));
            pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

            pedidoService.insertPedido(pedido, cliente, vehiculo, tipoCarga, estado, licenciaEmpleado);

            return "redirect:/pedidos/ver";
    }

    @GetMapping("/editar/{idPedido}")
    public String editarPedido(@PathVariable Long idPedido, Model model) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        Pedido pedidoResult = pedidoService.getPedido(pedido);
        model.addAttribute("pedido", pedidoResult);
        model.addAttribute("idPedido", idPedido);
        model.addAttribute("fechaPedido", pedidoResult.getFechaPedido());
        //model.addAttribute("descripcion", pedidoResult.getDescripcion());
        model.addAttribute("idTipo", pedidoResult.getTipoCarga().getIdTipo());
        model.addAttribute("idEstado", pedidoResult.getEstado().getIdEstado());
        model.addAttribute("idCliente", pedidoResult.getCliente().getIdCliente());
        model.addAttribute("idVehiculo", pedidoResult.getVehiculo().getIdVehiculo());
        model.addAttribute("idLicenciaEmpleado", pedidoResult.getLicenciaEmpleado().getIdLicenciaEmpleado());
        model.addAttribute("tiposCarga", tipoCargaService.getAllTiposCarga());
        model.addAttribute("estados", estadoService.getAllEstados());
        model.addAttribute("clientes", clienteService.getAllClientes());
        model.addAttribute("vehiculos", vehiculoService.getAllVehiculos());
        model.addAttribute("licenciasEmpleado", licenciaEmpleadoService.getAllLicenciasEmpleados());

        return "/pedido/actualizar";
    }

    @PostMapping("/update")
    public String actualizarPedido(@RequestParam Long idPedido, @RequestParam String fechaPedido, @RequestParam String idTipo, 
        @RequestParam String idEstado, @RequestParam String idLicenciaEmpleado, @RequestParam String idCliente, @RequestParam String idVehiculo, RedirectAttributes redirectAttributes) {
            Pedido pedido = new Pedido();
            pedido.setIdPedido(idPedido);
            //pedido.setDescripcion(descripcion);
            pedido.setFechaPedido(pedidoService.convertDate(fechaPedido));
            TipoCarga tipoCarga = new TipoCarga();
            tipoCarga.setIdTipo(Long.parseLong(idTipo));
            pedido.setTipoCarga(tipoCargaService.getTipoCarga(tipoCarga));
            Estado estado = new Estado();
            estado.setIdEstado(Long.parseLong(idEstado));
            pedido.setEstado(estadoService.getEstado(estado));
            Cliente cliente = new Cliente();
            cliente.setIdCliente(Long.parseLong(idCliente));
            pedido.setCliente(clienteService.getCliente(cliente));
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setIdVehiculo(Long.parseLong(idVehiculo));
            pedido.setVehiculo(vehiculoService.getVehiculo(vehiculo));
            LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
            licenciaEmpleado.setIdLicenciaEmpleado(Long.parseLong(idLicenciaEmpleado));
            pedido.setLicenciaEmpleado(licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado));

            pedidoService.updatePedido(pedido, cliente, vehiculo, tipoCarga, estado, licenciaEmpleado);

            return "redirect:/pedidos/ver";
    }

    @GetMapping("/ver")
    public String verPedidos(Model model) {
        List<Pedido> pedidos = pedidoService.getAllPedidos();
        model.addAttribute("pedidos", pedidos);
        return "/pedido/ver";
    }

    @GetMapping("/inactivar/{idPedido}")
    public String inactivarPedido(@PathVariable Long idPedido, RedirectAttributes redirectAttributes) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        pedidoService.inactivarPedido(pedido);
        return "redirect:/pedidos/ver";
    }

    // Direccion
    @GetMapping("{idPedido}/dir/ver")
    public String verDireccion(@PathVariable Long idPedido, Model model) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        List<DireccionPedido> direcciones = direccionPedidoService.searchDireccionesByPedido(pedido.getIdPedido());
        
      
        model.addAttribute("direcciones", direcciones);
        return "/direccion/ver-pedido";
    }

    @GetMapping("{idPedido}/dir/agregar")
    public String agregarDireccion(@PathVariable Long idPedido, Model model) {
        model.addAttribute("idPedido", idPedido);
        return "/direccion/agregar-pedido";
    }

    @PostMapping("/dir/add")
    public String insertarDireccion(@RequestParam Long idPedido, @RequestParam String idDistrito, @RequestParam String detalles, RedirectAttributes redirectAttributes) {
        DireccionPedido direccionPedido = new DireccionPedido();
        direccionPedido.setDetalles(detalles);
        
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        pedido = pedidoService.getPedido(pedido);
        direccionPedido.setPedido(pedido);

        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        distrito = distritoService.getDistrito(distrito);
        direccionPedido.setDistrito(distrito);
        
        Estado estado = new Estado();
        estado.setIdEstado(7L); // Asignar idEstado siempre como 7
        direccionPedido.setEstado(estado);
        
        direccionPedidoService.insertDireccionPedido(direccionPedido, pedido, distrito);
        
        redirectAttributes.addAttribute("idPedido", idPedido);

        return "redirect:/pedidos/{idPedido}/dir/ver";

    }

    @GetMapping("{idPedido}/dir/editar/{idDireccion}")
    public String editarDireccion(@PathVariable Long idPedido, @PathVariable Long idDireccion, Model model) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        
        DireccionPedido direccion = new DireccionPedido();
        direccion.setIdDireccion(idDireccion);
        DireccionPedido direccionResult = direccionPedidoService.getDireccionPedido(direccion);

//        System.out.println(" *** DEBUG *** ");
//        System.out.println(direccionResult);
        
        if (direccionResult != null && direccionResult.getDistrito() != null
            && direccionResult.getDistrito().getCanton() != null
            && direccionResult.getDistrito().getCanton().getProvincia() != null) {
            Provincia provincia = direccionResult.getDistrito().getCanton().getProvincia();
            System.out.println(provincia.getNombre());
        } else {
            System.out.println("Provincia, Cantón o Distrito son nulos.");
        }

        model.addAttribute("direccion", direccionResult);
        model.addAttribute("idPedido", idPedido);
        model.addAttribute("idDireccion", idDireccion);
        model.addAttribute("detalles", direccionResult.getDetalles());
        
        Provincia provincia = direccionResult.getDistrito().getCanton().getProvincia();
        model.addAttribute("provinciaOld", provincia); // Método para obtener provincias
        Canton canton = direccionResult.getDistrito().getCanton();
        model.addAttribute("cantonOld", canton);   // Método para obtener cantones
        Distrito distrito = direccionResult.getDistrito();
        model.addAttribute("distritoOld", distrito); // Método para obtener distritos

        model.addAttribute("provincias", provinciaService.getAllProvincias());
        model.addAttribute("cantones", cantonService.getAllCantones());
        model.addAttribute("distritos", distritoService.getAllDistritos());
        model.addAttribute("estados", estadoService.getAllEstados());
        
        return "/direccion/actualizar-pedido";
    }

    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idPedido, @RequestParam Long idDireccion, @RequestParam String detalles, @RequestParam String idDistrito, @RequestParam Long idEstado, RedirectAttributes redirectAttributes) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        
        DireccionPedido direccion = new DireccionPedido();
        direccion.setIdDireccion(idDireccion);
        direccion.setDetalles(detalles);
        
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        Distrito distritoResult = distritoService.getDistrito(distrito);
        
        // Configura el Estado
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        Estado estadoResult = estadoService.getEstado(estado); 
        direccion.setEstado(estadoResult);
        
        direccionPedidoService.updateDireccionPedido(direccion, distritoResult);
        redirectAttributes.addAttribute("idPedido", idPedido);
        
        return "redirect:/pedidos/{idPedido}/dir/ver";
    }

    @GetMapping("{idPedido}/dir/inactivar/{idDireccion}")
    public String inactivarDireccion(@PathVariable Long idPedido, @PathVariable Long idDireccion, RedirectAttributes redirectAttributes) {
        DireccionPedido direccion = new DireccionPedido();
        direccion.setIdDireccion(idDireccion);
        direccionPedidoService.inactivarDireccionPedido(direccion);
        redirectAttributes.addAttribute("idPedido", idPedido);
        
        return "redirect:/pedidos/{idPedido}/dir/ver";
    }

    // Detalles
    @GetMapping("{idPedido}/detalles/ver")
    public String verDetalles(@PathVariable Long idPedido, Model model) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        List<DetallePedido> detalles = detallePedidoService.searchDetallesByPedido(pedido.getIdPedido());
        List<Producto> productos = productoService.getAllProductos();
        List<Estado> estados = estadoService.getAllEstados();
      
        model.addAttribute("estados", estados);
        model.addAttribute("productos", productos);
        model.addAttribute("detallesPedido", detalles);

        model.addAttribute("idPedido", idPedido);

        return "/detalle/ver";
    }

    @PostMapping("detalles/add")
    public String insertarDetalle(@RequestParam Long idPedidoAdd, @RequestParam String idProductoAdd, @RequestParam String cantidadAdd, @RequestParam String unidadMasaAdd, RedirectAttributes redirectAttributes) {
        DetallePedido detallePedido = new DetallePedido();
        detallePedido.setCantidad(Integer.parseInt(cantidadAdd));
        detallePedido.setUnidadMasa(unidadMasaAdd);
        
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedidoAdd);
        pedido = pedidoService.getPedido(pedido);
        detallePedido.setPedido(pedido);

        Producto producto = new Producto();
        producto.setIdProducto(Long.parseLong(idProductoAdd));
        producto = productoService.getProducto(producto);
        detallePedido.setProducto(producto);
        
        if (detallePedido.getEstado() == null) {
            Estado estado = new Estado();
            estado.setIdEstado((long)7); 
            detallePedido.setEstado(estado);
        }
        
        detallePedidoService.insertDetallePedido(detallePedido, pedido, producto);
        
        redirectAttributes.addAttribute("idPedido", idPedidoAdd);

        return "redirect:/pedidos/{idPedido}/detalles/ver";
    }

    @PostMapping("detalles/update")
    public String actualizarDetalle(@RequestParam Long idPedidoUpdate, @RequestParam Long idDetalleUpdate, @RequestParam String cantidadUpdate, @RequestParam String idProductoUpdate, @RequestParam String unidadMasaUpdate, RedirectAttributes redirectAttributes) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedidoUpdate);
        
        DetallePedido detalle = new DetallePedido();
        detalle.setIdDetalle(idDetalleUpdate);
        detalle.setCantidad(Double.parseDouble(cantidadUpdate));
        detalle.setUnidadMasa(unidadMasaUpdate);
        
        // System.out.println(" ID PRODUCTO UPDATE");
        // System.out.println(idProductoUpdate);
        Producto producto = new Producto();
        producto.setIdProducto(Long.parseLong(idProductoUpdate));
        Producto productoResult = productoService.getProducto(producto);

        detalle.setProducto(productoResult);
        detalle.setPedido(pedido);
        
        if (detalle.getEstado() == null) {
            Estado estado = new Estado();
            estado.setIdEstado((long)7); 
            detalle.setEstado(estado);
        }
        
        detallePedidoService.updateDetallePedido(idDetalleUpdate, detalle);
        redirectAttributes.addAttribute("idPedido", idPedidoUpdate);
        
        return "redirect:/pedidos/{idPedido}/detalles/ver";
    }

    @GetMapping("{idPedido}/detalles/inactivar/{idDetalle}")
    public String inactivarDetalle(@PathVariable Long idPedido, @PathVariable Long idDetalle, RedirectAttributes redirectAttributes) {
        DetallePedido detalle = new DetallePedido();
        detalle.setIdDetalle(idDetalle);
        detallePedidoService.inactivarDetallePedido(detalle.getIdDetalle());
        redirectAttributes.addAttribute("idPedido", idPedido);
        
        return "redirect:/pedidos/{idPedido}/detalles/ver";
    }

}
