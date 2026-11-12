# Capacity report for TS-03: process list and largest process from one snapshot

$Largest = Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 1
$Total = (Get-Process | Measure-Object).Count
