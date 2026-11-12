$script:ModuleRoot = $PSScriptRoot
$script:MinPester = [version]'5.3.0'
$script:MaxPester = [version]'5.99.99'
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
    Where-Object { $_.Version -ge $script:MinPester -and $_.Version -le $script:MaxPester } |
    Select-Object -First 1

if (-not $pester) {
    $lines = @(
        "PSDojo needs Pester 5 ($($script:MinPester) or newer, but not Pester 6), and it is not installed."
        'Install it with this command, then import PSDojo again:'
        ''
        "    Install-Module -Name Pester -MinimumVersion $($script:MinPester) -MaximumVersion $($script:MaxPester) -Scope CurrentUser -Force -SkipPublisherCheck"
        ''
        "PSDojo braucht Pester 5 ($($script:MinPester) oder neuer, aber nicht Pester 6). Bitte mit dem Befehl oben installieren und PSDojo erneut importieren."
    )
    throw ($lines -join [Environment]::NewLine)
}
