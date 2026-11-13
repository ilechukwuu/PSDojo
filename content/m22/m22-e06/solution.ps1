param($Root = '.')
$Required = 'app.json', 'hosts.csv', 'license.txt'

# Which required configuration files are missing?

$ConfigDir = Join-Path -Path $Root -ChildPath 'config'

$Missing = foreach ($Name in $Required) {
    $Path = Join-Path -Path $ConfigDir -ChildPath $Name
    if (-not (Test-Path -Path $Path)) {
        $Name
    }
}
