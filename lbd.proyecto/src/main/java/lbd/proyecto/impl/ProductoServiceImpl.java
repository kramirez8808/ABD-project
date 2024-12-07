package lbd.proyecto.impl;

import lbd.proyecto.dao.ProductoDAO;
import lbd.proyecto.domain.Estado;
import lbd.proyecto.domain.Producto;
import lbd.proyecto.domain.Categoria;
import lbd.proyecto.service.EstadoService;
import lbd.proyecto.service.ProductoService;
import lbd.proyecto.service.CategoriaService;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.StoredProcedureQuery;

@Service
public class ProductoServiceImpl implements ProductoService {

    @Autowired
    private ProductoDAO productoDAO;
    
    @PersistenceContext
    private EntityManager entityManager;
    
    @Autowired
    private EstadoService estadoService;

    @Autowired
    private CategoriaService categoriaService;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Override
    @Transactional
    public void insertProducto(Producto producto) {
        productoDAO.insertProducto(producto.getNombre(), producto.getDescripcion(), producto.getCategoria().getIdCategoria(), producto.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void updateProducto(Long idProducto, Producto producto) {
        productoDAO.updateProducto(idProducto, producto.getNombre(), producto.getDescripcion(), producto.getCategoria().getIdCategoria(), producto.getEstado().getIdEstado());
    }

    @Override
    @Transactional
    public void inactivarProducto(Long idProducto) {
        productoDAO.inactivarProducto(idProducto);
    }

    @Override
    public Producto getProducto(Producto producto) {
        return transactionTemplate.execute(new TransactionCallback<Producto>() {
            @Override
            public Producto doInTransaction(TransactionStatus status) {
                // Create a StoredProcedureQuery instance for the stored procedure "ver_producto"
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PRODUCTOS_TB_VER_PRODUCTO_SP");
                
                // Register the input and output parameters
                query.registerStoredProcedureParameter("P_ID_PRODUCTO", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("P_NOMBRE", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_DESCRIPCION", String.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_CATEGORIA", Long.class, ParameterMode.OUT);
                query.registerStoredProcedureParameter("P_ID_ESTADO", Long.class, ParameterMode.OUT);

                // Set the input parameter
                query.setParameter("P_ID_PRODUCTO", producto.getIdProducto());

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
                }

                // Print the output parameters
                // System.out.println("Nombre: " + query.getOutputParameterValue("P_NOMBRE"));
                // System.out.println("Descripción: " + query.getOutputParameterValue("P_DESCRIPCION"));

                // Map the output parameters to a Producto object
                Producto productoResult = new Producto();
                productoResult.setIdProducto(producto.getIdProducto());
                productoResult.setNombre((String) query.getOutputParameterValue("P_NOMBRE"));
                productoResult.setDescripcion((String) query.getOutputParameterValue("P_DESCRIPCION"));

                Long categoriaId = (Long) query.getOutputParameterValue("P_ID_CATEGORIA");
                if (categoriaId != null) {
                    Categoria categoria = new Categoria();
                    categoria.setIdCategoria(categoriaId);
                    Categoria newCategoria = categoriaService.getCategoria(categoria);
                    productoResult.setCategoria(newCategoria);
                }

                Long estadoId = (Long) query.getOutputParameterValue("P_ID_ESTADO");
                if (estadoId != null) {
                    Estado estado = new Estado();
                    estado.setIdEstado(estadoId);
                    Estado newEstado = estadoService.getEstado(estado);
                    productoResult.setEstado(newEstado);
                }

                return productoResult;

            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<Producto> getAllProductos() {
        // Create a StoredProcedureQuery instance for the stored procedure "ver_productos"
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("FIDE_PRODUCTOS_TB_VER_PRODUCTOS_SP", Producto.class);

        // Register the output parameter
        query.registerStoredProcedureParameter(1, void.class, ParameterMode.REF_CURSOR);

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
                return null;
            } else {
                throw e;
            }
        }

        // Get the result set
        ResultSet resultSet = (ResultSet) query.getOutputParameterValue(1);

        // Create a list of products
        List<Producto> productos = new ArrayList<>();

        // Iterate over the result set
        try {
            while (resultSet.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(resultSet.getLong("id_producto"));
                producto.setNombre(resultSet.getString("nombre"));
                producto.setDescripcion(resultSet.getString("descripcion"));

                Categoria categoria = new Categoria();
                categoria.setIdCategoria(resultSet.getLong("id_categoria"));
                Categoria newCategoria = categoriaService.getCategoria(categoria);
                producto.setCategoria(newCategoria);

                Estado estado = new Estado();
                estado.setIdEstado(resultSet.getLong("id_estado"));
                Estado newEstado = estadoService.getEstado(estado);
                producto.setEstado(newEstado);
                
                productos.add(producto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return productos;
    }

}
