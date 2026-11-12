$Started = [datetime]'2026-03-14T22:05:00'
$GermanDate = '03.04.2026'

# Dates for log, archive name and expiry

$LogDate = $Started.ToString('yyyy-MM-dd')
$Stamp = $Started.ToString('yyyyMMdd-HHmm')
$ArchiveName = "backup-$Stamp.zip"
$Expires = [datetime]::ParseExact($GermanDate, 'dd.MM.yyyy', $null)
$DaysLeft = ($Expires - $Started).Days
