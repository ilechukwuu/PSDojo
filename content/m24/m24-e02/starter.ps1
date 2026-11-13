$FileVolumes = @(
    [pscustomobject]@{ Server = 'FS-01'; Drive = 'D:'; FreePercent = 42 }
    [pscustomobject]@{ Server = 'FS-02'; Drive = 'D:'; FreePercent = 9 }
)
$AppVolumes = @(
    [pscustomobject]@{ Server = 'APP-01'; Drive = 'C:'; FreePercent = 14 }
    [pscustomobject]@{ Server = 'WEB-01'; Drive = 'C:'; FreePercent = 61 }
)

# One rule for both lists

$IsLow = $null
$LowFile = $null
$LowApp = $null
$ToLabel = $null
$Labels = $null
