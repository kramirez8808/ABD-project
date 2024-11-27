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
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.direcciones.CantonService;
import lbd.proyecto.service.direcciones.DireccionClienteService;
import lbd.proyecto.service.direcciones.ProvinciaService;

@Controller
@RequestMapping("/clientes")
public class ClienteController {
    
    @Autowired
    ClienteService clienteService;

    @Autowired
    DireccionClienteService direccionClienteService;
    
    @Autowired
    EstadoService estadoService;
    
    @Autowired
    ProvinciaService provinciaService;
    
    @Autowired
    CantonService cantonService;

    @Autowired
    DistritoService distritoService;

    // Add
    // @GetMapping("/add-test")
    // public String addClientTest() {
    //     Cliente clienteTest = new Cliente("Alejandraias", "Lastname3", "3333333", "name3@last3.com");
    //     clienteService.insertCliente(clienteTest);
    //     return "redirect:/clientes";
    // }

    @GetMapping("/agregar")
    public String agregarCliente() {
        return "/cliente/agregar";
    }
    
    @PostMapping("/add")
    public String insertarCliente(@RequestParam String nombre, @RequestParam String apellido, 
                                  @RequestParam String telefono, @RequestParam String email) {
        Cliente cliente = new Cliente();
        cliente.setNombre(nombre);
        cliente.setApellido(apellido);
        cliente.setTelefono(telefono);
        cliente.setEmail(email);

        Estado estado = new Estado();
        estado.setIdEstado(7L);
        cliente.setEstado(estado);

        System.out.println(cliente);
        clienteService.insertCliente(cliente);
        return "redirect:/clientes/ver";
    }


    /*
    @PostMapping("/add")
    public String insertarCliente(@RequestParam String nombre, @RequestParam String apellido, @RequestParam String telefono, @RequestParam String email) {
        Cliente cliente = new Cliente(nombre, apellido, telefono, email);
        if (cliente.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7); 
                cliente.setEstado(estado);
            }
        System.out.println(cliente);
        clienteService.insertCliente(cliente);
        return "redirect:/clientes/ver";
    }*/

