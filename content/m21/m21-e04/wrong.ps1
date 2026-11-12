param($Folder = '.')

# Server inventory from XML

[xml]$Doc = Get-Content -Path "$Folder/inventory.xml" -Raw
$Servers = $Doc.inventory.server
$Names = $Servers.name
$HamburgNames = ($Servers | Where-Object { $_.site -eq 'Hamburg' }).name
$TotalRam = $Servers[0].ramGB + $Servers[1].ramGB + $Servers[2].ramGB
