param($Root = '.')

# Log report for APP-01

$Params = @{
    Path    = $Root
    Filter  = '*.log'
    Recurse = $true
}
$Logs = Get-ChildItem $Params

$Summary = [pscustomobject]@{ Folder = $Root; LogCount = @($Logs).Count }
$SummaryFolder = $Summary | Select-Object -ExpandProperty Folder
