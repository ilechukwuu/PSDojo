# Erst die Daten, zuletzt die Ansicht

Ein Bericht braucht dieselben Daten oft in mehreren Formen: eine Tabelle für die Mail, eine
Liste für das Ticket, eine Zahl für die Betreffzeile. Verlockend ist, die ganze Pipeline für
jede Form zu kopieren und den letzten Befehl zu ändern.

Das holt die Daten mehrfach. Es ist langsam, und auf einem beschäftigten Server können die
Kopien einander widersprechen.

Der bessere Aufbau hat zwei Schichten.

1. **Daten.** Eine Pipeline holt, filtert und sortiert. Ihr Ergebnis, echte Objekte, kommt in
   eine Variable mit sprechendem Namen.
2. **Ansichten.** Jede Ansicht beginnt bei dieser Variablen und endet mit einem Format und
   einem `Out-`Cmdlet.

Die Datenschicht enthält nie ein `Format-`Cmdlet. So bleibt die Variable auch für alles
andere brauchbar: zählen, exportieren, handeln.

## Beispiel

```powershell
$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object -Property Name

$Table = $Stopped | Format-Table -Property Name, StartType | Out-String
$List = $Stopped | Format-List -Property Name, DisplayName | Out-String
$Count = @($Stopped).Count
```

Ein Abruf, drei Ergebnisse.
