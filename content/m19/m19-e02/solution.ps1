# State of the services on APP-01 as lines for a chat message

$Lines = Get-Service -Name Nordwind* | ForEach-Object { "$($_.Name) is $($_.Status)" }
$StoppedNames = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | ForEach-Object { $_.Name.ToUpper() }
