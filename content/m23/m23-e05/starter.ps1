# Volumes below the warning threshold. Three structural mistakes.

$Checked = 0

param($Volumes, [int]$WarnPercent = 20)

$Low = foreach ($Volume in $Volumes) {
    if (Test-Volume -Volume $Volume) {
        $Volume.Name
    }
}

function Test-Volume {
    param($Volume)
    $Checked = $Checked + 1
    $Volume.FreePercent -lt $WarnPercent
}

[pscustomobject]@{ Checked = $Checked; Low = @($Low) }
