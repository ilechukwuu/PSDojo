$Today = [datetime]'2026-03-14'
$LastLogon = [datetime]'2025-11-02'

# Stale account check for one account

$Limit = $Today.AddDays(90)
$Age = $Today - $LastLogon
$AgeDays = $Age.Days
$IsStale = $LastLogon -lt $Limit
$DeleteOn = $Today.AddDays(30)
