# The three largest processes on TS-03. Works, but is hard to follow.

$a = Get-Process
$b = $a | Sort-Object -Property WorkingSet64 -Descending
$c = $b | Select-Object -First 3
$Report = $c
$d = $Report | Measure-Object
$ReportCount = $d.Count
