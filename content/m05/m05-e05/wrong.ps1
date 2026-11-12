# The three largest processes on TS-03

$Report = Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 3
$d = $Report | Measure-Object
$ReportCount = $d.Count
