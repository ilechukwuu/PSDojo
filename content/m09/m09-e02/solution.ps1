# Numbers about APP-01 for the monthly report

$ByStartType = Get-Service | Group-Object -Property StartType
$Memory = Get-Process | Measure-Object -Property WorkingSet64 -Sum -Average -Maximum
$TotalMB = [math]::Round($Memory.Sum / 1MB)
