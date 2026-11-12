param($Responses = @('Timeout', 'Timeout', 'OK'), $MaxAttempts = 4)

# Ask the load balancer until APP-01 answers, but not forever

$Attempt = 0
$Status = ''

do {
    $Status = $Responses[$Attempt]
    $Attempt++
} until ($Attempt -ge $MaxAttempts)

$Succeeded = $Status -eq 'OK'
