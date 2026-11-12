# Check that runs every minute against APP-01. Fetches far too much.

$NordwindDown = Get-Service | Where-Object { $_.Name -like 'Nordwind*' -and $_.Status -eq 'Stopped' }
$Sql = Get-Service | Where-Object { $_.Name -eq 'MSSQLSERVER' -or $_.Name -eq 'SQLSERVERAGENT' }
