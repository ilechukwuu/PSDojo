# Description of a restore job

function Get-RestoreJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [ValidateSet('Disk', 'Tape', 'Cloud')]
        [string]$Source = 'Disk'
    )

    "Preparing restore for $ComputerName"

    [pscustomobject]@{
        ComputerName = $ComputerName
        Source       = $Source
    }
}
