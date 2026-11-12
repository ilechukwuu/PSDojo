# Service monitoring for APP-01. Each condition contains one mistake.

$Stopped = Get-Service | Where-Object { $_.Status = 'Stopped' }
$Nordwind = Get-Service | Where-Object { $_.Name -eq 'Nordwind*' }
$Running = Get-Service | Where-Object { Status -eq 'Running' }
