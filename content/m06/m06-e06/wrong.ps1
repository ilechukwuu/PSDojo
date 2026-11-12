# Processes of the line-of-business application on TS-03

$All = Get-Process -Name nordwind*

$Names = $All[0].Name, $All[1].Name, $All[2].Name

$TotalMemory = ($All.WorkingSet64 | Measure-Object -Sum).Sum
