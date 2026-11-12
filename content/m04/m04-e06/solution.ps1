param($Root = '.')

# A drive for the weekly finance reports

$null = New-PSDrive -Name Reports -PSProvider FileSystem -Root $Root

$ReportFiles = Get-ChildItem -Path Reports:
$HasMarch = Test-Path -Path Reports:2026-03.csv
