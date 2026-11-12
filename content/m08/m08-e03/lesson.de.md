# Bedingungen verknüpfen

Ein Vergleich reicht selten. Ein Dienst ist erst dann ein Problem, wenn er gestoppt ist und
eigentlich laufen sollte.

- `-and`: Beide Seiten müssen wahr sein.
- `-or`: Mindestens eine Seite muss wahr sein.
- `-not`: macht aus wahr falsch. `!` bedeutet dasselbe.

Mischst du `-and` und `-or`, sage mit runden Klammern, was zusammengehört. Ohne sie haben
beide denselben Rang und werden von links nach rechts gelesen, was selten gemeint ist.

Zwei Operatoren ersparen lange Ketten von `-or`:

- `-like` mit Platzhaltern: `$_.Name -like 'Nordwind*'`
- `-in` mit einer Liste: `$_.Name -in $Critical` ist wahr, wenn der Name einer der Werte der
  Liste ist. `-notin` ist das Gegenteil.

## Beispiel

```powershell
Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic' }

$Critical = 'Spooler', 'WinRM'
Get-Service | Where-Object { $_.Name -in $Critical }

Get-Service | Where-Object { ($_.Name -like 'SQL*' -or $_.Name -like 'MSSQL*') -and $_.Status -eq 'Running' }
```

Zeile 1 findet Dienste, die laufen sollten, es aber nicht tun.
