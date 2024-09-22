package lbd.proyecto.controller;

import java.util.List;

import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Empleado;
import lbd.proyecto.service.EmpleadoService;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Factura;
import lbd.proyecto.service.FacturaService;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.domain.direcciones.Canton;
import lbd.proyecto.domain.direcciones.DireccionCliente;
import lbd.proyecto.domain.direcciones.DireccionEmpleado;
import lbd.proyecto.domain.direcciones.Distrito;
import lbd.proyecto.service.direcciones.CantonService;
import lbd.proyecto.service.direcciones.DireccionClienteService;
import lbd.proyecto.service.direcciones.DireccionEmpleadoService;
import lbd.proyecto.service.direcciones.DistritoService;
import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.service.direcciones.ProvinciaService;
import lbd.proyecto.domain.Licencia;
import lbd.proyecto.domain.LicenciaEmpleado;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.service.PedidoService;
import lbd.proyecto.service.LicenciaEmpleadoService;
import lbd.proyecto.domain.Puesto;
import lbd.proyecto.service.PuestoService;
import lbd.proyecto.service.LicenciaService;
import lbd.proyecto.domain.TipoCarga;
import lbd.proyecto.domain.Vehiculo;
import lbd.proyecto.service.VehiculoService;
import lbd.proyecto.service.TipoCargaService;
import lbd.proyecto.domain.direcciones.DireccionPedido;
import lbd.proyecto.service.direcciones.DireccionPedidoService;

@Controller
public class IndexController {

    @Autowired
    EmpleadoService empleadoService;

    @Autowired
    DireccionEmpleadoService direccionEmpleadoService;

    @Autowired
    PuestoService puestoService;

    @Autowired
    ProvinciaService provinciaService;

    @Autowired
    CantonService cantonService;

    @Autowired
    DistritoService distritoService;

    @Autowired
    DireccionClienteService direccionClienteService;

    @Autowired
    LicenciaService licenciaService;

    @Autowired
    EstadoService estadoService;

    @Autowired
    TipoCargaService tipoCargaService;

    @Autowired
    VehiculoService vehiculoService;

    @Autowired
    LicenciaEmpleadoService licenciaEmpleadoService;
    
    @Autowired
    PedidoService pedidoService;

    @Autowired
    DireccionPedidoService direccionPedidoService;

    @Autowired
    FacturaService facturaService;

