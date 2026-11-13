# A backup plan that rejects wrong input by itself

function Get-BackupPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('(FS|APP|WEB)-\d{2}')]
        [string]$ComputerName,

        [ValidateSet('Full', 'Differential', 'Log')]
        [string]$Type = 'Full',

        [ValidateRange(1, 90)]
        [int]$RetentionDays = 14
    )

    [pscustomobject]@{
        ComputerName  = $ComputerName
        Type          = $Type
        RetentionDays = $RetentionDays
    }
}
