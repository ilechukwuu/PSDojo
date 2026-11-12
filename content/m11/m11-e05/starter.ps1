# Nordwind check. Works, but talks all the time.

Write-Host 'Starting Nordwind check'
Write-Host 'Reading services'
$Services = Get-Service -Name Nordwind*
Write-Host 'Filtering stopped services'
$Services | Where-Object { $_.Status -eq 'Stopped' } | Select-Object -ExpandProperty Name
Write-Host 'Nordwind check done'
