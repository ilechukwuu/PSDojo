# Service count by status for APP-01

$Groups = Get-Service | Group-Object -Property Status
$RunningCount = (Get-Service | Where-Object { $_.Status -eq 'Running' } | Measure-Object).Count
$StoppedCount = ($Groups | Where-Object { $_.Name -eq 'Stopped' }).Count
$Summary = "Running: $RunningCount, Stopped: $StoppedCount"
