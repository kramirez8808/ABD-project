package lbd.proyecto.service;

import java.util.List;
import lbd.proyecto.domain.Usuario;


public interface UsuarioService {
    // Method to save a new client with the Stored Procedure
    void insertUsuario(Usuario usuario);

    // Method to update a client with the Stored Procedure
    void updateRol(Long idUsuario, Usuario usuario);

    // Method to get a client with the Stored Procedure
    Usuario getUsuario(Usuario usuario);

    // Method to get all clients with the Stored Procedure
    List<Usuario> getAllUsuarios();

    // Method to delete a client with the Stored Procedure
    void inactivarUsuario(Long idUsuario);
    
    Usuario Login(Usuario usuario);
}
