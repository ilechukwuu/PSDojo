[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Suite = @('Compatibility', 'Content', 'Engine', 'Visibility')
)

$minimum = [version]'5.3.0'
$pester = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge $minimum } | Sort-Object -Property Version -Descending | Select-Object -First 1
if (-not $pester) {
    throw "Pester $minimum or newer is required. Install-Module -Name Pester -MinimumVersion $minimum -Scope CurrentUser -Force -SkipPublisherCheck"
}
Import-Module -Name Pester -MinimumVersion $minimum

$paths = foreach ($name in $Suite) {
    Join-Path -Path $PSScriptRoot -ChildPath "$name.Tests.ps1"
}

$configuration = New-PesterConfiguration
$configuration.Run.Path = $paths
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'Normal'
$result = Invoke-Pester -Configuration $configuration

Write-Host ''
Write-Host ('PowerShell {0}  Pester {1}  passed {2}  failed {3}  skipped {4}' -f $PSVersionTable.PSVersion, $pester.Version, $result.PassedCount, $result.FailedCount, $result.SkippedCount)
if ($result.FailedCount -gt 0 -or $result.Result -ne 'Passed') {
    exit 1
}
exit 0
