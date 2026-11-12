param($LogFolder = '.')

# Log files for the weekly report. Works, but is written in console shorthand.

$Logs = Get-ChildItem $LogFolder *.log -Rec
$Stamp = Get-Date -F 'yyyyMMdd'
$ItemCommands = Get-Command *-Item -Com Cmdlet
