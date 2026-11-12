param($LogLine = '2026-03-14 22:05:13 ERROR Disk D: on FS-02 is 91 percent full')

# Take a line of the monitoring log apart

$Pattern = '^(?<Date>\d{4}-\d{2}-\d{2}) \S+ (?<Level>\w+) .* on (?<Server>FS-\d+) .*?(?<Percent>\d+) percent'

if ($LogLine -match $Pattern) {
    $Date = $Matches.Date
    $Level = $Matches.Level
    $Server = $Matches.Server
    $Percent = [int]$Matches.Percent
}
