# Sort-Object und Select-Object

**Sort-Object** bringt Objekte in eine Reihenfolge. Mit mehreren Eigenschaften sortiert es
nach der ersten und bei gleichen Werten nach der zweiten. `-Descending` dreht um, `-Unique`
entfernt Doppelte.

**Select-Object** erledigt zwei verschiedene Aufgaben.

Es begrenzt, wie viele Objekte durchkommen: `-First 5`, `-Last 5`, `-Skip 1`.

Und es wählt Eigenschaften aus. Hier sehen zwei Parameter ähnlich aus und sind es nicht:

- `-Property Name, Status` liefert neue Objekte, die nur diese Eigenschaften haben. Du hast
  weiter Objekte und kannst mit `.Name` weiterarbeiten.
- `-ExpandProperty Name` liefert die nackten Werte, hier eine Liste von Texten. Nimm es, wenn
  der nächste Schritt Text will und keine Objekte.

Weil `-Property` neue, schmalere Objekte baut, ist alles, was du nicht ausgewählt hast, für
den Rest der Pipeline weg.

## Beispiel

```powershell
Get-Service | Sort-Object -Property Status, Name
Get-Service | Select-Object -Property Name, Status
Get-Service | Select-Object -ExpandProperty Name
Get-Service | Select-Object -ExpandProperty StartType | Sort-Object -Unique
```

Zeile 2 liefert Objekte mit zwei Eigenschaften. Zeile 3 liefert Namen als Text. Zeile 4
liefert jeden Starttyp einmal.
