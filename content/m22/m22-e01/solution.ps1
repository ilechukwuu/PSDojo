param($Root = '.')

# Output folder of the nightly report job

$ReportDir = Join-Path -Path $Root -ChildPath 'Reports'
$Existed = Test-Path -Path $ReportDir

if (-not $Existed) {
    $null = New-Item -Path $ReportDir -ItemType Directory
}

$StatusFile = Join-Path -Path $ReportDir -ChildPath 'status.txt'
Set-Content -Path $StatusFile -Value 'ready'
