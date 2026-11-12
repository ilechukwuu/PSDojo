param($Servers = @('FS-01', 'FS-02', 'FS-03'))

# Announcement for the patch night

$Line = $Servers -join ', '
$LastTwo = $Servers[1..2]
$Summary = "$($Servers.Count) servers: $Line"
