# Is a volume low? One function for report, mail and dashboard.

function Get-VolumeStatus {
    param(
        [string]$Name,
        [double]$FreePercent,
        [int]$WarnPercent = 20
    )

    [pscustomobject]@{
        Name        = $Name
        FreePercent = $FreePercent
        Status      = if ($FreePercent -lt $WarnPercent) { 'low' } else { 'ok' }
    }
}

$Status = Get-VolumeStatus -Name 'E:' -FreePercent 35
