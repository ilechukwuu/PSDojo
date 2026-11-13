param($Volumes)

# Names of the volumes below a threshold

function Get-LowVolume {
    param($Volumes, $WarnPercent = 20)

    $Result = New-Object -TypeName System.Collections.ArrayList
    foreach ($Volume in $Volumes) {
        if ($Volume.FreePercent -lt $WarnPercent) {
            $Result.Add($Volume.Name)
        }
    }
    $Result
}

$Low = Get-LowVolume -Volumes $Volumes -WarnPercent 30
