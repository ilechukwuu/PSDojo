# Patch plan for the file servers

$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04', 'FS-05'
$Pilot = $Servers[1]
$Final = $Servers[-1]
$WaveTwo = $Servers[2..3]
$Total = $Servers.Count
