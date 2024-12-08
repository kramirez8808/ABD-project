package lbd.proyecto.service;

import java.util.List;
import lbd.proyecto.domain.Rol;

public interface RolService {
    // Method to save a new client with the Stored Procedure
    void insertRol(Rol rol);

    // Method to update a client with the Stored Procedure
    void updateRol(Long idRol, Rol rol);

    // Method to get a client with the Stored Procedure
    Rol getRol(Rol rol);

    // Method to get all clients with the Stored Procedure
    List<Rol> getAllRoles();

    // Method to delete a client with the Stored Procedure
    void inactivarRole(Long idRol);
}
