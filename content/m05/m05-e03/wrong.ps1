# Memory monitoring for TS-03

$Sorted = Get-Process | Sort-Object -Property Name

$TopTwo = Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 2

$Smallest = Get-Process
    | Sort-Object -Property WorkingSet64
    | Select-Object -First 1
