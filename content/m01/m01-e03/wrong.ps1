# Hanging process on terminal server TS-03: find the right commands first.

$ProcessCommands = Get-Command -Verb Process
$StopCommands = Get-Command -Noun Stop
$ItemCommands = Get-Command -Name Item
