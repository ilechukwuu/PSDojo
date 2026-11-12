# Report script for APP-01

$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Format-Table -Property Name, Status

$Names = Get-Service | Select-Object -ExpandProperty Name

$TopTable = Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 2 |
    Format-Table -Property Name, WorkingSet64
