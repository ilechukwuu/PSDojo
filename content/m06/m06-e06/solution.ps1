# Processes of the line-of-business application on TS-03

$All = Get-Process -Name nordwind*

$Names = $All.Name

$TotalMemory = ($All.WorkingSet64 | Measure-Object -Sum).Sum
