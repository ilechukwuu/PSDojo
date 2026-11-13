# Was beim Aufruf passiert

Rufst du eine erweiterte Funktion auf, arbeitet PowerShell jedes Argument in fester
Reihenfolge ab, bevor dein Code läuft.

1. **Parameter finden.** Über den Namen oder die Position. Ein unbekannter Name ist ein
   Fehler.
2. **Typ umwandeln.** Ein Text `'25'` für einen `[int]`-Parameter wird zur Zahl 25. Eine
   Kommazahl für `[int]` wird gerundet, aus `2.7` wird 3. Was sich nicht umwandeln lässt,
   etwa `'many'`, ist ein Fehler.
3. **Validieren.** Die Attribute prüfen den umgewandelten Wert. `ValidateSet` vergleicht ohne
   Rücksicht auf Groß- und Kleinschreibung. `ValidateRange` schliesst beide Grenzen ein.
4. **Pflichtparameter prüfen.** Fehlt einer, fragt eine interaktive Konsole danach. Eine
   nicht interaktive Sitzung meldet einen Fehler.

Standardwerte werden nicht validiert. Ein Standardwert ausserhalb seines eigenen
`ValidateRange` wird klaglos akzeptiert, prüfe deine Standardwerte also selbst.

Erst wenn all das gelungen ist, läuft die erste Zeile des Rumpfs.

## Beispiel

```powershell
function Get-Sample {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 10)]
        [int]$Count = 5
    )
    $Count
}

Get-Sample -Count '7'
Get-Sample -Count 10
Get-Sample -Count 11
```

Die ersten zwei Aufrufe liefern 7 und 10. Der dritte wird abgelehnt.
