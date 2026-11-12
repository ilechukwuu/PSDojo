param($Status = 'Stopped', $Server = 'FS-02')

# Recommended action and server role for an alert

$Action = switch ($Status) {
    'Running' { 'Nothing to do' }
    'Stopped' { 'Start the service' }
    'Paused'  { 'Resume the service' }
    default   { 'Check by hand' }
}

$Role = switch -Wildcard ($Server) {
    'FS-*'  { 'File server' }
    'PRN-*' { 'Print server' }
    'APP-*' { 'Application server' }
    default { 'Unknown' }
}
