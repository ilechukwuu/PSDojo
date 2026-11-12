param($LogLine = '2026-03-14 22:05:13 ERROR Disk D: on FS-02 is 91 percent full')

# Take a line of the monitoring log apart. Counts words.

$Words = $LogLine.Split(' ')
$Date = $Words[0]
$Level = $Words[2]
$Server = $Words[6]
$Percent = [int]$Words[8]
