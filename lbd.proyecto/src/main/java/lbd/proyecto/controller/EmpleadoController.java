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
import java.text.SimpleDateFormat;
// Internal imports
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.Direccion;

import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.service.PuestoService;
import lbd.proyecto.service.LicenciaService;
import lbd.proyecto.service.LicenciaEmpleadoService;
import lbd.proyecto.service.direcciones.DireccionEmpleadoService;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.direcciones.CantonService;
import lbd.proyecto.service.direcciones.ProvinciaService;

@Controller
@RequestMapping("/empleados")
public class EmpleadoController {
    
    @Autowired
    EmpleadoService empleadoService;

    @Autowired
    PuestoService puestoService;
    
    @Autowired
    EstadoService estadoService;
    
    @Autowired
    ProvinciaService provinciaService;
    
    @Autowired
    CantonService cantonService;
    
    @Autowired
    DistritoService distritoService;

    @Autowired
    LicenciaService licenciaService;

    @Autowired
    LicenciaEmpleadoService licenciaEmpleadoService;

    @Autowired
    DireccionEmpleadoService direccionEmpleadoService;

    

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
            if (empleado.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7); 
                empleado.setEstado(estado);
            }
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
        model.addAttribute("estados", estadoService.getAllEstados());
        return "/empleado/actualizar";
    }

    @PostMapping("/update")
    public String actualizarEmpleado(@RequestParam Long idEmpleado, @RequestParam String nombre, @RequestParam String apellido, @RequestParam String fechaNacimiento, @RequestParam String fechaContratacion, @RequestParam String idPuesto, @RequestParam Long idEstado, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        empleado.setNombre(nombre);
        empleado.setApellido(apellido);
        empleado.setFechaNacimiento(empleado.convertDate(fechaNacimiento));
        empleado.setFechaContratacion(empleado.convertDate(fechaContratacion));
        
        Puesto puesto = new Puesto();
        puesto.setIdPuesto(idPuesto);
        empleado.setPuesto(puestoService.getPuesto(puesto));
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        empleado.setEstado(estadoService.getEstado(estado));
        empleadoService.updateEmpleado(idEmpleado, empleado);

        return "redirect:/empleados/ver";
    }

    @GetMapping("/ver")
    public String verEmpleados(Model model) {
        List<Empleado> empleados = empleadoService.getAllEmpleados();
        model.addAttribute("empleados", empleados);
        return "/empleado/ver";
    }

    @GetMapping("/inactivar/{idEmpleado}")
    public String inactivarEmpleado(@PathVariable Long idEmpleado, RedirectAttributes redirectAttributes) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        empleadoService.inactivarEmpleado(idEmpleado);
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

        DireccionEmpleado direccionEmpleado = new DireccionEmpleado();
        direccionEmpleado.setDetalles(detalles);
        
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);
        empleado = empleadoService.getEmpleado(empleado);
        direccionEmpleado.setEmpleado(empleado);

        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));
        distrito = distritoService.getDistrito(distrito);
        direccionEmpleado.setDistrito(distrito);
        
        if (direccionEmpleado.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7); 
                direccionEmpleado.setEstado(estado);
        }
        direccionEmpleadoService.insertDireccionEmpleado(direccionEmpleado, empleado, distrito);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }
    
    @GetMapping("{idEmpleado}/dir/editar/{idDireccion}")
    public String editarDireccion(@PathVariable Long idEmpleado, @PathVariable Long idDireccion, Model model) {
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);

        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);

        // Obtén la dirección completa
        DireccionEmpleado direccionResult = direccionEmpleadoService.getDireccionEmpleado(direccion);

        // Debugging: Verifica la dirección y sus componentes
        System.out.println(" *** DEBUG *** ");
        System.out.println(direccionResult);

        // Verifica que no sea nulo antes de acceder a las propiedades
        if (direccionResult != null && direccionResult.getDistrito() != null
            && direccionResult.getDistrito().getCanton() != null
            && direccionResult.getDistrito().getCanton().getProvincia() != null) {
            Provincia provincia = direccionResult.getDistrito().getCanton().getProvincia();
            System.out.println(provincia.getNombre());
        } else {
            System.out.println("Provincia, Cantón o Distrito son nulos.");
        }

        model.addAttribute("direccion", direccionResult);
        model.addAttribute("idEmpleado", idEmpleado);
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
        
        return "/direccion/actualizar-empleado";
    }
    
    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idEmpleado, 
                                      @RequestParam Long idDireccion, 
                                      @RequestParam String detalles, 
                                      @RequestParam String idDistrito, 
                                      @RequestParam Long idEstado, 
                                      RedirectAttributes redirectAttributes) {

        // Verifica que los parámetros se reciban correctamente
        System.out.println("idEmpleado: " + idEmpleado);
        System.out.println("idDireccion: " + idDireccion);
        System.out.println("detalles: " + detalles);
        System.out.println("idDistrito: " + idDistrito);
        System.out.println("idEstado recibido: " + idEstado);

        // Crea el objeto Empleado
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);

        // Crea y configura el objeto DireccionEmpleado
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        direccion.setDetalles(detalles);

        // Configura el Distrito
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));  // Convierte idDistrito a Long
        Distrito distritoResult = distritoService.getDistrito(distrito);

        // Configura el Estado
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);  // Asigna el idEstado recibido
        Estado estadoResult = estadoService.getEstado(estado); 
        // Establece el estado en la dirección
        direccion.setEstado(estadoResult);

        // Llama al servicio para actualizar la dirección
        direccionEmpleadoService.updateDireccionEmpleado(direccion, distritoResult);
        empleado.setEstado(estadoService.getEstado(estado));
        
        // Agrega el idEmpleado para redirigir después
        redirectAttributes.addAttribute("idEmpleado", idEmpleado);

        // Redirige a la vista correspondiente
        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }





    /*
    @PostMapping("/dir/update")
    public String actualizarDireccion(@RequestParam Long idEmpleado, 
                                      @RequestParam Long idDireccion, 
                                      @RequestParam String detalles, 
                                      @RequestParam String idDistrito, 
                                      @RequestParam Long idEstado, 
                                      RedirectAttributes redirectAttributes) {

        // Verifica que los parámetros se reciban correctamente
        System.out.println("idEmpleado: " + idEmpleado);
        System.out.println("idDireccion: " + idDireccion);
        System.out.println("detalles: " + detalles);
        System.out.println("idDistrito: " + idDistrito);
        System.out.println("idEstado recibido: " + idEstado);

        // Crea el objeto Empleado
        Empleado empleado = new Empleado();
        empleado.setIdEmpleado(idEmpleado);

        // Crea y configura el objeto DireccionEmpleado
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        direccion.setDetalles(detalles);

        // Configura el Distrito
        Distrito distrito = new Distrito();
        distrito.setIdDistrito(Long.parseLong(idDistrito));  // Convierte idDistrito a Long
        Distrito distritoResult = distritoService.getDistrito(distrito);

        // Configura el Estado
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);  // Asigna el idEstado recibido
        Estado estadoResult = estadoService.getEstado(estado); 
        // Establece el estado en la dirección
        direccion.setEstado(estadoResult);

        // Llama al servicio para actualizar la dirección
        direccionEmpleadoService.updateDireccionEmpleado(direccion, distritoResult);
        empleado.setEstado(estadoService.getEstado(estado));
        
        // Agrega el idEmpleado para redirigir después
        redirectAttributes.addAttribute("idEmpleado", idEmpleado);

        // Redirige a la vista correspondiente
        return "redirect:/empleados/{idEmpleado}/dir/ver";
    }
    */

    @GetMapping("{idEmpleado}/dir/inactivar/{idDireccion}")
    public String inactivarDireccion(@PathVariable Long idEmpleado, @PathVariable Long idDireccion, RedirectAttributes redirectAttributes) {
        DireccionEmpleado direccion = new DireccionEmpleado();
        direccion.setIdDireccion(idDireccion);
        direccionEmpleadoService.inactivarDireccionEmpleado(direccion);
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

        Estado estado = new Estado();
        estado.setIdEstado(7L);
        Estado estadoResult = estadoService.getEstado(estado);

        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado(
            empleado.convertDate(fechaExpedicion),
            empleado.convertDate(fechaVencimiento),
            empleado,
            licenciaResult,
            estadoResult
        );

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
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaExpedicionStr = licenciaEmpleadoResult.getFechaExpedicion() != null ? sdf.format(licenciaEmpleadoResult.getFechaExpedicion()) : "";
        String fechaVencimientoStr = licenciaEmpleadoResult.getFechaVencimiento() != null ? sdf.format(licenciaEmpleadoResult.getFechaVencimiento()) : "";

        model.addAttribute("licenciaEmpleado", licenciaEmpleadoResult);
        model.addAttribute("fechaExpedicion", fechaExpedicionStr);
        model.addAttribute("fechaVencimiento", fechaVencimientoStr);
        model.addAttribute("idEmpleado", idEmpleado);
        model.addAttribute("idLicenciaEmpleado", idLicenciaEmpleado);
        model.addAttribute("licencias", licenciaService.getAllLicencias());
        model.addAttribute("estados", estadoService.getAllEstados());
        System.out.println("Fecha Expedicion: " + fechaExpedicionStr);
        System.out.println("Fecha Vencimiento: " + fechaVencimientoStr);


        return "/licencia/actualizar";
    }

    @PostMapping("/lic/update")
    public String actualizarLicencia(@RequestParam Long idEmpleado, @RequestParam Long idLicenciaEmpleado, @RequestParam String fechaVencimiento, @RequestParam String fechaExpedicion, @RequestParam String idLicencia, @RequestParam Long idEstado ,RedirectAttributes redirectAttributes) {
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
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        licenciaEmpleado.setEstado(estadoService.getEstado(estado));

        licenciaEmpleadoService.updateLicenciaEmpleado(licenciaResult, licenciaEmpleado);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/lic/ver";

    }

    @GetMapping("{idEmpleado}/lic/inactivar/{idLicenciaEmpleado}")
    public String inactivarLicencia(@PathVariable Long idEmpleado, @PathVariable Long idLicenciaEmpleado, RedirectAttributes redirectAttributes) {
        LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        licenciaEmpleado.setIdLicenciaEmpleado(idLicenciaEmpleado);
        licenciaEmpleadoService.inactivarLicenciaEmpleado(licenciaEmpleado);

        redirectAttributes.addAttribute("idEmpleado", idEmpleado);
        return "redirect:/empleados/{idEmpleado}/lic/ver";
    }


}

