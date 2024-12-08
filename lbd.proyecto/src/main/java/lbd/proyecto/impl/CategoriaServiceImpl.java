package lbd.proyecto.impl;


// External imports
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.hibernate.Session;
import org.hibernate.jdbc.Work;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import oracle.jdbc.OracleTypes;

// Internal imports
import lbd.proyecto.domain.Estado;
import lbd.proyecto.service.EstadoService;

import lbd.proyecto.service.CategoriaService;
import lbd.proyecto.dao.CategoriaDAO;
import lbd.proyecto.domain.Categoria;

@Service
public class CategoriaServiceImpl implements CategoriaService {

    @Autowired
    private CategoriaDAO categoriaDAO;

    @PersistenceContext
    private EntityManager entityManager;
    
    @Autowired
    private EstadoService estadoService;

    @Override
    @Transactional
    public void insertCategoria(Categoria categoria) {
        categoriaDAO.insertCategoria(categoria.getDescripcion(), categoria.getEstado().getIdEstado());
    }
    
    @Override
    @Transactional
    public void updateCategoria(Long idCategoria, Categoria categoria) {
        categoriaDAO.updateCategoria(idCategoria, categoria.getDescripcion(), categoria.getEstado().getIdEstado());
    }

    @Autowired
    private TransactionTemplate transactionTemplate;

        @Override
    public Categoria getCategoria(Categoria categoria) {
        return transactionTemplate.execute(new TransactionCallback<Categoria>() {
            @Override
            public Categoria doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_categoria"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_CATEGORIAS_TB_VER_CATEGORIA_SP");

                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_CATEGORIA", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_DESCRIPCION", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);
                // Set the input parameter
                query.setParameter("P_ID_CATEGORIA", categoria.getIdCategoria());

                // Execute the stored procedure
                try {
                    query.execute();
                } catch (PersistenceException e) {
                    if (e.getCause() instanceof SQLException) {
                        // Handle the SQLException
                        SQLException sqlException = (SQLException) e.getCause();
                        System.err.println("Error Code: " + sqlException.getErrorCode());
                        System.err.println("SQL State: " + sqlException.getSQLState());
                        System.err.println("Message: " + sqlException.getMessage());
                        status.setRollbackOnly();
                        return null;
                    } else {
                        throw e;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Map the output parameters to a Cliente object
                Categoria newCategoria = new Categoria();
                newCategoria.setIdCategoria(categoria.getIdCategoria());
                newCategoria.setDescripcion((String) query.getOutputParameterValue("P_DESCRIPCION"));
                
                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO");
                    if (estadoId != null) {
                        Estado estado = new Estado();
                        estado.setIdEstado(estadoId);
                        Estado newEstado = estadoService.getEstado(estado);
                        newCategoria.setEstado(newEstado);
                    }
                
                return newCategoria;
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Categoria> getAllCategorias() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_categorias"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_CATEGORIAS_TB_VER_CATEGORIAS_SP", Categoria.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

        // Execute the stored procedure
        query.execute();

        // Get the ResultSet
        ResultSet rs = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of categories
        List<Categoria> categorias = new ArrayList<>();

        // Iterate over the ResultSet and add the categories to the list
        try {
            while (rs.next()) {
                Categoria categoria = new Categoria();
                categoria.setIdCategoria(rs.getLong("id_categoria"));
                categoria.setDescripcion(rs.getString("descripcion"));
                
                Estado estado = new Estado();
                estado.setIdEstado(rs.getLong("id_estado"));
                Estado newEstado = estadoService.getEstado(estado);
                categoria.setEstado(newEstado);
                
                categorias.add(categoria);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categorias;
    }

    @Override
    @Transactional
    public void inactivarCategoria(Long idCategoria) {
        categoriaDAO.inactivarCategoria(idCategoria);
    }
    
}
