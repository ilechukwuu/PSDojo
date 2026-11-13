param($Folder = '.')

# Calling and dot-sourcing the shared settings file

$SettingsFile = Join-Path -Path $Folder -ChildPath 'settings.ps1'
$Output = & $SettingsFile
$AfterCall = $Site

$null = . $SettingsFile

$AfterDot = $Site
