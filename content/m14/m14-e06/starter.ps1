$Server = 'FS-02'
$Disk = [pscustomobject]@{ Letter = 'D'; FreeGB = 75; Percent = 15 }
$Week = 11

# Texts for the weekly disk report, glued together with plus signs

$Line = 'Server ' + $Server + ' drive ' + $Disk.Letter + ': has ' + $Disk.FreeGB + ' GB free (' + $Disk.Percent + ' percent)'
$Path = 'reports/' + $Server + '_week' + $Week + '.csv'
