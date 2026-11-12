# Aufgabe

Ein Skript, das Druckserver neu startet, verhält sich unterschiedlich, je nachdem, wie viele
Server eine Abfrage liefert. Du untersuchst die fraglichen Zeilen. Sage vorher, was sie
liefern. Führe nichts aus.

```powershell
$Found = 'PRN-01'
$Many = 'PRN-01', 'PRN-02', 'PRN-03'

$Found[0]
@($Found)[0]
@($Found).Count
$Many[5]
($Many + 'PRN-04').Count
@().Count
```

Speichere die Ergebnisse der Zeilen 4 bis 9 in `$Result1` bis `$Result6`. Für ein Ergebnis,
das nichts ist, speichere `$null`.
