# Patch script for the file servers

$Failed = @('FS-03')
$FirstFailed = $Failed[0]

$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'
$Servers += 'FS-05'

$LastServer = $Servers[$Servers.Count]
