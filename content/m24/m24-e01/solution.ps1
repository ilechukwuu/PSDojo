$VolumeBytes = 10737418240, 1610612736, 268435456000

# One conversion from bytes to gigabytes for all reports

$ToGB = {
    param($Bytes)
    [math]::Round($Bytes / 1GB, 1)
}

$Size = & $ToGB 53687091200
$Sizes = foreach ($Value in $VolumeBytes) {
    & $ToGB $Value
}
