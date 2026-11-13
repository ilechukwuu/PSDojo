# Three lines for the morning mail, built three times

$State1 = if (210 -lt 50) { 'LOW' } else { 'ok' }
$Line1 = '{0}: {1} GB free ({2})' -f 'FS-01', 210, $State1

$State2 = if (9 -lt 50) { 'LOW' } else { 'ok' }
$Line2 = '{0}: {1} GB free ({2})' -f 'FS-02', 9, $State2

$State3 = if (61 -lt 50) { 'LOW' } else { 'ok' }
$Line3 = '{0}: {1} GB free ({2})' -f 'WEB-01', 61, $State3

$Lines = $Line1, $Line2, $Line3
