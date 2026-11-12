# Where-Object

`Where-Object` ist der Filter der Pipeline. Es betrachtet jedes Objekt, das ankommt, und
lässt es nur durch, wenn eine Bedingung wahr ist.

Die Bedingung steht in geschweiften Klammern. Darin steht `$_` für das Objekt, das gerade
betrachtet wird. Du liest eine Eigenschaft davon und vergleichst:

- `-eq` gleich, `-ne` ungleich
- `-gt` größer als, `-ge` größer oder gleich
- `-lt` kleiner als, `-le` kleiner oder gleich

PowerShell benutzt zum Vergleichen weder `=` noch `<` oder `>`. `=` weist einen Wert zu, und
`>` schreibt in eine Datei.

Text auf der rechten Seite eines Vergleichs steht in Anführungszeichen. Textvergleiche
ignorieren Groß- und Kleinschreibung.

Für einen einzelnen Vergleich gibt es eine Kurzform, `Where-Object Status -eq 'Running'`. Die
Form mit Klammern kann alles, lerne also diese zuerst.

## Beispiel

```powershell
Get-Service | Where-Object { $_.Status -eq 'Stopped' }
Get-Process | Where-Object { $_.WorkingSet64 -gt 500MB }
```

Zeile 1 liefert die gestoppten Dienste. Zeile 2 liefert die Prozesse, die mehr als 500 MB
belegen. `MB` und `GB` werden als Einheiten verstanden.
