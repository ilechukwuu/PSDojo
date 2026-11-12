$RawName = 'Keller,     Anna'
$Mail = 'anna.keller@nordwind.example'
$Ticket = 'INC-004711'

# Clean up the values from the HR list

$Name = $RawName -replace '\s+', ' '
$DisplayName = $Name -replace '^(\w+), (\w+)$', '$2 $1'
$Login = $Mail -replace '@.*$', ''
$TicketPrefix = $null
$TicketNumber = $null

if ($Ticket -match '^(?<Prefix>[A-Za-z]+)-(?<Number>\d+)$') {
    $TicketPrefix = $Matches['Prefix']
    $TicketNumber = [int]$Matches['Number']
}
