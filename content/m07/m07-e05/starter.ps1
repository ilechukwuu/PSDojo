# Process check for TS-03. Four calls where one would do.

$Names = 'spoolsv', 'lsass', 'rdpclip', 'backupagent'

$p1 = Get-Process -Name $Names[0]
$p2 = Get-Process -Name $Names[1]
$p3 = Get-Process -Name $Names[2]
$p4 = Get-Process -Name $Names[3]
$Found = $p1, $p2, $p3, $p4
