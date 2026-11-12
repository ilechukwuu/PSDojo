param($Root = '.')

# Information about the report share

Set-Location -Path $Root
$Reports = Get-ChildItem -Path "$Root/reports"
$HasArchive = Test-Path -Path "$Root/archive"
$Readme = Get-Item -Path "$Root/reports/readme.txt"
