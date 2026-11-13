param($Root = '.')
$Required = 'app.json', 'hosts.csv', 'license.txt'

# Which required configuration files are missing?

$Missing = foreach ($Name in $Required) {
    if (-not (Test-Path -Path "$Root/config/$Name")) {
        $Name
    }
}
