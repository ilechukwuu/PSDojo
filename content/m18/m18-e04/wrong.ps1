param($Status = 'Running', $FreePercent = 5, $Server = 'FS-02')

# Rating of a server before patching

$ShouldStart = $false
if ($Status -eq 'Stopped') {
    $ShouldStart = $true
}

if ($FreePercent -lt 10) {
    $Priority = 'High'
}
elseif ($FreePercent -lt 20) {
    $Priority = 'Medium'
}
else {
    $Priority = 'Low'
}

$Role = switch -Wildcard ($Server) {
    'FS-*' { 'File server' }
    '*'    { 'Other' }
}
