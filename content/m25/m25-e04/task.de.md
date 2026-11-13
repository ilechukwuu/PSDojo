# Aufgabe

Die Funktion in deiner Übungsdatei soll die Namen der Volumes liefern, deren freier Platz
unter einem Schwellwert liegt. So aufgerufen wie in der letzten Zeile ist `$Low` leer. Sie
hat drei Fehler. Behebe sie. Lass die Zeile mit `param` ganz oben unverändert.

Wenn das Skript funktioniert:

- `Get-LowVolume -Volumes ... -WarnPercent ...` liefert nur die Namen der Volumes unter dem
  Schwellwert, sonst nichts.
- `$Low` enthält die Namen der Volumes in `$Volumes` mit weniger als 30 Prozent frei.
