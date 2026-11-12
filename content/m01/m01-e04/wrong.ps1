# Morning check for terminal server TS-03

$Spooler = Get-Process -Name spoolsv
$ProcessCommands = Get-Command -Noun Process
$Stamp = Get-Date -Fromat 'yyyy-MM-dd'
