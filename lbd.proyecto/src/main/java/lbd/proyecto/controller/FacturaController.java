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
import lbd.proyecto.domain.Factura;
import lbd.proyecto.domain.Cliente;
import lbd.proyecto.domain.Pedido;
import lbd.proyecto.domain.Estado;

import lbd.proyecto.service.FacturaService;
import lbd.proyecto.service.ClienteService;
import lbd.proyecto.service.PedidoService;
import lbd.proyecto.service.EstadoService;

@Controller
@RequestMapping("/facturas")
public class FacturaController {
    
    @Autowired
    private FacturaService facturaService;

    @Autowired
    private ClienteService clienteService;

    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private EstadoService estadoService;

    @PostMapping("/add")
    public String insertarFactura(@RequestParam String idPedido, @RequestParam String fecha, @RequestParam String total, RedirectAttributes redirectAttributes) {
        Factura factura = new Factura();
        factura.setFecha(facturaService.convertDate(fecha));
        factura.setTotal(Double.parseDouble(total));
    
        Pedido pedido = new Pedido();
        pedido.setIdPedido(Long.parseLong(idPedido));
        Pedido pedidoResult = pedidoService.getPedido(pedido);
        factura.setPedido(pedidoResult);

        Estado estado = new Estado();
        estado.setIdEstado(6L);
        Estado estadoResult = estadoService.getEstado(estado);

        facturaService.insertFactura(factura, pedidoResult, estadoResult);
        
        return "redirect:/facturas/ver";

    }

    @GetMapping("/ver")
    public String verFacturas(Model model) {
        List<Factura> facturas = facturaService.getAllFacturas();
        model.addAttribute("facturas", facturas);
        return "/factura/ver";
    }

    @GetMapping("/eliminar/{idFactura}")
    public String eliminarFactura(@PathVariable Long idFactura, RedirectAttributes redirectAttributes) {
        Factura factura = new Factura();
        factura.setIdFactura(idFactura);
        facturaService.deleteFactura(factura);
        return "redirect:/facturas/ver";
    }

}
