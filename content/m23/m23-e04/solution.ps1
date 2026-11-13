# Which execution policy really applies, and where does it come from?

$Policies = Get-ExecutionPolicy -List
$Winner = $Policies | Where-Object { $_.ExecutionPolicy -ne 'Undefined' } | Select-Object -First 1
$Effective = [string]$Winner.ExecutionPolicy
$SetBy = [string]$Winner.Scope
