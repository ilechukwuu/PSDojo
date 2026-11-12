# Listenfehler

**Ein Ergebnis wie eine Liste behandeln.** Eine Variable enthält einen einzelnen Text, und
der Code fragt nach `[0]`. Er bekommt den ersten Buchstaben. Setze den Wert dort, wo er
zugewiesen wird, in `@( )`, dann kann sich der Rest des Skripts auf eine Liste verlassen.

**Add an einem Array.** `$Servers.Add('FS-05')` scheitert mit der Meldung, die Sammlung habe
eine feste Größe. Ein Array kann nicht an Ort und Stelle wachsen. Nutze `+=` oder eine List,
wenn viel hinzukommt.

**Eine Position zu weit.** Ein Array mit vier Elementen hat die Positionen 0 bis 3.
`$Servers[$Servers.Count]` fragt nach Position 4, die es nicht gibt, und liefert nichts, ohne
Fehler. Das letzte Element ist `[-1]`.

Der dritte Fehler heißt Off-by-one und gehört zu den häufigsten der ganzen Programmierung.
Wann immer du eine Position ausrechnest, prüfe das erste und das letzte Element von Hand.

## Beispiel

```powershell
$Names = @('FS-01')
$Names[0]

$Servers = 'FS-01', 'FS-02'
$Servers += 'FS-03'
$Servers[-1]
```

Zeile 2 liefert FS-01, weil `$Names` ein echtes Array ist. Zeile 6 liefert FS-03.
