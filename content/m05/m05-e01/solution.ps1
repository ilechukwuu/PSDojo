# Facts about the processes on TS-03 for the ticket

$ByName = Get-Process | Sort-Object -Property Name
$TopTwo = Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 2
$ProcessCount = (Get-Process | Measure-Object).Count
