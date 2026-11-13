# What is to happen with accounts that have not logged on for a long time?

function Get-StaleAccountPlan {
    param(
        [string]$Name,
        [int]$Days = 90,
        [string]$Mode = 'Report'
    )

    if (-not $Name) {
        throw 'Name is required'
    }
    if ($Days -lt 30 -or $Days -gt 365) {
        throw 'Days must be between 30 and 356'
    }
    if ($Mode -ne 'Report' -and $Mode -ne 'Disable') {
        throw 'Mode must be Report or Disable'
    }

    [pscustomobject]@{
        Name = $Name
        Days = $Days
        Mode = $Mode
    }
}
