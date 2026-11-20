package net.youssfi.billingservice.feign;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import net.youssfi.billingservice.model.Product;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "INVENTORY-SERVICE")
public interface InventoryRestClient {

    @GetMapping("/products/{id}")
    @CircuitBreaker(name = "inventoryService", fallbackMethod = "getDefaultProduct")
    Product getProductById(@PathVariable("id") Long id);

    default Product getDefaultProduct(Long id, Exception exception) {
        return Product.builder()
                .id(id)
                .name("Default Product")
                .price(0)
                .quantity(0)
                .build();
    }
}
