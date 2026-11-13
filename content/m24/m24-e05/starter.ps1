param($CheckName = 'Disk', $Value = 0)

# Is the measured value healthy? One branch per kind of check.

if ($CheckName -eq 'Disk') {
    $Healthy = $Value -ge 15
}
elseif ($CheckName -eq 'Memory') {
    $Healthy = $Value -ge 10
}
elseif ($CheckName -eq 'Latency') {
    $Healthy = $Value -le 200
}
