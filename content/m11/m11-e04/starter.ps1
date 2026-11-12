param($LogFolder = '.')

# Check script used by a monitoring job. Three lines use the wrong stream.

Write-Output 'Reading services from APP-01'

$Names = Get-Service -Name Nordwind* | Select-Object -ExpandProperty Name
Write-Host $Names

Write-Warning -Message 'Nordwind check finished with warnings' 2> "$LogFolder/warnings.log"
