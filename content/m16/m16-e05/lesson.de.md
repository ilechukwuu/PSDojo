# Code, der nicht zählt

Code, der Positionen einzeln nennt, `$Servers[0] + ', ' + $Servers[1] + ', ' + $Servers[2]`,
enthält eine Annahme: Es gibt genau drei Elemente. An dem Tag, an dem ein vierter Server
dazukommt, wird er still weggelassen. An dem Tag, an dem einer wegfällt, erzeugt die Zeile
ein Komma am Ende und einen leeren Wert.

Guter Listencode setzt nie eine Länge voraus.

- `-join` verbindet alle Elemente mit einem Trennzeichen, ob zwei oder zweihundert.
- Ein Ausschnitt nimmt einen Teil nach Position: `[0..1]` die ersten zwei, `[-2..-1]` die
  letzten zwei.
- `Select-Object -First 2` und `-Last 2` tun dasselbe in einer Pipeline und beschweren sich
  nicht, wenn es weniger Elemente gibt.
- `Count` nennt dir die Länge, wenn du sie wirklich brauchst.

Ein einfacher Test für deine eigenen Skripte: Wäre die Zeile mit einem Element noch richtig,
und mit hundert?

## Beispiel

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'

$Line = $Servers -join ', '
$FirstTwo = $Servers[0..1]
$LastTwo = $Servers[-2..-1]
```

Keine der drei Zeilen muss sich ändern, wenn die Liste wächst.
