$Disks = @(
    [pscustomobject]@{ Server = 'FS-01'; FreeGB = 210 }
    [pscustomobject]@{ Server = 'FS-02'; FreeGB = 12 }
    [pscustomobject]@{ Server = 'FS-03'; FreeGB = 8 }
)

# Lines of the disk warning

$Warnings = foreach ($Disk in $Disks) {
    if ($Disk.FreeGB -lt 20) {
        "$($Disk.Server) has only $($Disk.FreeGB) GB free"
    }
}
