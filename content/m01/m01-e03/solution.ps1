# Hanging process on terminal server TS-03: find the right commands first.

$ProcessCommands = Get-Command -Noun Process
$StopCommands = Get-Command -Verb Stop
$ItemCommands = Get-Command -Name *-Item
