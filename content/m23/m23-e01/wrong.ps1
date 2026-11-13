# Disk check for one file server, controlled by parameters
param(
    $ComputerName = 'FS-01',
    $WarnPercent = 20,
    [switch]$Detailed
)

$Mode = if ($Detailed) { 'detailed' } else { 'short' }
