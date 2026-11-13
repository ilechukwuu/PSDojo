param($Root = '.')

# Output folder of the nightly report job

$ReportDir = Join-Path -Path $Root -ChildPath 'Reports'
$null = New-Item -Path $ReportDir -ItemType Directory -Force
$Existed = Test-Path -Path $ReportDir

$StatusFile = Join-Path -Path $ReportDir -ChildPath 'status.txt'
Set-Content -Path $StatusFile -Value 'ready'
