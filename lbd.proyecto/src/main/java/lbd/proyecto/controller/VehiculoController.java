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
import lbd.proyecto.domain.Estado;

// Internal imports
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.VehiculoService;

@Controller
@RequestMapping("/vehiculos")
public class VehiculoController {

    @Autowired
    VehiculoService vehiculoService;
    
    @Autowired
    EstadoService estadoService;
    
    @GetMapping("/agregar")
    public String agregarVehiculo(Model model) { 
        return "vehiculo/agregar";
    }

    @PostMapping("/add")
    public String insertarVehiculo(@RequestParam String placa, @RequestParam String marca, @RequestParam String modelo, @RequestParam Integer anio) {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setMarca(marca);
        vehiculo.setModelo(modelo);
        vehiculo.setAnio(anio);
        vehiculo.setPlaca(placa);
        if (vehiculo.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7); 
                vehiculo.setEstado(estado);
            }
        vehiculoService.insertVehiculo(vehiculo);
        return "redirect:/vehiculos/ver";
    }

    @GetMapping("/editar/{idVehiculo}")
    public String editarVehiculo(@PathVariable Long idVehiculo, Model model) {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setIdVehiculo(idVehiculo);
        vehiculo = vehiculoService.getVehiculo(vehiculo);
        
        model.addAttribute("vehiculo", vehiculo);
        model.addAttribute("idVehiculo", idVehiculo);
        model.addAttribute("marca", vehiculo.getMarca());
        model.addAttribute("modelo", vehiculo.getModelo());
        model.addAttribute("placa", vehiculo.getPlaca());
        model.addAttribute("anio", vehiculo.getAnio());
        model.addAttribute("estados", estadoService.getAllEstados());
        
        return "vehiculo/actualizar";
    }

    @PostMapping("/update")
    public String actualizarVehiculo(@RequestParam Long idVehiculo, @RequestParam String placa, @RequestParam String marca, @RequestParam String modelo, @RequestParam Integer anio, @RequestParam Long idEstado) {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setIdVehiculo(idVehiculo);
        vehiculo.setPlaca(placa);
        vehiculo.setMarca(marca);
        vehiculo.setModelo(modelo);
        vehiculo.setAnio(anio);
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        vehiculo.setEstado(estadoService.getEstado(estado));
        
        vehiculoService.updateVehiculo(idVehiculo, vehiculo);
        return "redirect:/vehiculos/ver";
    }

    @GetMapping("/ver")
    public String verVehiculos(Model model) {
        List<Vehiculo> vehiculos = vehiculoService.getAllVehiculos();
        model.addAttribute("vehiculos", vehiculos);
        return "vehiculo/ver";
    }

    @GetMapping("/inactivar/{idVehiculo}")
    public String inactivarVehiculo(@PathVariable Long idVehiculo, RedirectAttributes redirectAttributes) {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setIdVehiculo(idVehiculo);
        vehiculoService.inactivarVehiculo(idVehiculo);
        return "redirect:/vehiculos/ver";
    }
    
}

