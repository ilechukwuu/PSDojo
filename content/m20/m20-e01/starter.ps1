param($LogLine = '2026-03-14 22:05:13 ERROR Disk D: on FS-02 is 91 percent full')

# Facts from one line of the monitoring log

$IsError = $null
$Server = $null
$Percent = $null