    @GetMapping("/editar/{idCliente}")
    public String editarCliente(@PathVariable Long idCliente, Model model) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        Cliente clienteResult = clienteService.getCliente(cliente);
        model.addAttribute("cliente", clienteResult);
        model.addAttribute("idCliente", idCliente);
        model.addAttribute("nombre", clienteResult.getNombre());
        model.addAttribute("apellido", clienteResult.getApellido());
        model.addAttribute("telefono", clienteResult.getTelefono());
        model.addAttribute("email", clienteResult.getEmail());
        model.addAttribute("estados", estadoService.getAllEstados());
        return "/cliente/actualizar";
    }

    @PostMapping("/update")
    public String actualizarCliente(@RequestParam Long idCliente, @RequestParam String nombre, @RequestParam String apellido, @RequestParam String telefono, @RequestParam Long idEstado, @RequestParam String email) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        cliente.setNombre(nombre);
        cliente.setApellido(apellido);
        cliente.setTelefono(telefono);
        cliente.setEmail(email);
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        cliente.setEstado(estadoService.getEstado(estado));
        
        clienteService.updateCliente(idCliente, cliente);
        return "redirect:/clientes/ver";
    }

    @GetMapping("/get-test")
    public String getClienteTest() {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(2L);
        

        Cliente clienteTest = clienteService.getCliente(cliente);

        System.out.println(cliente.getIdCliente());
        System.out.println(clienteTest);
        return "redirect:/clientes";
    }

    @GetMapping("/ver")
    public String verClientes(Model model) {
        List<Cliente> clientes = clienteService.getAllClientes();
        model.addAttribute("clientes", clientes);
        return "/cliente/ver";
    }

    // Delete
    @GetMapping("/delete-test")
    public String inactivarClienteTest() {
        clienteService.inactivarCliente(3L);
        return "redirect:/clientes";
    }

    @GetMapping("/inactivar/{idCliente}")
    public String eliminarCliente(@PathVariable Long idCliente) {
        clienteService.inactivarCliente(idCliente);
        return "redirect:/clientes/ver";

    }

    @PostMapping("/busqueda-nombre")
    public String buscarClienteNombre(@RequestParam String nombreBusqueda, Model model) {
        List<Cliente> clientes = clienteService.searchClientesNombre(nombreBusqueda);
        model.addAttribute("nombreBusqueda", nombreBusqueda);
        model.addAttribute("clientes", clientes);
        return "/cliente/ver";
    }

    @PostMapping("/busqueda-email")
    public String buscarClienteEmail(@RequestParam String emailBusqueda, Model model) {
        List<Cliente> clientes = clienteService.searchClientesEmail(emailBusqueda);
        model.addAttribute("emailBusqueda", emailBusqueda);
        model.addAttribute("clientes", clientes);
        return "/cliente/ver";
    }

    @PostMapping("/busqueda-id")
    public String buscarClienteId(@RequestParam Long idBusqueda, Model model) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idBusqueda);

        Cliente clienteResult = clienteService.getCliente(cliente);
        List<Cliente> clientes = new ArrayList<>();

        if (clienteResult != null) {
            clientes.add(clienteResult);
        }

        model.addAttribute("clientes", clientes);

        // try {
        //     clienteResult = clienteService.getCliente(cliente);
        //     List<Cliente> clientes = new ArrayList<>();
        //     clientes.add(clienteResult);
        //     model.addAttribute("clientes", clientes);
        // } catch ( DataAccessException e) {
        //     List<Cliente> clientes = new ArrayList<>();
        //     model.addAttribute("clientes", clientes);
            
        // }

        model.addAttribute("idBusqueda", idBusqueda);
        return "/cliente/ver";
    }

    // Direccion

    @GetMapping("{idCliente}/dir/ver")
    public String verDireccion(@PathVariable Long idCliente, Model model) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        List<DireccionCliente> direcciones = direccionClienteService.searchDireccionesByCliente(cliente.getIdCliente());
        model.addAttribute("direcciones", direcciones);
        return "/direccion/ver-cliente";
    }

    @GetMapping("{idCliente}/dir/agregar")
    public String agregarDireccion(@PathVariable Long idCliente, Model model) {
        model.addAttribute("idCliente", idCliente);
        return "/direccion/agregar-cliente";
    }

    @PostMapping("/dir/add")
    public String insertarDireccion(@RequestParam Long idCliente, @RequestParam String idDistrito, @RequestParam String detalles, RedirectAttributes redirectAttributes) {
        
        DireccionCliente direccionCliente = new DireccionCliente();
        direccionCliente.setDetalles(detalles);
        
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        cliente = clienteService.getCliente(cliente);
        direccionCliente.setCliente(cliente);

        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        distrito = distritoService.getDistrito(distrito);
        direccionCliente.setDistrito(distrito);
        
        if (direccionCliente.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7); 
                direccionCliente.setEstado(estado);
        }
        direccionClienteService.insertDireccionCliente(direccionCliente, cliente, distrito);
        /*
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        /*
        Distrito distritoResult = distritoService.getDistrito(distrito);
        DireccionCliente direccionCliente = new DireccionCliente(detalles, distritoResult);
        direccionCliente.setCliente(cliente);
        
        direccionClienteService.insertDireccionCliente(direccionCliente, cliente, distritoResult);
        */
        
        redirectAttributes.addAttribute("idCliente", idCliente);

        return "redirect:/clientes/{idCliente}/dir/ver";
    }

    @GetMapping("{idCliente}/dir/editar/{idDireccion}")
    public String editarDireccion(@PathVariable Long idCliente, @PathVariable Long idDireccion, Model model) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        
        DireccionCliente direccion = new DireccionCliente();
        direccion.setIdDireccion(idDireccion);
        DireccionCliente direccionResult = direccionClienteService.getDireccionCliente(direccion);
        
        System.out.println(" *** DEBUG *** ");
        System.out.println(direccionResult);
        
        if (direccionResult != null && direccionResult.getDistrito() != null
            && direccionResult.getDistrito().getCanton() != null
            && direccionResult.getDistrito().getCanton().getProvincia() != null) {
            Provincia provincia = direccionResult.getDistrito().getCanton().getProvincia();
            System.out.println(provincia.getNombre());
        } else {
            System.out.println("Provincia, Cantón o Distrito son nulos.");
        }

        model.addAttribute("direccion", direccionResult);
        model.addAttribute("idCliente", idCliente);
        model.addAttribute("idDireccion", idDireccion);
        model.addAttribute("detalles", direccionResult.getDetalles());

        // Enviar las listas de provincias, cantones y distritos
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
        
        return "/direccion/actualizar-cliente";
    }

    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idCliente, @RequestParam Long idDireccion, @RequestParam String detalles, @RequestParam String idDistrito, @RequestParam Long idEstado, RedirectAttributes redirectAttributes) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(idCliente);
        
        DireccionCliente direccion = new DireccionCliente();
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

        direccionClienteService.updateDireccionCliente(direccion, distritoResult);
        redirectAttributes.addAttribute("idCliente", idCliente);
        
        return "redirect:/clientes/{idCliente}/dir/ver";
    }

    @GetMapping("{idCliente}/dir/inactivar/{idDireccion}")
    public String inactivarDireccion(@PathVariable Long idCliente, @PathVariable Long idDireccion, RedirectAttributes redirectAttributes) {
        DireccionCliente direccion = new DireccionCliente();
        direccion.setIdDireccion(idDireccion);
        direccionClienteService.inactivarDireccionCliente(direccion);
        redirectAttributes.addAttribute("idCliente", idCliente);
        return "redirect:/clientes/{idCliente}/dir/ver";
    }

}
