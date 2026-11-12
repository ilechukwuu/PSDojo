# Aufgabe

Das Kapazitätswerkzeug liefert ein Objekt pro Volume mit den Eigenschaften `Server`,
`SizeGB` und `FreeGB`. Für den Wochenbericht machst du aus jedem eine Berichtszeile. Die
ersten Zeilen deiner Übungsdatei enthalten die Daten. Lass sie unverändert.

Speichere ein Objekt pro Volume in `$Report`. Nutze eine `foreach`-Anweisung und weise ihr
Ergebnis zu. Jedes Objekt hat diese Eigenschaften, in dieser Reihenfolge:

1. `Server`: der Servername, unverändert.
2. `FreePercent`: `FreeGB` geteilt durch `SizeGB`, mal 100, gerundet auf eine ganze Zahl.
3. `State`: `Low`, wenn `FreePercent` unter 20 liegt, sonst `OK`.
