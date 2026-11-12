$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'
$Excluded = 'FS-02'

# Patch report. Three loop mistakes.

$Checks = foreach ($Server in $Servers) {
    "Checking $Servers"
}

$Numbered = for ($i = 0; $i -le $Servers.Count; $i++) {
    "$($i + 1): $($Servers[$i])"
}

$ToPatch = foreach ($Server in $Servers) {
    if ($Server -eq $Excluded) { break }
    $Server
}
