# Nordwind check

Write-Verbose -Message 'Starting Nordwind check'
Write-Verbose -Message 'Reading services'
$Services = Get-Service -Name Nordwind*
Write-Verbose -Message 'Filtering stopped services'
$Services | Where-Object { $_.Status -eq 'Stopped' } | Select-Object -ExpandProperty Name
Write-Host 'Nordwind check done'
