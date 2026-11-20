# TP2 — E-Commerce Microservices

Spring Boot & Spring Cloud project with Eureka service discovery and a dynamic API gateway.

## Services

| Service | Port | Description |
|---|---|---|
| `discovery-service` | 8761 | Eureka server |
| `customer-service` | 8081 | Customers REST API + H2 |
| `inventory-service` | 8082 | Products REST API + H2 |
| `gateway-service` | 8888 | Dynamic routing via Eureka |

## Stack

Java 21 · Spring Boot 3.5.16 · Spring Cloud 2025.0.3 · Eureka · Spring Cloud Gateway · Spring Data REST · H2 · Maven

## Run

Build the project:

```bash
mvn clean package
```

Start the services in order — discovery → customer → inventory → gateway — or run:

```powershell
.\run-all.ps1
```

Stop everything:

```powershell
.\stop-all.ps1
```

## URLs

- Eureka dashboard: http://localhost:8761
- Customers: http://localhost:8888/CUSTOMER-SERVICE/customers
- Products: http://localhost:8888/INVENTORY-SERVICE/products
- Gateway routes: http://localhost:8888/actuator/gateway/routes

## Dynamic routing

The gateway builds its routes from Eureka automatically:

- Predicate: `Path=/<SERVICE-ID>/**`
- Filter: `RewritePath` strips `/<SERVICE-ID>` before forwarding
- Any new Eureka service is immediately available at `http://localhost:8888/<SERVICE-ID>/**`

## Author

Nassime Khatib — [@Nassimek04](https://github.com/Nassimek04)
