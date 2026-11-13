# Wenn eine Funktion das Falsche liefert

Funktionen scheitern öfter leise als laut. Drei Ursachen decken die meisten Fälle ab.

**Eine vertippte Variable.** PowerShell beschwert sich nicht über eine Variable, die nie
gesetzt wurde. Sie ist einfach leer. `$WarnPrecent` statt `$WarnPercent` macht aus einem
Vergleich einen gegen nichts, der für jede Zahl falsch ist. Die Funktion liefert nichts und
meldet keinen Fehler. `Set-StrictMode -Version Latest` am Anfang eines Skripts macht die
Verwendung einer nicht gesetzten Variablen zu einem Fehler. Nutze es beim Entwickeln.

**Verschmutzte Ausgabe.** Ein Ergebnis mit Zahlen davor, die niemand hineingelegt hat, stammt
von einem Methodenaufruf, dessen Rückgabewert nicht verworfen wurde. Suche nach `.Add(` und
setze `$null =` davor.

**Ein Aufruf mit Klammern.** Enthält der erste Parameter alles und die anderen sind leer oder
haben ihre Standardwerte, wurde der Aufruf wie in einer anderen Sprache geschrieben.

Um herauszufinden, was eine Funktion wirklich liefert, sieh dir das rohe Ergebnis an:
`$Result | ForEach-Object { $_.GetType().Name }`.

## Beispiel

```powershell
Set-StrictMode -Version Latest

function Get-LargeFile {
    param($Files, $MinBytes = 1GB)
    foreach ($File in $Files) {
        if ($File.Length -ge $MinBytes) { $File.Name }
    }
}

Get-LargeFile -Files $All -MinBytes 500MB
```
