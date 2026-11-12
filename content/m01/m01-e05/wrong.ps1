# Values for the change ticket: patch window of the file servers

$PatchStart = Get-Date -Year 2026 -Month 3 -Day 14 -Hour 23 -Minute 59 -Second 30
$TicketStamp = Get-Date -Format 'yyyyMMdd'
$Watched = Get-Process -Name spoolsv, lsass
$Syntax = Get-Command -Name Stop-Process -Syntax
