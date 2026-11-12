# Capacity report for TS-03: process list and largest process from one snapshot

$Largest = Get-Process | Tee-Object -Variable AllProcesses | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 1
$Total = ($AllProcesses | Measure-Object).Count
