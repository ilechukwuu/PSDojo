# Aufgabe

Für den Kapazitätsbericht von TS-03 brauchst du die vollständige Prozessliste und den
einzelnen größten Prozess, aufgenommen im selben Moment. `Get-Process` darf nur einmal
aufgerufen werden.

1. Schreibe eine Pipeline, die mit `Get-Process` beginnt, mit `Tee-Object` alle Prozesse in
   der Variablen `AllProcesses` speichert, nach `WorkingSet64` absteigend sortiert und den
   ersten behält. Speichere das Ergebnis der Pipeline in `$Largest`.
2. Starte eine zweite Pipeline von `$AllProcesses` aus, ohne `Get-Process` erneut
   aufzurufen, und speichere die Anzahl der Prozesse in `$Total`.
