# Aufgabe

Die Morgenprüfung betrachtet die Volumes der Dateiserver und der Anwendungsserver. Beide
Listen müssen nach derselben Regel gefiltert werden, und die Regel ändert sich gelegentlich.
Die zwei Listen sind vorgegeben.

1. Speichere einen Skriptblock in `$IsLow`, der wahr ist, wenn `FreePercent` des aktuellen
   Objekts unter 15 liegt.
2. Filtere `$FileVolumes` mit diesem Block und speichere das Ergebnis in `$LowFile`.
3. Filtere `$AppVolumes` mit demselben Block und speichere das Ergebnis in `$LowApp`.
4. Speichere einen Skriptblock in `$ToLabel`, der Server und Laufwerk des aktuellen Objekts
   als einen Text liefert, getrennt durch ein Leerzeichen, zum Beispiel `FS-01 D:`.
5. Schicke `$LowFile` und `$LowApp` durch `ForEach-Object` mit diesem Block und speichere die
   Texte in `$Labels`.

Lass die vorgegebenen Zeilen unverändert.
