# Format gehört nach rechts

Ein `Format-`Cmdlet liefert nicht deine Objekte in schönerer Form. Es liefert eine andere Art
von Objekt: Zeichenanweisungen wie "Tabelle beginnen", "hier ist eine Zeile", "Tabelle
beenden". Die Dienste oder Prozesse selbst sind weg.

Nur die `Out-`Cmdlets verstehen diese Anweisungen: `Out-Host` für den Bildschirm, `Out-File`
für eine Textdatei, `Out-String` für einen Text im Speicher.

Alles andere verschluckt sich daran oder läuft, schlimmer noch, ohne Fehler und produziert
Unsinn. `Where-Object` findet keine Eigenschaft zum Vergleichen. `Sort-Object` sortiert
nichts Sinnvolles. `Export-Csv` schreibt Spalten mit kryptischen Namen.

Die Regel heißt format right: Ein `Format-`Cmdlet ist der letzte Befehl einer Pipeline oder
der letzte vor einem `Out-`Cmdlet. Sortiere, filtere, wähle aus und rechne vorher.

`Get-Member` beweist es jederzeit.

## Beispiel

```powershell
Get-Service | Format-Table | Get-Member

Get-Service | Sort-Object -Property Name | Format-Table -Property Name, Status
```

Zeile 1 listet Typen mit Format im Namen, nicht ServiceController. Zeile 3 ist die richtige
Reihenfolge: erst arbeiten, zuletzt zeichnen.
