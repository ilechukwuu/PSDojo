# Memory monitoring for TS-03. Three pipelines, three different mistakes.

$Sorted = Get-Process ; Sort-Object -Property Name

$TopTwo = Get-Process | Select-Object -First 2 | Sort-Object -Property WorkingSet64 -Descending

$Smallest = Get-Process
    | Sort-Object -Property WorkingSet64
    | Select-Object -First 1
