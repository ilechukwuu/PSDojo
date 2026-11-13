# Aufgabe

Das Skript in deiner Übungsdatei soll jedem Volume einen Status geben und die kritischen
auflisten. Es hat drei Fehler rund um Skriptblöcke. Behebe sie. Lass die Zeile mit `param`
unverändert.

Wenn das Skript funktioniert:

- `$Statuses` enthält einen Status pro Volume, in Reihenfolge: `critical` unter 10 Prozent
  frei, `warning` unter 20, sonst `ok`.
- `$Critical` enthält die Volumes mit weniger als 10 Prozent frei.
