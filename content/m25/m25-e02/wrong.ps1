# Is a volume low? One function for report, mail and dashboard.

function Get-VolumeStatus {
    param(
        [string]$Name,
        [double]$FreePercent,
        [int]$WarnPercent = 20
    )

    if ($FreePercent -lt $WarnPercent) {
        "$Name is low ($FreePercent %)"
    }
    else {
        "$Name is ok ($FreePercent %)"
    }
}

$Status = Get-VolumeStatus -Name 'E:' -FreePercent 35
