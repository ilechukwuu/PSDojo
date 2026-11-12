# Check for APP-01 with warning and verbose message

Write-Verbose -Message 'Reading services from APP-01'

$Broken = Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic' }
$Count = @($Broken).Count

Write-Warning -Message "Stopped automatic services: $Count"

$Broken | Select-Object -ExpandProperty Name
