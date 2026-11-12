# Operatorfehler

Drei Fehler mit Operatoren tauchen in fast jedem ersten Skript auf.

**Fehlende Klammern.** Ein Durchschnitt, geschrieben als `$A + $B + $C / 3`, teilt nur den
letzten Wert. Die Zahlen sehen plausibel aus, das macht den Fehler schwer zu entdecken.
Setze die Summe in Klammern.

**= wo -eq gemeint war.** `$IsFull = $UsedPercent = 100` vergleicht nichts. Es weist
`$UsedPercent` 100 zu und danach dieselbe 100 `$IsFull`. Beide Variablen sind überschrieben.

**Eine Zahl links von einem Text.** `$FreeGB + ' GB free'` scheitert, weil der linke Wert
eine Zahl ist und PowerShell versucht, den Text in eine zu verwandeln. Beginne mit dem Text
oder, besser, setze die Variable in einen Text mit doppelten Anführungszeichen.

Liefert eine Rechnung einen falschen Wert, zerlege sie in Schritte und sieh dir jedes
Zwischenergebnis an.

## Beispiel

```powershell
$Average = (120 + 35 + 25) / 3
$IsFull = $UsedPercent -eq 100
$Label = "$FreeGB GB free"
```

Die drei Zeilen zeigen die richtige Form für jeden der drei Fehler.