    // Muestra la página principal
    @RequestMapping("/")
    public String page(Model model) {

        // Test getPedido
        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(5L);
        // Pedido pedidoResult = pedidoService.getPedido(pedido);  
        // System.out.println(pedidoResult.toString());
        // System.out.println(pedidoResult.getCliente().toString());
        // System.out.println(pedidoResult.getVehiculo().toString());
        // System.out.println(pedidoResult.getTiposCarga().toString());
        // System.out.println(pedidoResult.getEstado().toString());
        // System.out.println(pedidoResult.getLicenciaEmpleado().toString());
        // System.out.println("***FACTURAAAAA***");
        // System.out.println(pedidoResult.getFactura());

        // Test getProvincia and getAllProvincias
        // Provincia provincia = new Provincia();
        // provincia.setIdProvincia(3L);
        // Provincia provinciaResult = provinciaService.getProvincia(provincia);
        // System.out.println(provinciaResult.toString());
        
        // List<Provincia> provincias = provinciaService.getAllProvincias();
        // for (Provincia p : provincias) {
        //     System.out.println(p.toString());
        // }
        
        //Test getCanton and getAllCantones
        // Canton canton = new Canton();
        // canton.setIdCanton(1L);
        // Canton cantonResult = cantonService.getCanton(canton);
        // System.out.println(cantonResult.toString());

        // List<Canton> cantones = cantonService.getAllCantones();
        // for (Canton c : cantones) {
        //     System.out.println(c.toString());
        // }

        // Test getDistrito and getAllDistritos
        // System.out.println("TEST DE DISTRITOS");
        // Distrito distrito = new Distrito();
        // distrito.setIdDistrito(14L);
        // Distrito distritoResult = distritoService.getDistrito(distrito);
        // System.out.println(distritoResult.toString());

        // List<Distrito> distritos = distritoService.getAllDistritos();
        // for (Distrito d : distritos) {
        //     System.out.println(d.toString());
        // }

        //Test addDireccion_Clientes
        // DireccionCliente direccionCliente = new DireccionCliente("Nueva direccion para delete 2", distritoResult);
        // Cliente cliente = new Cliente();
        // cliente.setIdCliente(2L);
        // System.out.println(direccionCliente.toString());
        // direccionClienteService.insertDireccionCliente(direccionCliente, cliente, distritoResult);

        //Test updateDireccion_Clientes
        // DireccionCliente direccionCliente = new DireccionCliente();
        // direccionCliente.setIdDireccion(6L);
        // direccionCliente.setDetalles("Fix Direccion 2");

        // Distrito distrito2 = new Distrito();
        // distrito2.setIdDistrito(14L);
        // direccionCliente.setDistrito(distrito2);

        // System.out.println("TEST");
        // System.out.println(direccionCliente.toString());
        // System.out.println(direccionCliente.getDistrito().toString());
        // direccionClienteService.updateDireccionCliente(direccionCliente, direccionCliente.getDistrito());

        //Test getDireccion_Clientes
        // DireccionCliente direccionCliente = new DireccionCliente();
        // direccionCliente.setIdDireccion(7L);
        // DireccionCliente direccionClienteResult = direccionClienteService.getDireccionCliente(direccionCliente);
        // System.out.println(direccionClienteResult.toString());
        // System.out.println(direccionClienteResult.getDistrito().toString());

        // Test getAllDirecciones_Clientes
        // List<DireccionCliente> direcciones = direccionClienteService.getAllDirecciones();
        // for (DireccionCliente d : direcciones) {
        //     System.out.println(d.toString());
        //     System.out.println(d.getDetalles());
        //     System.out.println(d.getDistrito().toString());
        // }

        // Test searchDireccionByCliente
        // List<DireccionCliente> direcciones = direccionClienteService.searchDireccionesByCliente(2L);
        // for (DireccionCliente d : direcciones) {
        //     System.out.println("----- DIRECCION -----");
        //     System.out.println("ID Dirección: " + d.getIdDireccion());
        //     System.out.println("Detalles: " + d.getDetalles());
        //     System.out.println("ID Distrito: " + d.getDistrito().getIdDistrito() + " Nombre Distrito: " + d.getDistrito().getNombre());
        //     System.out.println("ID Canton: " + d.getDistrito().getCanton().getIdCanton() + " Nombre Canton: " + d.getDistrito().getCanton().getNombre());
        //     System.out.println("ID Provincia: " + d.getDistrito().getCanton().getProvincia().getIdProvincia() + " Nombre Provincia: " + d.getDistrito().getCanton().getProvincia().getNombre());
        //     System.out.println("ID Cliente: " + d.getCliente().getIdCliente());
        //     System.out.println("Nombre Cliente: " + d.getCliente().getNombre());
        //     System.out.println("Email Cliente: " + d.getCliente().getEmail());
        //     System.out.println("Telefono Cliente: " + d.getCliente().getTelefono());

        // }

        //Test deleteDireccion_Cliente
        // DireccionCliente direccionCliente = new DireccionCliente();
        // direccionCliente.setIdDireccion(21L);
        // direccionClienteService.deleteDireccionCliente(direccionCliente);


        //Test getLicencia and getAllLicencias
        // Licencia licencia = new Licencia();
        // licencia.setIdLicencia(1L);
        // Licencia licenciaResult = licenciaService.getLicencia(licencia);
        // System.out.println(licenciaResult.toString());

        // List<Licencia> licencias = licenciaService.getAllLicencias();
        // for (Licencia l : licencias) {
        //     System.out.println(l.toString());
        // }

        // Test getEstado and getAllEstados
        // Estado estado = new Estado();
        // estado.setIdEstado(3L);
        // Estado estadoResult = estadoService.getEstado(estado);
        // System.out.println(estadoResult.toString());

        // List<Estado> estados = estadoService.getAllEstados();
        // for (Estado e : estados) {
        //     System.out.println(e.toString());
        // }

        // Test getTipoCarga and getAllTipoCargas
        // TipoCarga tipoCarga = new TipoCarga();
        // tipoCarga.setIdTipo(1L);
        // TipoCarga tipoCargaResult = tipoCargaService.getTipoCarga(tipoCarga);
        // System.out.println(tipoCargaResult.toString());

        // List<TipoCarga> tiposCarga = tipoCargaService.getAllTiposCarga();
        // for (TipoCarga t : tiposCarga) {
        //     System.out.println(t.toString());
        // }

        // Test getPuesto and getAllPuestos
        // Puesto puesto = new Puesto();
        // puesto.setIdPuesto("MTN-TEC");
        // Puesto puestoResult = puestoService.getPuesto(puesto);
        // System.out.println(puestoResult.toString());

        // List<Puesto> puestos = puestoService.getAllPuestos();
        // for (Puesto p : puestos) {
        //     System.out.println(p.toString());
        // }

        // Test getVehiculo and getAllVehiculos
        // Vehiculo vehiculo = new Vehiculo();
        // vehiculo.setIdVehiculo(1L);
        // Vehiculo vehiculoResult = vehiculoService.getVehiculo(vehiculo);
        // System.out.println(vehiculoResult.toString());

        // List<Vehiculo> vehiculos = vehiculoService.getAllVehiculos();
        // for (Vehiculo v : vehiculos) {
        //     System.out.println(v.toString());
        // }

        // Test insertVehiculo
        // Vehiculo vehiculo = new Vehiculo("123-TST", "Toyota", "Corolla", 2015);
        // vehiculoService.insertVehiculo(vehiculo);

        // Test updateVehiculo
        // Vehiculo vehiculo = new Vehiculo();
        // vehiculo.setIdVehiculo(9L);
        // vehiculo.setMarca("Chevrolet");
        // vehiculo.setModelo("Concord");
        // vehiculo.setAnio(2010);
        // vehiculo.setPlaca("456-DEF");
        // vehiculoService.updateVehiculo(vehiculo.getIdVehiculo(), vehiculo);

        // Test deleteVehiculo
        // Vehiculo vehiculo = new Vehiculo();
        // vehiculo.setIdVehiculo(11L);
        // vehiculoService.deleteVehiculo(vehiculo.getIdVehiculo());

        // Test getEmpleado and getAllEmpleados
        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(3L);
        // Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        // System.out.println("*** EMPLEADO ***");
        // System.out.println("Nombre" + empleadoResult.getNombre());
        // System.out.println("Apellido" + empleadoResult.getApellido());
        // System.out.println("Fecha Nacimiento" + empleadoResult.getFechaNacimiento());
        // System.out.println("Fecha Contratacion" + empleadoResult.getFechaContratacion());
        // System.out.println("Puesto" + empleadoResult.getPuesto().toString());

        // System.out.println("*** LIST ***");
        // List<Empleado> empleados = empleadoService.getAllEmpleados();
        // for (Empleado e : empleados) {
        //     System.out.println(e.toString());
        //     System.out.println("*** ITEM ***");
        //     System.out.println("Nombre: " + e.getNombre());
        //     System.out.println("Apellido: " + e.getApellido());
        //     System.out.println("Fecha Nacimiento: " + e.getFechaNacimiento());
        //     System.out.println("Fecha Contratacion: " + e.getFechaContratacion());
        //     System.out.println("Puesto: " + e.getPuesto().toString());
        // }

        // Test insertEmpleado
        // Puesto puesto = new Puesto();
        // puesto.setIdPuesto("DRV-03");
        // Empleado empleado = new Empleado("Test 2", "Employee", empleadoService.convertDate("1950-12-24"), empleadoService.convertDate("1949-01-01"));
        // empleado.setPuesto(puesto);
        // empleadoService.insertEmpleado(empleado);

        // Test updateEmpleado
        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(7L);
        // empleado.setNombre("Update");
        // empleado.setApellido("Test");
        // empleado.setFechaNacimiento(empleadoService.convertDate("1966-02-11"));
        // empleado.setFechaContratacion(empleadoService.convertDate("1965-01-01"));
        // Puesto puesto = new Puesto();
        // puesto.setIdPuesto("STR-MGR");
        // empleado.setPuesto(puesto);
        // empleadoService.updateEmpleado(empleado.getIdEmpleado(), empleado);

        // Test deleteEmpleado
        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(8L);
        // empleadoService.deleteEmpleado(empleado.getIdEmpleado());

        // Test insertLicenciaEmpleado
        // Licencia licencia = new Licencia();
        // licencia.setIdLicencia(5L);
        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(3L);
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setFechaExpedicion(empleadoService.convertDate("1980-06-01"));
        // licenciaEmpleado.setFechaVencimiento(empleadoService.convertDate("1985-06-01"));
        // licenciaEmpleado.setLicencia(licencia);
        // licenciaEmpleado.setEmpleado(empleado);
        // licenciaEmpleadoService.insertLicenciaEmpleado(licenciaEmpleado, empleado, licencia);

        // Test updateLicenciaEmpleado
        // Licencia licencia = new Licencia();
        // licencia.setIdLicencia(7L);
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setIdLicenciaEmpleado(6L);
        // licenciaEmpleado.setFechaExpedicion(empleadoService.convertDate("1983-12-12"));
        // licenciaEmpleado.setFechaVencimiento(empleadoService.convertDate("1988-12-12"));
        // licenciaEmpleado.setLicencia(licencia);
        // licenciaEmpleadoService.updateLicenciaEmpleado(licencia, licenciaEmpleado);

        // Test deleteLicenciaEmpleado
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setIdLicenciaEmpleado(7L);
        // licenciaEmpleadoService.deleteLicenciaEmpleado(licenciaEmpleado);

        // Test getLicenciaEmpleado
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setIdLicenciaEmpleado(8L);
        // LicenciaEmpleado licenciaEmpleadoResult = licenciaEmpleadoService.getLicenciaEmpleado(licenciaEmpleado);
        // System.out.println(licenciaEmpleadoResult.toString());
        // System.out.println(licenciaEmpleadoResult.getLicencia().toString());
        // System.out.println(licenciaEmpleadoResult.getEmpleado().toString());

        // Test getAllLicenciasEmpleado
        // List<LicenciaEmpleado> licenciasEmpleado = licenciaEmpleadoService.getAllLicenciasEmpleados();
        // for (LicenciaEmpleado le : licenciasEmpleado) {
        //     System.out.println(le.toString());
        //     System.out.println(le.getLicencia().toString());
        //     System.out.println(le.getEmpleado().toString());
        // }

        // Test insertDireccion_Empleados
        // Distrito distrito = new Distrito();
        // distrito.setIdDistrito(8L);

        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(6L);

        // DireccionEmpleado direccionEmpleado = new DireccionEmpleado("Nueva direccion por insert 3", distrito);
        // direccionEmpleadoService.insertDireccionEmpleado(direccionEmpleado, empleado, distrito);

        // Test updateDireccion_Empleados
        // DireccionEmpleado direccionEmpleado = new DireccionEmpleado();
        // direccionEmpleado.setIdDireccion(6L);
        // direccionEmpleado.setDetalles("Fix Direccion ID6");
        // System.out.println("TEST");
        // System.out.println(direccionEmpleado.toString());
        // System.out.println(direccionEmpleado.getDetalles().toString());

        // Distrito distrito2 = new Distrito();
        // distrito2.setIdDistrito(26L);
        // direccionEmpleado.setDistrito(distritoService.getDistrito(distrito2));

        // System.out.println(direccionEmpleado.getDistrito().toString());

        // direccionEmpleadoService.updateDireccionEmpleado(direccionEmpleado, direccionEmpleado.getDistrito());

        // Test getDireccion_Empleados
        // DireccionEmpleado direccionEmpleado = new DireccionEmpleado();
        // direccionEmpleado.setIdDireccion(2L);
        // DireccionEmpleado direccionEmpleadoResult = direccionEmpleadoService.getDireccionEmpleado(direccionEmpleado);
        // System.out.println(direccionEmpleadoResult.toString());
        // System.out.println(direccionEmpleadoResult.getDistrito().toString());

        // // Test getAllDirecciones_Empleados
        // List<DireccionEmpleado> direcciones = direccionEmpleadoService.getAllDirecciones();
        // for (DireccionEmpleado d : direcciones) {
        //     System.out.println(d.toString());
        //     System.out.println(d.getDetalles());
        //     System.out.println(d.getDistrito().toString());
        // }

        // Test searchDireccionesByEmpleado
        // List<DireccionEmpleado> direcciones = direccionEmpleadoService.searchDireccionesByEmpleado(5L);
        // for (DireccionEmpleado d : direcciones) {
        //     System.out.println("----- DIRECCION -----");
        //     System.out.println("ID Dirección: " + d.getIdDireccion());
        //     System.out.println("Detalles: " + d.getDetalles());
        //     System.out.println("ID Distrito: " + d.getDistrito().getIdDistrito() + " Nombre Distrito: " + d.getDistrito().getNombre());
        //     System.out.println("ID Canton: " + d.getDistrito().getCanton().getIdCanton() + " Nombre Canton: " + d.getDistrito().getCanton().getNombre());
        //     System.out.println("ID Provincia: " + d.getDistrito().getCanton().getProvincia().getIdProvincia() + " Nombre Provincia: " + d.getDistrito().getCanton().getProvincia().getNombre());
        //     System.out.println("ID Empleado: " + d.getEmpleado().getIdEmpleado());
        //     System.out.println("Nombre Empleado: " + d.getEmpleado().getNombre());
        //     System.out.println("Apellido Empleado: " + d.getEmpleado().getApellido());
        //     System.out.println("Fecha Nacimiento Empleado: " + d.getEmpleado().getFechaNacimiento());
        //     System.out.println("Fecha Contratacion Empleado: " + d.getEmpleado().getFechaContratacion());
        //     System.out.println("Puesto Empleado: " + d.getEmpleado().getPuesto().toString());
        // }

        // Test insertPedido
        // Pedido pedido = new Pedido();
        // pedido.setFechaPedido(empleadoService.convertDate("2022-12-22"));
        // pedido.setDescripcion("Duplicado de prueba");
        // Cliente cliente = new Cliente();
        // cliente.setIdCliente(6L);
        // pedido.setCliente(cliente);
        // Vehiculo vehiculo = new Vehiculo();
        // vehiculo.setIdVehiculo(6L);
        // pedido.setVehiculo(vehiculo);
        // TipoCarga tipoCarga = new TipoCarga();
        // tipoCarga.setIdTipo(2L);
        // pedido.setTiposCarga(tipoCarga);
        // Estado estado = new Estado();
        // estado.setIdEstado(4L);
        // pedido.setEstado(estado);
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setIdLicenciaEmpleado(8L);
        // pedido.setLicenciaEmpleado(licenciaEmpleado);
        // pedidoService.insertPedido(pedido, cliente, vehiculo, tipoCarga, estado, licenciaEmpleado);

        // Test updatePedido
        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(7L);
        // pedido.setFechaPedido(empleadoService.convertDate("2033-03-03"));
        // pedido.setDescripcion("Update de prueba");
        // Cliente cliente = new Cliente();
        // cliente.setIdCliente(1L);
        // pedido.setCliente(cliente);
        // Vehiculo vehiculo = new Vehiculo();
        // vehiculo.setIdVehiculo(1L);
        // pedido.setVehiculo(vehiculo);
        // TipoCarga tipoCarga = new TipoCarga();
        // tipoCarga.setIdTipo(1L);
        // pedido.setTiposCarga(tipoCarga);
        // Estado estado = new Estado();
        // estado.setIdEstado(1L);
        // pedido.setEstado(estado);
        // LicenciaEmpleado licenciaEmpleado = new LicenciaEmpleado();
        // licenciaEmpleado.setIdLicenciaEmpleado(1L);
        // pedido.setLicenciaEmpleado(licenciaEmpleado);
        // pedidoService.updatePedido(pedido, cliente, vehiculo, tipoCarga, estado, licenciaEmpleado);

        // Test deletePedido
        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(8L);
        // pedidoService.deletePedido(pedido);

        // Test getPedido
        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(5L);
        // Pedido pedidoResult = pedidoService.getPedido(pedido);  
        // System.out.println(pedidoResult.toString());
        // System.out.println(pedidoResult.getCliente().toString());
        // System.out.println(pedidoResult.getVehiculo().toString());
        // System.out.println(pedidoResult.getTiposCarga().toString());
        // System.out.println(pedidoResult.getEstado().toString());
        // System.out.println(pedidoResult.getLicenciaEmpleado().toString());
        // System.out.println("***FACTURAAAAA***");
        // System.out.println(pedidoResult.getFactura());

        // Test getAllPedidos
        // List<Pedido> pedidos = pedidoService.getAllPedidos();
        // for (Pedido p : pedidos) {
        //     System.out.println("----- PEDIDO -----");
        //     System.out.println(p.toString());
        //     System.out.println(p.getCliente().toString());
        //     System.out.println(p.getVehiculo().toString());
        //     System.out.println(p.getTiposCarga().toString());
        //     System.out.println(p.getEstado().toString());
        //     System.out.println(p.getLicenciaEmpleado().toString());
        // }

        // Test searchPedidosByCliente
        // List<Pedido> pedidos = pedidoService.searchPedidosByCliente(1L);
        // for (Pedido p : pedidos) {
        //     System.out.println("----- PEDIDO -----");
        //     System.out.println(p.toString());
        //     System.out.println(p.getCliente().toString());
        //     System.out.println(p.getVehiculo().toString());
        //     System.out.println(p.getTiposCarga().toString());
        //     System.out.println(p.getEstado().toString());
        //     System.out.println(p.getLicenciaEmpleado().toString());
        // }

        // Test insertDireccion_Pedidos
        // Distrito distrito = new Distrito();
        // distrito.setIdDistrito(26L);

        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(6L);

        // DireccionPedido direccionPedido = new DireccionPedido("Duplicado para update", distrito);
        // direccionPedidoService.insertDireccionPedido(direccionPedido, pedido, distrito);

        // Test updateDireccion_Pedidos
        // DireccionPedido direccionPedido = new DireccionPedido();
        // direccionPedido.setIdDireccion(7L);

        // Distrito distrito = new Distrito();
        // distrito.setIdDistrito(19L);

        // direccionPedido.setDetalles("Update exitoso");
        // direccionPedido.setDistrito(distritoService.getDistrito(distrito));

        // direccionPedidoService.updateDireccionPedido(direccionPedido, distrito);

        // Test deleteDireccion_Pedidos
        // DireccionPedido direccionPedido = new DireccionPedido();
        // direccionPedido.setIdDireccion(5L);
        // direccionPedidoService.deleteDireccionPedido(direccionPedido);

        // Test getDireccion_Pedidos
        // DireccionPedido direccionPedido = new DireccionPedido();
        // direccionPedido.setIdDireccion(2L);
        // DireccionPedido direccionPedidoResult = direccionPedidoService.getDireccionPedido(direccionPedido);
        // System.out.println("ID Direccion: " + direccionPedidoResult.getIdDireccion());
        // System.out.println("Detalles: " + direccionPedidoResult.getDetalles());
        // System.out.println("ID Distrito: " + direccionPedidoResult.getDistrito().getIdDistrito() + " Nombre Distrito: " + direccionPedidoResult.getDistrito().getNombre());
        // System.out.println("ID Canton: " + direccionPedidoResult.getDistrito().getCanton().getIdCanton() + " Nombre Canton: " + direccionPedidoResult.getDistrito().getCanton().getNombre());
        // System.out.println("ID Provincia: " + direccionPedidoResult.getDistrito().getCanton().getProvincia().getIdProvincia() + " Nombre Provincia: " + direccionPedidoResult.getDistrito().getCanton().getProvincia().getNombre());
        // System.out.println("ID Pedido: " + direccionPedidoResult.getPedido().getIdPedido());
        // System.out.println("Fecha Pedido: " + direccionPedidoResult.getPedido().getFechaPedido());
        // System.out.println("Descripcion Pedido: " + direccionPedidoResult.getPedido().getDescripcion());
        // System.out.println("ID Cliente: " + direccionPedidoResult.getPedido().getCliente().getIdCliente());
        // System.out.println("Nombre Cliente: " + direccionPedidoResult.getPedido().getCliente().getNombre());

        // Test getAllDirecciones_Pedidos
        // List<DireccionPedido> direcciones = direccionPedidoService.getAllDirecciones();
        // for (DireccionPedido d : direcciones) {
        //     System.out.println("----- DIRECCION -----");
        //     System.out.println("ID Dirección: " + d.getIdDireccion());
        //     System.out.println("Detalles: " + d.getDetalles());
        //     System.out.println("ID Distrito: " + d.getDistrito().getIdDistrito() + " Nombre Distrito: " + d.getDistrito().getNombre());
        //     System.out.println("ID Canton: " + d.getDistrito().getCanton().getIdCanton() + " Nombre Canton: " + d.getDistrito().getCanton().getNombre());
        //     System.out.println("ID Provincia: " + d.getDistrito().getCanton().getProvincia().getIdProvincia() + " Nombre Provincia: " + d.getDistrito().getCanton().getProvincia().getNombre());
        //     System.out.println("ID Pedido: " + d.getPedido().getIdPedido());
        //     System.out.println("Fecha Pedido: " + d.getPedido().getFechaPedido());
        //     System.out.println("Descripcion Pedido: " + d.getPedido().getDescripcion());
        //     System.out.println("ID Cliente: " + d.getPedido().getCliente().getIdCliente());
        //     System.out.println("Nombre Cliente: " + d.getPedido().getCliente().getNombre());
        // }

        // Test searchDireccionesByPedido
        // List<DireccionPedido> direcciones = direccionPedidoService.searchDireccionesByPedido(6L);
        // for (DireccionPedido d : direcciones) {
        //     System.out.println("----- DIRECCION -----");
        //     System.out.println("ID Dirección: " + d.getIdDireccion());
        //     System.out.println("Detalles: " + d.getDetalles());
        //     System.out.println("ID Distrito: " + d.getDistrito().getIdDistrito() + " Nombre Distrito: " + d.getDistrito().getNombre());
        //     System.out.println("ID Canton: " + d.getDistrito().getCanton().getIdCanton() + " Nombre Canton: " + d.getDistrito().getCanton().getNombre());
        //     System.out.println("ID Provincia: " + d.getDistrito().getCanton().getProvincia().getIdProvincia() + " Nombre Provincia: " + d.getDistrito().getCanton().getProvincia().getNombre());
        //     System.out.println("ID Pedido: " + d.getPedido().getIdPedido());
        //     System.out.println("Fecha Pedido: " + d.getPedido().getFechaPedido());
        //     System.out.println("Descripcion Pedido: " + d.getPedido().getDescripcion());
        //     System.out.println("ID Cliente: " + d.getPedido().getCliente().getIdCliente());
        //     System.out.println("Nombre Cliente: " + d.getPedido().getCliente().getNombre());
        // }

        // Test insertFactura
        // Factura factura = new Factura();
        // factura.setFecha(empleadoService.convertDate("2044-12-04"));
        // factura.setTotal(450000.00);
        // Pedido pedido = new Pedido();
        // pedido.setIdPedido(7L);
        // factura.setPedido(pedido);
        // Estado estado = new Estado();
        // estado.setIdEstado(2L);
        // factura.setEstado(estado);
        // facturaService.insertFactura(factura, pedido, estado);

        // Test updateFactura
        // Factura factura = new Factura();
        // factura.setIdFactura(6L);
        // factura.setFecha(empleadoService.convertDate("2012-12-12"));
        // factura.setTotal(500000.00);
        // Estado estado = new Estado();
        // estado.setIdEstado(4L);
        // factura.setEstado(estado);
        // facturaService.updateFactura(factura, estado);

        // Test deleteFactura
        // Factura factura = new Factura();
        // factura.setIdFactura(8L);
        // facturaService.deleteFactura(factura);

        // Test getFactura
        // Factura factura = new Factura();
        // factura.setIdFactura(7L);
        // Factura facturaResult = facturaService.getFactura(factura);
        // System.out.println("ID Factura: " + facturaResult.getIdFactura());
        // System.out.println("Fecha Factura: " + facturaResult.getFecha());
        // System.out.println("Total Factura: " + facturaResult.getTotal());
        // System.out.println("ID Estado: " + facturaResult.getEstado().getIdEstado());
        // System.out.println("Nombre Estado: " + facturaResult.getEstado().getDescripcion());
        // System.out.println("ID Pedido: " + facturaResult.getPedido().getIdPedido());
        // System.out.println("Fecha Pedido: " + facturaResult.getPedido().getFechaPedido());
        // System.out.println("Descripcion Pedido: " + facturaResult.getPedido().getDescripcion());
        // System.out.println("ID Cliente: " + facturaResult.getPedido().getCliente().getIdCliente());
        // System.out.println("Nombre Cliente: " + facturaResult.getPedido().getCliente().getNombre());

        // Test getAllFacturas
        // List<Factura> facturas = facturaService.getAllFacturas();
        // for (Factura f : facturas) {
        //     System.out.println("----- FACTURA -----");
        //     System.out.println("ID Factura: " + f.getIdFactura());
        //     System.out.println("Fecha Factura: " + f.getFecha());
        //     System.out.println("Total Factura: " + f.getTotal());
        //     System.out.println("ID Estado: " + f.getEstado().getIdEstado());
        //     System.out.println("Nombre Estado: " + f.getEstado().getDescripcion());
        //     System.out.println("ID Pedido: " + f.getPedido().getIdPedido());
        //     System.out.println("Fecha Pedido: " + f.getPedido().getFechaPedido());
        //     System.out.println("Descripcion Pedido: " + f.getPedido().getDescripcion());
        //     System.out.println("ID Cliente: " + f.getPedido().getCliente().getIdCliente());
        //     System.out.println("Nombre Cliente: " + f.getPedido().getCliente().getNombre());
        // }

        // Test searchLicenciasByEmpleado
        // List<LicenciaEmpleado> licencias = licenciaEmpleadoService.searchLicenciasByEmpleado(2L);
        // for (LicenciaEmpleado l : licencias) {
        //     System.out.println("----- LICENCIA -----");
        //     System.out.println("ID Licencia: " + l.getIdLicenciaEmpleado());
        //     System.out.println("Fecha Expedicion: " + l.getFechaExpedicion());
        //     System.out.println("Fecha Vencimiento: " + l.getFechaVencimiento());
        //     System.out.println("ID Licencia: " + l.getLicencia().getIdLicencia());
        //     System.out.println("Descripcion Licencia: " + l.getLicencia().getTipo());
        //     System.out.println("ID Empleado: " + l.getEmpleado().getIdEmpleado());
        //     System.out.println("Nombre Empleado: " + l.getEmpleado().getNombre());
        //     System.out.println("Apellido Empleado: " + l.getEmpleado().getApellido());
        //     System.out.println("Fecha Nacimiento Empleado: " + l.getEmpleado().getFechaNacimiento());
        //     System.out.println("Fecha Contratacion Empleado: " + l.getEmpleado().getFechaContratacion());
        //     System.out.println("Puesto Empleado: " + l.getEmpleado().getPuesto().toString());
        // }

        // Test searchFacturaByPedido
        // Factura factura = facturaService.searchFacturaByPedido(22L);
        // System.out.println("----- FACTURA -----");
        // System.out.println("ID Factura: " + factura.getIdFactura());
        // System.out.println("Fecha Factura: " + factura.getFecha());
        // System.out.println("Total Factura: " + factura.getTotal());
        // System.out.println("Objeto:" + factura);

        //Test Empleado.isDriver
        // Empleado empleado = new Empleado();
        // empleado.setIdEmpleado(61L);
        // Empleado empleadoResult = empleadoService.getEmpleado(empleado);
        // System.out.println(empleadoResult.isDriver());

        //Test Pedido.isCanceled
        Pedido pedido = new Pedido();
        pedido.setIdPedido(63L);
        Pedido pedidoResult = pedidoService.getPedido(pedido);
        System.out.println(pedidoResult.isCanceled());

        return "index-new";
    }
    
}

