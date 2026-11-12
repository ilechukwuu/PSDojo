# Ein Ort für jeden Wert

Skripte sammeln feste Werte: einen Servernamen, einen Schwellwert, einen Ordner. Direkt in
den Code getippt heißen sie Literale. Solange jedes einmal vorkommt, ist das in Ordnung.

Ärger beginnt, wenn dasselbe Literal fünfmal dasteht. An dem Tag, an dem der Schwellwert von
90 auf 85 sinkt, muss jemand alle fünf finden und findet vier. Das Skript warnt dann an einer
Stelle bei 85 und an einer anderen bei 90, und niemand versteht warum.

Die Kur ist einfach. Lege jeden solchen Wert oben im Skript in eine Variable und benutze
darunter überall die Variable.

- Der Name erklärt den Wert. `$WarnAtPercent` sagt mehr als `90`.
- Eine Änderung passiert in genau einer Zeile.
- Der Skriptanfang wird zur kurzen Liste von allem, was sich einstellen lässt.

Eine Zahl, die ohne Erklärung im Code steht, heißt magische Zahl. Reviewer suchen danach.

## Beispiel

```powershell
$WarnAtPercent = 90
$Server = 'FS-02'

$Title = "Capacity report for $Server"
$Note = "Warning above $WarnAtPercent percent on $Server"
```

Beide Werte werden einmal definiert und überall benutzt, wo sie gebraucht werden.
