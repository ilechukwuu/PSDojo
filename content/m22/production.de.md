# Was in der Produktion schiefgeht

Ein Aufräumskript leert jede Nacht den Staging-Ordner einer Bereitstellung:

```powershell
Remove-Item -Path "$StagingDir\*" -Recurse -Force
```

Eines Tages wird die Zeile geändert, die `$StagingDir` füllt, und der Variablenname bekommt
einen Tippfehler. Die Variable ist nun leer, der Pfad wird zu `\*`, und das Skript löscht
alles, was es auf dem aktuellen Laufwerk löschen darf. `-Force` sorgt dafür, dass auch
versteckte und schreibgeschützte Dateien verschwinden.

Lösche nie entlang eines Pfades, den du nicht geprüft hast. Prüfe mit `Test-Path`, dass die
Variable nicht leer ist und der Ordner existiert, baue den Pfad mit `Join-Path`, und lass ein
neues Aufräumskript mit `-WhatIf` laufen, bis die Ausgabe genau die Dateien zeigt, die du
meinst.
