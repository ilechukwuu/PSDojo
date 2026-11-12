# Aufgabe

Das Skript in deiner Übungsdatei zerlegt eine Zeile des Überwachungslogs mit `Split` und
festen Positionen. Es funktioniert für die Standardzeile und liefert Unsinn für Zeilen mit
mehr Wörtern. Schreibe es um.

1. Nutze ein `-match` mit den benannten Gruppen `Date`, `Level`, `Server` und `Percent`.
2. Fülle `$Date`, `$Level`, `$Server` und `$Percent` aus `$Matches`. `$Percent` ist eine
   ganze Zahl.
3. Kein `Split` und kein Index mit einer Zahl darf übrig bleiben.

Für die Standardzeile müssen die vier Variablen dieselben Werte enthalten wie jetzt. Lass die
Zeile mit `param` unverändert.
