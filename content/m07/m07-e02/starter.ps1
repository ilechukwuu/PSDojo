param($Root = '.')
$CommandNames = 'Get-ChildItem', 'Remove-Item', 'Out-File'
$Paths = "$Root/stale-users.csv", "$Root/stale-computers.csv"

# Audit of the cleanup script

$Commands = $null
$Files = $null
$Alias = $null
