# Was in der Produktion schiefgeht

Ein Skript baut einen Bericht aller Dateifreigaben und exportiert ihn für die Prüfer:

```powershell
$Row = @{ Server = 'FS-02'; Share = 'Finance'; SizeGB = 410 }
$Row | Export-Csv -Path shares.csv
```

Die CSV-Datei enthält Spalten namens IsReadOnly, IsFixedSize, Keys, Values und Count. Das
sind die Eigenschaften der Hashtable selbst, nicht der Daten darin. Die Prüfer erhalten eine
Datei, die über keine Freigabe etwas aussagt.

Eine Hashtable ist ein Behälter zum Nachschlagen. Eine Berichtszeile ist ein Objekt mit
Eigenschaften. Setze `[pscustomobject]` vor die Hashtable, und aus denselben drei Werten
werden drei Spalten.
