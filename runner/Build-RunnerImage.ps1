[CmdletBinding()]
param(
    [Parameter()]
    [string]$Tag = 'psdojo-runner:latest',

    [Parameter()]
    [string]$BaseImage = 'mcr.microsoft.com/powershell:7.4-ubuntu-22.04',

    [Parameter()]
    [string]$Docker = 'docker'
)

$ErrorActionPreference = 'Stop'
$minimum = [version]'5.3.0'
$maximum = [version]'5.99.99'
$repo = Split-Path -Path $PSScriptRoot -Parent
$context = Join-Path -Path $PSScriptRoot -ChildPath 'image'
$modules = Join-Path -Path $context -ChildPath '_modules'

$pester = Get-Module -ListAvailable -Name Pester |
    Where-Object { $_.Version -ge $minimum -and $_.Version -le $maximum } |
    Sort-Object -Property Version -Descending |
    Select-Object -First 1
if (-not $pester) {
    throw "Pester 5 ($minimum or newer, not Pester 6) must be installed on this machine. It is copied into the image, so the build needs no gallery access."
}

if (Test-Path -LiteralPath $modules) {
    Remove-Item -LiteralPath $modules -Recurse -Force
}
$pesterTarget = Join-Path -Path (Join-Path -Path $modules -ChildPath 'Pester') -ChildPath $pester.Version.ToString()
$null = New-Item -Path $pesterTarget -ItemType Directory -Force
Copy-Item -Path (Join-Path -Path $pester.ModuleBase -ChildPath '*') -Destination $pesterTarget -Recurse -Force
Copy-Item -LiteralPath (Join-Path -Path $repo -ChildPath 'module/PSDojo') -Destination (Join-Path -Path $modules -ChildPath 'PSDojo') -Recurse -Force

& $Docker build --build-arg "BASE_IMAGE=$BaseImage" --tag $Tag $context
if ($LASTEXITCODE -ne 0) {
    throw "docker build failed with exit code $LASTEXITCODE."
}
Write-Host "Built $Tag from $BaseImage with Pester $($pester.Version)."
