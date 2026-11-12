# Values for the change ticket: patch window of the file servers

$PatchStart = Get-Date -Year 2026 -Month 3 -Day 14 -Hour 22 -Minute 0 -Second 0
$TicketStamp = Get-Date -Format 'yyyyMMdd'
$Watched = Get-Process -Name spoolsv, lsass
$Syntax = Get-Command -Name Stop-Process -Syntax
