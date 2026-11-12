# Check script for the Nordwind services on APP-01

Write-Host 'Nordwind service check for APP-01'

Get-Service -Name Nordwind* | Select-Object -ExpandProperty Name

Write-Host 'Check finished'
