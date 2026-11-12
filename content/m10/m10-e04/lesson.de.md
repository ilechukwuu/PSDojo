# Ein falsch platziertes Format finden

Die Symptome eines Format-Cmdlets an der falschen Stelle erkennt man leicht, wenn man sie
einmal gesehen hat.

- Ein Filter danach liefert nichts.
- Ein Sortieren danach ändert nichts.
- Eine Variable, die Dienste enthalten soll, enthält etwas mit zu hoher Anzahl: Eine Tabelle
  mit zwölf Zeilen sind vierzehn oder mehr Layoutobjekte, denn Kopf und Rahmen sind auch
  Objekte.
- `-ExpandProperty` meldet, dass die Eigenschaft nicht gefunden wird.
- Als Text zusammengefügt ergibt das Ergebnis lange Typnamen mit Format darin.

Die Reparatur ist immer eine von zweien.

Werden die Daten danach gebraucht, in einer Variablen, einem Filter oder einem Export, muss
das Format ganz weg. Nimm `Select-Object`, wenn du nur bestimmte Eigenschaften willst.

Wird das Ergebnis nur angezeigt, verschiebe das Format ans Ende der Pipeline.

## Beispiel

```powershell
$Names = Get-Service | Format-List -Property Name | Select-Object -ExpandProperty Name

$Names = Get-Service | Select-Object -ExpandProperty Name
```

Zeile 1 scheitert, weil es nach dem Format keine Eigenschaft Name gibt. Zeile 3 braucht gar
kein Format: Die Variable ist nicht fürs Auge.
