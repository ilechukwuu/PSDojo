# Free space check for the file servers

$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'
$FreeGB = 120, 35, 8, 64
$Total = 0
$Low = ''

for ($i = 0; $i -lt $Servers.Count; $i++) {
    $Total = $Total + $FreeGB[$i]
    if ($FreeGB[$i] -lt 10) {
        $Low = $Servers[$i]
    }
}

$TotalAfterSecondPass = 155
$LowServer = 'FS-03'
$FinalTotal = 227
