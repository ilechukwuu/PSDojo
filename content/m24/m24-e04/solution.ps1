param($Volumes)

# A status for every volume

$GetStatus = {
    param($Volume)
    if ($Volume.FreePercent -lt 10) { 'critical' }
    elseif ($Volume.FreePercent -lt 20) { 'warning' }
    else { 'ok' }
}

$Statuses = foreach ($Volume in $Volumes) {
    & $GetStatus $Volume
}

$Critical = $Volumes | Where-Object { $_.FreePercent -lt 10 }
