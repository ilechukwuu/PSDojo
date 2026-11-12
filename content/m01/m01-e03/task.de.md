# Aufgabe

Auf dem Terminalserver TS-03 hängt ein Prozess und ein Benutzer kann sich nicht abmelden. Du
weißt noch nicht, welche Cmdlets mit Prozessen arbeiten. Also suchst du, bevor du handelst.

1. Speichere jeden Befehl mit dem Noun `Process` in `$ProcessCommands`.
2. Speichere jeden Befehl mit dem Verb `Stop` in `$StopCommands`.
3. Nach dem Vorfall muss das temporäre Profil aufgeräumt werden. Speichere jeden Befehl,
   dessen Name auf `-Item` endet, in `$ItemCommands`.

Nutze in allen drei Zeilen `Get-Command`.
