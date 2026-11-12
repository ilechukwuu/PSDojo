$SizeC = 107374182400
$SizeD = 429496729600
$FreeBytes = 80530636800
$FileCount = 1047
$BatchSize = 50
$Processed = 120

# Values for the archive job on FS-02

$TotalGB = ($SizeC + $SizeD) / 1GB
$FreePercent = [math]::Round($FreeBytes / ($SizeC + $SizeD) * 100)
$LeftOver = $FileCount % $BatchSize

$Processed += $BatchSize
$Processed++
