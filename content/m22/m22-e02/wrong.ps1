param($Root = '.')

# How much space do the old log files take?

$Limit = (Get-Date).AddDays(-30)

$Logs = Get-ChildItem -Path $Root -Filter '*.log' -File
$OldLogs = $Logs | Where-Object { $_.LastWriteTime -lt $Limit }
$TotalBytes = ($OldLogs | Measure-Object -Property Length -Sum).Sum
$Largest = ($OldLogs | Sort-Object -Property Length -Descending | Select-Object -First 1).Name
