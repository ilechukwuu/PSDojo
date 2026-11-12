param($Status = 'Running', $FreePercent = 5, $Server = 'FS-02')

# Rating of a server before patching. Three logic mistakes.

$ShouldStart = $false
if ($Status = 'Stopped') {
    $ShouldStart = $true
}

if ($FreePercent -lt 20) {
    $Priority = 'Medium'
}
elseif ($FreePercent -lt 10) {
    $Priority = 'High'
}
else {
    $Priority = 'Low'
}

$Role = switch -Wildcard ($Server) {
    'FS-*' { 'File server' }
    '*'    { 'Other' }
}
