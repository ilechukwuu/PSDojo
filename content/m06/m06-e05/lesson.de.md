# Statische Member

Bisher gehörte jede Eigenschaft und Methode zu einem Objekt: dieser Datei, jenem Datum.
Manche gehören zum Typ selbst. Sie heißen statisch, und du erreichst sie mit dem Typnamen in
eckigen Klammern und zwei Doppelpunkten.

- `[math]::Round(81.3749, 1)` rundet auf eine Nachkommastelle. `[math]::Max(a, b)` liefert
  die größere von zwei Zahlen.
- `[datetime]::Today` ist heute um Mitternacht, `[datetime]::Now` ist genau jetzt.
- `[System.IO.Path]::GetExtension('usage.csv')` zerlegt einen Dateinamen, ohne dass die Datei
  existieren muss.
- `[Environment]::MachineName` ist der Name des Computers.

Für Klammern gilt dieselbe Regel wie bisher: Statische Methoden brauchen sie, statische
Eigenschaften nicht.

`Get-Member -Static` listet die statischen Member eines Typs.

## Beispiel

```powershell
[math]::Round(81.3749, 1)
[math]::Max(42, 310)
[datetime]::Today
[System.IO.Path]::GetExtension('usage-2026-03.csv')

Get-Date | Get-Member -Static
```

Die ersten vier Zeilen liefern 81,4, 310, das heutige Datum und .csv. Die letzte Zeile
listet, was der Typ DateTime ohne Objekt anbietet.
