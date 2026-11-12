param($Responses = @('Timeout', 'Timeout', 'OK'), $MaxAttempts = 4)

# Ask the load balancer until APP-01 answers, but not forever

$Attempt = 0
$Status = ''

# Write the do loop here

$Succeeded = $null
