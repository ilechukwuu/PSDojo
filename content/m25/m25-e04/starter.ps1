param($Volumes)

# Names of the volumes below a threshold. Three mistakes.

function Get-LowVolume {
    param($Volumes, $WarnPercent = 20)

    $Result = New-Object -TypeName System.Collections.ArrayList
    foreach ($Volume in $Volumes) {
        if ($Volume.FreePercent -lt $WarnPrecent) {
            $Result.Add($Volume.Name)
        }
    }
    $Result
}

$Low = Get-LowVolume($Volumes, 30)
