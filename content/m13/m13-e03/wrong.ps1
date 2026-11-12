$ServerText = 'FS-01;FS-02;FS-03'
$SizeText = '500'
$BrokenText = 'n/a'

# Inventory export for the file servers

$Servers = $ServerText -split ','
$ServerLine = $Servers -join ', '
$DriveNumbers = 1..4
$IsNumber = $SizeText -is [int]
$Size = $SizeText -as [int]
$Broken = $BrokenText -as [int]
