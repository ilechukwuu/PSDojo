param($FreePercent = 12)

# Rate the free space of a volume

if ($FreePercent -lt 20) {
    $State = 'Warning'
}
elseif ($FreePercent -lt 10) {
    $State = 'Critical'
}
else {
    $State = 'OK'
}

$NeedsTicket = $State -ne 'OK'
