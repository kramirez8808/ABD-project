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
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.Puesto;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.service.PuestoService;
import lbd.proyecto.service.LicenciaService;
import lbd.proyecto.service.LicenciaEmpleadoService;
import lbd.proyecto.service.direcciones.DireccionEmpleadoService;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;

@Controller
@RequestMapping("/empleados")
public class EmpleadoController {
    
    @Autowired
    EmpleadoService empleadoService;

    @Autowired
    PuestoService puestoService;

    @Autowired
    LicenciaService licenciaService;

    @Autowired
    LicenciaEmpleadoService licenciaEmpleadoService;

    @Autowired
    DireccionEmpleadoService direccionEmpleadoService;

    @Autowired
    DistritoService distritoService;

    @GetMapping("/agregar")
    public String agregarEmpleado(Model model) { 
        model.addAttribute("puestos", puestoService.getAllPuestos());
        model.addAttribute("licencias", licenciaService.getAllLicencias());
        return "/empleado/agregar";
    }

    @PostMapping("/add")
    public String insertarEmpleado(@RequestParam String nombre, @RequestParam String apellido, @RequestParam String fechaNacimiento, 
        @RequestParam String idPuesto, @RequestParam String fechaContratacion, RedirectAttributes redirectAttributes) {
            Empleado empleado = new Empleado();
            empleado.setNombre(nombre);
            empleado.setApellido(apellido);
            empleado.setFechaNacimiento(empleado.convertDate(fechaNacimiento));
            empleado.setFechaContratacion(empleado.convertDate(fechaContratacion));
            Puesto puesto = new Puesto();
            puesto.setIdPuesto(idPuesto);
            empleado.setPuesto(puestoService.getPuesto(puesto));
            empleadoService.insertEmpleado(empleado);

            return "redirect:/empleados/ver";
    }
    
    @GetMapping("/editar/{idEmpleado}")
    public String editarEmpleado(@PathVariable Long idEmpleado, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        model.addAttribute("empleado", empleadoResult);
        model.addAttribute("idEmpleado", idEmpleado);
        model.addAttribute("nombre", empleadoResult.getNombre());
        model.addAttribute("apellido", empleadoResult.getApellido());
        model.addAttribute("fechaNacimiento", empleadoResult.getFechaNacimiento());
        model.addAttribute("fechaContratacion", empleadoResult.getFechaContratacion());
        model.addAttribute("puestos", puestoService.getAllPuestos());

        return "/empleado/actualizar";
    }

    @PostMapping("/update")
    public String actualizarEmpleado(@RequestParam Long idEmpleado, @RequestParam String nombre, @RequestParam String apellido, @RequestParam String fechaNacimiento, @RequestParam String fechaContratacion, @RequestParam String idPuesto, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        empleado.setNombre(nombre);
        empleado.setApellido(apellido);
        empleado.setFechaNacimiento(empleado.convertDate(fechaNacimiento));
        empleado.setFechaContratacion(empleado.convertDate(fechaContratacion));
        Puesto puesto = new Puesto();
        puesto.setIdPuesto(idPuesto);
        empleado.setPuesto(puestoService.getPuesto(puesto));
        empleadoService.updateEmpleado(idEmpleado, empleado);

        return "redirect:/empleados/ver";
    }

    @GetMapping("/ver")
    public String verEmpleados(Model model) {
        List<Empleado> empleados = empleadoService.getAllEmpleados();
        model.addAttribute("empleados", empleados);
        return "/empleado/ver";
    }

    @GetMapping("/eliminar/{idEmpleado}")
    public String eliminarEmpleado(@PathVariable Long idEmpleado, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        empleadoService.deleteEmpleado(idEmpleado);
        return "redirect:/empleados/ver";
    }

    // Direccion
    @GetMapping("{idEmpleado}/dir/ver")
    public String verDireccion(@PathVariable Long idEmpleado, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        List<DireccionEmpleado> direcciones = direccionEmpleadoService.searchDireccionesByEmpleado(empleado.getIdEmpleado());
        model.addAttribute("direcciones", direcciones);
        return "/direccion/ver-empleado";
    }

    @GetMapping("{idEmpleado}/dir/agregar")
    public String agregarDireccion(@PathVariable Long idEmpleado, Model model) {
        model.addAttribute("idEmpleado", idEmpleado);
        return "/direccion/agregar-empleado";
    }

