# Wo Pipelines reißen

Drei Fehler lassen eine Pipeline etwas anderes liefern als gemeint, oft ohne jede
Fehlermeldung.

**Ein Semikolon statt einer Pipe.** `Get-Process ; Sort-Object -Property Name` sind zwei
getrennte Befehle. Der zweite erhält nichts.

**Die falsche Reihenfolge.** Ein Befehl kann nur mit dem arbeiten, was ankommt. Wer vor dem
Sortieren begrenzt, sortiert die falschen Objekte.

**Ein falsch gesetzter Zeilenumbruch.** Eine lange Pipeline darf in der nächsten Zeile
weitergehen, aber PowerShell muss erkennen können, dass die Zeile nicht fertig ist. Setze das
Pipe-Zeichen ans Zeilenende. Dann weiß PowerShell, dass noch etwas folgt.

PowerShell 7 akzeptiert auch eine Pipe am Anfang der nächsten Zeile. Windows PowerShell 5.1
nicht: Es hält die erste Zeile für vollständig und meldet für die zweite einen Fehler.
Schreibe die Pipe ans Ende, dann läuft das Skript in beiden.

## Beispiel

```powershell
Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 3
```

Eine Pipeline über drei Zeilen. Jede Zeile endet mit einer Pipe, außer der letzten. Die
Einrückung zeigt, dass die Zeilen zusammengehören.
