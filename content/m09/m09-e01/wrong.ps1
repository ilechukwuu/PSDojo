# Weekly service report for APP-01

$Sorted = Get-Service | Sort-Object -Property Status, Name
$Narrow = Get-Service | Select-Object -Property Name, StartType
$StartTypes = Get-Service | Select-Object -Property StartType | Sort-Object -Property StartType -Unique
