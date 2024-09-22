package lbd.proyecto.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/viajes")
public class ViajesController {
    
    // Muestra la página principal
    @GetMapping("/agregar")
    public String page(Model model) { 
        return "viaje/agregar";
    }
    
}