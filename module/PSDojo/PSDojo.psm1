$script:ModuleRoot = $PSScriptRoot
$script:MinPester = [version]'5.3.0'
$script:CheckTimeoutSeconds = 60
$script:IdleCapSeconds = 1800
$script:StringCache = @{}

foreach ($folder in 'Private', 'Public') {
    $path = Join-Path -Path $PSScriptRoot -ChildPath $folder
    foreach ($file in (Get-ChildItem -Path $path -Filter '*.ps1' | Sort-Object -Property Name)) {
        . $file.FullName
    }
}

$pester = Get-Module -ListAvailable -Name Pester |
    Where-Object { $_.Version -ge $script:MinPester } |
    Select-Object -First 1

if (-not $pester) {
    $lines = @(
        "PSDojo needs Pester $($script:MinPester) or newer, and it is not installed."
        'Install it with this command, then import PSDojo again:'
        ''
        "    Install-Module -Name Pester -MinimumVersion $($script:MinPester) -Scope CurrentUser -Force -SkipPublisherCheck"
        ''
        "PSDojo braucht Pester $($script:MinPester) oder neuer. Bitte mit dem Befehl oben installieren und PSDojo erneut importieren."
    )
    throw ($lines -join [Environment]::NewLine)
}
