# Processes of the line-of-business application on TS-03. Works for exactly three.

$All = Get-Process -Name nordwind*

$First = $All[0].Name
$Second = $All[1].Name
$Third = $All[2].Name
$Names = $First, $Second, $Third

$TotalMemory = $All[0].WorkingSet64 + $All[1].WorkingSet64 + $All[2].WorkingSet64
