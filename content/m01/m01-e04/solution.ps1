# Morning check for terminal server TS-03

$Spooler = Get-Process -Name spoolsv
$ProcessCommands = Get-Command -Noun Process
$Stamp = Get-Date -Format 'yyyy-MM-dd'
