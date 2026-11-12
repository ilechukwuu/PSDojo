param($Root = '.')

# Inventory of the report share on FS-02

$AliasTarget = (Get-Item -Path Alias:gci).Definition
$HasReports = Test-Path -Path "$Root/reports" -PathType Container
$Archive = New-Item -Path "$Root/archive" -ItemType Directory
