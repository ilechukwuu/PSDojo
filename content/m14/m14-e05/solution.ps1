$Server = 'FS-02'
$Backup = [pscustomobject]@{ SizeGB = 42 }

# Backup script for FS-02

$Subject = "Backup of $Server finished"
$Summary = "Size: $($Backup.SizeGB) GB"
$FileName = "${Server}_full.bak"
