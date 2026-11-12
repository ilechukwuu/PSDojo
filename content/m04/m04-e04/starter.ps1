param($Root = '.')

# Inventory of the report share on FS-02. Three lines contain a mistake.

$AliasTarget = Get-Item -Path Alias:gci\Definition
$HasReports = Test-Path -Path "$Root/reports" -PathType Folder
$Archive = New-Item -Path "$Root/archive" -ItemType Folder
