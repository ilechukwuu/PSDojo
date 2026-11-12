# Facts about the processes on TS-03 for the ticket

$ByName = Get-Process | Sort-Object -Property Name
$TopTwo = Get-Process | Select-Object -First 2 | Sort-Object -Property WorkingSet64 -Descending
$ProcessCount = (Get-Process | Measure-Object).Count
