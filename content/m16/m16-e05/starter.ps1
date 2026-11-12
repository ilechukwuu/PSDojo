param($Servers = @('FS-01', 'FS-02', 'FS-03'))

# Announcement for the patch night. Works for exactly three servers.

$Line = $Servers[0] + ', ' + $Servers[1] + ', ' + $Servers[2]
$LastTwo = @($Servers[1], $Servers[2])
$Summary = '3 servers: ' + $Line
