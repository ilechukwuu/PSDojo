$Disks = @(
    [pscustomobject]@{ Server = 'FS-01'; SizeGB = 500; FreeGB = 210 }
    [pscustomobject]@{ Server = 'FS-02'; SizeGB = 500; FreeGB = 40 }
    [pscustomobject]@{ Server = 'FS-03'; SizeGB = 250; FreeGB = 45 }
)

# One report row per volume

$Report = $null
