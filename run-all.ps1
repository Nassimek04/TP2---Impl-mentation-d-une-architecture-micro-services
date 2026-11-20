# Starts all e-commerce microservices in separate windows.
# Usage: .\run-all.ps1
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$java = (Get-Command java -ErrorAction SilentlyContinue).Source
if (-not $java) { throw "java was not found on PATH." }

$services = @(
    [pscustomobject]@{ Name = 'discovery-service'; Jar = Join-Path $root 'discovery-service\target\discovery-service-1.0-SNAPSHOT.jar'; Port = 8761 },
    [pscustomobject]@{ Name = 'customer-service';  Jar = Join-Path $root 'customer-service\target\customer-service-1.0-SNAPSHOT.jar'; Port = 8081 },
    [pscustomobject]@{ Name = 'inventory-service'; Jar = Join-Path $root 'inventory-service\target\inventory-service-1.0-SNAPSHOT.jar'; Port = 8082 },
    [pscustomobject]@{ Name = 'gateway-service';   Jar = Join-Path $root 'gateway-service\target\gateway-service-1.0-SNAPSHOT.jar'; Port = 8888 }
)

foreach ($svc in $services) {
    if (-not (Test-Path $svc.Jar)) {
        throw "Missing $($svc.Jar). Run 'mvn clean package -DskipTests' first."
    }
}

function Wait-ForHealth {
    param([int]$Port, [int]$TimeoutSeconds = 90)
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            $health = Invoke-RestMethod "http://localhost:$Port/actuator/health" -TimeoutSec 2
            if ($health.status -eq 'UP') { return $true }
        } catch { }
        Start-Sleep -Seconds 1
    }
    return $false
}

Write-Host "Starting discovery-service..."
Start-Process -FilePath $java -ArgumentList "-jar `"$($services[0].Jar)`"" -WorkingDirectory $root | Out-Null
if (-not (Wait-ForHealth -Port $services[0].Port)) {
    throw "discovery-service did not become healthy on port $($services[0].Port)."
}

foreach ($svc in $services[1..($services.Count - 1)]) {
    Write-Host "Starting $($svc.Name)..."
    Start-Process -FilePath $java -ArgumentList "-jar `"$($svc.Jar)`"" -WorkingDirectory $root | Out-Null
}

foreach ($svc in $services[1..($services.Count - 1)]) {
    if (Wait-ForHealth -Port $svc.Port) {
        Write-Host "  $($svc.Name) is UP on port $($svc.Port)"
    } else {
        Write-Warning "  $($svc.Name) did not become healthy on port $($svc.Port)"
    }
}

Write-Host ""
Write-Host "Eureka dashboard:  http://localhost:8761"
Write-Host "Gateway customers: http://localhost:8888/CUSTOMER-SERVICE/customers"
Write-Host "Gateway products:  http://localhost:8888/INVENTORY-SERVICE/products"
Write-Host ""
Write-Host "Each service runs in its own window. Close a window to stop that service."
