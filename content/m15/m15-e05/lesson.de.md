# Den TimeSpan rechnen lassen

Skripte, die über Jahre gewachsen sind, rechnen Dauern oft von Hand um: Ticks oder Sekunden
nehmen, durch 60 teilen, wieder durch 60, durch 24. Jede dieser Zahlen ist eine Gelegenheit
für einen Fehler, und ein Leser muss herausfinden, was 86400 oder 10000000 bedeutet.

Ein TimeSpan weiß das alles schon.

- Ziehe den Anfang vom Ende ab, und du hast die Dauer.
- `TotalSeconds`, `TotalMinutes`, `TotalHours` und `TotalDays` liefern sie in der Einheit,
  die du brauchst.
- `[timespan]::FromSeconds(129600)` oder `New-TimeSpan -Seconds 129600` machen aus einer
  rohen Zahl aus einem Log einen TimeSpan.

Der Code wird kürzer, und er sagt, was er meint: Gesamtstunden, nicht "geteilt durch 3600".

## Beispiel

```powershell
$Seconds = 129600
$Days = $Seconds / 60 / 60 / 24

$Days = [timespan]::FromSeconds($Seconds).TotalDays
$Hours = ($End - $Start).TotalHours
```

Die Zeilen 2 und 4 ergeben beide 1.5. Zeile 4 braucht keine Erklärung.
