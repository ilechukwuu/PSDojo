param($Candidate = 'FS-02', $Fqdn = 'fs-02.nordwind.example', $Person = 'Keller, Anna')

# Input check before a server is added to the monitoring

$IsServerName = $Candidate -match '^FS-\d\d$'
$IsInternal = $Fqdn -match '.nordwind.example$'
$Owner = $Person -replace '^(\w+), (\w+)$', '$2 $1'
