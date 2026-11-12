$TicketServer = 'PRN-01'

# Site and team for a ticket

$SiteOf = @{
    'FS-01'  = 'Kiel'
    'FS-02'  = 'Hamburg'
    'PRN-01' = 'Hamburg'
}
$TeamOf = @{
    'Kiel'    = 'Team North'
    'Hamburg' = 'Team Elbe'
}

$Site = $SiteOf[$TicketServer]
$Team = $TeamOf[$Site]
$Line = "$TicketServer / $Site / $Team"
