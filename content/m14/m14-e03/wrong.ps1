$Number = 12
$Start = [datetime]'2026-03-14T22:00:00'
$FreeGB = 75

# Numbered server names and report lines

$ServerName = 'APP-{0}' -f $Number
$Stamp = '{0:yyyy-MM-dd}' -f $Start
$FileName = 'report_{0}_{1}.csv' -f $ServerName, $Stamp
$Row = '{0,-10}{1,6}' -f $ServerName, $FreeGB
