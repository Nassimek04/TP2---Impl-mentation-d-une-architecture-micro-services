# Stops the four e-commerce services by their listening ports.
# Also removes the scheduled tasks used to launch them in the background.
# Usage: .\stop-all.ps1
$ports = @(8888, 8082, 8081, 8761)
foreach ($port in $ports) {
    $listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if (-not $listeners) {
        Write-Host "Port $port is already free."
        continue
    }
    foreach ($listener in $listeners) {
        try {
            Stop-Process -Id $listener.OwningProcess -Force -ErrorAction Stop
            Write-Host "Stopped PID $($listener.OwningProcess) on port $port."
        } catch {
            Write-Warning "Could not stop PID $($listener.OwningProcess) on port ${port}: $($_.Exception.Message)"
        }
    }
}

foreach ($name in 'ecom-gateway-service', 'ecom-inventory-service', 'ecom-customer-service', 'ecom-discovery-service') {
    $task = Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue
    if ($task) {
        Stop-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskName $name -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "Removed scheduled task $name."
    }
}
