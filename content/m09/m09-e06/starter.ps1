# Service count by status for APP-01. Asks the server twice.

$RunningCount = (Get-Service | Where-Object { $_.Status -eq 'Running' } | Measure-Object).Count
$StoppedCount = (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
$Summary = "Running: $RunningCount, Stopped: $StoppedCount"
