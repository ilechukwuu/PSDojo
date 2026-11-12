# Process check for TS-03

$Names = 'spoolsv', 'lsass', 'rdpclip', 'backupagent'

$Found = (Get-Process -Name $Names[0]), (Get-Process -Name $Names[1]), (Get-Process -Name $Names[2]), (Get-Process -Name $Names[3])
