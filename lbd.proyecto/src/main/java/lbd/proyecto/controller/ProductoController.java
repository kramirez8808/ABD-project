package lbd.proyecto.controller;

// External imports
import java.util.List;
import java.util.Optional;

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
import lbd.proyecto.domain.Producto;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Categoria;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.ProductoService;
import lbd.proyecto.service.CategoriaService;

@Controller
@RequestMapping("/productos")
public class ProductoController {

    @Autowired
    ProductoService productoService;

    @Autowired
    CategoriaService categoriaService;
    
    @Autowired
    EstadoService estadoService;

    @GetMapping("/agregar")
    public String agregarProducto(Model model) {
        model.addAttribute("categorias", categoriaService.getAllCategorias());
        model.addAttribute("estados", estadoService.getAllEstados());
        return "producto/agregar";
    }

    @PostMapping("/add")
    public String insertarProducto(@RequestParam String nombre, @RequestParam String descripcion, @RequestParam Long idCategoria, @RequestParam Optional<Long> idEstado) {
        Producto producto = new Producto();
        producto.setNombre(nombre);
        producto.setDescripcion(descripcion);

        Categoria categoria = new Categoria();
        categoria.setIdCategoria(idCategoria);
        producto.setCategoria(categoriaService.getCategoria(categoria));
        
        if (producto.getEstado() == null && !idEstado.isPresent()) {
            Estado estado = new Estado();
            estado.setIdEstado((long)7); 
            producto.setEstado(estado);
        } else {
            Estado estado = new Estado();
            idEstado.ifPresent(estado::setIdEstado);
            // estado.setIdEstado(idEstado);
            producto.setEstado(estadoService.getEstado(estado));
        }

        productoService.insertProducto(producto);

        return "redirect:/productos/ver";
    }
    
    @GetMapping("/editar/{idProducto}")
    public String editarProducto(@PathVariable Long idProducto, Model model) {
        Producto producto = new Producto();
        producto.setIdProducto(idProducto);
        producto = productoService.getProducto(producto);
        
        model.addAttribute("producto", producto);
        model.addAttribute("idProducto", idProducto);
        model.addAttribute("nombre", producto.getNombre());
        model.addAttribute("descripcion", producto.getDescripcion());
        model.addAttribute("categorias", categoriaService.getAllCategorias());
        model.addAttribute("estados", estadoService.getAllEstados());
        
        return "producto/actualizar";
    }

    @PostMapping("/update")
    public String actualizarProducto(@RequestParam Long idProducto, @RequestParam String nombre, @RequestParam String descripcion, @RequestParam Long idCategoria, @RequestParam Long idEstado) {
        Producto producto = new Producto();
        producto.setIdProducto(idProducto);
        producto.setNombre(nombre);
        producto.setDescripcion(descripcion);
        
        Categoria categoria = new Categoria();
        categoria.setIdCategoria(idCategoria);
        producto.setCategoria(categoriaService.getCategoria(categoria));
        
        Estado estado = new Estado();
        estado.setIdEstado(idEstado);
        producto.setEstado(estadoService.getEstado(estado));
        
        productoService.updateProducto(idProducto, producto);
        return "redirect:/productos/ver";
    }

    @GetMapping("/ver")
    public String verProductos(Model model) {
        List<Producto> productos = productoService.getAllProductos();
        model.addAttribute("productos", productos);
        return "producto/ver";
    }

    @GetMapping("/inactivar/{idProducto}")
    public String inactivarProducto(@PathVariable Long idProducto, RedirectAttributes redirectAttributes) {
        Producto producto = new Producto();
        producto.setIdProducto(idProducto);
        productoService.inactivarProducto(idProducto);
        return "redirect:/productos/ver";
    }
    
}

