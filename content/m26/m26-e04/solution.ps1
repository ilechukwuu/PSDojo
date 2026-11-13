# Description of a restore job

function Get-RestoreJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [ValidateSet('Disk', 'Tape', 'Cloud')]
        [string]$Source = 'Disk'
    )

    Write-Verbose -Message "Preparing restore for $ComputerName"

    [pscustomobject]@{
        ComputerName = $ComputerName
        Source       = $Source
    }
}
