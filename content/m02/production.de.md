# Was in der Produktion schiefgeht

Ein Skript entsteht über einen Nachmittag im Editor. Dort läuft es, also wird es als geplante
Aufgabe eingerichtet. In der Nacht scheitert es an einer leeren Variablen.

Der Editor hält eine Sitzung offen. Jede Variable, die du von Hand oder durch eine frühere
Fassung des Skripts gesetzt hast, ist noch da. Das Skript benutzt deshalb unbemerkt Werte,
die es selbst nie setzt:

```powershell
$Report = "$LogFolder\report.csv"
```

`$LogFolder` wurde vor Stunden in die Konsole getippt. In einer frischen Sitzung ist sie leer.

Bevor du ein Skript übergibst, führe es einmal in einem neuen Konsolenfenster aus, in dem
nichts geladen ist.
