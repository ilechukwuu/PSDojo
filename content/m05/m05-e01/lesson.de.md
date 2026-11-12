# Die Pipeline

Das Pipe-Zeichen `|` verbindet zwei Befehle. Was der linke Befehl liefert, wird zur Eingabe
des rechten. Mehrere Befehle hintereinander bilden eine Pipeline.

Durch die Pipe wandern Objekte, kein Text. Der rechte Befehl erhält jeden Prozess und jede
Datei vollständig mit allen Eigenschaften. Er kann deshalb nach einer Eigenschaft sortieren
oder eine auswählen, ohne Text zu zerschneiden.

Drei Cmdlets, die nur in einer Pipeline Sinn ergeben, als erster Vorgeschmack:

- `Sort-Object -Property Name` sortiert nach einer Eigenschaft. `-Descending` dreht die
  Reihenfolge um.
- `Select-Object -First 3` lässt nur die ersten drei Objekte durch.
- `Measure-Object` zählt, was ankommt. Sein Ergebnis hat die Eigenschaft `Count`.

Lies eine Pipeline von links nach rechts wie einen Satz: holen, dann sortieren, dann die
ersten drei nehmen.

## Beispiel

```powershell
Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 3
(Get-Process | Measure-Object).Count
```

Zeile 1 liefert die drei Prozesse mit dem meisten Arbeitsspeicher. Zeile 2 liefert, wie viele
Prozesse laufen.
