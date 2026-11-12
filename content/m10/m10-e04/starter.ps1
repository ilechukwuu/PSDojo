# Report script for APP-01. Three misplaced format cmdlets.

$Stopped = Get-Service | Format-Table -Property Name, Status | Where-Object { $_.Status -eq 'Stopped' }

$Names = Get-Service | Format-List -Property Name | Select-Object -ExpandProperty Name

$TopTable = Get-Process |
    Format-Table -Property Name, WorkingSet64 |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 2
