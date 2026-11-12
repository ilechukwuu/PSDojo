# Service monitoring for APP-01

$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' }
$Nordwind = Get-Service | Where-Object { $_.Name -eq 'Nordwind*' }
$Running = Get-Service | Where-Object { $_.Status -eq 'Running' }
