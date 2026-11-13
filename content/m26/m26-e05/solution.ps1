# What is to happen with accounts that have not logged on for a long time?

function Get-StaleAccountPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [ValidateRange(30, 365)]
        [int]$Days = 90,

        [ValidateSet('Report', 'Disable')]
        [string]$Mode = 'Report'
    )

    [pscustomobject]@{
        Name = $Name
        Days = $Days
        Mode = $Mode
    }
}
