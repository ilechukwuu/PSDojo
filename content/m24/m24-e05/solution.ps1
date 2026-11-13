param($CheckName = 'Disk', $Value = 0)

# Is the measured value healthy? One table entry per kind of check.

$Checks = @{
    Disk    = { param($Value) $Value -ge 15 }
    Memory  = { param($Value) $Value -ge 10 }
    Latency = { param($Value) $Value -le 200 }
}

$Healthy = & $Checks[$CheckName] $Value
