# Stopped services on APP-01 in three shapes

$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object -Property Name

$Table = $Stopped | Format-Table -Property Name, StartType | Out-String -Width 200

$List = $Stopped | Format-List -Property Name, DisplayName | Out-String -Width 200

$Count = ($Stopped | Measure-Object).Count
