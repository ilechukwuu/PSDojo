param($Folder = '.')

# Capacity report from CSV to JSON. Three format mistakes.

$Rows = Import-Csv -Path "$Folder/disks.csv"

$TotalFree = $Rows[0].FreeGB + $Rows[1].FreeGB + $Rows[2].FreeGB

$Summary = [pscustomobject]@{
    Site  = 'Hamburg'
    Total = $TotalFree
    Data  = [pscustomobject]@{ Rows = $Rows }
}
$Summary | ConvertTo-Json | Set-Content -Path "$Folder/summary.json" -Encoding UTF8
