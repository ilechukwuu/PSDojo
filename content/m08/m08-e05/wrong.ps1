# Check that runs every minute against APP-01

$NordwindDown = Get-Service -Name Nordwind* | Where-Object { $_.Status -eq 'Stopped' }
$Sql = Get-Service | Where-Object { $_.Name -in 'MSSQLSERVER', 'SQLSERVERAGENT' }
