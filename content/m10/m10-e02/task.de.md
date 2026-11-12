# Aufgabe

Ein Kollege schickt dir fünf Pipelines aus einem Entwurf für den wöchentlichen Serverbericht
und fragt, welche liefern, was er erwartet. Führe sie nicht aus. Speichere `$true`, wenn die
Pipeline tut, was der Kommentar sagt, sonst `$false`.

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

Speichere die Antworten in `$Works1` bis `$Works5`.
