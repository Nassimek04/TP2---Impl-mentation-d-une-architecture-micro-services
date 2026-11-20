# TP2 — E-Commerce Microservices

Java 21 e-commerce demo with Spring Boot 3.5.16, Spring Cloud 2025.0.3, and Maven.

## Services

| Service | Port | Description |
|---|---|---|
| `discovery-service` | 8761 | Eureka server |
| `config-service` | 9999 | Spring Cloud Config server |
| `customer-service` | 8081 | Customers REST API + H2 |
| `inventory-service` | 8082 | Products REST API + H2 |
| `billing-service` | 8083 | Invoices with OpenFeign and Resilience4j fallbacks |
| `gateway-service` | 8888 | Dynamic routing via Eureka |

## Run locally

From the project root, create the local config repository once (skip these commands if you already have `config-repo/`). No second GitHub repository is needed.

```powershell
New-Item -ItemType Directory config-repo
Copy-Item config-repo-template/*.properties config-repo/
git -C config-repo init -b main
git -C config-repo add -- '*.properties'
git -C config-repo commit -m "Initial config commit"
```

Build and start from the project root:

```powershell
mvn clean package
.\run-all.ps1
```

In IntelliJ, use the project root as the Config Server working directory. Start discovery → config → customer, inventory, and billing → gateway. Use `.\stop-all.ps1` to stop the stack started by the script.

## URLs

- Eureka dashboard: http://localhost:8761
- Customer config: http://localhost:9999/customer-service/default (also try `/customer-service/dev`)
- Customers: http://localhost:8888/CUSTOMER-SERVICE/customers
- Products: http://localhost:8888/INVENTORY-SERVICE/products
- Aggregated bill: http://localhost:8888/BILLING-SERVICE/api/bills/1
- Shared config values: http://localhost:8888/CUSTOMER-SERVICE/testConfig1
- Customer config values: http://localhost:8888/CUSTOMER-SERVICE/testConfig2

## Refresh configuration

Change `global.params.p1` or `global.params.p2` in `config-repo/application.properties`, commit the change, then refresh customer-service:

```powershell
git -C config-repo commit -m "Update global params" -- application.properties
curl.exe -X POST http://localhost:8081/actuator/refresh
```

`/testConfig1` shows the new values without a restart. The immutable record behind `/testConfig2` does not rebind on refresh.

## Author

Nassime Khatib — [@Nassimek04](https://github.com/Nassimek04)
