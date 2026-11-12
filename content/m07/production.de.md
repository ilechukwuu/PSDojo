# Was in der Produktion schiefgeht

Ein Aufräumjob soll die Computerkonten entfernen, die in einer CSV-Datei stehen. Die Datei
hat eine Spalte namens Computer:

```powershell
Import-Csv -Path stale.csv | Remove-ADComputer
```

`Remove-ADComputer` sucht eine Eigenschaft, die es kennt, findet keine und meldet für jede
Zeile einen Fehler. Der Autor "behebt" das, indem er die Namen von Hand in eine Textdatei
schreibt und diese hineinleitet. Jetzt bindet jede Zeile über den Wert, auch die Zeile
SRV-DC01, weil jemand den falschen Block kopiert hat.

Bevor du Daten in einen Befehl leitest, der etwas verändert: Prüfe, an welchen Parameter sie
binden, benenne die Spalten passend und führe es einmal mit `-WhatIf` aus.
