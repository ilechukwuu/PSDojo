# Disk check for one file server, controlled by parameters
param(
    [string]$ComputerName = 'FS-01',
    [int]$WarnPercent = 20,
    [switch]$Detailed
)

$Mode = if ($Detailed) { 'detailed' } else { 'short' }
