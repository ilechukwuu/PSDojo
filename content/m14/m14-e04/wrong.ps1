$RawName = '  fs-02.nordwind.example  '
$FreeGB = 12

# Clean up the server name and write the ticket text

$Fqdn = $RawName
$ShortName = $Fqdn.Split('.')[0].ToUpper()
$IsInternal = $Fqdn.EndsWith('.nordwind.example')
$Body = @"
Ticket for $ShortName
Drive "D:" has $FreeGB GB free.
Please extend the volume.
"@
