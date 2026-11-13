# One function for the free space in percent

function Get-FreePercent {
    param(
        [double]$FreeGB,
        [double]$SizeGB
    )

    Write-Host ([math]::Round($FreeGB / $SizeGB * 100, 1))
}

$Percent = Get-FreePercent -FreeGB 120 -SizeGB 480
