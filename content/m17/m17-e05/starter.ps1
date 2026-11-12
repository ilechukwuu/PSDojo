param($Root = '.')

# Log report for APP-01. Three mistakes around splatting and objects.

$Params = @{
    Path      = $Root
    Filter    = '*.log'
    Recursive = $true
}
$Logs = Get-ChildItem $Params

$Summary = @{ Folder = $Root; LogCount = @($Logs).Count }
$SummaryFolder = $Summary | Select-Object -ExpandProperty Folder
