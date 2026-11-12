param($Folder = '.')
$Disks = @(
    [pscustomobject]@{ Server = 'FS-01'; FreeGB = 210; Note = 'Data' }
    [pscustomobject]@{ Server = 'FS-02'; FreeGB = 9; Note = 'Archive; old' }
    [pscustomobject]@{ Server = 'FS-03'; FreeGB = 100; Note = 'Profiles' }
)

# Weekly disk report as CSV, glued together by hand

$Lines = @('Server;Note;FreeGB')
foreach ($Disk in $Disks) {
    $Lines += $Disk.Server + ';' + $Disk.Note + ';' + $Disk.FreeGB
}
$Lines | Set-Content -Path "$Folder/report.csv" -Encoding UTF8
