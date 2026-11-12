param($LogFolder = '.')

# Check script used by a monitoring job

Write-Verbose -Message 'Reading services from APP-01'

$Names = Get-Service -Name Nordwind* | Select-Object -ExpandProperty Name
Write-Output $Names

Write-Warning -Message 'Nordwind check finished with warnings' 3> "$LogFolder/warnings.log"
