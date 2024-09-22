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
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.service.PedidoService;

import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.service.TipoCargaService;

import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.ClienteService;

import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.VehiculoService;

import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.service.LicenciaEmpleadoService;

import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.service.direcciones.DireccionPedidoService;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.DistritoService;

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
    private LicenciaEmpleadoService licenciaEmpleadoService;

    @Autowired
    private DireccionPedidoService direccionPedidoService;

    @Autowired
    private DistritoService distritoService;

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

    @PostMapping("/add")
    public String insertarPedido(@RequestParam String fechaPedido, @RequestParam String idTipo, 
        @RequestParam String idEstado, @RequestParam String idLicenciaEmpleado, @RequestParam String idCliente, @RequestParam String idVehiculo,
        @RequestParam String descripcion, RedirectAttributes redirectAttributes) {
            Pedido pedido = new Pedido();
            pedido.setFechaPedido(pedidoService.convertDate(fechaPedido));
            pedido.setDescripcion(descripcion);
            TipoCarga tipoCarga = new TipoCarga();
            tipoCarga.setIdTipo(Long.parseLong(idTipo));
            pedido.setTiposCarga(tipoCargaService.getTipoCarga(tipoCarga));
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
        model.addAttribute("descripcion", pedidoResult.getDescripcion());
        model.addAttribute("idTipo", pedidoResult.getTiposCarga().getIdTipo());
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
        @RequestParam String idEstado, @RequestParam String descripcion, @RequestParam String idLicenciaEmpleado, @RequestParam String idCliente, @RequestParam String idVehiculo, RedirectAttributes redirectAttributes) {
            Pedido pedido = new Pedido();
            pedido.setIdPedido(idPedido);
            pedido.setDescripcion(descripcion);
            pedido.setFechaPedido(pedidoService.convertDate(fechaPedido));
            TipoCarga tipoCarga = new TipoCarga();
            tipoCarga.setIdTipo(Long.parseLong(idTipo));
            pedido.setTiposCarga(tipoCargaService.getTipoCarga(tipoCarga));
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

    @GetMapping("/eliminar/{idPedido}")
    public String eliminarPedido(@PathVariable Long idPedido, RedirectAttributes redirectAttributes) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        pedidoService.deletePedido(pedido);
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
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        
        Distrito distritoResult = distritoService.getDistrito(distrito);
        DireccionPedido direccionPedido = new DireccionPedido(detalles, distritoResult);
        direccionPedido.setPedido(pedido);

        direccionPedidoService.insertDireccionPedido(direccionPedido, pedido, distritoResult);

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


        model.addAttribute("direccion", direccionResult);
        model.addAttribute("idPedido", idPedido);
        model.addAttribute("idDireccion", idDireccion);
        model.addAttribute("detalles", direccionResult.getDetalles());
        return "/direccion/actualizar-pedido";
    }

    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idPedido, @RequestParam Long idDireccion, @RequestParam String detalles, @RequestParam String idDistrito, RedirectAttributes redirectAttributes) {
        Pedido pedido = new Pedido();
        pedido.setIdPedido(idPedido);
        DireccionPedido direccion = new DireccionPedido();
        direccion.setIdDireccion(idDireccion);
        direccion.setDetalles(detalles);
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        Distrito distritoResult = distritoService.getDistrito(distrito);
        
        direccionPedidoService.updateDireccionPedido(direccion, distritoResult);

        redirectAttributes.addAttribute("idPedido", idPedido);
        return "redirect:/pedidos/{idPedido}/dir/ver";
    }

    @GetMapping("{idPedido}/dir/eliminar/{idDireccion}")
    public String eliminarDireccion(@PathVariable Long idPedido, @PathVariable Long idDireccion, RedirectAttributes redirectAttributes) {
        DireccionPedido direccion = new DireccionPedido();
        direccion.setIdDireccion(idDireccion);
        direccionPedidoService.deleteDireccionPedido(direccion);
        redirectAttributes.addAttribute("idPedido", idPedido);
        
        return "redirect:/pedidos/{idPedido}/dir/ver";
    }



}
