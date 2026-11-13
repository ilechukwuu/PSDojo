$VolumeBytes = 10737418240, 1610612736, 268435456000

# One conversion from bytes to gigabytes for all reports

$Bytes = 53687091200
$ToGB = {
    [math]::Round($Bytes / 1GB, 1)
}

$Size = & $ToGB
$Sizes = foreach ($Bytes in $VolumeBytes) {
    & $ToGB
}
