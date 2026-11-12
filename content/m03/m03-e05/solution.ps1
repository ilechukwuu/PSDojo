param($LogFolder = '.')

# Log files for the weekly report

$Logs = Get-ChildItem -Path $LogFolder -Filter *.log -Recurse
$Stamp = Get-Date -Format 'yyyyMMdd'
$ItemCommands = Get-Command -Name *-Item -CommandType Cmdlet
