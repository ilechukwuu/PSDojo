param($ReportFile = $PSCommandPath)
$File = Get-Item -Path $ReportFile

# Facts about the monthly usage report

$Size = $File.Length
$Extension = $File.Extension
$Year = $File.LastWriteTime.Year
$FolderName = $File.Directory.Name
