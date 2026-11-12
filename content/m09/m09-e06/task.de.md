# Aufgabe

Das Skript in deiner Übungsdatei zählt die Dienste von APP-01 nach Status. Es fragt den
Server zweimal. Schreibe es um:

1. Rufe `Get-Service` genau einmal auf, gruppiere nach `Status` und speichere die Gruppen in
   `$Groups`.
2. Lies `$RunningCount` und `$StoppedCount` aus `$Groups`.
3. `$Summary` bleibt, wie es ist.

Die drei Variablen `$RunningCount`, `$StoppedCount` und `$Summary` müssen dieselben Werte
enthalten wie jetzt.
