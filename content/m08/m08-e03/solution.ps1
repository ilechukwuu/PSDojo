$CriticalNames = 'Spooler', 'MSSQLSERVER', 'SQLSERVERAGENT', 'NordwindApi', 'NordwindSync'

# Three lists for the on-call engineer

$Broken = Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic' }
$Nordwind = Get-Service | Where-Object { $_.Name -like 'Nordwind*' }
$CriticalDown = Get-Service | Where-Object { $_.Name -in $CriticalNames -and $_.Status -ne 'Running' }
