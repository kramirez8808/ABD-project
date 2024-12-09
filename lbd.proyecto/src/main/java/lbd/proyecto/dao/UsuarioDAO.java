/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package lbd.proyecto.dao;

import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Rol;
import lbd.proyecto.domain.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

/**
 *
 * @author cadam
 */
public interface UsuarioDAO extends JpaRepository<Usuario, Long>{
    
    // Method to call an stored procedure to insert a new client
    @Procedure(procedureName = "FIDE_Usuarios_TB_VALIDAR_USUARIO_SP")
    Usuario login(String usuario, String contrasena);
}
