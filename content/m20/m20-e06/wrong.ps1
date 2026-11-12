param($LogLine = '2026-03-14 22:05:13 ERROR Disk D: on FS-02 is 91 percent full')

# Take a line of the monitoring log apart

$Pattern = '^(?<Date>\S+) \S+ (?<Level>\S+) \S+ \S+ \S+ (?<Server>\S+) \S+ (?<Percent>\d+)'

if ($LogLine -match $Pattern) {
    $Date = $Matches.Date
    $Level = $Matches.Level
    $Server = $Matches.Server
    $Percent = [int]$Matches.Percent
}
