$Server = 'FS-02'
$Year = 2026
$Disk = [pscustomobject]@{ Letter = 'D:'; FreeGB = 75 }

# Texts for the disk warning mail

$Subject = "Disk warning for $Server"
$Line = "Drive $($Disk.Letter) has $($Disk.FreeGB) GB free"
$LogName = "${Server}_$Year.log"
$Hint = 'Set $Limit in config.psd1'
