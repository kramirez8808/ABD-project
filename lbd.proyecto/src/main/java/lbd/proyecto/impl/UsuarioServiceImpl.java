/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package lbd.proyecto.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import lbd.proyecto.dao.UsuarioDAO;
import lbd.proyecto.domain.Rol;
import lbd.proyecto.domain.Usuario;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UsuarioServiceImpl implements UsuarioService {

    @Autowired
    private UsuarioDAO usuarioDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private EstadoService estadoService;

    @Override
    public Usuario Login(Usuario usuario) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_Usuarios_TB_VALIDAR_USUARIO_SP");

        // Registrar los parámetros de entrada y salida
        query.registerStoredProcedureParameter("P_USUARIO", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("P_USUARIO_RETORNO", String.class, ParameterMode.OUT);
        query.registerStoredProcedureParameter("P_CONTRASENA", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("P_ROL", String.class, ParameterMode.OUT);

        // Establecer los valores de los parámetros de entrada
        query.setParameter("P_USUARIO", usuario.getUsuario());
        query.setParameter("P_CONTRASENA", usuario.getContrasena());

        // Ejecutar el procedimiento
        try {
            query.execute();

            // Recuperar los parámetros de salida
            String usuarioRetornado = (String) query.getOutputParameterValue("P_USUARIO_RETORNO");
            String rolRetornado = (String) query.getOutputParameterValue("P_ROL");

            // Comprobar si los parámetros de salida no son nulos
            if (usuarioRetornado != null && !usuarioRetornado.isEmpty() && rolRetornado != null && !rolRetornado.isEmpty()) {
                Usuario usuarioRetorno = new Usuario();
                Rol rolAsignado = new Rol();
                usuarioRetorno.setUsuario(usuarioRetornado);
                rolAsignado.setDescripcion(rolRetornado);
                usuarioRetorno.setID_ROL(rolAsignado);

                return usuarioRetorno;
            } else {
                return new Usuario();
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error al ejecutar el procedimiento almacenado.");
            return new Usuario();
        }
    }

    @Override
    public void insertUsuario(Usuario usuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void updateRol(Long idUsuario, Usuario usuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Usuario getUsuario(Usuario usuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Usuario> getAllUsuarios() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void inactivarUsuario(Long idUsuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}