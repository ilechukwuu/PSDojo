# What is to happen with accounts that have not logged on for a long time?

function Get-StaleAccountPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [int]$Days = 90,

        [ValidateSet('Report', 'Disable')]
        [string]$Mode = 'Report'
    )

    if ($Days -lt 30 -or $Days -gt 365) {
        throw 'Days must be between 30 and 356'
    }

    [pscustomobject]@{
        Name = $Name
        Days = $Days
        Mode = $Mode
    }
}
