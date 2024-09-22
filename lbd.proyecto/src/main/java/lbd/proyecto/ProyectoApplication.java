package lbd.proyecto;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import lbd.proyecto.domain.direcciones.Provincia;
import lbd.proyecto.impl.direcciones.ProvinciaServiceImpl;

@SpringBootApplication
public class ProyectoApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProyectoApplication.class, args);
	}

}
