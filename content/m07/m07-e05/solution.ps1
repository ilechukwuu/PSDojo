# Process check for TS-03

$Names = 'spoolsv', 'lsass', 'rdpclip', 'backupagent'

$Found = Get-Process -Name $Names
