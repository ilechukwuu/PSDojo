param($Root = '.')

# Information about the report share. Works, but wanders around.

Set-Location -Path $Root
$Reports = Get-ChildItem -Path reports
$HasArchive = Test-Path -Path archive
cd reports
$Readme = Get-Item -Path readme.txt
