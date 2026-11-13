# Aufgabe

Der Terminalserver TS-03 sammelt temporäre Dateien eines Importwerkzeugs. Du schreibst das
Aufräumen, das jede Nacht läuft, und es muss einen Probelauf anbieten. Das Dojo übergibt den
Ordner als `$Root` und ruft dein Skript einmal mit `-WhatIf` und einmal ohne auf.

1. Speichere jede Datei mit der Endung `.tmp` unterhalb von `$Root`, in allen Unterordnern,
   die vor mehr als 7 Tagen zuletzt geschrieben wurde, in `$Candidates`.
2. Lösche jede Datei in `$Candidates` mit `Remove-Item`. Reiche den Schalter des Skripts
   weiter, damit mit `-WhatIf` nichts gelöscht wird.

Neuere `.tmp`-Dateien und alle anderen Dateien müssen bleiben. Lass die Zeile mit `param`
unverändert.
