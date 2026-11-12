$FreeFS01 = 120
$FreeFS02 = 35
$FreeFS03 = 25
$UsedPercent = 82

# Disk monitoring for the file servers

$AverageFreeGB = $FreeFS01 + $FreeFS02 + $FreeFS03 / 3
$IsFull = $UsedPercent -eq 100
$Label = "$FreeFS03 GB free on FS-03"
