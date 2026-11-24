package g1.emsi.inventoryservice;

import g1.emsi.inventoryservice.entities.Product;
import g1.emsi.inventoryservice.repository.ProductRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class InventoryServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(InventoryServiceApplication.class, args);
    }

    @Bean
    CommandLineRunner start(ProductRepository productRepository) {
        return args -> {
            productRepository.save(Product.builder().name("Computer").price(3200).quantity(12).build());
            productRepository.save(Product.builder().name("Printer").price(1299).quantity(10).build());
            productRepository.save(Product.builder().name("Smart Phone").price(5400).quantity(8).build());
        };
    }
}
