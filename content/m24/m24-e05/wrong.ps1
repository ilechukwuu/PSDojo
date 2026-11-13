param($CheckName = 'Disk', $Value = 0)

# Is the measured value healthy? One table entry per kind of check.

$Checks = @{
    Disk    = ($Value -ge 15)
    Memory  = ($Value -ge 10)
    Latency = ($Value -le 200)
}

$Healthy = $Checks[$CheckName]
