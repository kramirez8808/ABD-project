/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package lbd.proyecto.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lbd.proyecto.domain.Usuario;
import lbd.proyecto.impl.UsuarioServiceImpl;
import lbd.proyecto.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author cadam
 */
@Controller
@RequestMapping("/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    //public UsuarioService usuarioService = new UsuarioServiceImpl();
    @RequestMapping("/login")
    public String page(Model model) {
        //model.addAttribute("attribute", "value");
        return "usuario/login";
    }

    @PostMapping("/validar")
    public String ValidarCredenciales(@RequestParam String username, @RequestParam String password, HttpSession session) {
        Usuario usuario = new Usuario();
        usuario.setUsuario(username);
        usuario.setContrasena(password);

        Usuario usuarioRetorno = usuarioService.Login(usuario);

        if (usuarioRetorno.getUsuario() == null) {
            return "usuario/login";
        }

        session.setAttribute("usuario", usuarioRetorno);
        return "index-new";
    }

    @PostMapping("/cerrar-sesion")
    public String cerrarSesion(HttpSession session) {
        System.out.println("ID de sesión antes de invalidar: " + session.getId());
        session.invalidate();  // Invalida la sesión
        System.out.println("ID de sesión después de invalidar: " + session.getId()); // El ID de sesión será diferente o nulo
        return "usuario/login";
    }
}
