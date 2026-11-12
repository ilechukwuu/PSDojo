param($Folder = '.')

# Settings of the disk monitoring from JSON

$Config = Get-Content -Path "$Folder/monitor.json" -Raw | ConvertFrom-Json
$WarnPercent = $Config.thresholds.warnPercent
$ServerNames = $Config.servers.name
$DriveCount = @($Config.servers[1].drives).Count

$Config | ConvertTo-Json -Depth 5 | Set-Content -Path "$Folder/copy.json" -Encoding UTF8
