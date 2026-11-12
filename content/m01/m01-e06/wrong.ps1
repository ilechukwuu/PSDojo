# Memory check for terminal server TS-03

$Heavy = Get-Process | Where-Object { $_.WorkingSet64 -gt 500MB } | select Name, Id, WorkingSet64
$Names = $Heavy | % { $_.Name }
