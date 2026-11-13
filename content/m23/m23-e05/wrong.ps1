# Volumes below the warning threshold
param($Volumes, [int]$WarnPercent = 20)

function Test-Volume {
    param($Volume)
    $Checked = $Checked + 1
    $Volume.FreePercent -lt $WarnPercent
}

$Checked = 0

$Low = foreach ($Volume in $Volumes) {
    if (Test-Volume -Volume $Volume) {
        $Volume.Name
    }
}

[pscustomobject]@{ Checked = $Checked; Low = @($Low) }
