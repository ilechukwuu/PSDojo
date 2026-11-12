# Three views of the services on APP-01 for the handover

$Table = Get-Service | Format-Table -Property Name, Status
$List = Get-Service -Name Spooler | Format-List -Property *
$Wide = Get-Service | Format-Wide -Property Name -Column 3
