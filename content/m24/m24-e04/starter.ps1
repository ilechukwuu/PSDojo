param($Volumes)

# A status for every volume. Three mistakes around script blocks.

$GetStatus = {
    if ($_.FreePercent -lt 10) { 'critical' }
    elseif ($_.FreePercent -lt 20) { 'warning' }
    else { 'ok' }
}

$Statuses = foreach ($Volume in $Volumes) {
    $GetStatus $Volume
}

$Critical = $Volumes | Where-Object ($_.FreePercent -lt 10)
