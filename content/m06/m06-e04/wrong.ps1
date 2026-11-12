# Maintenance announcement for FS-02

$Server = 'fs-02'
$Start = Get-Date -Year 2026 -Month 3 -Day 14 -Hour 22 -Minute 0 -Second 0

$Upper = $Server.ToUpper
$NameLength = $Server.Length
$End = $Start.AddDays(7)
