# Morning check on APP-01: sort the services

$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' }
$NotDisabled = Get-Service | Where-Object { $_.StartType -ne 'Disabled' }
$Running = Get-Service | Where-Object { $_.Status -eq 'Running' }
