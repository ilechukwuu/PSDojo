[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Suite = @('Compatibility', 'Content', 'Engine', 'Visibility', 'Review')
)

$minimum = [version]'5.3.0'
$maximum = [version]'5.99.99'
$pester = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge $minimum -and $_.Version -le $maximum } | Sort-Object -Property Version -Descending | Select-Object -First 1
if (-not $pester) {
    throw "Pester 5 is required. Install-Module -Name Pester -MinimumVersion $minimum -MaximumVersion $maximum -Scope CurrentUser -Force -SkipPublisherCheck"
}
Import-Module -Name Pester -MinimumVersion $minimum -MaximumVersion $maximum

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
