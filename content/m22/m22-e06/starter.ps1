param($Root = '.')
$Required = 'app.json', 'hosts.csv', 'license.txt'

# Which required configuration files are missing?

$Missing = @()
foreach ($Name in $Required) {
    $Found = $false
    foreach ($Item in (Get-ChildItem -Path ($Root + '/' + 'config'))) {
        if ($Item.Name -eq $Name) {
            $Found = $true
        }
    }
    if (-not $Found) {
        $Missing += $Name
    }
}
