param($Folder = '.')

# Capacity report from CSV to JSON

$Rows = Import-Csv -Path "$Folder/disks.csv" -Delimiter ';'

$TotalFree = ($Rows | Measure-Object -Property FreeGB -Sum).Sum

$Summary = [pscustomobject]@{
    Site  = 'Hamburg'
    Total = $TotalFree
    Data  = [pscustomobject]@{ Rows = $Rows }
}
$Summary | ConvertTo-Json -Depth 5 | Set-Content -Path "$Folder/summary.json" -Encoding UTF8
