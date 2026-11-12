# Stopped services on APP-01 in three shapes. Fetches three times.

$Table = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object -Property Name |
    Format-Table -Property Name, StartType | Out-String -Width 200

$List = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object -Property Name |
    Format-List -Property Name, DisplayName | Out-String -Width 200

$Count = (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
