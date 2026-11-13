# Description of a restore job. Three mistakes.

function Get-RestoreJob {
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [ValidateSet('Disk,Tape,Cloud')]
        [string]$Source = 'Disk'
    )
    [CmdletBinding()]

    "Preparing restore for $ComputerName"

    [pscustomobject]@{
        ComputerName = $ComputerName
        Source       = $Source
    }
}
