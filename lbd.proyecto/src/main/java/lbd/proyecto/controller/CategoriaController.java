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
import lbd.proyecto.domain.Categoria;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.CategoriaService;


@Controller
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    CategoriaService categoriaService;
    
    @Autowired
    EstadoService estadoService;
    
    @GetMapping("/agregar")
    public String agregarCategoria(Model model) { 
        return "categoria/agregar";
    }

    @PostMapping("/add")
    public String insertarCategoria(@RequestParam String descripcion) {
        Categoria categoria = new Categoria();
        categoria.setDescripcion(descripcion);
        if (categoria.getEstado() == null) {
                Estado estado = new Estado();
                estado.setIdEstado((long)7);
                categoria.setEstado(estado);
            }
        categoriaService.insertCategoria(categoria);
        return "redirect:/categorias/ver";
    }

    @GetMapping("/editar/{idCategoria}")
    public String editarCategoria(@PathVariable Long idCategoria, Model model) {
        Categoria categoria = new Categoria();
        categoria.setIdCategoria(idCategoria);
        categoria = categoriaService.getCategoria(categoria);
        
        model.addAttribute("categoria", categoria);
        model.addAttribute("idCategoria", idCategoria);
        model.addAttribute("descripcion", categoria.getDescripcion());
        model.addAttribute("estados", estadoService.getAllEstados());
        
        return "categoria/actualizar";
    }

    @PostMapping("/update")
    public String actualizarCategoria(@RequestParam Long idCategoria, @RequestParam String descripcion, @RequestParam Long idEstado) {
        Categoria categoria = new Categoria();
        categoria.setIdCategoria(idCategoria);
        categoria.setDescripcion(descripcion);
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        categoria.setEstado(estadoService.getEstado(estado));
        
        categoriaService.updateCategoria(idCategoria, categoria);
        return "redirect:/categorias/ver";
    }

    @GetMapping("/ver")
    public String verCategorias(Model model) {
        List<Categoria> categorias = categoriaService.getAllCategorias();
        model.addAttribute("categorias", categorias);
        return "categoria/ver";
    }

    @GetMapping("/inactivar/{idCategoria}")
    public String inactivarCategoria(@PathVariable Long idCategoria, RedirectAttributes redirectAttributes) {
        Categoria categoria = new Categoria();
        categoria.setIdCategoria(idCategoria);
        categoriaService.inactivarCategoria(idCategoria);
        return "redirect:/categorias/ver";
    }
    
}

