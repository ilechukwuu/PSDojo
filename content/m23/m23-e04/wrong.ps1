# Which execution policy really applies, and where does it come from?

$Policies = Get-ExecutionPolicy -List
$Winner = $Policies | Where-Object { $_.Scope -eq 'LocalMachine' }
$Effective = [string]$Winner.ExecutionPolicy
$SetBy = [string]$Winner.Scope