    @PostMapping("/dir/add")
    public String insertarDireccion(@RequestParam Long idEmpleado, @RequestParam String idDistrito, @RequestParam String detalles, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        
        Distrito distritoResult = distritoService.getDistrito(distrito);
        DireccionEmpleado direccionEmpleado = new DireccionEmpleado(detalles, distritoResult);
        direccionEmpleado.setEmpleado(empleado);

        direccionEmpleadoService.insertDireccionEmpleado(direccionEmpleado, empleado, distritoResult);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);

        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }

    @GetMapping("{idEmpleado}/dir/editar/{idDireccion}")
    public String editarDireccion(@PathVariable Long idEmpleado, @PathVariable Long idDireccion, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        DireccionEmpleado direccionResult = direccionEmpleadoService.getDireccionEmpleado(direccion);
        System.out.println(" *** DEBUG *** ");
        System.out.println(direccionResult);
        System.out.println(direccionResult.getDistrito().getCanton().getProvincia().getIdProvincia());
        

        model.addAttribute("direccion", direccionResult);
        model.addAttribute("idEmpleado", idEmpleado);
        model.addAttribute("idDireccion", idDireccion);
        model.addAttribute("detalles", direccionResult.getDetalles());
        return "/direccion/actualizar-empleado";
    }

    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idEmpleado, @RequestParam Long idDireccion, @RequestParam String detalles, @RequestParam String idDistrito, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        direccion.setDetalles(detalles);
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        Distrito distritoResult = distritoService.getDistrito(distrito);

        direccionEmpleadoService.updateDireccionEmpleado(direccion, distritoResult);
        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }

    @GetMapping("{idEmpleado}/dir/eliminar/{idDireccion}")
    public String eliminarDireccion(@PathVariable Long idEmpleado, @PathVariable Long idDireccion, RedirectAttributes redirectAttributes) {
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        direccionEmpleadoService.deleteDireccionEmpleado(direccion);
        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }

    // Licencia
    @GetMapping("{idEmpleado}/lic/ver")
    public String verLicencia(@PathVariable Long idEmpleado, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        List<LicenciaEmpleado> licenciasEmpleado = licenciaEmpleadoService.searchLicenciasByEmpleado(empleado.getIdEmpleado());
        model.addAttribute("licenciasEmpleado", licenciasEmpleado);
        
        return "/licencia/ver";
    }

    @GetMapping("{idEmpleado}/lic/agregar")
    public String agregarLicencia(@PathVariable Long idEmpleado, Model model) {
        model.addAttribute("idEmpleado", idEmpleado);
        model.addAttribute("licencias", licenciaService.getAllLicencias());
        return "/licencia/agregar";
    }

    @PostMapping("/lic/add")
    public String insertarLicencia(@RequestParam Long idEmpleado, @RequestParam String idLicencia, @RequestParam String fechaExpedicion, @RequestParam String fechaVencimiento, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        Licencia licencia = new Licencia();
        licencia.setIdLicencia(Long.parseLong(idLicencia));

        Licencia licenciaResult = licenciaService.getLicencia(licencia);
        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado(empleado.convertDate(fechaExpedicion), empleado.convertDate(fechaVencimiento), empleado, licenciaResult);

        licenciaEmpleadoService.insertLicenciaEmpleado(licenciaEmpleado, empleado, licenciaResult);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);

        return "redirect:/empleados/{idEmpleado}/lic/ver";
    }

    @GetMapping("{idEmpleado}/lic/editar/{idLicenciaEmpleado}")
    public String editarLicencia(@PathVariable Long idEmpleado, @PathVariable Long idLicenciaEmpleado, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        licenciaEmpleado.setIdLicenciaEmpleado(idLicenciaEmpleado);
        LicenciaEmpleado licenciaEmpleadoResult = licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado);

        model.addAttribute("licenciaEmpleado", licenciaEmpleadoResult);
        model.addAttribute("idEmpleado", idEmpleado);
        model.addAttribute("idLicenciaEmpleado", idLicenciaEmpleado);
        model.addAttribute("licencias", licenciaService.getAllLicencias());
        
        return "/licencia/actualizar";
    }

    @PostMapping("/lic/update")
    public String actualizarLicencia(@RequestParam Long idEmpleado, @RequestParam Long idLicenciaEmpleado, @RequestParam String fechaVencimiento, @RequestParam String fechaExpedicion, @RequestParam String idLicencia, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        Licencia licencia = new Licencia();
        licencia.setIdLicencia(Long.parseLong(idLicencia));
        Licencia licenciaResult = licenciaService.getLicencia(licencia);

        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        licenciaEmpleado.setIdLicenciaEmpleado(idLicenciaEmpleado);
        licenciaEmpleado.setFechaVencimiento(empleado.convertDate(fechaVencimiento));
        licenciaEmpleado.setFechaExpedicion(empleado.convertDate(fechaExpedicion));
        licenciaEmpleado.setLicencia(licenciaResult);
        licenciaEmpleado.setEmpleado(empleado);

        licenciaEmpleadoService.updateLicenciaEmpleado(licenciaResult, licenciaEmpleado);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/lic/ver";

    }

    @GetMapping("{idEmpleado}/lic/eliminar/{idLicenciaEmpleado}")
    public String eliminarLicencia(@PathVariable Long idEmpleado, @PathVariable Long idLicenciaEmpleado, RedirectAttributes redirectAttributes) {
        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        licenciaEmpleado.setIdLicenciaEmpleado(idLicenciaEmpleado);
        licenciaEmpleadoService.deleteLicenciaEmpleado(licenciaEmpleado);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/lic/ver";
    }


}

