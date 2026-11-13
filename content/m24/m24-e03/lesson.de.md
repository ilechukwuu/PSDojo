# Spätes Lesen

Ein Skriptblock wird als Code gespeichert, nicht als Ergebnis. Zwei Folgen überraschen.

**Beim Definieren läuft nichts.** `$Check = { Test-Connection FS-01 }` pingt nichts an. Die
Variable enthält ein Skriptblock-Objekt.

**Äussere Variablen werden beim Aufruf gelesen.** Ein Block, der `$Limit` von aussen nutzt,
schlägt den Wert bei jedem Lauf nach. Hat sich `$Limit` zwischen Definition und Aufruf
geändert, sieht der Block den neuen Wert. In einem langen Skript entsteht so leicht ein
Filter, der still etwas anderes tut als an der Stelle, an der er geschrieben wurde.

Zwei Auswege:

- Reiche den Wert über `param` hinein. Das ist der klare Weg.
- Rufe `.GetNewClosure()` auf dem Block auf. Die Kopie, die das liefert, trägt die
  Variablenwerte dieses Moments mit sich und schaut nicht mehr nach aussen.

Ein Block liefert alles, was er ausgibt. Zwei Ausgaben sind zwei Ergebnisse, und der Aufrufer
erhält eine Liste.

## Beispiel

```powershell
$Limit = 10
$IsLow = { param($Value) $Value -lt $Limit }
$Frozen = $IsLow.GetNewClosure()

$Limit = 50

& $IsLow 30
& $Frozen 30
```

Der erste Aufruf liefert `True`, der zweite `False`.
