$UsedText = '81'
$FreeText = '39'
$ServerName = 'FS-02'

# Capacity script for FS-02

$TotalGB = $UsedText + $FreeText
[int]$DriveCount = 12
$Line = "Server: $ServerName"
