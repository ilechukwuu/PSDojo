param($LogLine = '2026-03-14 22:05:13 ERROR Disk D: on FS-02 is 91 percent full')

# Facts from one line of the monitoring log

$IsError = $LogLine -match 'ERROR'
$Server = $null
$Percent = $null

if ($LogLine -match 'on (FS-\d+)') {
    $Server = $Matches[1]
}
if ($LogLine -match '(\d+) percent') {
    $Percent = [int]$Matches[1]
}
