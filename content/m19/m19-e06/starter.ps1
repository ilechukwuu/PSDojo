$Disks = @(
    [pscustomobject]@{ Server = 'FS-01'; FreeGB = 210 }
    [pscustomobject]@{ Server = 'FS-02'; FreeGB = 12 }
    [pscustomobject]@{ Server = 'FS-03'; FreeGB = 8 }
)

# Lines of the disk warning. Counter, index and += as in other languages.

$Warnings = @()
for ($i = 0; $i -lt $Disks.Count; $i++) {
    if ($Disks[$i].FreeGB -lt 20) {
        $Warnings += "$($Disks[$i].Server) has only $($Disks[$i].FreeGB) GB free"
    }
}
