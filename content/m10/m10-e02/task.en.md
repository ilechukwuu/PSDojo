# Task

A colleague sends you five pipelines from a draft for the weekly server report and asks
which of them return what he expects. Do not run them. Store `$true` when the pipeline does
what the comment says, otherwise `$false`.

```powershell
# 1: the stopped services, shown as a table
Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Format-Table -Property Name

# 2: the stopped services, shown as a table
Get-Service | Format-Table -Property Name, Status | Where-Object { $_.Status -eq 'Stopped' }

# 3: a CSV file with the service names
Get-Service | Format-Table -Property Name | Export-Csv -Path services.csv

# 4: a text file that looks like the table on screen
Get-Service | Format-Table -Property Name, Status | Out-File -FilePath services.txt

# 5: the services sorted by name, shown as a list
Get-Service | Format-List -Property Name | Sort-Object -Property Name
```

Store the answers in `$Works1` to `$Works5`.
