# Memory check for terminal server TS-03, copied from the team wiki.
# It works. Make it readable: replace every alias with the full cmdlet name.

$Heavy = gps | ? { $_.WorkingSet64 -gt 500MB } | select Name, Id, WorkingSet64
$Names = $Heavy | % { $_.Name }
