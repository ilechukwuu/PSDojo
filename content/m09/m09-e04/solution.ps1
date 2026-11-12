# Capacity report for APP-01 in megabytes

$Report = Get-Process | Select-Object -Property Name,
    @{ Name = 'MemoryMB'; Expression = { [math]::Round($_.WorkingSet64 / 1MB) } },
    @{ Name = 'Team'; Expression = { $_.Category } }
$Sorted = $Report | Sort-Object -Property MemoryMB -Descending
