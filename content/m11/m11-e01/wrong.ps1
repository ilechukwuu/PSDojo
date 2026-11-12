# Check script for the Nordwind services on APP-01

Write-Output 'Nordwind service check for APP-01'

Get-Service -Name Nordwind* | Select-Object -ExpandProperty Name

Write-Output 'Check finished'
