param($ReportFile = $PSCommandPath)
$File = Get-Item -Path $ReportFile

# Facts about the monthly usage report

$Size = $null
$Extension = $null
$Year = $null
$FolderName = $null
