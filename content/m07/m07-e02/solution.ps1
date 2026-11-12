param($Root = '.')
$CommandNames = 'Get-ChildItem', 'Remove-Item', 'Out-File'
$Paths = "$Root/stale-users.csv", "$Root/stale-computers.csv"

# Audit of the cleanup script

$Commands = $CommandNames | Get-Command
$Files = $Paths | Get-Item
$Alias = 'gci' | Get-Alias
