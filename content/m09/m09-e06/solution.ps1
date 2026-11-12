# Service count by status for APP-01

$Groups = Get-Service | Group-Object -Property Status
$RunningCount = ($Groups | Where-Object { $_.Name -eq 'Running' }).Count
$StoppedCount = ($Groups | Where-Object { $_.Name -eq 'Stopped' }).Count
$Summary = "Running: $RunningCount, Stopped: $StoppedCount"
