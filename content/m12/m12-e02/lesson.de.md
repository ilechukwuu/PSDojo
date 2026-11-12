# Stille Umwandlung

PowerShell gibt sich Mühe, eine Operation möglich zu machen. Haben die zwei Seiten
verschiedene Typen, wandelt es eine davon um, ohne es zu sagen. Die Regel ist dieselbe wie
bei Vergleichen: Die linke Seite entscheidet.

- Text links: Die rechte Seite wird Text. `+` fügt zusammen, `*` wiederholt.
- Zahl links: Die rechte Seite wird eine Zahl. Geht das nicht, gibt es einen Fehler.

Drei weitere Umwandlungen sorgen für Überraschungen:

- `[int]` rundet, es schneidet nicht ab. Und es rundet eine Hälfte zur nächsten geraden
  Zahl: Aus 2.5 wird 2, aus 3.5 wird 4.
- Teilt man zwei ganze Zahlen, entsteht eine Kommazahl, wenn es nicht aufgeht.
- Als Wahrheitswert zählt jeder nicht leere Text als wahr, auch der Text `'false'`. Nur der
  leere Text, 0 und `$null` zählen als falsch.

## Beispiel

```powershell
'5' + 3
5 + '3'
'ab' * 3
[int]3.7
7 / 2
[bool]'false'
```

Die Ergebnisse sind 53, 8, ababab, 4, 3.5 und True.
