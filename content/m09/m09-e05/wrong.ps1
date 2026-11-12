# Memory report for APP-01

$Top = Get-Process |
    Select-Object -Property Name, @{ Name = 'MemoryMB'; Expression = { [math]::Round($_.WorkingSet64 / 1MB) } } |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 2

$NameList = (Get-Process | Select-Object -ExpandProperty Name) -join ', '
