# Aufgabe

Der Terminalserver TS-03 ist langsam. Für das Ticket brauchst du drei Fakten über seine
Prozesse.

1. Speichere alle Prozesse, sortiert nach `Name`, in `$ByName`.
2. Speichere die zwei Prozesse mit dem höchsten `WorkingSet64` in `$TopTwo`. Sortiere
   absteigend und nimm dann die ersten zwei.
3. Speichere die Anzahl der Prozesse in `$ProcessCount`.

Jede Zeile ist eine Pipeline, die mit `Get-Process` beginnt.
