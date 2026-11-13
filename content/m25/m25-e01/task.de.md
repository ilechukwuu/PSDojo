# Aufgabe

Die Hälfte der Skripte deines Teams berechnet den freien Platz eines Volumes in Prozent, und
zwei davon runden unterschiedlich. Du schreibst die eine Funktion, die alle benutzen werden.

1. Definiere eine Funktion `Get-FreePercent` mit den Parametern `$FreeGB` und `$SizeGB`, beide
   vom Typ `[double]`, in dieser Reihenfolge.
2. Die Funktion liefert den freien Platz in Prozent der Größe, gerundet auf eine
   Nachkommastelle.
3. Rufe die Funktion für 120 GB frei von 480 GB auf und speichere das Ergebnis in
   `$Percent`.
